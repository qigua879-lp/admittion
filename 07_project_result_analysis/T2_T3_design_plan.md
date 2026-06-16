# T2 / T3 实现方案设计 — 行级重采集闭环 + 基线对比

> 本文给出交接文档 §4 中 T2（行级重采集闭环）与 T3（基线对比实验）的**每部分实现思路与方案设计**，
> 在动手写代码前对齐架构。设计建立在对现有数据通路的核查之上（见 §0 关键事实）。
> 上游模型：[line_level_recapture_model.md](line_level_recapture_model.md)。

---

## 0. 现有数据通路关键事实（决定方案的硬约束）

核查结论（已读源码确认）：

1. **写地址由行号驱动，但行号是内部计数器。**
   - [addr_gen_frame_based.sv](../01_source_code/rtl/axi/addr_gen_frame_based.sv): `addr = frame_base + line_stride·line_id + byte_offset`。
   - [pixel_to_axi_writer.sv](../01_source_code/rtl/axi/pixel_to_axi_writer.sv): 喂给 addr_gen 的 `line_id` 来自内部计数器 `sys_line_id_q`，在 `frame_start` 清零、每个 `line_end` +1（L292/L319）。
   - **含义**：朴素地“多发一行”会被写到计数器的下一槽，而**不会覆盖坏行 k**。且 `sys_line_id_q >= frame_height` 的行会被丢弃（L310）。
   - **结论**：要做真正的“覆盖坏行”闭环，必须让重采行的写地址按 `retry_line_id` 寻址，而不是按计数器 → 这是 T2 的核心 RTL 增量。

2. **CRC 坏行已能被丢弃。** [packet_error_policy.sv](../01_source_code/rtl/reliability/packet_error_policy.sv) 的 `crc_drop_req_o` + writer 的 `discard_line_i` 通路可把坏行丢掉（不写 DDR），留出空槽等重采填补。

3. **retry 当前是纯观测。** [mipi_csi2_capture_top.sv](../01_source_code/rtl/top/mipi_csi2_capture_top.sv) 中 `retry_request_ctrl`（L1162）输出只进了 APB 状态寄存器（L517），**没有任何模块消费 retry 去改写地址**。这正是 §2.4 说的“闭环未完成”。

4. **标准 CSI-2 长包不带行号**，行靠顺序隐式确定 → 重采行的“目标行号”必须由**可控图像源的旁路信号**带出。这正对应 §3 的“条件（上游可控）”，是可行性前提，不是标准链路能力——与论文红线一致。

5. **`pixel_to_axi_writer` 在 top 内只实例化一次** → 只需改 top 一处实例连线，新端口默认接 0，**不影响现有 40+ wrapper 测试**。

---

## 1. T2 总体架构

把 retry 从“请求 + 定位”推进到“请求 + 定位 + 写回闭环”，新增/改动如下（按数据流）：

```
 可控相机(TB)                         DUT (mipi_csi2_capture_top)
 ┌──────────────────────┐            ┌───────────────────────────────────────┐
 │ recapture_camera_model│  lane字节  │ phy_adapter → csi2解析 → sync_fsm       │
 │  - 多行帧             │──────────▶ │      │              │                  │
 │  - 保留窗口深度 D     │            │   err_classifier   pixel流              │
 │  - 坏行注入(首发)     │            │      │              │                  │
 │  - 收到请求后重发该行 │            │ retry_request_ctrl  pixel_to_axi_writer │
 │    (干净) + 旁路标记  │            │      │                ▲ recap覆盖地址   │
 │                       │ recap旁路  │ recapture_writeback_ctrl ──────────────┤
 │                       │◀──────────▶│  (新模块: 把retry_line_id变成写回指令) │
 │  retry_*  ◀───────────┼────────────┤  retry_req/pending/line_id             │
 └──────────────────────┘            └───────────────────────────────────────┘
                                              │ AXI 写
                                              ▼  TB AXI sink memory ─→ 比对 golden
```

新增 1 个 RTL 模块、改 2 个文件、新增 2 个 TB 文件。

---

## 2. T2 分部分实现方案

### T2.1 RTL：`pixel_to_axi_writer` 增加重采写回端口（核心，最小改动）

**思路**：保持正常通路不变；当“重采行”流过时，用 `retry_line_id` 取代内部计数器寻址，且不推进计数器、不触发 height 丢弃。

