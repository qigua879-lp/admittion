# Thesis Result Tables

## Purpose

本文件用于提前定义论文结果表结构，让后续实验、综合和统计结果能直接映射到正文图表，而不是在论文写作后期临时补表。

## Status Markers

每个字段都使用以下状态标记：

- `已有`：当前仓库或报告中已有可直接整理的数据
- `需补采`：需要通过新增实验或重新跑仿真获得
- `需通过对比实验得到`：需要配置对比、策略对比或多组实验后统计得到

## 1. 功能覆盖表

### Table Purpose

用于回答“系统做到了哪些功能覆盖”，适合放在论文验证章节开头或系统设计章节结尾。

| 字段 | 说明 | 当前状态 |
| --- | --- | --- |
| 支持数据类型 `DT` | RAW8、RAW10、RGB888、YUV422 | 已有 |
| 支持 lane 数配置 | 1 / 2 / 4 lane | 已有 |
| Short packet 事件支持 | FS / FE / LS / LE | 已有 |
| Long packet payload 接收 | 支持顶层主链路 | 已有 |
| Header ECC 检测 | good / error / correctable classification | 已有 |
| Payload CRC 检测 | 累加、expected CRC、mismatch | 已有 |
| 帧/行同步 | frame/line marker 与计数 | 已有 |
| 错误分类 | ecc / crc / sync / lane | 已有 |
| 恢复策略 | resync / degrade / recover / discard policy | 已有 |
| 系统级验证覆盖 | top smoke、CRC/ECC/同步异常等 | 需补采 |
| FPGA 原型化验证覆盖 | wrapper、综合、约束基础 | 已有 |

## 2. 性能 / 恢复结果表

### Table Purpose

用于回答“系统性能如何、出错后恢复效果如何”，是论文最能体现硕士层级实验分量的表。

| 字段 | 说明 | 当前状态 |
| --- | --- | --- |
| 基础吞吐率 | 在给定 lane/format 下的像素/字节流吞吐 | 需补采 |
| 主链路稳定性 | 单帧、多行、多 lane smoke 的通过情况 | 已有 |
| CRC 错误恢复时延 | 从 CRC error 到系统进入稳定状态的时延 | 需补采 |
| Sync 错误恢复时延 | 从非法 FS/LS/LE/FE 到恢复稳定的时延 | 已有基础测量入口 |
| Lane 降级恢复门限 | good frame 数与 lane 恢复关系 | 需补采 |
| 丢弃粒度 | packet / line / frame 级别 | 需通过对比实验得到 |
| 错误隔离效果 | 错误是否局限于当前 line/frame | 需通过对比实验得到 |
| Buffer 深度需求 | 不同背压下 async FIFO / writer FIFO 需求 | 需通过对比实验得到 |
| AXI 背压容忍性 | backpressure 下完成度、无死锁行为 | 已有基础测量入口 |
| Resync 期间重复错误表现 | repeated error 时的状态一致性 | 已有 |
| Lane skew 容忍窗口 | 在给定 `DESKEW_DEPTH` 下可接受的领先 lane 字节差 | 已有 |

## 3. 资源 / 时序结果表

### Table Purpose

用于回答“设计代价如何、是否可综合、可实现到什么程度”，建议放在论文综合实现分析章节。

| 字段 | 说明 | 当前状态 |
| --- | --- | --- |
| 综合目标顶层 | `mipi_csi2_capture_top` 或 FPGA wrapper | 已有 |
| LUT 使用量 | 逻辑资源占用 | 已有 |
| FF 使用量 | 寄存器资源占用 | 已有 |
| BRAM 使用量 | FIFO / buffer 资源占用 | 已有 |
| DSP 使用量 | 若预处理路径使用 DSP，则统计 | 已有 |
| Fmax | 关键时钟可达频率 | 已有基础结果 |
| Worst path | 关键路径位置与 slack | 已有 |
| 约束边界说明 | 现阶段 XDC/board pin 的限制 | 已有 |
| 实现定位 | 综合可行性验证 / 原型化验证 | 已有 |

## 4. Recommended Comparison Tables

下面三类对比表不是 Stage A 全部做完，但从现在开始就应该按这个结构积累数据。

### 4.1 可靠性策略对比

| 对比项 | 说明 | 当前状态 |
| --- | --- | --- |
| 无恢复策略 | 仅检测错误，不执行恢复 | 需通过对比实验得到 |
| 有 resync | 启用重同步策略 | 需通过对比实验得到 |
| 有 degrade/recover | 启用降级恢复策略 | 需通过对比实验得到 |
| 结果指标 | 恢复时延、丢弃粒度、错误隔离效果 | 需通过对比实验得到 |

