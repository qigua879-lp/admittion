`timescale 1ns/1ps

module contrast_adjust (
    input  logic               clk_sys,
    input  logic               rst_n,

    input  logic               bypass_i,
    input  logic [7:0]         cfg_gain_i,
    input  logic signed [8:0]  cfg_bias_i,

    input  logic               pixel_valid_i,
    output logic               pixel_ready_o,
    input  logic [23:0]        pixel_data_i,
    input  logic               pixel_sof_i,
    input  logic               pixel_sol_i,

    output logic               pixel_valid_o,
    input  logic               pixel_ready_i,
    output logic [23:0]        pixel_data_o,
    output logic               pixel_sof_o,
    output logic               pixel_sol_o
);

    logic [7:0] adj_ch0;
    logic [7:0] adj_ch1;
    logic [7:0] adj_ch2;

    function automatic logic [7:0] sat_u8(input logic signed [31:0] value);
        begin
            if (value < 32'sd0) begin
                sat_u8 = 8'd0;
            end else if (value > 32'sd255) begin
                sat_u8 = 8'd255;
            end else begin
                sat_u8 = value[7:0];
            end
        end
    endfunction

    function automatic logic [7:0] apply_contrast(
        input logic [7:0]        channel,
        input logic [7:0]        gain,
        input logic signed [8:0] bias
    );
        logic [8:0]         delta;
        logic [31:0]        product;
        logic [31:0]        scaled_delta;
        logic signed [31:0] scaled;
        begin
            if (channel >= 8'd128) begin
                delta = {1'b0, channel} - 9'd128;
                product = {23'd0, delta} * {24'd0, gain};
                scaled_delta = product >> 7;
                scaled = 32'sd128 + $signed({1'b0, scaled_delta[30:0]}) + bias;
            end else begin
                delta = 9'd128 - {1'b0, channel};
                product = {23'd0, delta} * {24'd0, gain};
                scaled_delta = product >> 7;
                scaled = 32'sd128 - $signed({1'b0, scaled_delta[30:0]}) + bias;
            end
            apply_contrast = sat_u8(scaled);
        end
    endfunction

    assign pixel_ready_o = !pixel_valid_o || pixel_ready_i;
    assign adj_ch0 = apply_contrast(pixel_data_i[23:16], cfg_gain_i, cfg_bias_i);
    assign adj_ch1 = apply_contrast(pixel_data_i[15:8], cfg_gain_i, cfg_bias_i);
    assign adj_ch2 = apply_contrast(pixel_data_i[7:0], cfg_gain_i, cfg_bias_i);

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            pixel_valid_o <= 1'b0;
            pixel_data_o  <= 24'd0;
            pixel_sof_o   <= 1'b0;
            pixel_sol_o   <= 1'b0;
        end else begin
            if (pixel_valid_i && pixel_ready_o) begin
                pixel_valid_o <= 1'b1;
                pixel_data_o  <= bypass_i ? pixel_data_i : {adj_ch0, adj_ch1, adj_ch2};
                pixel_sof_o   <= pixel_sof_i;
                pixel_sol_o   <= pixel_sol_i;
            end else if (pixel_ready_i) begin
                pixel_valid_o <= 1'b0;
                pixel_sof_o   <= 1'b0;
                pixel_sol_o   <= 1'b0;
            end
        end
    end

endmodule
