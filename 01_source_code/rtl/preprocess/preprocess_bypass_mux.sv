`timescale 1ns/1ps

module preprocess_bypass_mux (
    input  logic        clk_sys,
    input  logic        rst_n,

    input  logic        bypass_i,

    input  logic        raw_valid_i,
    output logic        raw_ready_o,
    input  logic [23:0] raw_data_i,
    input  logic        raw_sof_i,
    input  logic        raw_sol_i,

    input  logic        proc_valid_i,
    output logic        proc_ready_o,
    input  logic [23:0] proc_data_i,
    input  logic        proc_sof_i,
    input  logic        proc_sol_i,

    output logic        pixel_valid_o,
    input  logic        pixel_ready_i,
    output logic [23:0] pixel_data_o,
    output logic        pixel_sof_o,
    output logic        pixel_sol_o
);

    logic select_valid;
    logic [23:0] select_data;
    logic select_sof;
    logic select_sol;

    assign raw_ready_o  = bypass_i  ? (!pixel_valid_o || pixel_ready_i) : 1'b0;
    assign proc_ready_o = !bypass_i ? (!pixel_valid_o || pixel_ready_i) : 1'b0;

    assign select_valid = bypass_i ? raw_valid_i : proc_valid_i;
    assign select_data  = bypass_i ? raw_data_i  : proc_data_i;
    assign select_sof   = bypass_i ? raw_sof_i   : proc_sof_i;
    assign select_sol   = bypass_i ? raw_sol_i   : proc_sol_i;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            pixel_valid_o <= 1'b0;
            pixel_data_o  <= 24'd0;
            pixel_sof_o   <= 1'b0;
            pixel_sol_o   <= 1'b0;
        end else begin
            if (select_valid && (!pixel_valid_o || pixel_ready_i)) begin
                pixel_valid_o <= 1'b1;
                pixel_data_o  <= select_data;
                pixel_sof_o   <= select_sof;
                pixel_sol_o   <= select_sol;
            end else if (pixel_ready_i) begin
                pixel_valid_o <= 1'b0;
                pixel_sof_o   <= 1'b0;
                pixel_sol_o   <= 1'b0;
            end
        end
    end

endmodule