### 4.2 lane / format 配置对比

| 对比项 | 说明 | 当前状态 |
| --- | --- | --- |
| lane1 vs lane2 vs lane4 | 比较吞吐和复杂度 | 已有基础 smoke 证据，量化对比仍需补 |
| RAW8 vs RAW10 vs RGB888 | 比较系统路径覆盖和数据组织差异 | 需通过对比实验得到 |

### 4.3 buffer / AXI 配置对比

| 对比项 | 说明 | 当前状态 |
| --- | --- | --- |
| FIFO 深度变化 | 比较背压容忍性和资源开销 | 需通过对比实验得到 |
| AXI beat 宽度 / burst 设置 | 比较写通路效率和复杂度 | 需通过对比实验得到 |

## 5. Stage A Immediate Collection Targets

Stage A 目前已经开始积累下面这些结果：

1. `RAW8 single-frame smoke` 的通过证据和关键波形
2. `CRC error` 系统级错误注入的通过证据和关键波形
3. `RAW8 metrics` 的主链路时延结果
4. `AXI backpressure metrics` 的 stall 与释放后握手结果
5. 当前已有综合/脚本/约束边界的整理框架

## 6. Current Collected Metrics

下面这些数字已经通过真实 top / wrapper 样例 fresh run 获取，可直接作为论文表格草稿输入：

### 6.1 RAW8 主链路时延

来源：`tb_fpga_wrapper_raw8_metrics`

| 指标 | 数值 | 说明 |
| --- | --- | --- |
| `init_to_frame` | `14` 个 `clk_sys` 周期 | 从 wrapper boot 完成到首个 `frame_start_o` |
| `frame_to_first_pixel` | `16` 个 `clk_sys` 周期 | 从 `frame_start_o` 到首个 `pixel_valid_o` |
| `frame_to_end` | `34` 个 `clk_sys` 周期 | 从 `frame_start_o` 到 `frame_end_o` |
| `first_to_last_pixel` | `3` 个 `clk_sys` 周期 | 首个到最后一个像素输出跨度 |
| `pixel_valid_cycles` | `4` 个 `clk_sys` 周期 | 对应当前 RAW8 单帧样例的像素输出周期数 |

### 6.2 AXI 背压基础结果

来源：`tb_fpga_wrapper_axi_backpressure_metrics`

| 指标 | 数值 | 说明 |
| --- | --- | --- |
| `aw_stall_cycles` | `6` 个 `clk_axi` 周期 | AXI AW 通道在 `ready=0` 下的阻塞持续时间 |
| `w_stall_cycles` | `6` 个 `clk_axi` 周期 | AXI W 通道在 `ready=0` 下的阻塞持续时间 |
| `aw_release_to_fire` | `81` 个 `clk_axi` 周期 | AW `ready` 释放到真实握手 fire 的周期差 |
| `axi_busy_duration` | `4` 个 `clk_axi` 周期 | `axi_busy` 活跃持续时间 |
| `frame_result` | `exp=4 act=4` | 背压下像素结果与期望一致 |

### 6.3 RGB888 主链路时延

来源：`tb_fpga_wrapper_rgb888_metrics`

| 指标 | 数值 | 说明 |
| --- | --- | --- |
| `init_to_frame` | `14` 个 `clk_sys` 周期 | 从 wrapper boot 完成到首个 `frame_start_o` |
| `frame_to_first_pixel` | `18` 个 `clk_sys` 周期 | 从 `frame_start_o` 到首个 `pixel_valid_o` |
| `frame_to_end` | `42` 个 `clk_sys` 周期 | 从 `frame_start_o` 到 `frame_end_o` |
| `first_to_last_pixel` | `9` 个 `clk_sys` 周期 | 首个到最后一个像素输出跨度 |
| `pixel_valid_cycles` | `4` 个 `clk_sys` 周期 | 对应当前 RGB888 单帧样例的像素输出周期数 |

### 6.4 已闭环但尚未量化成统一表格的结果