**新增输入端口**（默认 0 → 行为与现状完全一致）：
- `recap_active_i`（level，重采行在流期间保持高，覆盖到该行 `line_end`）
- `recap_line_id_i [15:0]`（= retry_line_id，目标槽位）

**改动点**（line_end 提交块 L308–324）：
- 在 `line_end_i && sys_can_accept_line_end` 处，把当拍 `recap_active_i` 锁存到 `sys_line_recap_pending_q`，并锁存 `sys_recap_line_id_q <= recap_line_id_i`。
- 在 cmd 生成处：若 `sys_line_recap_pending_q`，则
  - `sys_cmd_line_id_q <= sys_recap_line_id_q;`（按目标行寻址）
  - **不**执行 `sys_line_id_q <= sys_line_id_q + 1`（不推进正常计数器）
  - drop 条件里排除 height 判断（重采行 id 必 < height）
- 复位/clear 路径补齐新寄存器。

**验证**：模块级 `tb_pixel_to_axi_writer_recap`（或在现有 tb_pixel_to_axi_writer 增 case）——正常写 3 行后，发一行 `recap_active`、`recap_line_id=1`，断言地址 = base+stride·1，且后续正常行计数器未受扰动。

### T2.2 RTL：新模块 `recapture_writeback_ctrl.sv`（创新载体，clk_sys）

**职责**：把 retry 请求 + 可控源旁路标记，翻译成 writer 的写回指令，并在写回完成后清 pending。

**接口**：
```
input  retry_pending_i, retry_mode_i, [31:0] retry_line_id_i   // 来自 retry_request_ctrl
input  src_recap_line_valid_i                                   // 可控源旁路: 正在重发某重采行
input  line_end_i                                               // 重采行结束沿(来自 sync_fsm)
output recap_active_o, [15:0] recap_line_id_o                   // 去 pixel_to_axi_writer
output retry_ack_o                                              // 写回完成→清 retry_pending
```

**逻辑**（极简 FSM / 组合 + 一个寄存器）：
- `recap_active_o = retry_pending_i && retry_mode_i && src_recap_line_valid_i`
  （三重门控：有未决请求 + 行级模式 + 源确实在重发，杜绝杂散触发）
- `recap_line_id_o = retry_line_id_i[15:0]`
- 当 `recap_active_o && line_end_i`（重采行收尾）→ 拉一拍 `retry_ack_o` 清 pending。
- 帧级模式（retry_mode=0）此模块不动作，交回原有“丢帧等下一帧”路径（保持帧级简单、力气不投帧级，符合 §2.5）。

**为什么单独成模块**：把“请求→写回”的闭环逻辑独立、可单测，论文里可把它作为机制贡献点单独画状态/时序图。

### T2.3 RTL：top 集成

- 实例化 `recapture_writeback_ctrl`，连 `retry_pending/retry_mode/retry_line_id`（已存在）+ `line_end`（已存在 sync_fsm 输出）+ 新增 top 输入 `src_recap_line_valid_i`（仿真由相机驱动；真实硬件来自可控源控制通道）。
- 把 `recap_active_o/recap_line_id_o` 接到 `pixel_to_axi_writer` 新端口。
- 把 `retry_ack_o` 或 与现有 `CTRL[3] retry_ack_pulse` 做 OR，去清 `retry_request_ctrl` 的 pending。
- top 新增端口 `src_recap_line_valid_i`，在现有 wrapper 里默认接 0（不影响旧 TB）。

### T2.4 TB：`recapture_camera_model.sv`（可控图像源）

**相对现有 [sensor_model.sv](../04_tb_tests/tb/models/sensor_model.sv) 的升级**（现有只发**单行帧**、发完即停）：
- **多行帧**：`FS, {LS,long(line i),LE}×H, FE`，H 小（如 8）。每行长包 payload 由 golden 函数 `line_pixel(frame,line,idx)` 决定。
- **保留窗口 D**：内部 ring 记录最近 D 个已发行的 (frame,line)；只有窗口内的行可被重采（请求窗口外 → 拒绝并置 `recap_reject_o`，用于演示 T1 的 D 边界）。
- **坏行注入**：参数 `INJ_FRAME/INJ_LINE`，仅**首发**时对该行 payload 异或扰动（触发 CRC 错）；用 `recaptured[frame][line]` 标记，使重采发干净数据。
- **请求响应**：监听 `retry_req_i/retry_line_id_i/retry_mode_i`。行级请求且命中窗口 → 在当前行收尾后插入一行重采序列 `{LS,long(line k 干净),LE}`，期间拉 `src_recap_line_valid_o`（贯穿到该行 LE），并把行内容设为 line k。之后继续正常 line k+1…（正常行不影响计数器；重采行靠旁路覆盖到槽 k）。
- **golden 输出**：对每个 (frame,line) 提供期望像素，供 scoreboard 重建整帧比对。

