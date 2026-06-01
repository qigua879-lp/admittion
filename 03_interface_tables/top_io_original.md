# Top-Level I/O

## Purpose
This document captures the draft external interface for `mipi_csi2_capture_top`. It is intended to keep interface style stable while lower-level modules are developed.

## Clocks and Reset
| Signal | Direction | Width | Clock Domain | Description |
|---|---:|---:|---|---|
| clk_sys | input | 1 | system | Protocol control and status domain |
| clk_byte | input | 1 | byte | Digital lane receive domain |
| clk_axi | input | 1 | AXI | AXI write master domain |
| clk_ddr | input | 1 | DDR | DDR controller-related domain |
| rst_n | input | 1 | all | Active-low synchronous reset |

## PHY Digital Adapter Inputs
| Signal | Direction | Width | Clock Domain | Description |
|---|---:|---:|---|---|
| lane_data_0 | input | 32 | clk_byte | Digital abstract lane 0 data |
| lane_data_1 | input | 32 | clk_byte | Digital abstract lane 1 data |
| lane_data_2 | input | 32 | clk_byte | Digital abstract lane 2 data |
| lane_data_3 | input | 32 | clk_byte | Digital abstract lane 3 data |
| lane_valid_0 | input | 1 | clk_byte | Lane 0 data valid |
| lane_valid_1 | input | 1 | clk_byte | Lane 1 data valid |
| lane_valid_2 | input | 1 | clk_byte | Lane 2 data valid |
| lane_valid_3 | input | 1 | clk_byte | Lane 3 data valid |
| hs_mode | input | 1 | clk_byte | Digital high-speed mode indicator |
| lp_mode | input | 1 | clk_byte | Digital low-power mode indicator |

## Configuration Interface
Early-stage integration should use an APB-style slave interface for simplicity.

| Signal | Direction | Width | Clock Domain | Description |
|---|---:|---:|---|---|
| psel | input | 1 | clk_sys | APB select |
| penable | input | 1 | clk_sys | APB enable |
| pwrite | input | 1 | clk_sys | APB write enable |
| paddr | input | 16 | clk_sys | Register address |
| pwdata | input | 32 | clk_sys | Write data |
| prdata | output | 32 | clk_sys | Read data |
| pready | output | 1 | clk_sys | Transfer ready |
| pslverr | output | 1 | clk_sys | Register access error |

## AXI Write Interface
Only the write path is planned for early implementation.

| Signal Group | Direction | Clock Domain | Description |
|---|---:|---|---|
| m_axi_aw* | output/input | clk_axi | AXI write address channel |
| m_axi_w* | output/input | clk_axi | AXI write data channel |
| m_axi_b* | output/input | clk_axi | AXI write response channel |

## Debug and Status Outputs
| Signal | Direction | Width | Clock Domain | Description |
|---|---:|---:|---|---|
| frame_start_o | output | 1 | clk_sys | Frame start pulse |
| frame_end_o | output | 1 | clk_sys | Frame end pulse |
| line_start_o | output | 1 | clk_sys | Line start pulse |
| line_end_o | output | 1 | clk_sys | Line end pulse |
| err_ecc_o | output | 1 | clk_sys | ECC error pulse or sticky status |
| err_crc_o | output | 1 | clk_sys | CRC error pulse or sticky status |
| err_sync_o | output | 1 | clk_sys | Sync error pulse or sticky status |
| frame_cnt_o | output | 32 | clk_sys | Frame counter |
| line_cnt_o | output | 32 | clk_sys | Line counter |
| err_cnt_ecc_o | output | 32 | clk_sys | ECC error counter |
| err_cnt_crc_o | output | 32 | clk_sys | CRC error counter |
| retry_req_o | output | 1 | clk_sys | Retry request pulse |
| retry_pending_o | output | 1 | clk_sys | Retry request is pending software/upstream acknowledgement |
| retry_mode_o | output | 1 | clk_sys | Retry granularity, 0 for frame and 1 for line |
| retry_frame_id_o | output | 32 | clk_sys | Retry request frame id |
| retry_line_id_o | output | 32 | clk_sys | Retry request line id |

## Pixel Debug Outputs
| Signal | Direction | Width | Clock Domain | Description |
|---|---:|---:|---|---|
| pixel_data_o | output | 24 | clk_sys | Debug pixel data |
| pixel_valid_o | output | 1 | clk_sys | Debug pixel valid |
| pixel_sof_o | output | 1 | clk_sys | Pixel stream start-of-frame |
| pixel_sol_o | output | 1 | clk_sys | Pixel stream start-of-line |

## Interface Rules
- All sequential logic uses synchronous behavior and active-low `rst_n`.
- Signal names follow `AGENTS.md` naming rules.
- New top-level ports require a spec update before RTL integration.
- Real analog D-PHY behavior is out of scope.
