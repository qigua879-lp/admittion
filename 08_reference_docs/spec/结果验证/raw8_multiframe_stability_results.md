# RAW8 Multi-Frame Stability Results

## Purpose

本文件用于留痕真实 `mipi_csi2_capture_fpga_wrapper` 路径下的 `RAW8` 连续多帧 / 多行稳定性结果，证明系统级结论不只覆盖最小单帧样例。

## Test

- `tb/tests/tb_fpga_wrapper_raw8_multiframe_stability.sv`

## Scenario

- `DATA_TYPE = RAW8`
- `LANE_NUM = 2`
- `FRAME_COUNT = 3`
- `LINE_COUNT = 3`
- `PIXELS_PER_LINE = 4`
- `TOTAL_PIXELS = 36`

## Final PASS Result

```text
PASS: tb_fpga_wrapper_raw8_multiframe_stability frames=3 lines=9 total_pixels=36 scoreboard_frames=3 mismatch=0
```

## Key Conclusion

- 在真实 wrapper 路径下，系统已完成 `3` 帧、`9` 行的连续 `RAW8` 闭环。
- `frame_start / frame_end / line_start / line_end / pixel_sof / pixel_sol` 计数均与预期一致。
- scoreboard 结果为 `mismatch=0`，说明连续多帧多行场景下未出现像素乱序或 silent corruption。

## Thesis Wording Suggestion

- 可表述为：“除最小单帧样例外，系统在真实 FPGA wrapper 集成路径下还完成了连续三帧、每帧三行的 `RAW8` 稳定性验证，帧/行标记和像素结果均与预期一致，说明该主链路具备基础连续流工作能力。”
