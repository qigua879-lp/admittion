`timescale 1ns/1ps

module raw8_unpack (
    input  logic        clk_sys,
    input  logic        rst_n,
    input  logic        clear_i,

    input  logic        payload_valid_i,
    output logic        payload_ready_o,
    input  logic [7:0]  payload_data_i,
    input  logic        payload_sof_i,
    input  logic        payload_sol_i,

    output logic        pixel_valid_o,
    input  logic        pixel_ready_i,
    output logic [23:0] pixel_data_o,
    output logic        pixel_sof_o,
    output logic        pixel_sol_o
);

    assign payload_ready_o = !pixel_valid_o || pixel_ready_i;

    always_ff @(posedge clk_sys) begin
        if (!rst_n || clear_i) begin
            pixel_valid_o <= 1'b0;
            pixel_data_o  <= 24'd0;
            pixel_sof_o   <= 1'b0;
            pixel_sol_o   <= 1'b0;
        end else begin
            if (payload_valid_i && payload_ready_o) begin
                pixel_valid_o <= 1'b1;
                pixel_data_o  <= {16'd0, payload_data_i};
                pixel_sof_o   <= payload_sof_i;
                pixel_sol_o   <= payload_sol_i;
            end else if (pixel_ready_i) begin
                pixel_valid_o <= 1'b0;
                pixel_sof_o   <= 1'b0;
                pixel_sol_o   <= 1'b0;
            end
        end
    end

endmodule