| 样例 | 当前结论 | 后续可量化方向 |
| --- | --- | --- |
| `tb_fpga_wrapper_resync_recovery` | `err_sync -> resync_req -> resync_busy -> resync_done -> clear` 信号链闭合 | 补 `sync error` 到 `resync_done` 的周期数 |
| `tb_fpga_wrapper_resync_repeated_error` | `resync_busy` 期间再次报错后恢复流程仍闭合 | 补 repeated error 次数与恢复时延统计 |
| `tb_fpga_wrapper_lane_skew_tolerance` | deskew 容忍范围内像素输出正确 | 已由 `tb_fpga_wrapper_lane_skew_scan` 补成系统级窗口表 |
| `tb_fpga_wrapper_lane_skew_overflow` | 超界 skew 时可观测到 backpressure 和 overflow | 已由 `tb_fpga_wrapper_lane_skew_scan` 固化 overflow 边界 |
| `tb_fpga_wrapper_resync_metrics` | 已给出恢复信号链阶段时延数字 | 补 repeated-error 分布 |
| `tb_fpga_wrapper_resync_clean_frame` | 已证明恢复后重新回到 clean RAW8 输出路径 | 已有 |

### 6.5 RAW10 像素路径时延

来源：`tb_fpga_wrapper_raw10_metrics`

| 指标 | 数值 | 说明 |
| --- | --- | --- |
| `init_to_frame` | `16` 个 `clk_sys` 周期 | 从 wrapper boot 完成到首个 `frame_start_o` |
| `frame_to_first_pixel` | `20` 个 `clk_sys` 周期 | 从 `frame_start_o` 到首个 `pixel_valid_o` |
| `frame_to_end` | `38` 个 `clk_sys` 周期 | 从 `frame_start_o` 到 `frame_end_o` |
| `first_to_last_pixel` | `3` 个 `clk_sys` 周期 | 首个到最后一个像素输出跨度 |
| `pixel_valid_cycles` | `4` 个 `clk_sys` 周期 | 对应当前 RAW10 单帧样例的像素输出周期数 |
| `frame_result` | `exp=4 act=4, full_frame=1` | 当前真实 top 下 RAW10 像素路径与 frame/line 收尾结果均与期望一致 |

注：

- 当前 RAW10 wrapper 样例已经稳定证明像素路径与 `FS/LS/LE/FE` 收尾闭合。
- 为了把 RAW10 尾部最后一个 `FE` ECC 字节稳定冲出当前 2-lane wrapper 路径，testbench 在 `FE` short packet 后追加了一个 flush byte；该补充只用于把末尾单字节从适配路径中推出，不改变 DUT RTL。

### 6.6 YUV422 主链路时延

来源：`tb_fpga_wrapper_yuv422_metrics`

| 指标 | 数值 | 说明 |
| --- | --- | --- |
| `init_to_frame` | `14` 个 `clk_sys` 周期 | 从 wrapper boot 完成到首个 `frame_start_o` |
| `frame_to_first_pixel` | `19` 个 `clk_sys` 周期 | 从 `frame_start_o` 到首个 `pixel_valid_o` |
| `frame_to_end` | `40` 个 `clk_sys` 周期 | 从 `frame_start_o` 到 `frame_end_o` |
| `first_to_last_pixel` | `7` 个 `clk_sys` 周期 | 首个到最后一个像素输出跨度 |
| `pixel_valid_cycles` | `4` 个 `clk_sys` 周期 | 对应当前 YUV422 单帧样例的像素输出周期数 |
| `frame_result` | `exp=4 act=4` | 当前真实 top 下 YUV422 主链路结果与期望一致 |

### 6.7 多格式横向比较表

来源：

- `tb_fpga_wrapper_raw8_metrics`
- `tb_fpga_wrapper_raw10_metrics`
- `tb_fpga_wrapper_rgb888_metrics`
- `tb_fpga_wrapper_yuv422_metrics`

| Format | `init_to_frame` | `frame_to_first_pixel` | `frame_to_end` | `first_to_last_pixel` | `pixel_valid_cycles` | Full-frame closure | 说明 |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| `RAW8` | `14` | `16` | `34` | `3` | `4` | Yes | baseline 最短主链路 |
| `RAW10` | `16` | `20` | `38` | `3` | `4` | Yes | header/payload 收尾完整，首像素时延高于 `RAW8` |
| `RGB888` | `14` | `18` | `42` | `9` | `4` | Yes | 打包粒度更宽，整帧跨度最长 |
| `YUV422` | `14` | `19` | `40` | `7` | `4` | Yes | 介于 `RAW10` 与 `RGB888` 之间 |

比较结论建议：

