# 多帧行级重采集 — 仿真验证结果（多帧推广）

## 目的

堵住 T2 的"只演示单帧"漏洞：证明行级重采集闭环**跨帧成立**，而不只是第一帧。

## 根因与修法

- **问题**：`frame_line_sync_fsm` 的 `line_cnt` 是**跨帧自由计数**（只在 LS 自增，FS 不复位），
  而 AXI writer 的槽位计数**按帧复位**（0 基）。原写回按 `retry_line_id−1` 映射，**仅第一帧成立**
  （首帧 `line_cnt == 帧内行号`）；第 2 帧起 `line_cnt = H + 帧内行号`，映射错位。
- **修法（向后兼容）**：在 sync FSM 新增**帧内行号** `line_in_frame`（FS 复位、LS 自增、帧内 1 基），
  并把 `err_classifier.line_id_i` 由 `line_cnt` 改接 `line_in_frame`；`line_cnt` 保留作全局 LINE_CNT。
  首帧 `line_in_frame == line_cnt`，故**所有既有首帧测试不受影响**。
  - 改动：[frame_line_sync_fsm.sv](01_source_code/rtl/csi2_rx/frame_line_sync_fsm.sv)、
    [mipi_csi2_capture_top.sv](01_source_code/rtl/top/mipi_csi2_capture_top.sv)。

## 场景与判据

[tb_recapture_multiframe.sv](04_tb_tests/tb/tests/tb_recapture_multiframe.sv)：
先发**一整帧干净**（帧 1，把自由计数推进到 H=4），再发**帧 2** 并在其 line2 注 CRC 坏行 → 重采。

**判别性证据**（这是多帧修复的关键）：定位行号是**帧内相对**的——

| 量 | 修复后（正确）| 未修复（错误）|
|---|---|---|
| `retry_frame_id` | 2 | 2 |
| `retry_line_id`（定位行号）| **3**（帧 2 的 line2, 帧内 1 基）| 7（=4+3, 自由计数）|
| 写回目标槽 `recap_line_id` | **2**（正确槽）| 6（错位/越界）|

## 结果

```
PASS: tb_recapture_multiframe  frame=2 located_line=3 (frame-relative) recap_slot=2 overwritten clean
```

即：帧 2 的坏行被正确定位为"帧内第 3 行"、写回命中槽 2、槽 2 被干净数据覆盖、`retry_pending` 经 ack 清除。

## 回归（frame-relative 改动零回归）

本环境通过：tb_recapture_line_level_closed_loop（首帧 located_line 仍=3，不变）、
tb_frame_line_sync、tb_retry_request_ctrl、tb_err_classifier、tb_err_logger、
tb_fpga_wrapper_axi_mem_closure、tb_fpga_wrapper_resync_recovery、tb_cfg_reg_if_apb、
tb_boot_cfg_apb_unit、策略对比 A/B/C。

## 意义

- 闭环从单帧推广到多帧，"行级重采集机制"对连续视频流成立，补齐答辩漏洞。
- 与 T5 条件 C4（帧内行索引 + 幂等写回）对应：C4 在 RTL 上现已闭合。
- 守红线不变：重发仍以"可控图像源前提"表述。
