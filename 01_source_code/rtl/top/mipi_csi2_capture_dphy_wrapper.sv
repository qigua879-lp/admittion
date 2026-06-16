`timescale 1ns/1ps

// Board-oriented D-PHY PPI entry wrapper. The AMD MIPI D-PHY RX IP can connect
// its RX PPI byte outputs here, while the existing capture FPGA wrapper remains
// unchanged behind the adapter.
module mipi_csi2_capture_dphy_wrapper #(
    parameter int LANE_NUM             = 2,
    parameter int DESKEW_DEPTH         = 16,
    parameter int BYTE_FIFO_ADDR_WIDTH = 8,
    parameter int AXI_FIFO_ADDR_WIDTH  = 8,
    parameter int AXI_ADDR_WIDTH       = 32,
    parameter int AXI_DATA_WIDTH       = 128,
    parameter int AXI_MAX_BURST_LEN    = 16,
    parameter int AXI_SINK_MEM_ADDR_WIDTH = 12,
    parameter int BYTE_FIFO_GUARD_MARGIN = 1
) (
    input  logic                         clk_sys,
    input  logic                         clk_axi,
    input  logic                         clk_ddr,
    input  logic                         rst_n,

    input  logic                         rxbyteclkhs,
    input  logic                         cl_stopstate,

    input  logic [7:0]                   dl0_rxdatahs,
    input  logic [7:0]                   dl1_rxdatahs,
    input  logic [7:0]                   dl2_rxdatahs,
    input  logic [7:0]                   dl3_rxdatahs,
    input  logic                         dl0_rxvalidhs,
    input  logic                         dl1_rxvalidhs,
    input  logic                         dl2_rxvalidhs,
    input  logic                         dl3_rxvalidhs,
    input  logic                         dl0_rxactivehs,
    input  logic                         dl1_rxactivehs,
    input  logic                         dl2_rxactivehs,
    input  logic                         dl3_rxactivehs,
    input  logic                         dl0_rxsynchs,
    input  logic                         dl1_rxsynchs,
    input  logic                         dl2_rxsynchs,
    input  logic                         dl3_rxsynchs,
    input  logic                         dl0_stopstate,
    input  logic                         dl1_stopstate,
    input  logic                         dl2_stopstate,
    input  logic                         dl3_stopstate,
    input  logic                         dl0_errsoths,
    input  logic                         dl1_errsoths,
    input  logic                         dl2_errsoths,
    input  logic                         dl3_errsoths,
    input  logic                         dl0_errsotsynchs,
    input  logic                         dl1_errsotsynchs,
    input  logic                         dl2_errsotsynchs,
    input  logic                         dl3_errsotsynchs,

    output logic                         frame_start_o,
    output logic                         frame_end_o,
    output logic                         line_start_o,
    output logic                         line_end_o,
    output logic                         err_ecc_o,
    output logic                         err_crc_o,
    output logic                         err_sync_o,
    output logic [23:0]                  pixel_data_o,
    output logic                         pixel_valid_o,
    output logic                         pixel_sof_o,
    output logic                         pixel_sol_o,
    output logic                         retry_req_o,
    output logic                         retry_pending_o,
    output logic                         retry_mode_o,
    output logic [31:0]                  retry_frame_id_o,
    output logic [31:0]                  retry_line_id_o,
    output logic                         no_backpressure_drop_event_o,
    output logic                         no_backpressure_drop_active_o,
    output logic                         cfg_init_done_o,

    output logic                         dphy_hs_mode_o,
    output logic                         dphy_lp_mode_o,
    output logic [3:0]                   dphy_lane_active_hs_o,
    output logic [3:0]                   dphy_lane_valid_hs_o,
    output logic [3:0]                   dphy_lane_sync_hs_o,
    output logic [3:0]                   dphy_lane_stopstate_o,
    output logic                         dphy_err_sot_hs_o,
    output logic                         dphy_err_sot_sync_hs_o,
    output logic [63:0]                  ila_probe_o
);

    logic        clk_byte;
    logic [31:0] lane_data_0;
    logic [31:0] lane_data_1;
    logic [31:0] lane_data_2;
    logic [31:0] lane_data_3;
    logic        lane_valid_0;
    logic        lane_valid_1;
    logic        lane_valid_2;
    logic        lane_valid_3;
    logic        hs_mode;
    logic        lp_mode;

    mipi_dphy_ppi_adapter #(
        .LANE_NUM(LANE_NUM)
    ) u_mipi_dphy_ppi_adapter (
        .rxbyteclkhs_i(rxbyteclkhs),
        .cl_stopstate_i(cl_stopstate),
        .dl0_rxdatahs_i(dl0_rxdatahs),
        .dl1_rxdatahs_i(dl1_rxdatahs),
        .dl2_rxdatahs_i(dl2_rxdatahs),
        .dl3_rxdatahs_i(dl3_rxdatahs),
        .dl0_rxvalidhs_i(dl0_rxvalidhs),
        .dl1_rxvalidhs_i(dl1_rxvalidhs),
        .dl2_rxvalidhs_i(dl2_rxvalidhs),
        .dl3_rxvalidhs_i(dl3_rxvalidhs),
        .dl0_rxactivehs_i(dl0_rxactivehs),
        .dl1_rxactivehs_i(dl1_rxactivehs),
        .dl2_rxactivehs_i(dl2_rxactivehs),
        .dl3_rxactivehs_i(dl3_rxactivehs),
        .dl0_rxsynchs_i(dl0_rxsynchs),
        .dl1_rxsynchs_i(dl1_rxsynchs),
        .dl2_rxsynchs_i(dl2_rxsynchs),
        .dl3_rxsynchs_i(dl3_rxsynchs),
        .dl0_stopstate_i(dl0_stopstate),
        .dl1_stopstate_i(dl1_stopstate),
        .dl2_stopstate_i(dl2_stopstate),
        .dl3_stopstate_i(dl3_stopstate),
        .dl0_errsoths_i(dl0_errsoths),
        .dl1_errsoths_i(dl1_errsoths),
        .dl2_errsoths_i(dl2_errsoths),
        .dl3_errsoths_i(dl3_errsoths),
        .dl0_errsotsynchs_i(dl0_errsotsynchs),
        .dl1_errsotsynchs_i(dl1_errsotsynchs),
        .dl2_errsotsynchs_i(dl2_errsotsynchs),
        .dl3_errsotsynchs_i(dl3_errsotsynchs),
        .clk_byte_o(clk_byte),
        .lane_data_0_o(lane_data_0),
        .lane_data_1_o(lane_data_1),
        .lane_data_2_o(lane_data_2),
        .lane_data_3_o(lane_data_3),
        .lane_valid_0_o(lane_valid_0),
        .lane_valid_1_o(lane_valid_1),
        .lane_valid_2_o(lane_valid_2),
        .lane_valid_3_o(lane_valid_3),
        .hs_mode_o(hs_mode),
        .lp_mode_o(lp_mode),
        .lane_active_hs_o(dphy_lane_active_hs_o),
        .lane_valid_hs_o(dphy_lane_valid_hs_o),
        .lane_sync_hs_o(dphy_lane_sync_hs_o),
        .lane_stopstate_o(dphy_lane_stopstate_o),
        .err_sot_hs_o(dphy_err_sot_hs_o),
        .err_sot_sync_hs_o(dphy_err_sot_sync_hs_o)
    );

    assign dphy_hs_mode_o = hs_mode;
    assign dphy_lp_mode_o = lp_mode;

    assign ila_probe_o = {
        4'd0,
        no_backpressure_drop_active_o,
        no_backpressure_drop_event_o,
        retry_mode_o,
        cfg_init_done_o,
        pixel_data_o,
        retry_pending_o,
        retry_req_o,
        err_sync_o,
        err_crc_o,
        err_ecc_o,
        pixel_sol_o,
        pixel_sof_o,
        pixel_valid_o,
        line_end_o,
        line_start_o,
        frame_end_o,
        frame_start_o,
        dphy_err_sot_sync_hs_o,
        dphy_err_sot_hs_o,
        dphy_lane_stopstate_o,
        dphy_lane_sync_hs_o,
        dphy_lane_valid_hs_o,
        dphy_lane_active_hs_o,
        lp_mode,
        hs_mode
    };

    mipi_csi2_capture_fpga_wrapper #(
        .LANE_NUM(LANE_NUM),
        .DESKEW_DEPTH(DESKEW_DEPTH),
        .BYTE_FIFO_ADDR_WIDTH(BYTE_FIFO_ADDR_WIDTH),
        .AXI_FIFO_ADDR_WIDTH(AXI_FIFO_ADDR_WIDTH),
        .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
        .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
        .AXI_MAX_BURST_LEN(AXI_MAX_BURST_LEN),
        .AXI_SINK_MEM_ADDR_WIDTH(AXI_SINK_MEM_ADDR_WIDTH),
        .ENABLE_NO_BACKPRESSURE_GUARD(1'b1),
        .BYTE_FIFO_GUARD_MARGIN(BYTE_FIFO_GUARD_MARGIN)
    ) u_mipi_csi2_capture_fpga_wrapper (
        .clk_sys(clk_sys),
        .clk_byte(clk_byte),
        .clk_axi(clk_axi),
        .clk_ddr(clk_ddr),
        .rst_n(rst_n),
        .lane_data_0(lane_data_0),
        .lane_data_1(lane_data_1),
        .lane_data_2(lane_data_2),
        .lane_data_3(lane_data_3),
        .lane_valid_0(lane_valid_0),
        .lane_valid_1(lane_valid_1),
        .lane_valid_2(lane_valid_2),
        .lane_valid_3(lane_valid_3),
        .hs_mode(hs_mode),
        .lp_mode(lp_mode),
        .frame_start_o(frame_start_o),
        .frame_end_o(frame_end_o),
        .line_start_o(line_start_o),
        .line_end_o(line_end_o),
        .err_ecc_o(err_ecc_o),
        .err_crc_o(err_crc_o),
        .err_sync_o(err_sync_o),
        .pixel_data_o(pixel_data_o),
        .pixel_valid_o(pixel_valid_o),
        .pixel_sof_o(pixel_sof_o),
        .pixel_sol_o(pixel_sol_o),
        .retry_req_o(retry_req_o),
        .retry_pending_o(retry_pending_o),
        .retry_mode_o(retry_mode_o),
        .retry_frame_id_o(retry_frame_id_o),
        .retry_line_id_o(retry_line_id_o),
        .no_backpressure_drop_event_o(no_backpressure_drop_event_o),
        .no_backpressure_drop_active_o(no_backpressure_drop_active_o),
        .cfg_init_done_o(cfg_init_done_o)
    );

endmodule
