`timescale 1ns/1ps

module mem_map_ctrl #(
    parameter int ADDR_WIDTH = 32
) (
    input  logic                  clk_sys,
    input  logic                  rst_n,

    input  logic                  cfg_valid_i,
    output logic                  cfg_ready_o,
    input  logic [ADDR_WIDTH-1:0] cfg_frame_base_addr_i,
    input  logic [ADDR_WIDTH-1:0] cfg_line_stride_i,
    input  logic [15:0]           cfg_line_bytes_i,
    input  logic [15:0]           cfg_frame_height_i,
    input  logic [8:0]            cfg_max_burst_len_i,

    output logic [ADDR_WIDTH-1:0] frame_base_addr_o,
    output logic [ADDR_WIDTH-1:0] line_stride_o,
    output logic [15:0]           line_bytes_o,
    output logic [15:0]           frame_height_o,
    output logic [8:0]            max_burst_len_o
);

    assign cfg_ready_o = 1'b1;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            frame_base_addr_o <= '0;
            line_stride_o     <= '0;
            line_bytes_o      <= 16'd0;
            frame_height_o    <= 16'd0;
            max_burst_len_o   <= 9'd16;
        end else if (cfg_valid_i && cfg_ready_o) begin
            frame_base_addr_o <= cfg_frame_base_addr_i;
            line_stride_o     <= cfg_line_stride_i;
            line_bytes_o      <= cfg_line_bytes_i;
            frame_height_o    <= cfg_frame_height_i;
            max_burst_len_o   <= cfg_max_burst_len_i;
        end
    end

endmodule