- `RAW8` 仍是当前最短的 baseline 路径，`frame_to_first_pixel` 与 `frame_to_end` 都最小。
- `RAW10` 的像素输出跨度与 `RAW8` 一致，但首像素与整帧收尾时延更高，说明额外解包复杂度主要体现在前端整理阶段，而不是最终像素吐出长度。
- `RGB888` 的 `frame_to_end` 与 `first_to_last_pixel` 都最大，符合 24-bit 像素路径在当前最小样例下的数据组织特征。
- `YUV422` 的整体时延介于 `RAW10` 与 `RGB888` 之间，适合作为中等复杂度格式的工程参考点。

边界说明：

- 当前比较表基于相同 wrapper 启动框架下的最小单帧样例，适合用于“格式间主链路相对差异”比较，不等价于最终吞吐上限测试。
- `RAW10` full-frame closure 在 testbench 中通过 `FE` 后追加一个 flush byte 完成尾部单字节冲刷；该处理只作用于激励层，不改变 DUT RTL。

### 6.8 Buffer 深度与背压关系基础扫描

来源：

- `tb/tests/tb_fpga_wrapper_buffer_depth_sweep.sv`
- `scripts/run_buffer_depth_sweep.ps1`
- `docs/spec/结果验证/buffer_depth_sweep_results.md`

测试配置：

- `DATA_TYPE=RAW8`
- `LANE_NUM=2`
- `PIXEL_COUNT=16`
- `AXI_DATA_WIDTH=128`
- `BYTE_FIFO_ADDR_WIDTH ∈ {2,3,4}`
- `AXI_FIFO_ADDR_WIDTH ∈ {3,4,6}`
- `AXI_STALL_CYCLES ∈ {6,16}`

关键归纳结果：

| 观测项 | 结果 | 说明 |
| --- | --- | --- |
| `max_byte_fifo_level` | 随 `BYTE_FIFO_ADDR_WIDTH` 提升而增加：`3 -> 7 -> 10` | 更深 byte FIFO 会吸收更多背压积压 |
| `max_axi_fifo_level` | 固定为 `4` | 当前 16-pixel 样例下 writer data FIFO 尚未成为瓶颈 |
| `lane_bp_cycles` | 全部为 `0` | 本工作点下背压尚未传回 sensor lane 侧 |
| `pixel_stall_cycles` | 全部为 `0` | 本工作点下背压尚未传回像素输出侧 |
| `axi_busy_duration` | 固定为 `4` 个 `clk_axi` 周期 | 在当前稳定样例下主要受固定 line write 行为支配 |

论文/工程表述建议：

- 当前基础扫描说明：在稳定可复现的 `16-pixel` 单行样例下，增大 byte-to-sys FIFO 深度会提高可吸收的瞬时积压，但尚未改变 writer FIFO 峰值占用，也未把背压传播到像素侧或 lane 侧。
- 因此可将这一轮结果表述为“缓存占用趋势扫描”，而不是“最终吞吐上限”或“系统饱和边界”。
- 若后续要形成更强工程结论，仍需补更长行、更连续多帧或更窄 AXI 数据宽度下的扩展扫描。

### 6.9 连续多帧 / 多行稳定性证明

来源：

- `tb/tests/tb_fpga_wrapper_raw8_multiframe_stability.sv`
- `docs/spec/结果验证/raw8_multiframe_stability_results.md`

测试配置：

- `DATA_TYPE=RAW8`
- `LANE_NUM=2`
- `FRAME_COUNT=3`
- `LINE_COUNT=3`
- `PIXELS_PER_LINE=4`

结果摘要：

| 观测项 | 结果 | 说明 |
| --- | --- | --- |
| frame count | `3` | `frame_start_o / frame_end_o` 都完整闭合 |
| line count | `9` | `line_start_o / line_end_o` 都完整闭合 |
| total pixels | `36` | 连续多帧多行像素总量符合预期 |
| scoreboard frames | `3` | scoreboard 侧帧计数与输入一致 |
| mismatch | `0` | 未观察到像素错序或 silent corruption |

论文/工程表述建议：

- 当前系统级验证已经不再局限于最小单帧样例。
- 在真实 wrapper 路径下，系统可连续完成 `3` 帧、每帧 `3` 行的 `RAW8` 主链路闭环，且 marker 与像素结果均保持一致。
- 这一结果适合作为“基础连续流稳定性”证明；若后续要形成更强工程结论，仍可继续扩展到更长连续帧序列或混合异常场景。

### 6.10 RAW8 连续流背压强化扫描

来源：

- `tb/tests/tb_fpga_wrapper_raw8_backpressure_stress.sv`
- `scripts/run_raw8_backpressure_stress_sweep.ps1`
- `docs/spec/结果验证/raw8_backpressure_stress_results.md`

