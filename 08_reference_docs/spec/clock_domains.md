# Clock Domains

## Purpose
This document defines the intended clock-domain ownership and CDC boundaries for the digital CSI-2 capture front end.

## Clock Domain Summary
| Clock | Primary Use | Initial Blocks |
|---|---|---|
| clk_byte | Digital lane receive path | `phy_digital_adapter`, lane front-end logic |
| clk_sys | Protocol and pixel control | `cfg_reg_if`, `csi2_rx_core`, `pixel_repack_core`, `reliability_monitor` |
| clk_axi | AXI write master | `axi_ddr_writer` |
| clk_ddr | DDR controller-facing support | DDR-related integration wrapper logic |

## Reset
- `rst_n` is active-low.
- All RTL sequential logic uses synchronous reset behavior.
- Reset release must be handled per clock domain.
- Cross-domain reset assumptions must be documented when CDC modules are implemented.

## Planned CDC Boundaries

### clk_byte to clk_sys
Boundary between `phy_digital_adapter` and `csi2_rx_core`.

Initial rule: transfer packetized byte-stream data through a ready/valid boundary or an async FIFO when rates are not guaranteed.

Current RTL implementation:
- `lane_deskew_buffer` and `lane_reorder_merge` run in `clk_byte`.
- `u_byte_to_sys_fifo` transfers the merged byte stream from `clk_byte` into `clk_sys`.
- `deskew_overflow` is reported into `clk_sys` with a toggle synchronizer.
- `resync_req` is reported back into `clk_byte` with a toggle synchronizer.
- Configuration lane count/mask fields are sampled into `clk_byte` through two-stage synchronizers and are expected to change only during idle or reset/recovery windows.

Constraint rule:
- `clk_byte` and `clk_sys` are declared asynchronous in `fpga/xdc/top_constraints.xdc`.
- The exception is valid only while all payload/control crossings remain behind the FIFO or synchronizer structures listed above.

### clk_sys to clk_axi
Boundary between pixel buffering and `axi_ddr_writer`.

Initial rule: use `buffer_cdc_subsys` for async FIFO transfer from system-side pixel stream to AXI write-side stream.

### clk_axi to clk_ddr
Boundary depends on DDR controller integration.

Initial rule: do not assume this boundary is free. Document the selected DDR controller interface before implementation.

## Ready/Valid Rules
- `xxx_valid` is driven by the source domain.
- `xxx_ready` is driven by the sink domain when both signals share a clock.
- Ready/valid must not be directly connected across unrelated clocks.
- CDC payloads must stay stable until accepted by the crossing mechanism.

## Verification Requirements
- Each CDC module must include reset, full, empty, backpressure, and data-order tests.
- The first P0 milestone may use a single-clock simplification inside TB, but CDC assumptions must be visible in the test name or comments.
