`timescale 1ns/1ps

// DDR-like AXI write slave model: same write/readback memory semantics as
// axi_write_null_slave, plus configurable DDR-controller-like behavior:
//   * AW_DELAY_CYCLES  - address-acceptance latency (bank open / cmd queue)
//   * B_DELAY_CYCLES   - write-response latency after the last beat (commit)
//   * W_STALL_LFSR     - pseudo-random per-beat wready stalls (refresh /
//                        scheduling backpressure); stall when lfsr[1:0]==0,
//                        i.e. ~25% of beats. Deterministic via seed for
//                        reproducible regression.
// Counters expose how much backpressure was actually exercised so a testbench
// can assert the stress was real, not accidentally configured away.
module axi_ddr_latency_model #(
    parameter int ADDR_WIDTH      = 32,
    parameter int DATA_WIDTH      = 128,
    parameter int MEM_ADDR_WIDTH  = 12,
    parameter int AW_DELAY_CYCLES = 8,
    parameter int B_DELAY_CYCLES  = 12,
    // Fixed per-beat acceptance delay (guarantees W-channel stress even for
    // short bursts) on top of the pseudo-random LFSR stalls.
    parameter int W_FIXED_STALL_CYCLES = 2,
    parameter logic [15:0] W_STALL_LFSR_SEED = 16'hACE1
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
    input  logic                      s_axi_bready_i,

    output logic [31:0]               aw_stall_cycles_o,
    output logic [31:0]               w_stall_cycles_o,
    output logic [31:0]               b_delay_cycles_o
);

    localparam int BYTES_PER_BEAT = DATA_WIDTH / 8;
    localparam int MEM_WORDS      = (1 << MEM_ADDR_WIDTH);

    logic [31:0] mem [0:MEM_WORDS-1];

    typedef enum logic [1:0] {ST_AW_DELAY, ST_AW_READY, ST_DATA, ST_B_DELAY} st_t;
    st_t state;

    logic [15:0] lfsr_q;
    logic [7:0]  aw_delay_cnt_q;
    logic [7:0]  w_stall_cnt_q;
    logic [7:0]  b_delay_cnt_q;
    logic [7:0]  beats_remaining_q;
    logic [ADDR_WIDTH-1:0] burst_addr_q;
    logic [2:0]  burst_size_q;
    logic [1:0]  burst_type_q;
    logic        mem_overflow_q;
    logic        w_stall_now;

    // Beat stall = fixed per-beat delay OR pseudo-random LFSR stall.
    assign w_stall_now     = (w_stall_cnt_q != 8'd0) || (lfsr_q[1:0] == 2'b00);
    assign s_axi_awready_o = rst_n && (state == ST_AW_READY);
    assign s_axi_wready_o  = rst_n && (state == ST_DATA) && !w_stall_now;
    assign s_axi_bresp_o   = mem_overflow_q ? 2'b10 : 2'b00;
    assign s_axi_bvalid_o  = rst_n && (state == ST_B_DELAY) && (b_delay_cnt_q == 8'd0);

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
        input logic [ADDR_WIDTH-1:0]     beat_addr,
        input logic [DATA_WIDTH-1:0]     beat_data,
        input logic [(DATA_WIDTH/8)-1:0] beat_strb
    );
        int byte_idx;
        begin
            for (byte_idx = 0; byte_idx < BYTES_PER_BEAT; byte_idx = byte_idx + 1) begin
                if (beat_strb[byte_idx]) begin
                    write_byte_to_mem(beat_addr + byte_idx[ADDR_WIDTH-1:0],
                                      beat_data[(byte_idx * 8) +: 8]);
                end
            end
        end
    endtask

    integer mem_idx;

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            state             <= ST_AW_DELAY;
            lfsr_q            <= W_STALL_LFSR_SEED;
            aw_delay_cnt_q    <= AW_DELAY_CYCLES[7:0];
            w_stall_cnt_q     <= W_FIXED_STALL_CYCLES[7:0];
            b_delay_cnt_q     <= B_DELAY_CYCLES[7:0];
            beats_remaining_q <= 8'd0;
            burst_addr_q      <= '0;
            burst_size_q      <= '0;
            burst_type_q      <= '0;
            mem_overflow_q    <= 1'b0;
            aw_stall_cycles_o <= 32'd0;
            w_stall_cycles_o  <= 32'd0;
            b_delay_cycles_o  <= 32'd0;
            for (mem_idx = 0; mem_idx < MEM_WORDS; mem_idx = mem_idx + 1) begin
                mem[mem_idx] <= 32'd0;
            end
        end else begin
            // Galois LFSR x^16+x^14+x^13+x^11+1, advance every cycle.
            lfsr_q <= {lfsr_q[14:0], lfsr_q[15] ^ lfsr_q[13] ^ lfsr_q[12] ^ lfsr_q[10]};

            case (state)
                ST_AW_DELAY: begin
                    // Master is waiting: count the imposed address latency.
                    if (s_axi_awvalid_i) begin
                        aw_stall_cycles_o <= aw_stall_cycles_o + 32'd1;
                        if (aw_delay_cnt_q == 8'd0) begin
                            state <= ST_AW_READY;
                        end else begin
                            aw_delay_cnt_q <= aw_delay_cnt_q - 8'd1;
                        end
                    end
                end

                ST_AW_READY: begin
                    if (s_axi_awvalid_i) begin
                        beats_remaining_q <= s_axi_awlen_i + 8'd1;
                        burst_addr_q      <= s_axi_awaddr_i;
                        burst_size_q      <= s_axi_awsize_i;
                        burst_type_q      <= s_axi_awburst_i;
                        mem_overflow_q    <= 1'b0;
                        state             <= ST_DATA;
                    end
                end

                ST_DATA: begin
                    if (s_axi_wvalid_i && w_stall_now) begin
                        w_stall_cycles_o <= w_stall_cycles_o + 32'd1;
                        if (w_stall_cnt_q != 8'd0) begin
                            w_stall_cnt_q <= w_stall_cnt_q - 8'd1;
                        end
                    end
                    if (s_axi_wvalid_i && s_axi_wready_o) begin
                        w_stall_cnt_q <= W_FIXED_STALL_CYCLES[7:0];
                        write_beat_to_mem(burst_addr_q, s_axi_wdata_i, s_axi_wstrb_i);
                        if ((burst_type_q == 2'b01) || (burst_type_q == 2'b10)) begin
                            burst_addr_q <= burst_addr_q +
                                ({{(ADDR_WIDTH-4){1'b0}}, 4'd1} << burst_size_q);
                        end
                        if (s_axi_wlast_i || (beats_remaining_q == 8'd1)) begin
                            b_delay_cnt_q <= B_DELAY_CYCLES[7:0];
                            state         <= ST_B_DELAY;
                        end else begin
                            beats_remaining_q <= beats_remaining_q - 8'd1;
                        end
                    end
                end

                ST_B_DELAY: begin
                    if (b_delay_cnt_q != 8'd0) begin
                        b_delay_cnt_q    <= b_delay_cnt_q - 8'd1;
                        b_delay_cycles_o <= b_delay_cycles_o + 32'd1;
                    end else if (s_axi_bready_i) begin
                        aw_delay_cnt_q <= AW_DELAY_CYCLES[7:0];
                        state          <= ST_AW_DELAY;
                    end
                end

                default: state <= ST_AW_DELAY;
            endcase
        end
    end

endmodule