### T2.5 TB：`tb_recapture_line_level_closed_loop.sv`（系统级闭环演示）

参考 [tb_fpga_wrapper_crc_error.sv](../04_tb_tests/tb/tests/tb_fpga_wrapper_crc_error.sv) 的 AXI sink memory readback 骨架。

**步骤**：
1. 配置 IMG_WIDTH/HEIGHT（小尺寸，如 64×8）、DT=RAW8、`ERR_POLICY` 使能 retry + line_mode + CRC 丢行。
2. 相机发一帧，在 (f=1,line=k) 注坏行。
3. 观测链路：CRC 错 → 坏行丢弃 → retry_request_ctrl 锁存 (f,k) 拉 retry_req → writeback_ctrl 进入 pending → 相机窗口内重发 line k（干净）+ 旁路 → writer 把 line k 写回槽 k → retry_ack 清 pending。
4. 帧尾读 AXI mem，**重建帧 == golden** → 断言通过（“恢复出正确帧”）。
5. **量化留痕**：重采延迟（请求→重采行写回的行数，应 ≤ D）、额外传输行数（=1）、占用窗口 = D·L。写入结果 md。

**负向对照（同一 TB 第二轮 / 或 disable 重采）**：关闭 line_mode（或请求窗口外行）→ 槽 k 为坏/空 → 重建帧 ≠ golden → 断言“无重采则不可恢复”。这条同时是 T3 的“只丢不重采”基线。

### T2.6 编译/回归接入

- 把新 RTL 加入 [compile.f](../04_tb_tests/compile.f) 与 vcs compile.f。
- 新 TB 跑通（xsim/vcs，按现有脚本）。
- 跑一遍既有 wrapper 回归，确认新端口默认 0 未引入回归。

---

## 3. T3 实现方案（在 T2 之上，复用相机）

**思路**：同一可控相机 + 同一注错序列，切换三种恢复策略，采同样指标，画曲线并与 T1 模型叠加验证。

- **三策略开关**（已有/新增配置）：
  - A 行级重采：T2 闭环。
  - B 整帧重传：相机收到任一坏行 → 整帧重发（已有“发一帧”能力扩成“可重发整帧”），writer 用整帧覆盖。
  - C 整帧丢弃：retry 关闭 + 坏帧丢（现有路径）。
- **扫描**：注错位置/密度（等效 BER 点，对齐 T1 的 `p`），多帧。
- **采集**：有效好帧产出率、额外传输字节、恢复延迟（行/帧）。
- **产出**：`07_project_result_analysis/recapture_baseline_results.md` 表 + 把仿真点用 `recapture_model.py` 叠加到模型曲线（脚本已留 overlay 接口）。

---

## 4. 风险与防守

| 风险 | 缓解 |
|---|---|
| 改 writer 影响既有回归 | 新端口默认 0；单实例化点；先跑全回归 |
| “重采行号靠旁路”被质疑非标准 | 论文明确表述为“可控图像源前提下”，对应 §3 条件 / T5；不声称标准链路能力（守红线，[[feedback-thesis-wording-red-lines]]）|
| 帧级被误当创新 | writeback_ctrl 帧级不动作，演示与曲线都突出行级（§2.5）|
| 窗口外请求 | 相机置 reject，演示 D 边界 → 正好支撑 T1/T4 量化边界 |

---

## 5. 执行顺序（建议）

1. **T2.1** writer 重采端口 + 模块级单测（最小、最先，验证寻址覆盖成立）
2. **T2.2** recapture_writeback_ctrl + 模块级单测
3. **T2.3** top 集成（新端口默认 0，先不破回归）
4. **T2.4** recapture_camera_model
5. **T2.5** 系统级闭环 TB + 跑通 + 负向对照
6. **T2.6** 回归接入 + 既有回归确认
7. **T3** 三基线扫描 + 曲线叠加
8. 文档：更新结果 md、与红线对齐
