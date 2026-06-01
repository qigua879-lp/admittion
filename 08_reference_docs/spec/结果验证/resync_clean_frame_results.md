# Resync Clean-Frame Recovery Results

## Purpose

本文件用于固化 `resync -> clean frame` 的系统级证明结果，回答“系统不仅能发出 `req/busy/clear/done`，还能在恢复后重新回到正常像素输出路径”。

## Testbench

- 主验证 TB：
  - `tb/tests/tb_fpga_wrapper_resync_clean_frame.sv`
- 关联基线 TB：
  - `tb/tests/tb_fpga_wrapper_resync_recovery.sv`
  - `tb/tests/tb_fpga_wrapper_resync_metrics.sv`

## Scenario

两阶段激励：

1. 先发送非法同步序列：
   - `FS -> LS -> FE`
   - 用于触发 `sync error` 与 `resync`
2. 再等待恢复链和 byte/sys 域清空完成后，发送一帧干净 RAW8：
   - `FS -> LS -> long packet -> LE -> FE`

## Fresh Run Command

```powershell
iverilog -g2012 -Wall -s tb_fpga_wrapper_resync_clean_frame `
  -o sim/logs/tb_fpga_wrapper_resync_clean_frame/tb_fpga_wrapper_resync_clean_frame.vvp `
  -f sim/vcs/compile.f tb/tests/tb_fpga_wrapper_resync_clean_frame.sv

vvp sim/logs/tb_fpga_wrapper_resync_clean_frame/tb_fpga_wrapper_resync_clean_frame.vvp
```

## Fresh Run Result

日志路径：

- `sim/logs/tb_fpga_wrapper_resync_clean_frame/tb_fpga_wrapper_resync_clean_frame.log`

关键输出：

```text
PASS: tb_fpga_wrapper_resync_clean_frame sync=1 req=1 busy=1 done=1 clear_sys=1 clear_byte=1 exp=4 act=4 frames=1
```

## Observed Conclusion

在当前真实 wrapper 路径下，系统满足以下链路闭环：

1. 非法同步事件触发 `err_sync_o`
2. `resync_req / resync_busy / resync_clear_pulse_sys / resync_clear_pulse_byte / resync_done_o` 全部可观测
3. 恢复完成后，新的 clean RAW8 frame 能重新输出：
   - `frame_start_o`
   - `line_start_o`
   - `pixel_valid_o`
   - `pixel_sof_o`
   - `pixel_sol_o`
   - `line_end_o`
   - `frame_end_o`
4. scoreboard 结果为：
   - `exp=4`
   - `act=4`
   - `mismatch=0`

## Design Note

本轮同时修复了一个与恢复相关的 byte 域残留问题：

- `lane_deskew_buffer`
- `lane_reorder_merge`

两者新增同步 `clear_i`，并由 `resync_clear_pulse_byte` 驱动，以确保恢复时能清掉 lane 对齐与 merge 残留状态，而不是只清 async FIFO。

## Formal Waveform Target

本结果对应的正式截图目标为：

- `docs/spec/结果验证/正式波形/07_resync_clean_frame_xsim.png`

对应 Tcl：

- `fpga/vivado/formal_wave_tcl/tb_fpga_wrapper_resync_clean_frame_formal.tcl`

## Known Limits

- 当前证明基于 `LANE_NUM=2`、`RAW8` 路径。
- 当前重点是恢复后重新回到 clean frame 输出，不在本轮扩展 repeated-error 与多格式恢复矩阵。
