# Lane Skew Scan Results

## Purpose

本文件用于固化 `lane skew` 容忍窗口扫描的正式结果，作为论文第 4 章 lane 对齐实验表与第 6 章系统级验证结论的直接留痕。

## Testbench

- 系统级 TB：
  - `tb/tests/tb_fpga_wrapper_lane_skew_scan.sv`
- 关联基线 TB：
  - `tb/tests/tb_fpga_wrapper_lane_skew_tolerance.sv`
  - `tb/tests/tb_fpga_wrapper_lane_skew_overflow.sv`

## Configuration

- DUT:
  - `mipi_csi2_capture_fpga_wrapper`
- Active lane count:
  - `2`
- Data type:
  - `RAW8`
- Deskew depth:
  - `DESKEW_DEPTH = 4`
- 扫描定义：
  - `lead_bytes` 表示 lane0 相对 lane1 提前注入的未配对字节数
  - 扫描范围为 `0..5`

## Fresh Run Command

```powershell
iverilog -g2012 -Wall -s tb_fpga_wrapper_lane_skew_scan `
  -o sim/logs/tb_fpga_wrapper_lane_skew_scan/tb_fpga_wrapper_lane_skew_scan.vvp `
  -f sim/vcs/compile.f tb/tests/tb_fpga_wrapper_lane_skew_scan.sv

vvp sim/logs/tb_fpga_wrapper_lane_skew_scan/tb_fpga_wrapper_lane_skew_scan.vvp
```

## Fresh Run Result

日志路径：

- `sim/logs/tb_fpga_wrapper_lane_skew_scan/tb_fpga_wrapper_lane_skew_scan.log`

关键输出：

```text
RESULT: lead_bytes=0 tolerant=1 overflow=0 ready_low=1 act_pixels=4 mismatch=0
RESULT: lead_bytes=1 tolerant=1 overflow=0 ready_low=0 act_pixels=4 mismatch=0
RESULT: lead_bytes=2 tolerant=1 overflow=0 ready_low=0 act_pixels=4 mismatch=0
RESULT: lead_bytes=3 tolerant=1 overflow=0 ready_low=0 act_pixels=4 mismatch=0
RESULT: lead_bytes=4 tolerant=1 overflow=0 ready_low=1 act_pixels=4 mismatch=0
RESULT: lead_bytes=5 tolerant=0 overflow=1 ready_low=1 act_pixels=0 mismatch=0
PASS: tb_fpga_wrapper_lane_skew_scan tolerant_window=0..4 overflow_at=5
```

## Result Table

| `lead_bytes` | Pixel closure | Overflow | 结论 |
| --- | --- | --- | --- |
| `0` | `act=4, mismatch=0` | `0` | 正常通过 |
| `1` | `act=4, mismatch=0` | `0` | 正常通过 |
| `2` | `act=4, mismatch=0` | `0` | 正常通过 |
| `3` | `act=4, mismatch=0` | `0` | 正常通过 |
| `4` | `act=4, mismatch=0` | `0` | 边界通过 |
| `5` | `act=0, mismatch=0` | `1` | 超界 overflow |

## Thesis-Ready Conclusion

在当前真实 wrapper 系统路径、`LANE_NUM=2`、`RAW8`、`DESKEW_DEPTH=4` 的配置下：

- 可容忍的 lane skew 领先窗口为 `0..4` 字节
- 当领先扩大到 `5` 字节时，`u_lane_deskew_buffer.err_overflow_o` 被触发
- 论文中可直接表述为：
  - `lane skew tolerance window = DESKEW_DEPTH`
  - `lane skew overflow boundary = DESKEW_DEPTH + 1`

## Interpretation Notes

- 本扫描以“overflow-free 且像素闭合正确”作为容忍判据，而不是简单看 `ready` 是否瞬时拉低。
- `lead_bytes=0` 和 `lead_bytes=4` 下都观察到过 `ready_low`，说明 `ready` 瞬时回压并不等价于越界。

## Self-Check

已完成 fresh run：

1. `tb_fpga_wrapper_lane_skew_scan`
2. `tb_fpga_wrapper_lane_skew_tolerance`
3. `tb_fpga_wrapper_lane_skew_overflow`

对应日志：

- `sim/logs/tb_fpga_wrapper_lane_skew_scan/tb_fpga_wrapper_lane_skew_scan.log`
- `sim/logs/tb_fpga_wrapper_lane_skew_tolerance_recheck/tb_fpga_wrapper_lane_skew_tolerance.log`
- `sim/logs/tb_fpga_wrapper_lane_skew_overflow_recheck/tb_fpga_wrapper_lane_skew_overflow.log`

## Known Limits

- 当前扫描固定在 `LANE_NUM=2`、`RAW8`、`DESKEW_DEPTH=4`，尚未扩展到其他格式。
- 当前结论服务于论文阶段的高收益闭环，优先回答“容忍窗口是否存在、边界在哪里”，不在本轮扩展更低收益的多维参数矩阵。