测试配置：

- Fixed traffic: `RAW8`, `LANE_NUM=2`, `BYTE_FIFO_ADDR_WIDTH=2`, `AXI_DATA_WIDTH=128`
- Variable knobs: `AXI_FIFO_ADDR_WIDTH`, `AXI_STALL_CYCLES`, `FRAME_COUNT`, `LINE_COUNT`
- Stress method: for each observed `AWVALID/WVALID`, keep `AWREADY/WREADY` low for a fixed number of `clk_axi` cycles before release

关键归纳结果：

| 工作点 | 结果 | 说明 |
| --- | --- | --- |
| `axi_fifo_aw=3, stall=12, 4x4` | `PASS`, `lane_bp_cycles=256`, `max_axi_fifo=2` | 已出现 lane 侧回压 |
| `axi_fifo_aw=3, stall=16, 6x4` | `PASS`, `lane_bp_cycles=416`, `max_axi_fifo=6` | 压力增强后仍保持 scoreboard 闭合 |
| `axi_fifo_aw=3, stall=16, 8x4` | `PASS`, `lane_bp_cycles=576`, `max_axi_fifo=7` | 当前稳定区中 FIFO 占用最高 |
| `axi_fifo_aw=3, stall=24, 4x4` | `PASS`, `lane_bp_cycles=256`, `max_axi_fifo=7` | 更重 AW/W stall 下仍未破坏主链路 |
| `axi_fifo_aw=2, stall=16, 6x4` | `FAIL`, timeout with mismatch | 极浅 writer FIFO 下进入失稳边界 |

论文/工程表述建议：

- 这一轮比基础 `16-pixel` 单行扫描更接近工程连续流压力场景，因为回压已经稳定传播到 `lane_ready` 侧。
- 在稳定通过区间内，`pixel_stall_seen` 仍为 `0`，说明当前实现会先通过 lane 入口节流吸收 AXI 背压，再进一步向像素侧传播。
- 当 `AXI_FIFO_ADDR_WIDTH` 进一步缩小到 `2` 时，`stall=16, 6x4` 连续流已经出现 scoreboard 失配与超时，因此该配置不适合作为当前工程推荐值。
- 现阶段可将 `AXI_FIFO_ADDR_WIDTH=3` 视为当前更稳妥的最小建议值；若要继续压榨资源，还需要针对 `AXI_FIFO_ADDR_WIDTH=2` 做专项排查。

### 6.11 RAW8 Lane1 / Lane4 Wrapper Smoke

来源：

- `tb/tests/tb_fpga_wrapper_raw8_lane_config_smoke.sv`
- `scripts/run_raw8_lane_config_smokes.ps1`
- `docs/spec/结果验证/raw8_lane_config_results.md`

测试配置：

- Fixed traffic: `RAW8` single-frame wrapper path
- 扫描配置：
  - `LANE_NUM=1` with `cfg_lane_num_minus1=0`, `lane_enable_mask=0001`
  - `LANE_NUM=4` with `cfg_lane_num_minus1=3`, `lane_enable_mask=1111`
- 为了让 lane4 分组精确闭合，本 smoke 使用 `2-byte` 最小 `RAW8` payload

结果摘要：

| lane config | exp pixels | act pixels | frames | 说明 |
| --- | --- | --- | --- | --- |
| `lane1` | `2` | `2` | `1` | 单 lane wrapper 路径闭合 |
| `lane4` | `2` | `2` | `1` | 四 lane wrapper 路径闭合 |

论文/工程表述建议：

- 配合既有 `lane2 RAW8 smoke`，现在可以更稳妥地表述为：`1 / 2 / 4 lane` 配置能力已实现，并且三种配置都已具备至少一条 wrapper 级系统闭环证据。
- 这批结果仍属于最小 smoke 级补证，不等价于 `lane1 / lane4` 已经拥有与 `lane2` 同等强度的异常注入、恢复和吞吐量化覆盖。

### 6.12 Resync 恢复时延

来源：`tb_fpga_wrapper_resync_metrics`

| 指标 | 数值 | 说明 |
| --- | --- | --- |
| `sync_to_req` | `1` 个 `clk_sys` 周期 | 从 `err_sync_o` 到 `resync_req` 被观测到 |
| `req_to_busy` | `0` 个 `clk_sys` 周期 | `resync_req` 到 `resync_busy` 的进入间隔 |
| `busy_to_clear` | `0` 个 `clk_sys` 周期 | `resync_busy` 到 `resync_clear_pulse_sys` 的间隔 |
| `clear_to_done` | `1` 个 `clk_sys` 周期 | clear 脉冲到 `resync_done_o` 的间隔 |
| `sync_to_done` | `2` 个 `clk_sys` 周期 | 从 `err_sync_o` 到 `resync_done_o` 的总间隔 |

