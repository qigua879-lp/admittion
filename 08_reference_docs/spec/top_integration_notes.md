# Top Integration Notes

## Scope

This stage adds the first synthesizable `mipi_csi2_capture_top` wrapper. It is a minimum main-path integration, not a final product top. Existing verified submodule interfaces are preserved.

For compile-only and regression entry points that include this top, see `docs/spec/regression_plan.md`.

The integration keeps the external interface style from `top_io.md`:

- `clk_byte` owns digital lane intake and lane merge.
- `clk_sys` owns packet parsing, frame/line sync, pixel repack, preprocess, and reliability status.
- `clk_axi` owns the exported AXI write master interface.
- `clk_ddr` is reserved for later DDR-controller integration.
- `rst_n` remains active-low and synchronous inside each clocked block.

## Added Files

| File | Role |
| --- | --- |
| `rtl/top/mipi_csi2_capture_top.sv` | Minimum top-level wrapper connecting the main receive path, debug/status outputs, preprocess bypass, reliability monitor, and reserved AXI write interface. |
| `rtl/top/mipi_csi2_capture_dphy_wrapper.sv` | Board-oriented D-PHY PPI entry wrapper that maps AMD D-PHY RX byte-lane signals into the existing FPGA wrapper input style. |
| `docs/spec/top_integration_notes.md` | Documents connected modules, placeholders, clock domains, APB-lite control bits, and follow-up tasks. |

## Main Path

```text
lane_data_0..3[7:0] + lane_valid_0..3
  -> phy_digital_adapter                (clk_byte)
  -> lane_deskew_buffer                  (clk_byte)
  -> lane_reorder_merge                  (clk_byte)
  -> async_fifo                          (clk_byte -> clk_sys)
  -> csi2_long_packet_parser             (clk_sys)
  -> frame_line_sync_fsm for FS/FE/LS/LE (clk_sys)
  -> RAW8 / RAW10 / RGB888 / YUV422 unpack
  -> brightness_adjust
  -> contrast_adjust
  -> gray_balance
  -> preprocess_bypass_mux
  -> pixel debug outputs
```

The top currently treats each external `lane_data_x[31:0]` as an already digital lane word. `phy_digital_adapter` applies HS/LP gating plus `LANE_CFG` lane masking, and forwards only `[7:0]` into the current byte-lane receive path. The effective lane count is further limited by `degrade_recover_fsm.active_lane_num_o`, so lane degradation now changes the actual receive path width instead of only reporting status.

For AMD D-PHY RX IP bring-up, `mipi_csi2_capture_dphy_wrapper` adds this
entry path in front of the FPGA wrapper:

```text
rxbyteclkhs + dl*_rxdatahs/rxvalidhs/rxactivehs/rxsynchs
  -> mipi_dphy_ppi_adapter
  -> mipi_csi2_capture_fpga_wrapper
  -> existing receive / pixel / AXI path
```

This wrapper does not instantiate the AMD IP itself. It expects the generated
D-PHY RX IP or a Vivado block design to provide the PPI-side byte signals.
It also exports `ila_probe_o[63:0]`, a narrow debug bus that packs D-PHY PPI
state, frame/line markers, pixel activity, and error pulses for first-board ILA
bring-up. The bit map is documented in `dphy_ila_probe_map.md`.

The D-PHY wrapper enables `ENABLE_NO_BACKPRESSURE_GUARD` because AMD D-PHY RX
PPI does not provide an RX ready/credit signal. When the byte/sys path cannot
accept the incoming stream, the guard clears byte-domain residual state and the
system parser/FIFO/writer path, suppresses the damaged frame, and resumes on the
next valid FS short packet. The generic FPGA wrapper keeps this guard disabled
so existing sensor-model tests still exercise the ready/valid backpressure
contract.

## Real Connections

The following verified modules are instantiated and connected:

