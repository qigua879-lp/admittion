# FPGA I/O Reduction Notes

## Problem Summary

The system logic top `mipi_csi2_capture_top` is useful as a project-level
integration view, but it exposes APB, AXI, and wide debug buses directly as
top-level ports. On `xczu9eg-ffvb1156-2-e`, that style over-consumes package
pins.

Historical synthesis evidence:

- Vivado utilization report: `Bonded IOB = 344 / 328`
- Report file:
  `fpga/vivado/reports/mipi_csi2_capture/synth_utilization.rpt`

## Why The Limit Was Exceeded

The excess is not caused by LUT/FF usage. The main issue is that multiple
on-chip interfaces were treated as off-chip FPGA pins at the same time:

1. PHY digital abstract lane buses:
   - `lane_data_0..3[31:0]` = 128 bits
2. APB configuration bus:
   - `psel/penable/pwrite/paddr/pwdata/prdata/pready/pslverr`
3. AXI write bus:
   - `m_axi_aw*`, `m_axi_w*`, `m_axi_b*`
4. Wide debug/status outputs:
   - frame/line counters, error counters, pixel debug bus, sync/debug pulses

Those interfaces are valuable for RTL composition, but not all of them should
be physical FPGA package pins in the board-level build.

## Structural Fix

Add an FPGA-oriented wrapper:

- `rtl/top/mipi_csi2_capture_fpga_wrapper.sv`

The wrapper keeps `mipi_csi2_capture_top` unchanged and moves the following
connections on-chip:

1. APB:
   - replaced by `fpga_apb_boot_cfg.sv`
2. AXI write target:
   - replaced by `axi_write_null_slave.sv`
3. Wide debug buses:
   - no longer exported as FPGA pins

## Port Count Comparison

Approximate top-level bit counts after the wrapper split:

| Top | Input bits | Output bits | Total bits |
| --- | ---: | ---: | ---: |
| `mipi_csi2_capture_top` | 195 | 389 | 584 |
| `mipi_csi2_capture_fpga_wrapper` | 139 | 35 | 174 |

This moves the board-oriented top well below the previous I/O pressure level.

## Boundary Conditions

- The wrapper is intended for FPGA build entry, not as a replacement for the
  project logic top.
- The wrapper currently uses a boot-time APB sequencer with fixed startup
  configuration.
- The wrapper currently sinks AXI writes internally instead of forwarding them
  to external DDR pins.

## Recommended Follow-Up

1. Use `mipi_csi2_capture_fpga_wrapper` as the Vivado synthesis top for FPGA
   builds.
2. Keep `mipi_csi2_capture_top` as the system RTL integration top.
3. If real DDR or software control is needed on board, connect APB/AXI through
   PS, AXI interconnect, MIG, or another on-chip subsystem instead of raw pins.
4. Move detailed observability to:
   - status registers
   - ILA/VIO
   - a narrow debug mux

## Self-Check

- `tb/tests/tb_fpga_wrapper_boot.sv` verifies that the internal APB boot
  sequencer completes and that the wrapper stays quiescent in idle startup.
- Vivado XSim logs for this wrapper smoke run are stored under:
  `sim/logs/vivado_xsim_20260506_fpga_wrapper/`
