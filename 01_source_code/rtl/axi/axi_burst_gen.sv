`timescale 1ns/1ps

module axi_burst_gen #(
    parameter int ADDR_WIDTH    = 32,
    parameter int DATA_WIDTH    = 32,
    parameter int MAX_BURST_LEN = 16
) (
    input  logic                  clk_axi,
    input  logic                  rst_n,

    input  logic                  req_valid_i,
    output logic                  req_ready_o,
    input  logic [ADDR_WIDTH-1:0] req_addr_i,
    input  logic [15:0]           req_beat_cnt_i,
    input  logic [8:0]            cfg_max_burst_len_i,

    output logic                  burst_valid_o,
    input  logic                  burst_ready_i,
    output logic [ADDR_WIDTH-1:0] burst_addr_o,
    output logic [7:0]            burst_len_o,
    output logic [8:0]            burst_beat_cnt_o,
    output logic                  burst_last_o,
    output logic                  busy_o
);

    localparam int DATA_BYTES = DATA_WIDTH / 8;
    localparam logic [8:0] DEFAULT_MAX_BURST = MAX_BURST_LEN;

    logic [15:0] remaining_beat_cnt;
    logic [ADDR_WIDTH-1:0] next_addr;
    logic [8:0] max_burst_eff;
    logic [8:0] req_burst_beats;
    logic [8:0] rem_burst_beats;

    function automatic logic [8:0] calc_burst_beats(
        input logic [15:0] remaining,
        input logic [8:0]  max_burst
    );
        begin
            if (remaining == 16'd0) begin
                calc_burst_beats = 9'd0;
            end else if (remaining > {7'd0, max_burst}) begin
                calc_burst_beats = max_burst;
            end else begin
                calc_burst_beats = remaining[8:0];
            end
        end
    endfunction

    assign req_ready_o = !busy_o;
    assign busy_o      = burst_valid_o || (remaining_beat_cnt != 16'd0);
    assign req_burst_beats = calc_burst_beats(req_beat_cnt_i, max_burst_eff);
    assign rem_burst_beats = calc_burst_beats(remaining_beat_cnt, max_burst_eff);

    always_comb begin
        if (cfg_max_burst_len_i == 9'd0) begin
            max_burst_eff = DEFAULT_MAX_BURST;
        end else if (cfg_max_burst_len_i > DEFAULT_MAX_BURST) begin
            max_burst_eff = DEFAULT_MAX_BURST;
        end else begin
            max_burst_eff = cfg_max_burst_len_i;
        end
    end

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            remaining_beat_cnt <= 16'd0;
            next_addr          <= '0;
            burst_valid_o      <= 1'b0;
            burst_addr_o       <= '0;
            burst_len_o        <= 8'd0;
            burst_beat_cnt_o   <= 9'd0;
            burst_last_o       <= 1'b0;
        end else begin
            if (req_valid_i && req_ready_o && (req_beat_cnt_i != 16'd0)) begin
                burst_beat_cnt_o   <= req_burst_beats;
                burst_addr_o       <= req_addr_i;
                burst_len_o        <= req_burst_beats[7:0] - 8'd1;
                burst_last_o       <= (req_beat_cnt_i <= {7'd0, max_burst_eff});
                remaining_beat_cnt <= req_beat_cnt_i - {7'd0, req_burst_beats};
                next_addr          <= req_addr_i + (req_burst_beats * DATA_BYTES);
                burst_valid_o      <= 1'b1;
            end else if (burst_valid_o && burst_ready_i) begin
                if (remaining_beat_cnt == 16'd0) begin
                    burst_valid_o    <= 1'b0;
                    burst_last_o     <= 1'b0;
                    burst_beat_cnt_o <= 9'd0;
                end else begin
                    burst_beat_cnt_o   <= rem_burst_beats;
                    burst_addr_o       <= next_addr;
                    burst_len_o        <= rem_burst_beats[7:0] - 8'd1;
                    burst_last_o       <= (remaining_beat_cnt <= {7'd0, max_burst_eff});
                    remaining_beat_cnt <= remaining_beat_cnt - {7'd0, rem_burst_beats};
                    next_addr          <= next_addr + (rem_burst_beats * DATA_BYTES);
                end
            end
        end
    end

endmodule
