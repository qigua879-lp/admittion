# Resync Backpressure Multiframe Results

## Purpose

本文件用于留痕“连续流异常混合场景”中的高收益组合：先触发一次 `illegal sync -> resync`，再在恢复后的连续 clean `RAW8` 帧上施加 AXI 背压，验证恢复链和持续输出能否同时成立。

## Testbench

- 系统级 TB：
  - `tb/tests/tb_fpga_wrapper_resync_backpressure_multiframe.sv`
- 相关基线：
  - `tb/tests/tb_fpga_wrapper_resync_clean_frame.sv`
  - `tb/tests/tb_fpga_wrapper_axi_backpressure_metrics.sv`
  - `tb/tests/tb_fpga_wrapper_raw8_multiframe_stability.sv`

## Configuration

- DUT:
  - `mipi_csi2_capture_fpga_wrapper`
- Fixed traffic:
  - `RAW8`, `LANE_NUM=2`
- Buffer setup:
  - `BYTE_FIFO_ADDR_WIDTH=2`
  - `AXI_FIFO_ADDR_WIDTH=3`
- Post-resync clean flow:
  - `FRAME_COUNT=2`
  - `LINE_COUNT=2`
  - total `16` pixels
- AXI backpressure method:
  - once the first clean frame starts, force `AWREADY/WREADY=0`
  - for each observed `AWVALID/WVALID`, hold low for `12` AXI cycles, then release briefly

## Fresh Run Command

```powershell
iverilog -g2012 -Wall -s tb_fpga_wrapper_resync_backpressure_multiframe `
  -o sim/logs/tb_fpga_wrapper_resync_backpressure_multiframe/tb_fpga_wrapper_resync_backpressure_multiframe.vvp `
  -f sim/vcs/compile.f tb/tests/tb_fpga_wrapper_resync_backpressure_multiframe.sv

vvp sim/logs/tb_fpga_wrapper_resync_backpressure_multiframe/tb_fpga_wrapper_resync_backpressure_multiframe.vvp `
  > sim/logs/tb_fpga_wrapper_resync_backpressure_multiframe/tb_fpga_wrapper_resync_backpressure_multiframe.log
```

## Fresh Run Result

日志路径：

- `sim/logs/tb_fpga_wrapper_resync_backpressure_multiframe/tb_fpga_wrapper_resync_backpressure_multiframe.log`

关键输出：

```text
PASS: tb_fpga_wrapper_resync_backpressure_multiframe frames=2 lines=4 exp=16 act=16 mismatch=0 aw_stall_cycles=52 w_stall_cycles=52
```

## Result Summary

| 观测项 | 结果 | 说明 |
| --- | --- | --- |
| `resync_req / busy / done` | 全部观测到 | 非法同步事件后恢复链闭合 |
| `resync_clear_pulse_sys / byte` | 全部观测到 | sys / byte 域清空动作已发生 |
| clean frame count | `2` | 恢复后连续两帧都完成 |
| clean line count | `4` | 每帧两行均完整输出 |
| clean pixel result | `exp=16 act=16 mismatch=0` | 恢复后连续 clean 流像素闭合正确 |
| `aw_stall_cycles` | `52` | clean multiframe 期间已成功施加 AXI 背压 |
| `w_stall_cycles` | `52` | clean multiframe 期间已成功施加 AXI 背压 |

## Thesis-Ready Conclusion

- 当前系统不仅能在 `illegal sync` 后完成 `resync`，
- 还能够在恢复完成后继续输出连续 clean `RAW8` 帧，
- 并且这一过程可与 AXI 写通路背压同时成立。

论文里可以稳妥表述为：

- 恢复策略具备“恢复后继续连续工作”的系统级有效性；
- AXI 背压不会破坏当前恢复后 clean multiframe 的基本正确性。

## Engineering Interpretation

- 这条证据比单独的 `resync clean-frame` 或单独的 `AXI backpressure` 更接近工程实际，因为它验证了异常恢复与输出通路阻塞能够共存。
- 当前结果仍属于“功能/稳定性闭环”而不是最终吞吐极限；若要进一步工程化，可继续扩展到更多帧数、更多行数，或叠加 `CRC error`/`repeated error`。

## Known Limits

- 当前混合场景固定在 `RAW8`、`LANE_NUM=2`、`FRAME_COUNT=2`、`LINE_COUNT=2`。
- 当前只覆盖一次 `illegal sync -> resync`，未叠加 `CRC error` 或 `repeated error during busy`。
