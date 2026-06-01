`timescale 1ns/1ps

module degrade_recover_fsm #(
    parameter int FULL_LANE_NUM         = 4,
    parameter int DEGRADED_LANE_NUM     = 2,
    parameter int RECOVER_GOOD_FRAME_TH = 3
) (
    input  logic       clk_sys,
    input  logic       rst_n,

    input  logic       enable_degrade_i,
    input  logic       lane_error_i,
    input  logic       good_frame_i,

    output logic       degraded_o,
    output logic       recovering_o,
    output logic [2:0] active_lane_num_o
);

    localparam int GOOD_CNT_WIDTH = (RECOVER_GOOD_FRAME_TH <= 1) ? 1 : $clog2(RECOVER_GOOD_FRAME_TH + 1);
    localparam logic [2:0] FULL_LANES     = FULL_LANE_NUM;
    localparam logic [2:0] DEGRADED_LANES = DEGRADED_LANE_NUM;
    localparam logic [GOOD_CNT_WIDTH-1:0] RECOVER_TH = RECOVER_GOOD_FRAME_TH;

    logic [GOOD_CNT_WIDTH-1:0] good_frame_cnt;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            degraded_o        <= 1'b0;
            recovering_o      <= 1'b0;
            active_lane_num_o <= FULL_LANES;
            good_frame_cnt    <= '0;
        end else begin
            if (enable_degrade_i && lane_error_i) begin
                degraded_o        <= 1'b1;
                recovering_o      <= 1'b0;
                active_lane_num_o <= DEGRADED_LANES;
                good_frame_cnt    <= '0;
            end else if (degraded_o && good_frame_i) begin
                if (good_frame_cnt + 1'b1 >= RECOVER_TH) begin
                    degraded_o        <= 1'b0;
                    recovering_o      <= 1'b0;
                    active_lane_num_o <= FULL_LANES;
                    good_frame_cnt    <= '0;
                end else begin
                    recovering_o   <= 1'b1;
                    good_frame_cnt <= good_frame_cnt + 1'b1;
                end
            end else if (!degraded_o) begin
                recovering_o   <= 1'b0;
                good_frame_cnt <= '0;
            end
        end
    end

endmodule