### 6.13 Lane Skew 容忍窗口扫描

来源：`tb_fpga_wrapper_lane_skew_scan`

补充留痕：

- `docs/spec/结果验证/lane_skew_scan_results.md`

测试配置：

- `LANE_NUM=2`
- `DATA_TYPE=RAW8`
- `DESKEW_DEPTH=4`

| `lead_bytes` | Pixel result | Overflow | 结论 |
| --- | --- | --- | --- |
| `0` | `act=4, mismatch=0` | `0` | 通过 |
| `1` | `act=4, mismatch=0` | `0` | 通过 |
| `2` | `act=4, mismatch=0` | `0` | 通过 |
| `3` | `act=4, mismatch=0` | `0` | 通过 |
| `4` | `act=4, mismatch=0` | `0` | 边界通过 |
| `5` | `act=0, mismatch=0` | `1` | 超界 overflow |

论文表述建议：

- 可容忍窗口：`0..4` 字节
- 超界阈值：`5` 字节
- 在本配置下可归纳为：
  - `tolerance window = DESKEW_DEPTH`
- `overflow boundary = DESKEW_DEPTH + 1`

### 6.14 Lane / Buffer 联合敏感性扫描

来源：

- `tb/tests/tb_fpga_wrapper_lane_skew_scan.sv`
- `scripts/run_lane_buffer_sensitivity_sweep.ps1`
- `docs/spec/结果验证/lane_buffer_sensitivity_results.md`

测试矩阵：

- `DESKEW_DEPTH ∈ {2, 4, 6}`
- `BYTE_FIFO_ADDR_WIDTH ∈ {2, 4}`
- `AXI_FIFO_ADDR_WIDTH ∈ {3, 6}`
- Fixed traffic: `RAW8`, `LANE_NUM=2`, single-frame wrapper path

关键归纳结果：

| `DESKEW_DEPTH` | `BYTE_FIFO_ADDR_WIDTH` | `AXI_FIFO_ADDR_WIDTH` | 容忍窗口 | overflow 边界 |
| --- | --- | --- | --- | --- |
| `2` | `2 / 4` | `3 / 6` | `0..2` | `3` |
| `4` | `2 / 4` | `3 / 6` | `0..4` | `5` |
| `6` | `2 / 4` | `3 / 6` | `0..6` | `7` |

论文/工程表述建议：

- 在当前联合扫描矩阵内，所有组合都满足：
  - `lane skew tolerance window = DESKEW_DEPTH`
  - `lane skew overflow boundary = DESKEW_DEPTH + 1`
- 这说明真实 wrapper 路径下，lane skew 容忍能力的主导因素仍是 `lane_deskew_buffer` 本身深度，而不是 `BYTE FIFO` 或 `AXI writer FIFO` 的选值。
- `ready_low` 的出现位置会变化，但不会改变容忍窗口，因此它更适合作为瞬时回压现象记录，而不是越界判据。
- 对工程选型而言，如果目标是扩大 lane skew 容忍窗口，应优先增大 `DESKEW_DEPTH`；仅增大后级 FIFO 不能等效替代 deskew 深度。

### 6.15 Resync 后 Clean-Frame 恢复证明

来源：`tb_fpga_wrapper_resync_clean_frame`

补充留痕：

- `docs/spec/结果验证/resync_clean_frame_results.md`

| 观测项 | 结果 | 说明 |
| --- | --- | --- |
| `err_sync_o` | `1` | 非法序列已触发同步错误 |
| `resync_req / busy / done` | 全部观测到 | 恢复链保持闭合 |
| `resync_clear_pulse_sys` | `1` | sys 域 clear 已发生 |
| `resync_clear_pulse_byte` | `1` | byte 域 clear 已发生 |
| clean-frame `frame/line/pixel` | 全部恢复 | 恢复后重新回到正常输出路径 |
| scoreboard | `exp=4 act=4 mismatch=0` | 干净 RAW8 帧像素闭合正确 |

论文表述建议：

- 当前系统不仅能够完成 `sync error -> resync` 信号链闭环，
- 还能够在恢复完成后重新接收并正确输出后续 clean frame，
- 因而恢复策略具备“恢复后继续工作”而非“仅清空状态”的系统级有效性。

