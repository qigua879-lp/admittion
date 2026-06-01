# Board IO Bitstream DRC v1 Results

## Purpose

本文件记录 `board_io_v1` 这轮板级 IO 约束补齐后的 bitstream DRC 结果，专门回应之前 `NSTD-1` 和 `UCIO-1` 阻塞 bitstream 的问题。

## Build

| Item | Value |
| --- | --- |
| Project | `mipi_csi2_capture_board_io_v1_clkfix5` |
| Top | `mipi_csi2_capture_fpga_wrapper` |
| FPGA part | `xczu9eg-ffvb1156-2-e` |
| Report directory | `C:\vivado_admittion\reports\mipi_csi2_capture_board_io_v1_clkfix5` |
| Vivado log | `C:\vivado_admittion\logs\direct_board_io_v1_clkfix5_r2.vivado.log` |

## Constraint Updates

| Constraint area | Status |
| --- | --- |
| `LOC` | Added through `02_vivado_project_and_sim/xdc/board_lab_placeholder_v1.xdc` |
| `IOSTANDARD` | Added as `LVCMOS18` lab default |
| IO delay | Added in `02_vivado_project_and_sim/xdc/top_constraints.xdc` |
| Output drive/slew | Added in `top_constraints.xdc` |
| Clock pins | Moved `clk_sys` and `clk_byte` to P-side global clock pins to avoid `Place 30-876` |

## Verification

| Check | Result |
| --- | --- |
| `place_design` | Completed successfully |
| `route_design` | Completed successfully |
| `write_bitstream` DRC | `0 Errors` |
| `impl_drc.rpt` | `Violations found: 0` |
| Bitstream | `mipi_csi2_capture_board_io_v1_clkfix5.bit` generated |
| `NSTD-1` | Not present in final bitgen DRC |
| `UCIO-1` | Not present in final bitgen DRC |

The generated bitstream size was `26510915` bytes in the local verified run.

## Timing Note

This run fixes the bitstream-blocking board IO DRC issue. It does not mean timing is fully closed:

- `impl_timing_summary.rpt` reports `Timing constraints are not met`
- Global `WNS = -3.398 ns`
- Global `TNS = -464.042 ns`

So the correct wording is:

```text
实验版板级 LOC/IOSTANDARD/IO delay 已补齐，bitstream DRC 中 NSTD-1/UCIO-1 已清零并可生成 bit 文件；但真实上板前仍需按原理图替换 lab pinout，并继续做 timing closure。
```

## Hardware Boundary

`board_lab_placeholder_v1.xdc` is a lab DRC-unblocking pin map, not a verified schematic pinout. Do not use it for physical board bring-up until the actual board schematic, bank VCCO, clock sources, and external PHY/bridge connections are checked.

## Recheck Command

```powershell
powershell -ExecutionPolicy Bypass -File 02_vivado_project_and_sim/vivado/check_board_io_drc_v1.ps1
```
