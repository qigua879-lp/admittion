`timescale 1ns/1ps

// Internal AXI write sink used by the FPGA wrapper. It accepts single-channel
// write traffic from the capture core and returns an OKAY response without
// exposing the AXI bus as package pins.
module axi_write_null_slave #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32,
    parameter int MEM_ADDR_WIDTH = 18
) (
    input  logic                      clk_axi,
    input  logic                      rst_n,

    input  logic [ADDR_WIDTH-1:0]     s_axi_awaddr_i,
    input  logic [7:0]                s_axi_awlen_i,
    input  logic [2:0]                s_axi_awsize_i,
    input  logic [1:0]                s_axi_awburst_i,
    input  logic                      s_axi_awvalid_i,
    output logic                      s_axi_awready_o,

    input  logic [DATA_WIDTH-1:0]     s_axi_wdata_i,
    input  logic [(DATA_WIDTH/8)-1:0] s_axi_wstrb_i,
    input  logic                      s_axi_wlast_i,
    input  logic                      s_axi_wvalid_i,
    output logic                      s_axi_wready_o,

    output logic [1:0]                s_axi_bresp_o,
    output logic                      s_axi_bvalid_o,
    input  logic                      s_axi_bready_i
);

    logic aw_seen_q;
    logic [7:0] beats_remaining_q;
    logic [ADDR_WIDTH-1:0] burst_addr_q;
    logic [2:0]            burst_size_q;
    logic [1:0]            burst_type_q;
    logic                  mem_overflow_q;

    logic aw_fire;
    logic w_fire;
    logic b_fire;

    localparam int BYTES_PER_BEAT = DATA_WIDTH / 8;
    localparam int MEM_WORDS      = (1 << MEM_ADDR_WIDTH);

    logic [31:0] mem [0:MEM_WORDS-1];

    assign aw_fire = s_axi_awvalid_i && s_axi_awready_o;
    assign w_fire  = s_axi_wvalid_i  && s_axi_wready_o;
    assign b_fire  = s_axi_bvalid_o  && s_axi_bready_i;

    assign s_axi_awready_o = rst_n && !aw_seen_q;
    assign s_axi_wready_o  = rst_n && aw_seen_q && !s_axi_bvalid_o;
    assign s_axi_bresp_o   = mem_overflow_q ? 2'b10 : 2'b00;

    task automatic write_byte_to_mem(
        input logic [ADDR_WIDTH-1:0] byte_addr,
        input logic [7:0]            byte_val
    );
        int word_idx;
        int byte_sel;
        begin
            word_idx = byte_addr[ADDR_WIDTH-1:2];
            byte_sel = byte_addr[1:0];

            if ((word_idx >= 0) && (word_idx < MEM_WORDS)) begin
                case (byte_sel)
                    0: mem[word_idx][7:0]   <= byte_val;
                    1: mem[word_idx][15:8]  <= byte_val;
                    2: mem[word_idx][23:16] <= byte_val;
                    default: mem[word_idx][31:24] <= byte_val;
                endcase
            end else begin
                mem_overflow_q <= 1'b1;
            end
        end
    endtask

    task automatic write_beat_to_mem(
        input logic [ADDR_WIDTH-1:0]         beat_addr,
        input logic [DATA_WIDTH-1:0]         beat_data,
        input logic [(DATA_WIDTH/8)-1:0]     beat_strb
    );
        int byte_idx;
        logic [ADDR_WIDTH-1:0] byte_addr;
        logic [7:0]            byte_val;
        begin
            for (byte_idx = 0; byte_idx < BYTES_PER_BEAT; byte_idx = byte_idx + 1) begin
                if (beat_strb[byte_idx]) begin
                    byte_addr = beat_addr + byte_idx[ADDR_WIDTH-1:0];
                    byte_val  = beat_data[(byte_idx * 8) +: 8];
                    write_byte_to_mem(byte_addr, byte_val);
                end
            end
        end
    endtask

    integer mem_idx;

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            aw_seen_q          <= 1'b0;
            beats_remaining_q  <= 8'd0;
            burst_addr_q       <= '0;
            burst_size_q       <= '0;
            burst_type_q       <= '0;
            mem_overflow_q     <= 1'b0;
            s_axi_bvalid_o     <= 1'b0;
            for (mem_idx = 0; mem_idx < MEM_WORDS; mem_idx = mem_idx + 1) begin
                mem[mem_idx] <= 32'd0;
            end
        end else begin
            if (aw_fire) begin
                aw_seen_q         <= 1'b1;
                beats_remaining_q <= s_axi_awlen_i + 8'd1;
                burst_addr_q      <= s_axi_awaddr_i;
                burst_size_q      <= s_axi_awsize_i;
                burst_type_q      <= s_axi_awburst_i;
                mem_overflow_q    <= 1'b0;
            end

            if (w_fire) begin
                write_beat_to_mem(burst_addr_q, s_axi_wdata_i, s_axi_wstrb_i);

                if (beats_remaining_q > 8'd0) begin
                    beats_remaining_q <= beats_remaining_q - 8'd1;
                end

                if (s_axi_wlast_i || (beats_remaining_q == 8'd1)) begin
                    aw_seen_q      <= 1'b0;
                    s_axi_bvalid_o <= 1'b1;
                end

                if ((burst_type_q == 2'b01) || (burst_type_q == 2'b10)) begin
                    burst_addr_q <= burst_addr_q + ({{(ADDR_WIDTH-4){1'b0}}, 4'd1} << burst_size_q);
                end
            end

            if (b_fire) begin
                s_axi_bvalid_o <= 1'b0;
            end
        end
    end

endmodule
