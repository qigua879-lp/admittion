`timescale 1ns/1ps

module gray_balance (
    input  logic               clk_sys,
    input  logic               rst_n,

    input  logic               bypass_i,
    input  logic [7:0]         cfg_gain_r_i,
    input  logic [7:0]         cfg_gain_g_i,
    input  logic [7:0]         cfg_gain_b_i,
    input  logic signed [8:0]  cfg_bias_r_i,
    input  logic signed [8:0]  cfg_bias_g_i,
    input  logic signed [8:0]  cfg_bias_b_i,

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

    logic [7:0] adj_r;
    logic [7:0] adj_g;
    logic [7:0] adj_b;

    function automatic logic [7:0] sat_u8(input logic signed [19:0] value);
        begin
            if (value < 20'sd0) begin
                sat_u8 = 8'd0;
            end else if (value > 20'sd255) begin
                sat_u8 = 8'd255;
            end else begin
                sat_u8 = value[7:0];
            end
        end
    endfunction

    function automatic logic [7:0] apply_balance(
        input logic [7:0]        channel,
        input logic [7:0]        gain,
        input logic signed [8:0] bias
    );
        logic [19:0] product;
        logic signed [19:0] scaled;
        begin
            product = {12'd0, channel} * {12'd0, gain};
            scaled = $signed({1'b0, product[19:7]}) + bias;
            apply_balance = sat_u8(scaled);
        end
    endfunction

    assign pixel_ready_o = !pixel_valid_o || pixel_ready_i;
    assign adj_r = apply_balance(pixel_data_i[23:16], cfg_gain_r_i, cfg_bias_r_i);
    assign adj_g = apply_balance(pixel_data_i[15:8],  cfg_gain_g_i, cfg_bias_g_i);
    assign adj_b = apply_balance(pixel_data_i[7:0],   cfg_gain_b_i, cfg_bias_b_i);

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            pixel_valid_o <= 1'b0;
            pixel_data_o  <= 24'd0;
            pixel_sof_o   <= 1'b0;
            pixel_sol_o   <= 1'b0;
        end else begin
            if (pixel_valid_i && pixel_ready_o) begin
                pixel_valid_o <= 1'b1;
                pixel_data_o  <= bypass_i ? pixel_data_i : {adj_r, adj_g, adj_b};
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
