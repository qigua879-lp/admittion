`timescale 1ns/1ps

module addr_gen_frame_based #(
    parameter int ADDR_WIDTH = 32
) (
    input  logic                  clk_axi,
    input  logic                  rst_n,

    input  logic                  addr_req_valid_i,
    output logic                  addr_req_ready_o,
    input  logic [ADDR_WIDTH-1:0] frame_base_addr_i,
    input  logic [ADDR_WIDTH-1:0] line_stride_i,
    input  logic [15:0]           line_id_i,
    input  logic [ADDR_WIDTH-1:0] byte_offset_i,

    output logic                  addr_valid_o,
    input  logic                  addr_ready_i,
    output logic [ADDR_WIDTH-1:0] addr_o
);

    logic [ADDR_WIDTH-1:0] line_offset;

    assign addr_req_ready_o = !addr_valid_o || addr_ready_i;
    assign line_offset      = line_stride_i * line_id_i;

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            addr_valid_o <= 1'b0;
            addr_o       <= '0;
        end else begin
            if (addr_req_valid_i && addr_req_ready_o) begin
                addr_valid_o <= 1'b1;
                addr_o       <= frame_base_addr_i + line_offset + byte_offset_i;
            end else if (addr_ready_i) begin
                addr_valid_o <= 1'b0;
            end
        end
    end

endmodule
