`timescale 1ns/1ps

module async_fifo #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 4
) (
    input  logic                  clk_wr,
    input  logic                  clk_rd,
    input  logic                  rst_n,
    input  logic                  clear_wr_i,
    input  logic                  clear_rd_i,

    input  logic                  wr_valid,
    output logic                  wr_ready,
    input  logic [DATA_WIDTH-1:0] wr_data,

    output logic                  rd_valid,
    input  logic                  rd_ready,
    output logic [DATA_WIDTH-1:0] rd_data,

    output logic                  full,
    output logic                  empty,
    output logic [ADDR_WIDTH:0]   wr_level,
    output logic [ADDR_WIDTH:0]   rd_level
);

    localparam int DEPTH = (1 << ADDR_WIDTH);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    logic [ADDR_WIDTH:0] wr_ptr_bin;
    logic [ADDR_WIDTH:0] wr_ptr_gray;
    logic [ADDR_WIDTH:0] rd_ptr_bin;
    logic [ADDR_WIDTH:0] rd_ptr_gray;

    // Gray pointers are the only multi-bit values sampled across clock domains.
    // ASYNC_REG keeps the two-stage synchronizers visible to FPGA tools.
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [ADDR_WIDTH:0] rd_ptr_gray_wrclk_ff1;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [ADDR_WIDTH:0] rd_ptr_gray_wrclk_ff2;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [ADDR_WIDTH:0] wr_ptr_gray_rdclk_ff1;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [ADDR_WIDTH:0] wr_ptr_gray_rdclk_ff2;

    logic [ADDR_WIDTH:0] rd_ptr_bin_wrclk;
    logic [ADDR_WIDTH:0] wr_ptr_bin_rdclk;

    logic wr_fire;
    logic rd_fire;

    function automatic logic [ADDR_WIDTH:0] bin_to_gray(
        input logic [ADDR_WIDTH:0] bin_value
    );
        bin_to_gray = (bin_value >> 1) ^ bin_value;
    endfunction

    function automatic logic [ADDR_WIDTH:0] gray_to_bin(
        input logic [ADDR_WIDTH:0] gray_value
    );
        int i;
        begin
            gray_to_bin[ADDR_WIDTH] = gray_value[ADDR_WIDTH];
            for (i = ADDR_WIDTH - 1; i >= 0; i = i - 1) begin
                gray_to_bin[i] = gray_to_bin[i + 1] ^ gray_value[i];
            end
        end
    endfunction

    function automatic logic [ADDR_WIDTH:0] full_gray_compare_value(
        input logic [ADDR_WIDTH:0] gray_value
    );
        begin
            full_gray_compare_value                 = gray_value;
            full_gray_compare_value[ADDR_WIDTH]     = ~gray_value[ADDR_WIDTH];
            full_gray_compare_value[ADDR_WIDTH - 1] = ~gray_value[ADDR_WIDTH - 1];
        end
    endfunction

    assign wr_fire = wr_valid && wr_ready;
    assign rd_fire = rd_valid && rd_ready;

    assign full = (wr_ptr_gray == full_gray_compare_value(rd_ptr_gray_wrclk_ff2));
    assign empty = (rd_ptr_gray == wr_ptr_gray_rdclk_ff2);

    assign wr_ready = !full;
    assign rd_valid = !empty;

    assign rd_data = mem[rd_ptr_bin[ADDR_WIDTH-1:0]];

    assign rd_ptr_bin_wrclk = gray_to_bin(rd_ptr_gray_wrclk_ff2);
    assign wr_ptr_bin_rdclk = gray_to_bin(wr_ptr_gray_rdclk_ff2);
    assign wr_level = wr_ptr_bin - rd_ptr_bin_wrclk;
    assign rd_level = wr_ptr_bin_rdclk - rd_ptr_bin;

    always_ff @(posedge clk_wr) begin
        if (!rst_n || clear_wr_i) begin
            wr_ptr_bin            <= '0;
            wr_ptr_gray           <= '0;
            rd_ptr_gray_wrclk_ff1 <= '0;
            rd_ptr_gray_wrclk_ff2 <= '0;
        end else begin
            rd_ptr_gray_wrclk_ff1 <= rd_ptr_gray;
            rd_ptr_gray_wrclk_ff2 <= rd_ptr_gray_wrclk_ff1;

            if (wr_fire) begin
                mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
                wr_ptr_bin  <= wr_ptr_bin + {{ADDR_WIDTH{1'b0}}, 1'b1};
                wr_ptr_gray <= bin_to_gray(wr_ptr_bin + {{ADDR_WIDTH{1'b0}}, 1'b1});
            end
        end
    end

    always_ff @(posedge clk_rd) begin
        if (!rst_n || clear_rd_i) begin
            rd_ptr_bin            <= '0;
            rd_ptr_gray           <= '0;
            wr_ptr_gray_rdclk_ff1 <= '0;
            wr_ptr_gray_rdclk_ff2 <= '0;
        end else begin
            wr_ptr_gray_rdclk_ff1 <= wr_ptr_gray;
            wr_ptr_gray_rdclk_ff2 <= wr_ptr_gray_rdclk_ff1;

            if (rd_fire) begin
                rd_ptr_bin  <= rd_ptr_bin + {{ADDR_WIDTH{1'b0}}, 1'b1};
                rd_ptr_gray <= bin_to_gray(rd_ptr_bin + {{ADDR_WIDTH{1'b0}}, 1'b1});
            end
        end
    end

endmodule
