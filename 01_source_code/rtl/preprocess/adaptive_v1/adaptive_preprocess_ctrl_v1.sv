`timescale 1ns/1ps

// adaptive_v1 iteration:
// Frame-to-frame adaptive coefficient generator. Statistics captured from frame
// N are translated into coefficients used by frame N+1.
module adaptive_preprocess_ctrl_v1 (
    input  logic               clk_sys,
    input  logic               rst_n,

    input  logic               enable_i,
    input  logic               awb_enable_i,
    input  logic               stretch_enable_i,
    input  logic               clear_i,

    input  logic               stats_valid_i,
    input  logic [31:0]        pixel_cnt_i,
    input  logic [15:0]        mean_r_i,
    input  logic [15:0]        mean_g_i,
    input  logic [15:0]        mean_b_i,
    input  logic [7:0]         luma_min_i,
    input  logic [7:0]         luma_max_i,

    output logic [7:0]         awb_gain_r_o,
    output logic [7:0]         awb_gain_g_o,
    output logic [7:0]         awb_gain_b_o,
    output logic [7:0]         stretch_gain_o,
    output logic signed [8:0]  stretch_bias_o,
    output logic               coeff_valid_o
);

    localparam logic [7:0] GAIN_IDENTITY = 8'h80;
    localparam logic [7:0] GAIN_MIN_Q17  = 8'h20;
    localparam logic [7:0] GAIN_MAX_Q17  = 8'hff;
    localparam int unsigned STRETCH_MIN_RANGE = 24;

    logic [17:0] mean_sum;
    logic [15:0] gray_target;
    logic [8:0]  luma_range;
    logic [31:0] ideal_gain_q17;
    logic [31:0] bias_limit_gain_q17;
    logic [31:0] clipped_gain_q17;
    logic signed [16:0] stretch_bias_calc;

    function automatic logic [7:0] clamp_gain_q17(input logic [31:0] gain_q17);
        begin
            if (gain_q17[31] || (gain_q17 < GAIN_MIN_Q17)) begin
                clamp_gain_q17 = GAIN_MIN_Q17;
            end else if (gain_q17 > GAIN_MAX_Q17) begin
                clamp_gain_q17 = GAIN_MAX_Q17;
            end else begin
                clamp_gain_q17 = gain_q17[7:0];
            end
        end
    endfunction

    function automatic logic [7:0] calc_awb_gain_q17(
        input logic [15:0] target_mean,
        input logic [15:0] channel_mean
    );
        logic [31:0] gain_q17;
        begin
            if (channel_mean == 16'd0) begin
                calc_awb_gain_q17 = GAIN_MAX_Q17;
            end else begin
                gain_q17 = (({16'd0, target_mean} << 7) + (channel_mean >> 1)) / channel_mean;
                calc_awb_gain_q17 = clamp_gain_q17(gain_q17);
            end
        end
    endfunction

    function automatic logic signed [8:0] clamp_bias_s9(input logic signed [16:0] bias_value);
        begin
            if (bias_value > 17'sd255) begin
                clamp_bias_s9 = 9'sd255;
            end else if (bias_value < -17'sd256) begin
                clamp_bias_s9 = -9'sd256;
            end else begin
                clamp_bias_s9 = bias_value[8:0];
            end
        end
    endfunction

    always_comb begin
        mean_sum           = {2'd0, mean_r_i} + {2'd0, mean_g_i} + {2'd0, mean_b_i};
        gray_target        = mean_sum / 3;
        luma_range         = {1'b0, luma_max_i} - {1'b0, luma_min_i};
        ideal_gain_q17     = 32'd128;
        bias_limit_gain_q17 = 32'd255;
        clipped_gain_q17   = 32'd128;
        stretch_bias_calc  = 17'sd0;

        if (luma_range >= STRETCH_MIN_RANGE) begin
            ideal_gain_q17 = ((32'd255 << 7) + (luma_range >> 1)) / luma_range;
            if (luma_min_i != 8'd0) begin
                bias_limit_gain_q17 = (32'd256 << 7) / luma_min_i;
            end

            if (ideal_gain_q17 < bias_limit_gain_q17) begin
                clipped_gain_q17 = ideal_gain_q17;
            end else begin
                clipped_gain_q17 = bias_limit_gain_q17;
            end
        end

        if (clipped_gain_q17 > GAIN_MAX_Q17) begin
            clipped_gain_q17 = GAIN_MAX_Q17;
        end else if (clipped_gain_q17 < GAIN_IDENTITY) begin
            clipped_gain_q17 = GAIN_IDENTITY;
        end

        stretch_bias_calc = -$signed(({9'd0, luma_min_i} * clipped_gain_q17) >> 7);
    end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            awb_gain_r_o   <= GAIN_IDENTITY;
            awb_gain_g_o   <= GAIN_IDENTITY;
            awb_gain_b_o   <= GAIN_IDENTITY;
            stretch_gain_o <= GAIN_IDENTITY;
            stretch_bias_o <= 9'sd0;
            coeff_valid_o  <= 1'b0;
        end else begin
            coeff_valid_o <= 1'b0;

            if (clear_i || !enable_i) begin
                awb_gain_r_o   <= GAIN_IDENTITY;
                awb_gain_g_o   <= GAIN_IDENTITY;
                awb_gain_b_o   <= GAIN_IDENTITY;
                stretch_gain_o <= GAIN_IDENTITY;
                stretch_bias_o <= 9'sd0;
            end else if (stats_valid_i && (pixel_cnt_i != 32'd0)) begin
                coeff_valid_o <= 1'b1;

                if (awb_enable_i) begin
                    awb_gain_r_o <= calc_awb_gain_q17(gray_target, mean_r_i);
                    awb_gain_g_o <= calc_awb_gain_q17(gray_target, mean_g_i);
                    awb_gain_b_o <= calc_awb_gain_q17(gray_target, mean_b_i);
                end else begin
                    awb_gain_r_o <= GAIN_IDENTITY;
                    awb_gain_g_o <= GAIN_IDENTITY;
                    awb_gain_b_o <= GAIN_IDENTITY;
                end

                if (stretch_enable_i && (luma_range >= STRETCH_MIN_RANGE)) begin
                    stretch_gain_o <= clamp_gain_q17(clipped_gain_q17);
                    stretch_bias_o <= clamp_bias_s9(stretch_bias_calc);
                end else begin
                    stretch_gain_o <= GAIN_IDENTITY;
                    stretch_bias_o <= 9'sd0;
                end
            end
        end
    end

endmodule