| Area | Modules |
| --- | --- |
| Lane path | `phy_digital_adapter`, `lane_deskew_buffer`, `lane_reorder_merge`, `async_fifo` |
| CSI-2 parsing | `csi2_long_packet_parser` |
| Frame/line sync | `frame_line_sync_fsm` |
| Pixel repack | `raw8_unpack`, `raw10_unpack`, `rgb888_unpack`, `yuv422_unpack` |
| Preprocess | `brightness_adjust`, `contrast_adjust`, `gray_balance`, `preprocess_bypass_mux` |
| Reliability | `err_classifier`, `err_frame_line_logger`, `resync_ctrl_fsm`, `degrade_recover_fsm` |
| AXI write interface | `pixel_to_axi_writer`, `addr_gen_frame_based`, `axi_write_master` |

## Packet Handling

`csi2_long_packet_parser` is used as the single byte-stream packet parser in this wrapper:

- `word_count == 0` and DT in FS/FE/LS/LE is treated as a short packet event.
- nonzero `word_count` captures `payload_dt_reg` and drives the selected unpacker.
- long packets with mismatched `VC` or mismatched configured `DT` are drained without generating pixels.

This avoids duplicating packet header parsing at top level while keeping the already verified parser interfaces unchanged.

## Pixel Format Selection

The top selects the unpacker by packet DT:

| DT | Path |
| --- | --- |
| `6'h2a` | RAW8 |
| `6'h2b` | RAW10 |
| `6'h24` | RGB888 |
| `6'h1e` | YUV422 8-bit style path |

SOF/SOL markers are latched from `frame_line_sync_fsm` and applied to the first payload byte accepted after FS/LS.

## Preprocess Bypass

The preprocess chain is structurally connected as:

```text
pixel_repack -> stats_observer -> brightness -> contrast -> gray_balance -> bypass_mux processed input
             `-------------------------------------------> bypass_mux raw input
```

`cfg_preprocess_bypass` selects raw or processed output. It resets to bypass enabled. The processed path uses identity default settings:

- gain = `8'h80`
- bias = `9'sd0`

Adaptive preprocess `v1` extends this path with frame-based statistics and
previous-frame coefficient updates:

- bit3 adaptive global enable
- bit4 adaptive AWB enable
- bit5 adaptive stretch enable

Current adaptive limitations:

- AWB is only active for `RGB888`.
- Stretch is only active for `RGB888` and `RAW8`.
- `RAW10` and `YUV422` stay in pass-through semantics for adaptive mode.

The minimal APB control register can change the bypass bit. Runtime changes should be made while the stream is idle until a full configuration block and frame-boundary update policy are added.

## Reliability Connections

Connected error sources:

| Error | Source |
| --- | --- |
| ECC | `csi2_long_packet_parser` header ECC status |
| Sync | `frame_line_sync_fsm` |
| Lane | `lane_deskew_buffer` overflow, crossed from `clk_byte` to `clk_sys` with a toggle synchronizer |
| CRC | `csi2_payload_crc_checker` plus configurable line discard policy |

`err_classifier` and `err_frame_line_logger` bind errors to current `frame_cnt`, `line_cnt`, VC, and DT. `cfg_enable_err_log` gates logger entry creation. `degrade_recover_fsm.active_lane_num_o` now limits the effective lane count seen by `phy_digital_adapter`. When the D-PHY no-backpressure guard is enabled, lane overflow caused by downstream byte backpressure is not fed into lane degradation, because it is a buffering condition rather than proof that one physical lane should be removed. `resync_ctrl_fsm` still does not directly reset or drain parser state in this phase.

## APB Register Block

The top now instantiates `cfg_reg_if_apb` as the formal APB control/status
block for this phase.

Key addresses:

| Address | Access | Meaning |
| --- | --- | --- |
| `16'h0000` | RW | `CTRL`: enable plus soft/start control pulses |
| `16'h0004` | RO | `STATUS`: idle/receiving/frame/line/overflow/AXI/link status |
| `16'h0008` | RW | `IMG_WIDTH` |
| `16'h000c` | RW | `IMG_HEIGHT` |
| `16'h0018` | RW | `FRAME_BASE_ADDR` |
| `16'h001c` | RW | `LINE_STRIDE` |
| `16'h0034` | RW | `ERR_POLICY` |
| `16'h0038` | RW | `PREPROC_CFG` |
| `16'h0040` | RW | `AXI_CFG` |
| `16'h0044` | RO | `LAST_ERR` |
| `16'h0048` | RO | `ADAPT_GAIN` |
| `16'h004c` | RO | `ADAPT_STAT0` |
| `16'h0050` | RO | `ADAPT_STAT1` |

