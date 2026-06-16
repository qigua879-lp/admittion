# 行级重采集闭环 — 仿真验证结果（T2.5）

## 目的

验证交接文档 §4 的 T2：把 `retry_request_ctrl` 从“仅请求 + 定位”推进到
**“请求 + 定位 + 按行号写回”** 的行级重采集闭环，并在仿真中完整展示
“出错 → 定位 → 请求 → 重采 → 恢复出正确帧”。

## 被测结构

- DUT：`mipi_csi2_capture_recap_wrapper`（复用 boot cfg + 内部 AXI sink memory，
  额外暴露可控源旁路 `src_recap_line_valid_i`）。
- 新增 RTL：
  - `rtl/reliability/recapture_writeback_ctrl.sv`（写回控制，三重门控 + 行号基转换）
  - `rtl/axi/pixel_to_axi_writer.sv` 新增 `recap_active_i/recap_line_id_i`（默认 0 不影响原通路）
- 激励：`04_tb_tests/tb/tests/tb_recapture_line_level_closed_loop.sv`

## 场景

单帧 RAW8，4 行 × 4 像素，每行干净 payload = `11 22 33 44`：

| 行 | 内容 | 写入槽 | 结果 |
|---|---|---|---|
| line0 | 干净 | slot0 (word 0..3) | 正常写入 `11 22 33 44` |
| line1 | 干净 | slot1 (word 16..19) | 正常写入 |
| line2 | **CRC 坏行** | slot2 (word 32..35) | CRC 丢行 → **slot2 保持空(0)** |
| line3 | 干净 | slot3 (word 48..51) | 正常写入（模拟帧内往返延迟）|
| line2(重采) | 可控源干净重发 + 旁路 | slot2 | **写回覆盖 → slot2 = `11 22 33 44`** |

## 单次运行同时给出的证据

1. **定位**：`retry_req` 在 line 模式触发，定位行索引 = 3（sync 行计数，对应写回槽 2）。
2. **坏行确被丢弃**：重采前 slot2 四个字全为 0，而 slot0/1/3 已写入干净数据。
3. **写回覆盖到正确槽**：重采后 slot2 == slot0（`11 22 33 44`），即坏行槽被干净行覆盖。
4. **闭环握手**：DUT 内部 `recap_active` 拉高一行；写回收尾 `retry_ack` 清 `retry_pending`。

## 结果

```
PASS: tb_recapture_line_level_closed_loop  located_line=3 slot2 overwritten clean, pending cleared
```

仿真器：Vivado xsim 2017.3（xvlog/xelab/xsim）。

## 关键实现要点

- **写地址此前由 writer 内部行计数器驱动**，朴素重发只会落到下一槽；写回路径改为按
  `retry_line_id` 寻址、不推进计数器、不触发 height 丢弃，才实现“覆盖坏行槽”。
- **行号基转换**：`retry_line_id` 取自 sync FSM 行计数（首帧内 1 基），而 writer 槽位 0 基，
  写回控制按 `retry_line_id − 1` 映射到目标槽（已在 RTL 注释；多帧推广需帧内行索引，留作后续）。
- **可控源前提（守红线）**：重采行的“目标行号”由可控源旁路 `src_recap_line_valid` 带出，
  明确表述为“上游可控图像源前提下”，不声称标准单向 CSI-2 链路具备重传能力。

## 负向对照（已内含）

重采前对 slot2 == 0 的断言即“无重采则坏行槽不可恢复”的负向证据；
完整三基线（行级 / 整帧重传 / 只丢）扫描见 T3（后续）。

## 环境备注

- 既有 `tb_fpga_wrapper_axi_mem_closure` / `tb_pixel_to_axi_writer` / `tb_retry_request_ctrl` /
  `tb_cfg_reg_if_apb` / `tb_fpga_wrapper_resync_recovery` 在本环境回归通过，确认新端口默认 0 零回归。
- `tb_fpga_wrapper_crc_error` 在本机 xsim 2017.3 上**纯净 HEAD 也超时**（与本次改动无关，
  疑为 xsim/VCS 时序差异；该用例原在 VCS 环境验证）。
- 发现一处既有问题：片上 boot 配置序列 `fpga_apb_boot_cfg` 的 APB 写不落地
  （cfg_reg `pready` 恒高，boot FSM 不进入 access 相），各 wrapper TB 历来用 `force` 配置寄存器规避。
