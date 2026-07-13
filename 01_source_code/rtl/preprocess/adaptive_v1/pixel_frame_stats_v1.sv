`timescale 1ns/1ps

// adaptive_v1 iteration:
// Frame-based pixel statistics observer for the unified pixel debug stream.
// The module is synthesizable and computes previous-frame statistics used by
// later adaptive preprocess stages. It never backpressures the pixel stream.
//
// Timing-closure note: the mean computation (sum / pixel_cnt, three 48/32-bit
// divides) was originally combinational at frame end — the design's worst
// timing path (~280 logic levels). Means are frame-rate data, so this version
// snapshots the accumulators at frame_end and runs three parallel restoring
// dividers (1 bit/cycle, 48 cycles); stats_valid_o asserts when the full
// coherent stat set (means + min/max/counts of the SAME frame) is ready.
// Accumulation of the next frame continues in parallel with the division.
module pixel_frame_stats_v1 (
    input  logic        clk_sys,
    input  logic        rst_n,

    input  logic        enable_i,
    input  logic        clear_i,
    input  logic [2:0]  pixel_format_i,
    input  logic        frame_end_i,

    input  logic        pixel_valid_i,
    input  logic        pixel_ready_i,
    input  logic [23:0] pixel_data_i,
    input  logic        pixel_sof_i,

    output logic        stats_valid_o,
    output logic [31:0] pixel_cnt_o,
    output logic [15:0] mean_r_o,
    output logic [15:0] mean_g_o,
    output logic [15:0] mean_b_o,
    output logic [7:0]  luma_min_o,
    output logic [7:0]  luma_max_o,
    output logic [31:0] dark_cnt_o,
    output logic [31:0] bright_cnt_o
);

    localparam logic [2:0] PIXFMT_RAW8   = 3'd0;
    localparam logic [2:0] PIXFMT_RAW10  = 3'd1;
    localparam logic [2:0] PIXFMT_RGB888 = 3'd2;
    localparam logic [2:0] PIXFMT_YUV422 = 3'd3;

    localparam logic [7:0] DARK_TH   = 8'd16;
    localparam logic [7:0] BRIGHT_TH = 8'd240;

    logic        pixel_fire;
    logic        frame_active;
    logic [7:0]  sample_r;
    logic [7:0]  sample_g;
    logic [7:0]  sample_b;
    logic [7:0]  sample_luma;
    logic [31:0] pixel_cnt_acc;
    logic [47:0] sum_r_acc;
    logic [47:0] sum_g_acc;
    logic [47:0] sum_b_acc;
    logic [7:0]  luma_min_acc;
    logic [7:0]  luma_max_acc;
    logic [31:0] dark_cnt_acc;
    logic [31:0] bright_cnt_acc;

    // Snapshot + three parallel restoring dividers (mean = sum / pixel_cnt).
    localparam int DIVN_W = 48;
    logic        div_busy_q;
    logic [5:0]  div_cnt_q;
    logic [31:0] div_den_q;
    logic [DIVN_W-1:0] num_r_q, num_g_q, num_b_q;
    logic [32:0]       rem_r_q, rem_g_q, rem_b_q;
    logic [DIVN_W-1:0] quo_r_q, quo_g_q, quo_b_q;
    logic [31:0] cnt_pend_q, dark_pend_q, bright_pend_q;
    logic [7:0]  min_pend_q, max_pend_q;

    logic [32:0] rsh_r, rsh_g, rsh_b;
    logic        ge_r, ge_g, ge_b;
    assign rsh_r = {rem_r_q[31:0], num_r_q[DIVN_W-1]};
    assign rsh_g = {rem_g_q[31:0], num_g_q[DIVN_W-1]};
    assign rsh_b = {rem_b_q[31:0], num_b_q[DIVN_W-1]};
    assign ge_r  = (rsh_r >= {1'b0, div_den_q});
    assign ge_g  = (rsh_g >= {1'b0, div_den_q});
    assign ge_b  = (rsh_b >= {1'b0, div_den_q});

    function automatic logic [7:0] avg3_u8(
        input logic [7:0] a,
        input logic [7:0] b,
        input logic [7:0] c
    );
        logic [9:0] sum;
        begin
            sum = {2'b00, a} + {2'b00, b} + {2'b00, c};
            avg3_u8 = sum / 3;
        end
    endfunction

    always @* begin
        sample_r    = 8'd0;
        sample_g    = 8'd0;
        sample_b    = 8'd0;
        sample_luma = 8'd0;

        case (pixel_format_i)
            PIXFMT_RAW8: begin
                sample_r    = pixel_data_i[7:0];
                sample_g    = pixel_data_i[7:0];
                sample_b    = pixel_data_i[7:0];
                sample_luma = pixel_data_i[7:0];
            end

            PIXFMT_RAW10: begin
                sample_r    = pixel_data_i[9:2];
                sample_g    = pixel_data_i[9:2];
                sample_b    = pixel_data_i[9:2];
                sample_luma = pixel_data_i[9:2];
            end

            PIXFMT_RGB888: begin
                sample_r    = pixel_data_i[23:16];
                sample_g    = pixel_data_i[15:8];
                sample_b    = pixel_data_i[7:0];
                sample_luma = avg3_u8(pixel_data_i[23:16], pixel_data_i[15:8], pixel_data_i[7:0]);
            end

            PIXFMT_YUV422: begin
                sample_r    = pixel_data_i[23:16];
                sample_g    = pixel_data_i[23:16];
                sample_b    = pixel_data_i[23:16];
                sample_luma = pixel_data_i[23:16];
            end

            default: begin
                sample_r    = pixel_data_i[7:0];
                sample_g    = pixel_data_i[7:0];
                sample_b    = pixel_data_i[7:0];
                sample_luma = pixel_data_i[7:0];
            end
        endcase
    end

    assign pixel_fire = enable_i && pixel_valid_i && pixel_ready_i;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            frame_active   <= 1'b0;
            stats_valid_o  <= 1'b0;
            pixel_cnt_acc  <= 32'd0;
            sum_r_acc      <= 48'd0;
            sum_g_acc      <= 48'd0;
            sum_b_acc      <= 48'd0;
            luma_min_acc   <= 8'hff;
            luma_max_acc   <= 8'h00;
            dark_cnt_acc   <= 32'd0;
            bright_cnt_acc <= 32'd0;
            pixel_cnt_o    <= 32'd0;
            mean_r_o       <= 16'd0;
            mean_g_o       <= 16'd0;
            mean_b_o       <= 16'd0;
            luma_min_o     <= 8'd0;
            luma_max_o     <= 8'd0;
            dark_cnt_o     <= 32'd0;
            bright_cnt_o   <= 32'd0;
            div_busy_q     <= 1'b0;
            div_cnt_q      <= 6'd0;
            div_den_q      <= 32'd0;
            num_r_q        <= '0;
            num_g_q        <= '0;
            num_b_q        <= '0;
            rem_r_q        <= '0;
            rem_g_q        <= '0;
            rem_b_q        <= '0;
            quo_r_q        <= '0;
            quo_g_q        <= '0;
            quo_b_q        <= '0;
            cnt_pend_q     <= 32'd0;
            min_pend_q     <= 8'd0;
            max_pend_q     <= 8'd0;
            dark_pend_q    <= 32'd0;
            bright_pend_q  <= 32'd0;
        end else begin
            stats_valid_o <= 1'b0;

            // Divider engine: one restoring-division bit per cycle, three
            // channels in lockstep. Runs independently of accumulation.
            if (div_busy_q) begin
                if (div_cnt_q != 6'd0) begin
                    rem_r_q <= ge_r ? (rsh_r - {1'b0, div_den_q}) : rsh_r;
                    rem_g_q <= ge_g ? (rsh_g - {1'b0, div_den_q}) : rsh_g;
                    rem_b_q <= ge_b ? (rsh_b - {1'b0, div_den_q}) : rsh_b;
                    quo_r_q <= {quo_r_q[DIVN_W-2:0], ge_r};
                    quo_g_q <= {quo_g_q[DIVN_W-2:0], ge_g};
                    quo_b_q <= {quo_b_q[DIVN_W-2:0], ge_b};
                    num_r_q <= {num_r_q[DIVN_W-2:0], 1'b0};
                    num_g_q <= {num_g_q[DIVN_W-2:0], 1'b0};
                    num_b_q <= {num_b_q[DIVN_W-2:0], 1'b0};
                    div_cnt_q <= div_cnt_q - 6'd1;
                end else begin
                    // Coherent publish: means + companion stats of one frame.
                    div_busy_q    <= 1'b0;
                    stats_valid_o <= 1'b1;
                    mean_r_o      <= quo_r_q[15:0];
                    mean_g_o      <= quo_g_q[15:0];
                    mean_b_o      <= quo_b_q[15:0];
                    pixel_cnt_o   <= cnt_pend_q;
                    luma_min_o    <= min_pend_q;
                    luma_max_o    <= max_pend_q;
                    dark_cnt_o    <= dark_pend_q;
                    bright_cnt_o  <= bright_pend_q;
                end
            end

            if (clear_i || !enable_i) begin
                frame_active   <= 1'b0;
                div_busy_q     <= 1'b0;
                pixel_cnt_acc  <= 32'd0;
                sum_r_acc      <= 48'd0;
                sum_g_acc      <= 48'd0;
                sum_b_acc      <= 48'd0;
                luma_min_acc   <= 8'hff;
                luma_max_acc   <= 8'h00;
                dark_cnt_acc   <= 32'd0;
                bright_cnt_acc <= 32'd0;
                if (clear_i) begin
                    pixel_cnt_o  <= 32'd0;
                    mean_r_o     <= 16'd0;
                    mean_g_o     <= 16'd0;
                    mean_b_o     <= 16'd0;
                    luma_min_o   <= 8'd0;
                    luma_max_o   <= 8'd0;
                    dark_cnt_o   <= 32'd0;
                    bright_cnt_o <= 32'd0;
                end
            end else begin
                if (pixel_fire) begin
                    if (pixel_sof_i || !frame_active) begin
                        frame_active   <= 1'b1;
                        pixel_cnt_acc  <= 32'd1;
                        sum_r_acc      <= {40'd0, sample_r};
                        sum_g_acc      <= {40'd0, sample_g};
                        sum_b_acc      <= {40'd0, sample_b};
                        luma_min_acc   <= sample_luma;
                        luma_max_acc   <= sample_luma;
                        dark_cnt_acc   <= (sample_luma <= DARK_TH)   ? 32'd1 : 32'd0;
                        bright_cnt_acc <= (sample_luma >= BRIGHT_TH) ? 32'd1 : 32'd0;
                    end else begin
                        pixel_cnt_acc  <= pixel_cnt_acc + 32'd1;
                        sum_r_acc      <= sum_r_acc + {40'd0, sample_r};
                        sum_g_acc      <= sum_g_acc + {40'd0, sample_g};
                        sum_b_acc      <= sum_b_acc + {40'd0, sample_b};
                        if (sample_luma < luma_min_acc) begin
                            luma_min_acc <= sample_luma;
                        end
                        if (sample_luma > luma_max_acc) begin
                            luma_max_acc <= sample_luma;
                        end
                        if (sample_luma <= DARK_TH) begin
                            dark_cnt_acc <= dark_cnt_acc + 32'd1;
                        end
                        if (sample_luma >= BRIGHT_TH) begin
                            bright_cnt_acc <= bright_cnt_acc + 32'd1;
                        end
                    end
                end

                if (frame_end_i && frame_active && (pixel_cnt_acc != 32'd0)) begin
                    // Snapshot the frame and launch the dividers (latest frame
                    // wins if a previous division is still in flight).
                    div_busy_q    <= 1'b1;
                    div_cnt_q     <= DIVN_W[5:0];
                    div_den_q     <= pixel_cnt_acc;
                    num_r_q       <= sum_r_acc;
                    num_g_q       <= sum_g_acc;
                    num_b_q       <= sum_b_acc;
                    rem_r_q       <= '0;
                    rem_g_q       <= '0;
                    rem_b_q       <= '0;
                    quo_r_q       <= '0;
                    quo_g_q       <= '0;
                    quo_b_q       <= '0;
                    cnt_pend_q    <= pixel_cnt_acc;
                    min_pend_q    <= luma_min_acc;
                    max_pend_q    <= luma_max_acc;
                    dark_pend_q   <= dark_cnt_acc;
                    bright_pend_q <= bright_cnt_acc;

                    frame_active   <= 1'b0;
                    pixel_cnt_acc  <= 32'd0;
                    sum_r_acc      <= 48'd0;
                    sum_g_acc      <= 48'd0;
                    sum_b_acc      <= 48'd0;
                    luma_min_acc   <= 8'hff;
                    luma_max_acc   <= 8'h00;
                    dark_cnt_acc   <= 32'd0;
                    bright_cnt_acc <= 32'd0;
                end
            end
        end
    end

endmodule
