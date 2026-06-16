# D-PHY ILA Probe Map

## Purpose

`mipi_csi2_capture_dphy_wrapper` exports `ila_probe_o[63:0]` so the first board
bring-up can attach one compact ILA probe bus instead of many individual top
ports. The bus is combinational and intended for debug visibility, not software
ABI compatibility.

## Bit Map

| Bits | Signal |
| ---: | --- |
| `0` | `dphy_hs_mode_o` |
| `1` | `dphy_lp_mode_o` |
| `5:2` | `dphy_lane_active_hs_o[3:0]` |
| `9:6` | `dphy_lane_valid_hs_o[3:0]` |
| `13:10` | `dphy_lane_sync_hs_o[3:0]` |
| `17:14` | `dphy_lane_stopstate_o[3:0]` |
| `18` | `dphy_err_sot_hs_o` |
| `19` | `dphy_err_sot_sync_hs_o` |
| `20` | `frame_start_o` |
| `21` | `frame_end_o` |
| `22` | `line_start_o` |
| `23` | `line_end_o` |
| `24` | `pixel_valid_o` |
| `25` | `pixel_sof_o` |
| `26` | `pixel_sol_o` |
| `27` | `err_ecc_o` |
| `28` | `err_crc_o` |
| `29` | `err_sync_o` |
| `30` | `retry_req_o` |
| `31` | `retry_pending_o` |
| `55:32` | `pixel_data_o[23:0]` |
| `56` | `cfg_init_done_o` |
| `57` | `retry_mode_o` |
| `58` | `no_backpressure_drop_event_o` |
| `59` | `no_backpressure_drop_active_o` |
| `63:60` | reserved, tied to zero |

## Suggested ILA Trigger

For the first RAW8 board run, use `rxbyteclkhs` or the D-PHY wrapper byte
clock as the ILA sampling clock and trigger on one of:

- `ila_probe_o[20]` for frame start.
- `ila_probe_o[22]` for line start.
- `ila_probe_o[24]` for first pixel valid.
- `ila_probe_o[27] || ila_probe_o[28] || ila_probe_o[29]` for parser errors.
- `ila_probe_o[18] || ila_probe_o[19]` for D-PHY SoT-side errors.
- `ila_probe_o[58]` for a no-backpressure guard drop/clear event.

## Verification

The bit map is covered by `tb_mipi_csi2_capture_dphy_debug_probe.sv`, which
checks LP idle, HS active/valid/sync masks, D-PHY error summaries, and reserved
zero bits.
