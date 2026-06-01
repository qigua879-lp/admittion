`timescale 1ns/1ps

module scoreboard #(
    parameter int MAX_PIXELS = 1024
) (
    input  logic        clk_sys,
    input  logic        rst_n,
    input  logic        clear_i,

    input  logic        exp_valid_i,
    output logic        exp_ready_o,
    input  logic [23:0] exp_data_i,
    input  logic        exp_sof_i,
    input  logic        exp_sol_i,

    input  logic        act_valid_i,
    output logic        act_ready_o,
    input  logic [23:0] act_data_i,
    input  logic        act_sof_i,
    input  logic        act_sol_i,

    input  logic        finish_i,
    output logic        pass_o,
    output logic        fail_o,
    output logic [31:0] frame_cnt_o,
    output logic [31:0] exp_pixel_cnt_o,
    output logic [31:0] act_pixel_cnt_o,
    output logic [31:0] mismatch_cnt_o
);

    logic [23:0] exp_data_mem [0:MAX_PIXELS-1];
    logic        exp_sof_mem  [0:MAX_PIXELS-1];
    logic        exp_sol_mem  [0:MAX_PIXELS-1];

    logic [31:0] exp_wr_idx;
    logic [31:0] act_rd_idx;
    logic        act_mismatch;

    assign exp_ready_o = (exp_wr_idx < MAX_PIXELS);
    assign act_ready_o = 1'b1;

    always_comb begin
        act_mismatch = 1'b0;
        if (act_valid_i && act_ready_o) begin
            if (act_rd_idx >= exp_wr_idx) begin
                act_mismatch = 1'b1;
            end else if (act_data_i != exp_data_mem[act_rd_idx] ||
                         act_sof_i  != exp_sof_mem[act_rd_idx]  ||
                         act_sol_i  != exp_sol_mem[act_rd_idx]) begin
                act_mismatch = 1'b1;
            end
        end
    end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            exp_wr_idx      <= 32'd0;
            act_rd_idx      <= 32'd0;
            pass_o          <= 1'b0;
            fail_o          <= 1'b0;
            frame_cnt_o     <= 32'd0;
            exp_pixel_cnt_o <= 32'd0;
            act_pixel_cnt_o <= 32'd0;
            mismatch_cnt_o  <= 32'd0;
        end else if (clear_i) begin
            exp_wr_idx      <= 32'd0;
            act_rd_idx      <= 32'd0;
            pass_o          <= 1'b0;
            fail_o          <= 1'b0;
            frame_cnt_o     <= 32'd0;
            exp_pixel_cnt_o <= 32'd0;
            act_pixel_cnt_o <= 32'd0;
            mismatch_cnt_o  <= 32'd0;
        end else begin
            pass_o <= 1'b0;
            fail_o <= 1'b0;

            if (exp_valid_i && exp_ready_o) begin
                exp_data_mem[exp_wr_idx] <= exp_data_i;
                exp_sof_mem[exp_wr_idx]  <= exp_sof_i;
                exp_sol_mem[exp_wr_idx]  <= exp_sol_i;
                exp_wr_idx               <= exp_wr_idx + 32'd1;
                exp_pixel_cnt_o          <= exp_pixel_cnt_o + 32'd1;
            end

            if (act_valid_i && act_ready_o) begin
                act_rd_idx      <= act_rd_idx + 32'd1;
                act_pixel_cnt_o <= act_pixel_cnt_o + 32'd1;
                if (act_sof_i) begin
                    frame_cnt_o <= frame_cnt_o + 32'd1;
                end
                if (act_mismatch) begin
                    mismatch_cnt_o <= mismatch_cnt_o + 32'd1;
                end
            end

            if (finish_i) begin
                if ((exp_pixel_cnt_o == act_pixel_cnt_o) &&
                    (mismatch_cnt_o == 32'd0) &&
                    (exp_pixel_cnt_o != 32'd0)) begin
                    pass_o <= 1'b1;
                end else begin
                    fail_o <= 1'b1;
                end
            end
        end
    end

endmodule
