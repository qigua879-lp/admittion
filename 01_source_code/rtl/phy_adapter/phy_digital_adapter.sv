`timescale 1ns/1ps

// Digital abstraction layer for the bridged MIPI D-PHY inputs.
// The current design stage assumes each external lane already provides a
// parallel digital word and valid strobe in clk_byte. This adapter centralizes
// HS/LP gating, lane mask application, and byte extraction so the protocol
// receive path no longer performs those tasks inline at top level.
module phy_digital_adapter #(
    parameter int LANE_NUM = 4
) (
    input  logic                     hs_mode_i,
    input  logic                     lp_mode_i,
    input  logic [1:0]               cfg_lane_num_minus1_i,
    input  logic [3:0]               cfg_lane_enable_mask_i,
    input  logic [31:0]              lane_data_0_i,
    input  logic [31:0]              lane_data_1_i,
    input  logic [31:0]              lane_data_2_i,
    input  logic [31:0]              lane_data_3_i,
    input  logic                     lane_valid_0_i,
    input  logic                     lane_valid_1_i,
    input  logic                     lane_valid_2_i,
    input  logic                     lane_valid_3_i,
    output logic [LANE_NUM-1:0]      lane_valid_o,
    output logic [LANE_NUM-1:0][7:0] lane_data_o,
    output logic [LANE_NUM-1:0]      lane_enable_o,
    output logic                     phy_active_o
);

    integer lane_idx;
    logic [3:0] lane_num_mask;
    logic [7:0] lane_byte_0;
    logic [7:0] lane_byte_1;
    logic [7:0] lane_byte_2;
    logic [7:0] lane_byte_3;

    assign lane_byte_0 = lane_data_0_i[7:0];
    assign lane_byte_1 = lane_data_1_i[7:0];
    assign lane_byte_2 = lane_data_2_i[7:0];
    assign lane_byte_3 = lane_data_3_i[7:0];

    always_comb begin
        case (cfg_lane_num_minus1_i)
            2'd0: lane_num_mask = 4'b0001;
            2'd1: lane_num_mask = 4'b0011;
            2'd2: lane_num_mask = 4'b0111;
            default: lane_num_mask = 4'b1111;
        endcase
    end

    // HS byte-valid strobes already encode whether bytes are present. LP mode is
    // a slow state hint for reset/resync policy and must not mask the first HS
    // bytes while a synchronized stop-state indication is draining.
    assign phy_active_o = hs_mode_i;

    always_comb begin
        lane_valid_o  = '0;
        lane_data_o   = '0;
        lane_enable_o = '0;

        for (lane_idx = 0; lane_idx < LANE_NUM; lane_idx = lane_idx + 1) begin
            lane_enable_o[lane_idx] = lane_num_mask[lane_idx] && cfg_lane_enable_mask_i[lane_idx];

            case (lane_idx)
                0: begin
                    lane_valid_o[lane_idx] = phy_active_o && lane_enable_o[lane_idx] && lane_valid_0_i;
                    lane_data_o[lane_idx]  = lane_byte_0;
                end
                1: begin
                    lane_valid_o[lane_idx] = phy_active_o && lane_enable_o[lane_idx] && lane_valid_1_i;
                    lane_data_o[lane_idx]  = lane_byte_1;
                end
                2: begin
                    lane_valid_o[lane_idx] = phy_active_o && lane_enable_o[lane_idx] && lane_valid_2_i;
                    lane_data_o[lane_idx]  = lane_byte_2;
                end
                3: begin
                    lane_valid_o[lane_idx] = phy_active_o && lane_enable_o[lane_idx] && lane_valid_3_i;
                    lane_data_o[lane_idx]  = lane_byte_3;
                end
                default: begin
                    lane_valid_o[lane_idx] = 1'b0;
                    lane_data_o[lane_idx]  = 8'd0;
                end
            endcase
        end
    end

endmodule
