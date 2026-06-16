# D-PHY Wrapper Vivado Synthesis/Timing Results

## Purpose

本文件记录 `mipi_csi2_capture_dphy_wrapper` 作为 Vivado top 的 synthesis-only 入口验证和 routed timing-only 验证。目标是证明新增 D-PHY PPI wrapper、`ila_probe_o[63:0]` debug bus、现有 FPGA wrapper/top、以及最小 D-PHY XDC profile 可以被 Vivado 2017.3 正常创建工程、完成综合，并在 D-PHY/BD/pinout 尚未固定前先完成内部 core timing 收敛。

## Build

| Item | Value |
| --- | --- |
| Project | `dphy_core5` |
| Top | `mipi_csi2_capture_dphy_wrapper` |
| FPGA part | `xczu9eg-ffvb1156-2-e` |
| XDC profile | `dphy_minimal` |
| Constraint file | `02_vivado_project_and_sim/xdc/dphy_wrapper_constraints.xdc` |
| Flow | direct synth + opt/place/route timing-only |
| Vivado | `2017.3` |
| Report root | `C:\vivado_admittion\reports\dphy_core5` |

## Verification Commands

```powershell
powershell -ExecutionPolicy Bypass -File 02_vivado_project_and_sim/vivado/check_dphy_wrapper_synth_entry.ps1
powershell -ExecutionPolicy Bypass -File 02_vivado_project_and_sim/vivado/run_dphy_wrapper_timing_direct.ps1 -ProjectName dphy_core5 -Jobs 4 -ReportRoot C:\vivado_admittion\reports
```

## Latest Result

The static entry check passed:

```text
PASS: check_dphy_wrapper_synth_entry
```

The routed timing-only direct flow passed on 2026-06-02:

```text
All user specified timing constraints are met.
WNS = 0.825 ns
TNS = 0.000 ns
WHS = 0.009 ns
THS = 0.000 ns
TPWS = 0.000 ns
```

Route status:

```text
fully routed nets = 1612 / 1612
routing errors    = 0
```

Post-change checks:

```text
PASS: check_dphy_wrapper_synth_entry
PASS: tb_mipi_dphy_ppi_adapter
PASS: tb_mipi_csi2_capture_dphy_wrapper_raw8_smoke exp=4 act=4 frames=1
PASS: tb_mipi_csi2_capture_dphy_no_backpressure_guard exp=4 act=4 frames=1 max_fifo=62 lane_ready_low=1
PASS: git diff --check
```

## Current Resource Summary

| Resource | Used |
| --- | ---: |
| CLB LUTs | `595 / 274080` |
| CLB Registers | `1129 / 548160` |
| Block RAM Tile | `0 / 912` |
| DSPs | `0 / 2520` |
| Bonded IOB | `221 / 328` |
| BUFGCE | `3 / 116` |

## Timing Boundary

The timing-clean result is a core timing-only result. The direct flow sets `DPHY_CORE_TIMING_ONLY=1` and cuts artificial wrapper boundaries that are not final board timing contracts yet:

```text
rst_n placeholder input
status/debug outputs such as frame_start_o, pixel_valid_o, ila_probe_o, err_*_o
```

The internal clocked domains are still checked. The latest report includes `clk_sys`, `clk_axi`, `clk_ddr`, and `rxbyteclkhs`; the inter-clock table is empty because the intended asynchronous clock groups are active.

This is not a final board-level timing closure result. Final board-level closure still requires the real AMD D-PHY RX IP/BD instance, pinout, IOSTANDARD, generated clocks, board constraints, DRC, and bitstream run.

## Current Meaning

This result supports the following statement:

```text
The D-PHY wrapper internal core timing is clean after route under the current pre-board timing-only constraints. The remaining timing work is board integration timing, not the internal parser/adapter core timing seen in dphy_core5.
```