### 6.16 Resync + Backpressure + Clean Multiframe 混合场景

来源：

- `tb/tests/tb_fpga_wrapper_resync_backpressure_multiframe.sv`
- `docs/spec/结果验证/resync_backpressure_multiframe_results.md`

测试配置：

- `RAW8`, `LANE_NUM=2`
- `BYTE_FIFO_ADDR_WIDTH=2`
- `AXI_FIFO_ADDR_WIDTH=3`
- `FRAME_COUNT=2`
- `LINE_COUNT=2`
- 场景顺序：
  - 先发送 `illegal sync` 触发 `resync`
  - 等待 `clear_byte` 与 parser/merge/FIFO drain 完成
  - 再发送连续 clean multiframe，并对 AXI `AW/W` 施加固定 `12-cycle` backpressure

结果摘要：

| 观测项 | 结果 | 说明 |
| --- | --- | --- |
| `resync_req / busy / done` | 全部观测到 | 恢复链完整闭合 |
| `clear_sys / clear_byte` | 全部观测到 | 恢复后的 sys/byte 域清空都已发生 |
| clean frame count | `2` | 恢复后连续两帧都完成 |
| clean line count | `4` | 每帧两行完整输出 |
| pixel result | `exp=16 act=16 mismatch=0` | 恢复后的连续 clean 流像素闭合正确 |
| `aw_stall_cycles` | `52` | AXI 背压已真实施加 |
| `w_stall_cycles` | `52` | AXI 背压已真实施加 |

论文/工程表述建议：

- 这条证据说明当前系统并不是只能在“恢复后无负载”的理想情况下工作。
- 即使恢复后的 clean multiframe 同时遭遇 AXI 写通路背压，主链路仍能保持 marker 和像素结果正确。
- 因此可将当前恢复策略表述为：具备“恢复后继续连续工作”的系统级有效性，而不是仅证明恢复脉冲本身存在。

### 6.17 Vivado 资源与时序结果

来源：

- `fpga/vivado/reports/mipi_csi2_capture_fpga_head_20260519/synth_utilization.rpt`
- `fpga/vivado/reports/mipi_csi2_capture_fpga_head_20260519/impl_utilization.rpt`
- `fpga/vivado/reports/mipi_csi2_capture_fpga_head_20260519/impl_timing_summary.rpt`

测试对象：

- 顶层：`mipi_csi2_capture_fpga_wrapper`
- 器件：`xczu9eg-ffvb1156-2-e`
- 约束：占位 XDC，`clk_sys/clk_axi/clk_ddr = 200 MHz`，`clk_byte = 187.5 MHz`

资源结果：

| 指标 | 综合后 | 实现后 | 说明 |
| --- | ---: | ---: | --- |
| LUT | `541` | `530` | 当前 HEAD 实现后与综合估计接近 |
| FF | `818` | `819` | 基本稳定 |
| BRAM Tile | `0` | `0` | 当前 FIFO 主要落在 LUTRAM / 寄存器 |
| DSP | `0` | `0` | 当前轻量预处理未引入 DSP |
| Bonded IOB | `59 / 328` | `59 / 328` | wrapper 方案已消除 I/O 超限 |

时序结果：

| 指标 | 数值 | 说明 |
| --- | ---: | --- |
| Global routed WNS | `-2.725 ns` | 全局 setup 未收敛 |
| Global routed TNS | `-327.762 ns` | 全局 setup 负裕量总和 |
| Worst violated clock pair | `clk_byte -> clk_sys` | 主负 slack 来自跨时钟路径 |
| Worst violated path | `u_byte_to_sys_fifo.mem_reg_0_15_0_5/RAMD_D1 -> u_payload_crc_checker.crc_error_reg/D` | 指向 byte 域到 sys 域边界 |

同域时序结果：

| 时钟域 | 目标周期 | Routed WNS | 估算可达周期 | 估算 Fmax |
| --- | ---: | ---: | ---: | ---: |
| `clk_sys` | `5.000 ns` | `1.715 ns` | `3.285 ns` | `304.4 MHz` |
| `clk_byte` | `5.333 ns` | `2.610 ns` | `2.723 ns` | `367.2 MHz` |
| `clk_axi` | `5.000 ns` | `2.835 ns` | `2.165 ns` | `461.9 MHz` |

论文表述建议：

