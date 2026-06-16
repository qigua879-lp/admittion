`timescale 1ns/1ps

// Adapter from AMD MIPI D-PHY RX PPI-style byte signals to the existing
// digital lane abstraction consumed by phy_digital_adapter.
module mipi_dphy_ppi_adapter #(
    parameter int LANE_NUM = 2
) (
    input  logic       rxbyteclkhs_i,
    input  logic       cl_stopstate_i,

    input  logic [7:0] dl0_rxdatahs_i,
    input  logic [7:0] dl1_rxdatahs_i,
    input  logic [7:0] dl2_rxdatahs_i,
    input  logic [7:0] dl3_rxdatahs_i,

    input  logic       dl0_rxvalidhs_i,
    input  logic       dl1_rxvalidhs_i,
    input  logic       dl2_rxvalidhs_i,
    input  logic       dl3_rxvalidhs_i,

    input  logic       dl0_rxactivehs_i,
    input  logic       dl1_rxactivehs_i,
    input  logic       dl2_rxactivehs_i,
    input  logic       dl3_rxactivehs_i,

    input  logic       dl0_rxsynchs_i,
    input  logic       dl1_rxsynchs_i,
    input  logic       dl2_rxsynchs_i,
    input  logic       dl3_rxsynchs_i,

    input  logic       dl0_stopstate_i,
    input  logic       dl1_stopstate_i,
    input  logic       dl2_stopstate_i,
    input  logic       dl3_stopstate_i,

    input  logic       dl0_errsoths_i,
    input  logic       dl1_errsoths_i,
    input  logic       dl2_errsoths_i,
    input  logic       dl3_errsoths_i,

    input  logic       dl0_errsotsynchs_i,
    input  logic       dl1_errsotsynchs_i,
    input  logic       dl2_errsotsynchs_i,
    input  logic       dl3_errsotsynchs_i,

    output logic       clk_byte_o,
    output logic [31:0] lane_data_0_o,
    output logic [31:0] lane_data_1_o,
    output logic [31:0] lane_data_2_o,
    output logic [31:0] lane_data_3_o,
    output logic       lane_valid_0_o,
    output logic       lane_valid_1_o,
    output logic       lane_valid_2_o,
    output logic       lane_valid_3_o,
    output logic       hs_mode_o,
    output logic       lp_mode_o,

    output logic [3:0] lane_active_hs_o,
    output logic [3:0] lane_valid_hs_o,
    output logic [3:0] lane_sync_hs_o,
    output logic [3:0] lane_stopstate_o,
    output logic       err_sot_hs_o,
    output logic       err_sot_sync_hs_o
);

    localparam logic [3:0] LANE_MASK =
        (LANE_NUM <= 1) ? 4'b0001 :
        (LANE_NUM == 2) ? 4'b0011 :
        (LANE_NUM == 3) ? 4'b0111 :
                          4'b1111;

    logic [3:0] lane_active_raw;
    logic [3:0] lane_valid_raw;
    logic [3:0] lane_sync_raw;
    logic [3:0] lane_stopstate_raw;
    logic [3:0] err_sot_hs_raw;
    logic [3:0] err_sot_sync_hs_raw;
    logic       lp_mode_raw;
    logic [7:0] dl0_rxdatahs_q = 8'd0;
    logic [7:0] dl1_rxdatahs_q = 8'd0;
    logic [7:0] dl2_rxdatahs_q = 8'd0;
    logic [7:0] dl3_rxdatahs_q = 8'd0;
    logic [3:0] lane_active_q = 4'd0;
    logic [3:0] lane_valid_q = 4'd0;
    logic [3:0] lane_sync_q = 4'd0;
    logic [3:0] err_sot_hs_q = 4'd0;
    logic [3:0] err_sot_sync_hs_q = 4'd0;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic lp_mode_meta = 1'b0;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic lp_mode_sync = 1'b0;

    assign clk_byte_o = rxbyteclkhs_i;

    always_ff @(posedge rxbyteclkhs_i) begin
        dl0_rxdatahs_q      <= dl0_rxdatahs_i;
        dl1_rxdatahs_q      <= dl1_rxdatahs_i;
        dl2_rxdatahs_q      <= dl2_rxdatahs_i;
        dl3_rxdatahs_q      <= dl3_rxdatahs_i;
        lane_active_q       <= {dl3_rxactivehs_i, dl2_rxactivehs_i, dl1_rxactivehs_i, dl0_rxactivehs_i};
        lane_valid_q        <= {dl3_rxvalidhs_i, dl2_rxvalidhs_i, dl1_rxvalidhs_i, dl0_rxvalidhs_i};
        lane_sync_q         <= {dl3_rxsynchs_i, dl2_rxsynchs_i, dl1_rxsynchs_i, dl0_rxsynchs_i};
        err_sot_hs_q        <= {dl3_errsoths_i, dl2_errsoths_i, dl1_errsoths_i, dl0_errsoths_i};
        err_sot_sync_hs_q   <= {dl3_errsotsynchs_i, dl2_errsotsynchs_i, dl1_errsotsynchs_i, dl0_errsotsynchs_i};
    end

    assign lane_data_0_o = {24'd0, dl0_rxdatahs_q};
    assign lane_data_1_o = {24'd0, dl1_rxdatahs_q};
    assign lane_data_2_o = {24'd0, dl2_rxdatahs_q};
    assign lane_data_3_o = {24'd0, dl3_rxdatahs_q};

    assign lane_active_raw       = lane_active_q;
    assign lane_valid_raw        = lane_active_q & lane_valid_q;
    assign lane_sync_raw         = lane_sync_q;
    assign lane_stopstate_raw    = {dl3_stopstate_i, dl2_stopstate_i, dl1_stopstate_i, dl0_stopstate_i};
    assign err_sot_hs_raw        = err_sot_hs_q;
    assign err_sot_sync_hs_raw   = err_sot_sync_hs_q;

    assign lane_active_hs_o   = lane_active_raw & LANE_MASK;
    assign lane_valid_hs_o    = lane_valid_raw & LANE_MASK;
    assign lane_sync_hs_o     = lane_sync_raw & LANE_MASK;
    assign lane_stopstate_o   = lane_stopstate_raw & LANE_MASK;

    assign lane_valid_0_o = lane_valid_hs_o[0];
    assign lane_valid_1_o = lane_valid_hs_o[1];
    assign lane_valid_2_o = lane_valid_hs_o[2];
    assign lane_valid_3_o = lane_valid_hs_o[3];

    assign hs_mode_o    = |lane_active_hs_o;
    assign lp_mode_raw  = cl_stopstate_i && ((lane_stopstate_raw & LANE_MASK) == LANE_MASK);
    assign lp_mode_o    = lp_mode_sync;

    always_ff @(posedge rxbyteclkhs_i) begin
        lp_mode_meta <= lp_mode_raw;
        lp_mode_sync <= lp_mode_meta;
    end

    assign err_sot_hs_o      = |(err_sot_hs_raw & LANE_MASK);
    assign err_sot_sync_hs_o = |(err_sot_sync_hs_raw & LANE_MASK);

endmodule
