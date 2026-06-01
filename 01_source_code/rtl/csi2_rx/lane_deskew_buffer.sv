`timescale 1ns/1ps

module lane_deskew_buffer #(
    parameter int LANE_NUM     = 4,
    parameter int DESKEW_DEPTH = 4
) (
    input  logic                         clk_byte,
    input  logic                         rst_n,
    input  logic                         clear_i,

    input  logic [LANE_NUM-1:0]          lane_valid_i,
    output logic [LANE_NUM-1:0]          lane_ready_o,
    input  logic [LANE_NUM-1:0][7:0]     lane_data_i,

    output logic                         deskew_valid_o,
    input  logic                         deskew_ready_i,
    output logic [LANE_NUM-1:0][7:0]     deskew_data_o,
    output logic                         err_overflow_o
);

    localparam int PTR_WIDTH = (DESKEW_DEPTH <= 2) ? 1 : $clog2(DESKEW_DEPTH);
    localparam int CNT_WIDTH = (DESKEW_DEPTH <= 1) ? 1 : $clog2(DESKEW_DEPTH + 1);
    localparam logic [PTR_WIDTH-1:0] LAST_PTR  = DESKEW_DEPTH - 1;
    localparam logic [CNT_WIDTH-1:0] DEPTH_CNT = DESKEW_DEPTH;

    logic [7:0]               fifo_mem [0:LANE_NUM-1][0:DESKEW_DEPTH-1];
    logic [PTR_WIDTH-1:0]     wr_ptr   [0:LANE_NUM-1];
    logic [PTR_WIDTH-1:0]     rd_ptr   [0:LANE_NUM-1];
    logic [CNT_WIDTH-1:0]     lane_cnt [0:LANE_NUM-1];

    logic                     all_lane_nonempty;
    logic                     deskew_fire;

    genvar g_lane;
    generate
        for (g_lane = 0; g_lane < LANE_NUM; g_lane = g_lane + 1) begin : gen_lane_status
            assign lane_ready_o[g_lane]  = (lane_cnt[g_lane] < DEPTH_CNT);
            assign deskew_data_o[g_lane] = fifo_mem[g_lane][rd_ptr[g_lane]];
        end
    endgenerate

    integer comb_idx;
    integer seq_idx;

    always_comb begin
        all_lane_nonempty = 1'b1;
        for (comb_idx = 0; comb_idx < LANE_NUM; comb_idx = comb_idx + 1) begin
            if (lane_cnt[comb_idx] == {CNT_WIDTH{1'b0}}) begin
                all_lane_nonempty = 1'b0;
            end
        end
    end

    assign deskew_valid_o = all_lane_nonempty;
    assign deskew_fire    = deskew_valid_o && deskew_ready_i;

    always_ff @(posedge clk_byte) begin
        if (!rst_n) begin
            err_overflow_o <= 1'b0;
            for (seq_idx = 0; seq_idx < LANE_NUM; seq_idx = seq_idx + 1) begin
                wr_ptr[seq_idx]   <= '0;
                rd_ptr[seq_idx]   <= '0;
                lane_cnt[seq_idx] <= '0;
            end
        end else if (clear_i) begin
            err_overflow_o <= 1'b0;
            for (seq_idx = 0; seq_idx < LANE_NUM; seq_idx = seq_idx + 1) begin
                wr_ptr[seq_idx]   <= '0;
                rd_ptr[seq_idx]   <= '0;
                lane_cnt[seq_idx] <= '0;
            end
        end else begin
            err_overflow_o <= 1'b0;

            for (seq_idx = 0; seq_idx < LANE_NUM; seq_idx = seq_idx + 1) begin
                if (lane_valid_i[seq_idx] && !lane_ready_o[seq_idx]) begin
                    err_overflow_o <= 1'b1;
                end

                if (lane_valid_i[seq_idx] && lane_ready_o[seq_idx]) begin
                    fifo_mem[seq_idx][wr_ptr[seq_idx]] <= lane_data_i[seq_idx];
                    if (wr_ptr[seq_idx] == LAST_PTR) begin
                        wr_ptr[seq_idx] <= '0;
                    end else begin
                        wr_ptr[seq_idx] <= wr_ptr[seq_idx] + 1'b1;
                    end
                end

                if (deskew_fire) begin
                    if (rd_ptr[seq_idx] == LAST_PTR) begin
                        rd_ptr[seq_idx] <= '0;
                    end else begin
                        rd_ptr[seq_idx] <= rd_ptr[seq_idx] + 1'b1;
                    end
                end

                case ({lane_valid_i[seq_idx] && lane_ready_o[seq_idx], deskew_fire})
                    2'b10: lane_cnt[seq_idx] <= lane_cnt[seq_idx] + 1'b1;
                    2'b01: lane_cnt[seq_idx] <= lane_cnt[seq_idx] - 1'b1;
                    default: lane_cnt[seq_idx] <= lane_cnt[seq_idx];
                endcase
            end
        end
    end

endmodule
