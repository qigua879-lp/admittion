`timescale 1ns/1ps

module lane_reorder_merge #(
    parameter int LANE_NUM = 4
) (
    input  logic                     clk_byte,
    input  logic                     rst_n,
    input  logic                     clear_i,

    input  logic                     lane_group_valid_i,
    output logic                     lane_group_ready_o,
    input  logic [LANE_NUM-1:0][7:0] lane_group_data_i,

    output logic                     byte_valid_o,
    input  logic                     byte_ready_i,
    output logic [7:0]               byte_data_o,
    output logic                     group_done_o
);

    localparam int IDX_WIDTH = (LANE_NUM <= 2) ? 1 : $clog2(LANE_NUM);
    localparam logic [IDX_WIDTH-1:0] LAST_IDX = LANE_NUM - 1;

    logic [LANE_NUM-1:0][7:0] group_data_reg;
    logic [IDX_WIDTH-1:0]     lane_idx;
    logic                     active;
    logic                     byte_fire;
    logic                     last_lane;

    assign lane_group_ready_o = !active;
    assign byte_valid_o       = active;
    assign byte_data_o        = group_data_reg[lane_idx];
    assign byte_fire          = byte_valid_o && byte_ready_i;
    assign last_lane          = (lane_idx == LAST_IDX);
    assign group_done_o       = byte_fire && last_lane;

    always_ff @(posedge clk_byte) begin
        if (!rst_n) begin
            group_data_reg <= '0;
            lane_idx       <= '0;
            active         <= 1'b0;
        end else if (clear_i) begin
            group_data_reg <= '0;
            lane_idx       <= '0;
            active         <= 1'b0;
        end else begin
            if (!active) begin
                if (lane_group_valid_i) begin
                    group_data_reg <= lane_group_data_i;
                    lane_idx       <= '0;
                    active         <= 1'b1;
                end
            end else if (byte_fire) begin
                if (last_lane) begin
                    active   <= 1'b0;
                    lane_idx <= '0;
                end else begin
                    lane_idx <= lane_idx + 1'b1;
                end
            end
        end
    end

endmodule