See `docs/regmap/register_map.md` for the full field definition.

## AXI Minimum Closure

The top now connects a minimum synthesizable pixel-to-DDR write path through
`pixel_to_axi_writer`.

Current write-path behavior:

1. `preprocess_bypass_mux` final pixel output is backpressured by AXI write readiness.
2. Each accepted 24-bit pixel is packed into one padded 32-bit slot as `{8'h00, pixel_data}`.
3. When `AXI_DATA_WIDTH > 32`, multiple pixel slots are packed into one wider AXI beat before crossing into `clk_axi`.
4. Pixel beats cross from `clk_sys` to `clk_axi` through an async FIFO.
5. Each `line_end` emits one line write command using the accepted byte count of that line.
6. `addr_gen_frame_based` computes `frame_base + line_id * line_stride`.
7. `axi_write_master` performs the actual AXI AW/W/B transaction.
8. `clear_i` now allows resync/soft-reset to flush writer state after any in-flight AXI transaction safely completes.

The following APB-controlled fields now drive the write path:

- `CTRL[0]` capture enable
- `FRAME_BASE_ADDR` at `0x0018`
- `LINE_STRIDE` at `0x001c`
- `IMG_WIDTH` and `IMG_HEIGHT` at `0x0008/0x000c`
- `AXI_CFG[8:0]` at `0x0040`

This is intentionally a minimum closure path, not the final optimized frame
buffer architecture. Important current limits:

- one pixel still maps to one padded 32-bit slot, so efficiency is improved on
  wider AXI buses but not yet comparable to a true format-aware frame buffer
- only line-based write scheduling is implemented
- configuration should only be changed while capture is idle
- AXI write completion/error is surfaced, but not yet folded back into the
  higher-level recovery policy
- CRC-failed lines can now be turned into discard commands so buffered line data is drained without AXI write traffic
- `resync_ctrl_fsm` now clears parser/FIFO/unpacker/writer state instead of only
  holding a request until the next `frame_start`

## Debug Outputs

Direct top-level debug/status outputs:

| Output | Source |
| --- | --- |
| `frame_start_o`, `frame_end_o` | `frame_line_sync_fsm` |
| `line_start_o`, `line_end_o` | `frame_line_sync_fsm` |
| `err_ecc_o` | header ECC event |
| `err_crc_o` | payload CRC error pulse |
| `err_sync_o` | sync FSM error pulse |
| `frame_cnt_o`, `line_cnt_o` | sync FSM counters |
| `err_cnt_ecc_o`, `err_cnt_crc_o` | error classifier counters |
| `no_backpressure_drop_event_o` | D-PHY no-backpressure guard clear/drop event |
| `no_backpressure_drop_active_o` | D-PHY no-backpressure guard frame-drop active state |
| `pixel_data_o`, `pixel_valid_o`, `pixel_sof_o`, `pixel_sol_o` | preprocess/bypass output |

## Placeholders And TODO

- Replace the minimum `pixel_to_axi_writer` path with a higher-efficiency
  line/frame buffer architecture when DDR throughput targets are frozen.
- Add a board-specific wrapper or block design that instantiates the AMD MIPI
  D-PHY RX IP and connects its PPI ports to `mipi_csi2_capture_dphy_wrapper`.
- Decide whether `DT_CFG` should stay as a strict stream filter or evolve into a wider allow-list.
- Decide whether unsupported DT should raise an explicit parser or policy error.
- Extend system-level TB to instantiate the real top, not only the TB skeleton chain.
- Decide whether resync should also wait for an explicit sensor-side idle marker
  before releasing capture again.

## Compile Check

This stage requires a compile-level check of `mipi_csi2_capture_top` with all connected RTL sources. A full Vivado synth/impl run still requires final FPGA part binding and complete XDC pin constraints.