- 上述数字基于 `2026-05-19` 当前分支 `HEAD` 的 fresh routed report，而不是 `2026-05-06` 历史留痕。
- 在当前 FPGA wrapper 和占位时钟约束下，设计的同域主路径可满足 `200 MHz / 187.5 MHz` 目标。
- 这组数字保留为 `timing_cdc_v1` 问题基线：全局负 slack 主要来自 `clk_byte -> clk_sys` CDC 相关路径。
- `timing_cdc_v2` 已基于现有异步 FIFO/同步器结构补充 `clk_byte` 与 `clk_sys` 异步时钟组约束；最终论文引用收敛数据前，应使用 v2 约束重新跑 Vivado。
- 现阶段结果足以支持“RTL 可综合、wrapper 可实现、资源占用较低”的论文结论；后续 `board_io_v1` 已补实验版 `LOC/IOSTANDARD`、IO delay 并生成 bitstream，但真实上板仍需按原理图替换 pinout 并继续 timing closure。

### 6.18 timing_cdc_v2 结果更新

来源：

- `fpga/vivado/reports/mipi_csi2_capture_fpga_timing_cdc_v2/synth_utilization.rpt`
- `fpga/vivado/reports/mipi_csi2_capture_fpga_timing_cdc_v2/impl_utilization.rpt`
- `fpga/vivado/reports/mipi_csi2_capture_fpga_timing_cdc_v2/impl_timing_summary.rpt`
- `fpga/vivado/reports/mipi_csi2_capture_fpga_timing_cdc_v2/impl_drc.rpt`

测试对象：

- 顶层：`mipi_csi2_capture_fpga_wrapper`
- 器件：`xczu9eg-ffvb1156-2-e`
- 约束：占位 XDC，`clk_sys/clk_axi/clk_ddr = 200 MHz`，`clk_byte = 187.5 MHz`
- 版本：`timing_cdc_v2`

资源结果：

| 指标 | 综合后 | 实现后 | 说明 |
| --- | ---: | ---: | --- |
| LUT | `634` | `618` | 直接 routed 流程下的实现资源略低于综合估计 |
| FF | `1165` | `1135` | 与当前 wrapper 完整端口版本一致 |
| BRAM Tile | `0` | `0` | 当前 FIFO 仍未使用 BRAM |
| DSP | `0` | `0` | 当前轻量预处理未引入 DSP |
| Bonded IOB | `77 / 328` | `77 / 328` | 当前完整 wrapper 端口数对应 I/O 占用 |

时序结果：

| 指标 | 数值 | 说明 |
| --- | ---: | --- |
| Global routed WNS | `1.884 ns` | setup 满足 |
| Global routed TNS | `0.000 ns` | 无 failing endpoint |
| Routed conclusion | `All user specified timing constraints are met.` | 占位时钟约束已收敛 |
| `clk_byte` WNS | `2.476 ns` | byte 域留有正裕量 |
| `clk_sys` WNS | `1.884 ns` | sys 域留有正裕量 |
| `clk_sys -> clk_axi` WNS | `3.167 ns` | 跨域表中仍为正裕量 |
| `clk_axi -> clk_sys` WNS | `3.222 ns` | 跨域表中仍为正裕量 |

结论：

- `timing_cdc_v2` 结果证明，在当前异步 FIFO 与同步器结构上补充 `clk_byte` / `clk_sys` 异步时钟组后，原先 `timing_cdc_v1` 中主导全局负 slack 的 CDC 路径不再进入 routed timing 违例。
- 当前结果可用于论文中“CDC 约束修正后，设计在占位 FPGA 时钟约束下实现收敛”的结论。
- `board_io_v1` 已进一步补实验版 `LOC/IOSTANDARD/IO delay`，`write_bitstream` 前 DRC 为 `0 Errors`，`impl_drc.rpt` 为 `Violations found: 0`，并生成 `mipi_csi2_capture_board_io_v1_clkfix5.bit`。
- 因此论文中应明确区分：
  - `timing_cdc_v2`：时序/资源/CDC 收敛验证已完成
  - `board_io_v1`：实验版 bitstream DRC 已清零
  - 最终真实上板：仍需按原理图替换 pinout、确认 bank VCCO/外设连接并完成 timing closure

## 7. Writing Guidance

后续写论文时，建议遵循下面的结果组织方式：

1. 先给功能覆盖表，说明“做了什么”
2. 再给性能/恢复表，说明“效果如何”
3. 最后给资源/时序表，说明“代价与可实现性如何”

这样可以形成完整闭环：

```text
功能实现 -> 系统行为 -> 代价分析
```
