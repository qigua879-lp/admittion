# D-PHY ILA Probe Results

## Purpose

This result records the verification of the compact `ila_probe_o[63:0]` debug
bus exported by `mipi_csi2_capture_dphy_wrapper`.

## Testbench

| Item | Value |
| --- | --- |
| Testbench | `tb_mipi_csi2_capture_dphy_debug_probe.sv` |
| DUT | `mipi_csi2_capture_dphy_wrapper` |
| Probe bus | `ila_probe_o[63:0]` |

## Result

```text
PASS: tb_mipi_csi2_capture_dphy_debug_probe
```

The test confirms:

- bit `0/1` mirror D-PHY HS/LP mode.
- bits `5:2`, `9:6`, `13:10`, and `17:14` expose lane active, valid, sync,
  and stop-state masks.
- bits `18/19` expose D-PHY SoT error summary signals.
- bit `56` exposes internal APB boot completion.
- bits `58/59` expose no-backpressure drop event/active.
- bits `63:60` are reserved and tied to zero.

## Boundary

The probe bus is a bring-up convenience signal. It does not replace a full
Vivado ILA core, and it does not prove board-level D-PHY IP pinout or timing by
itself.
