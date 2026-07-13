`timescale 1ns/1ps

// adaptive_v1 iteration:
// Frame-to-frame adaptive coefficient generator. Statistics captured from frame
// N are translated into coefficients used by frame N+1.
//
// Timing-closure note: the original single-cycle implementation computed four
// 24/16-bit divisions plus a multiply combinationally (~70 logic levels, the
// design's critical path). Since coefficients are consumed a whole frame later,
// this version computes them over multiple cycles with one shared iterative
// (restoring, 1 bit/cycle) divider: worst case ~150 clk_sys cycles per frame,
// which is negligible against any real frame interval. Outputs update
// atomically with coeff_valid_o; until then the previous coefficients hold.
module adaptive_preprocess_ctrl_v1 (
    input  logic               clk_sys,
    input  logic               rst_n,

    input  logic               enable_i,
    input  logic               awb_enable_i,
    input  logic               stretch_enable_i,
    input  logic               clear_i,

    input  logic               stats_valid_i,
    input  logic [31:0]        pixel_cnt_i,
    input  logic [15:0]        mean_r_i,
    input  logic [15:0]        mean_g_i,
    input  logic [15:0]        mean_b_i,
    input  logic [7:0]         luma_min_i,
    input  logic [7:0]         luma_max_i,

    output logic [7:0]         awb_gain_r_o,
    output logic [7:0]         awb_gain_g_o,
    output logic [7:0]         awb_gain_b_o,
    output logic [7:0]         stretch_gain_o,
    output logic signed [8:0]  stretch_bias_o,
    output logic               coeff_valid_o
);

    localparam logic [7:0] GAIN_IDENTITY = 8'h80;
    localparam logic [7:0] GAIN_MIN_Q17  = 8'h20;
    localparam logic [7:0] GAIN_MAX_Q17  = 8'hff;
    localparam int unsigned STRETCH_MIN_RANGE = 24;

    localparam int DIV_W = 24;   // dividend/quotient width

    typedef enum logic [3:0] {
        ST_IDLE,
        ST_DIV_GRAY,
        ST_DIV_R,
        ST_DIV_G,
        ST_DIV_B,
        ST_DIV_IDEAL,
        ST_DIV_LIMIT,
        ST_CLIP,
        ST_MUL,
        ST_OUT
    } state_t;

    state_t state;

    // Latched stats for the in-flight computation.
    logic [15:0] mean_r_q, mean_g_q, mean_b_q;
    logic [7:0]  luma_min_q;
    logic [8:0]  luma_range_q;
    logic        awb_en_q, st_en_q;

    logic [17:0] mean_sum;
    logic [15:0] gray_q;
    logic [7:0]  gain_r_q, gain_g_q, gain_b_q;
    logic [23:0] ideal_q, limit_q;
    logic [23:0] clipped_q;
    logic [16:0] mul_q;

    // Shared restoring divider: quo = num / den (truncating), 1 bit per cycle.
    logic [DIV_W-1:0] div_num_q;
    logic [15:0]      div_den_q;
    logic [DIV_W-1:0] div_quo_q;
    logic [16:0]      div_rem_q;
    logic [4:0]       div_cnt_q;
    logic             div_busy_q;
    logic             div_done;

    logic [16:0] rem_shift;
    logic        rem_ge;
    assign rem_shift = {div_rem_q[15:0], div_num_q[DIV_W-1]};
    assign rem_ge    = (rem_shift >= {1'b0, div_den_q});
    assign div_done  = div_busy_q && (div_cnt_q == 5'd0);

    function automatic logic [7:0] clamp_gain_q17(input logic [23:0] gain_q17);
        begin
            if (gain_q17 < {16'd0, GAIN_MIN_Q17}) begin
                clamp_gain_q17 = GAIN_MIN_Q17;
            end else if (gain_q17 > {16'd0, GAIN_MAX_Q17}) begin
                clamp_gain_q17 = GAIN_MAX_Q17;
            end else begin
                clamp_gain_q17 = gain_q17[7:0];
            end
        end
    endfunction

    function automatic logic signed [8:0] clamp_bias_s9(input logic signed [16:0] bias_value);
        begin
            if (bias_value > 17'sd255) begin
                clamp_bias_s9 = 9'sd255;
            end else if (bias_value < -17'sd256) begin
                clamp_bias_s9 = -9'sd256;
            end else begin
                clamp_bias_s9 = bias_value[8:0];
            end
        end
    endfunction

    // Start one divide: loads the divider and asserts busy.
    task automatic div_start(input logic [DIV_W-1:0] num, input logic [15:0] den);
        begin
            div_num_q  <= num;
            div_den_q  <= den;
            div_quo_q  <= '0;
            div_rem_q  <= '0;
            div_cnt_q  <= DIV_W[4:0];
            div_busy_q <= 1'b1;
        end
    endtask

    assign mean_sum = {2'd0, mean_r_q} + {2'd0, mean_g_q} + {2'd0, mean_b_q};

    // min(ideal, limit) clamped into [identity .. max], computed as a small
    // combinational select (few logic levels only).
    logic [23:0] clip_sel;
    always_comb begin
        clip_sel = (ideal_q < limit_q) ? ideal_q : limit_q;
        if (clip_sel > {16'd0, GAIN_MAX_Q17}) begin
            clip_sel = {16'd0, GAIN_MAX_Q17};
        end else if (clip_sel < {16'd0, GAIN_IDENTITY}) begin
            clip_sel = {16'd0, GAIN_IDENTITY};
        end
    end

    // -((luma_min * clipped) >> 7) as a 17-bit signed value for the clamp.
    logic signed [16:0] bias_neg;
    assign bias_neg = -$signed({7'd0, mul_q[16:7]});

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            state          <= ST_IDLE;
            awb_gain_r_o   <= GAIN_IDENTITY;
            awb_gain_g_o   <= GAIN_IDENTITY;
            awb_gain_b_o   <= GAIN_IDENTITY;
            stretch_gain_o <= GAIN_IDENTITY;
            stretch_bias_o <= 9'sd0;
            coeff_valid_o  <= 1'b0;
            div_busy_q     <= 1'b0;
            div_num_q      <= '0;
            div_den_q      <= '0;
            div_quo_q      <= '0;
            div_rem_q      <= '0;
            div_cnt_q      <= '0;
            mean_r_q       <= '0;
            mean_g_q       <= '0;
            mean_b_q       <= '0;
            luma_min_q     <= '0;
            luma_range_q   <= '0;
            awb_en_q       <= 1'b0;
            st_en_q        <= 1'b0;
            gray_q         <= '0;
            gain_r_q       <= GAIN_IDENTITY;
            gain_g_q       <= GAIN_IDENTITY;
            gain_b_q       <= GAIN_IDENTITY;
            ideal_q        <= '0;
            limit_q        <= '0;
            clipped_q      <= '0;
            mul_q          <= '0;
        end else begin
            coeff_valid_o <= 1'b0;

            // One divider bit per cycle while busy.
            if (div_busy_q && (div_cnt_q != 5'd0)) begin
                if (rem_ge) begin
                    div_rem_q <= rem_shift - {1'b0, div_den_q};
                end else begin
                    div_rem_q <= rem_shift;
                end
                div_quo_q <= {div_quo_q[DIV_W-2:0], rem_ge};
                div_num_q <= {div_num_q[DIV_W-2:0], 1'b0};
                div_cnt_q <= div_cnt_q - 5'd1;
            end

            if (clear_i || !enable_i) begin
                awb_gain_r_o   <= GAIN_IDENTITY;
                awb_gain_g_o   <= GAIN_IDENTITY;
                awb_gain_b_o   <= GAIN_IDENTITY;
                stretch_gain_o <= GAIN_IDENTITY;
                stretch_bias_o <= 9'sd0;
                state          <= ST_IDLE;
                div_busy_q     <= 1'b0;
            end else begin
                case (state)
                    ST_IDLE: begin
                        if (stats_valid_i && (pixel_cnt_i != 32'd0)) begin
                            mean_r_q     <= mean_r_i;
                            mean_g_q     <= mean_g_i;
                            mean_b_q     <= mean_b_i;
                            luma_min_q   <= luma_min_i;
                            luma_range_q <= {1'b0, luma_max_i} - {1'b0, luma_min_i};
                            awb_en_q     <= awb_enable_i;
                            st_en_q      <= stretch_enable_i;
                            gain_r_q     <= GAIN_IDENTITY;
                            gain_g_q     <= GAIN_IDENTITY;
                            gain_b_q     <= GAIN_IDENTITY;
                            state        <= ST_DIV_GRAY;
                        end
                    end

                    // gray_target = (mean_r+mean_g+mean_b) / 3  (AWB only)
                    ST_DIV_GRAY: begin
                        if (!awb_en_q) begin
                            state <= ST_DIV_IDEAL;
                        end else if (!div_busy_q) begin
                            div_start({6'd0, mean_sum}, 16'd3);
                        end else if (div_done) begin
                            div_busy_q <= 1'b0;
                            gray_q     <= div_quo_q[15:0];
                            state      <= ST_DIV_R;
                        end
                    end

                    // awb gain: ((gray<<7)+(mean>>1)) / mean, clamped.
                    ST_DIV_R: begin
                        if (mean_r_q == 16'd0) begin
                            gain_r_q <= GAIN_MAX_Q17;
                            state    <= ST_DIV_G;
                        end else if (!div_busy_q) begin
                            div_start(({8'd0, gray_q} << 7) + {8'd0, mean_r_q >> 1}, mean_r_q);
                        end else if (div_done) begin
                            div_busy_q <= 1'b0;
                            gain_r_q   <= clamp_gain_q17(div_quo_q);
                            state      <= ST_DIV_G;
                        end
                    end

                    ST_DIV_G: begin
                        if (mean_g_q == 16'd0) begin
                            gain_g_q <= GAIN_MAX_Q17;
                            state    <= ST_DIV_B;
                        end else if (!div_busy_q) begin
                            div_start(({8'd0, gray_q} << 7) + {8'd0, mean_g_q >> 1}, mean_g_q);
                        end else if (div_done) begin
                            div_busy_q <= 1'b0;
                            gain_g_q   <= clamp_gain_q17(div_quo_q);
                            state      <= ST_DIV_B;
                        end
                    end

                    ST_DIV_B: begin
                        if (mean_b_q == 16'd0) begin
                            gain_b_q <= GAIN_MAX_Q17;
                            state    <= ST_DIV_IDEAL;
                        end else if (!div_busy_q) begin
                            div_start(({8'd0, gray_q} << 7) + {8'd0, mean_b_q >> 1}, mean_b_q);
                        end else if (div_done) begin
                            div_busy_q <= 1'b0;
                            gain_b_q   <= clamp_gain_q17(div_quo_q);
                            state      <= ST_DIV_IDEAL;
                        end
                    end

                    // ideal_gain = ((255<<7)+(range>>1)) / range  (stretch only)
                    ST_DIV_IDEAL: begin
                        if (!st_en_q || (luma_range_q < STRETCH_MIN_RANGE)) begin
                            state <= ST_OUT;   // stretch stays identity/0
                        end else if (!div_busy_q) begin
                            div_start(24'd32640 + {15'd0, luma_range_q >> 1}, {7'd0, luma_range_q});
                        end else if (div_done) begin
                            div_busy_q <= 1'b0;
                            ideal_q    <= div_quo_q;
                            state      <= ST_DIV_LIMIT;
                        end
                    end

                    // bias_limit = (256<<7) / luma_min (or GAIN_MAX when min==0)
                    ST_DIV_LIMIT: begin
                        if (luma_min_q == 8'd0) begin
                            limit_q <= {16'd0, GAIN_MAX_Q17};
                            state   <= ST_CLIP;
                        end else if (!div_busy_q) begin
                            div_start(24'd32768, {8'd0, luma_min_q});
                        end else if (div_done) begin
                            div_busy_q <= 1'b0;
                            limit_q    <= div_quo_q;
                            state      <= ST_CLIP;
                        end
                    end

                    // clipped = clamp(min(ideal, limit), [identity .. max])
                    ST_CLIP: begin
                        clipped_q <= clip_sel;
                        state     <= ST_MUL;
                    end

                    // bias = -((luma_min * clipped) >> 7), registered multiply.
                    ST_MUL: begin
                        mul_q <= {9'd0, luma_min_q} * clipped_q[7:0];
                        state <= ST_OUT;
                    end

                    ST_OUT: begin
                        awb_gain_r_o <= awb_en_q ? gain_r_q : GAIN_IDENTITY;
                        awb_gain_g_o <= awb_en_q ? gain_g_q : GAIN_IDENTITY;
                        awb_gain_b_o <= awb_en_q ? gain_b_q : GAIN_IDENTITY;
                        if (st_en_q && (luma_range_q >= STRETCH_MIN_RANGE)) begin
                            stretch_gain_o <= clamp_gain_q17(clipped_q);
                            stretch_bias_o <= clamp_bias_s9(bias_neg);
                        end else begin
                            stretch_gain_o <= GAIN_IDENTITY;
                            stretch_bias_o <= 9'sd0;
                        end
                        coeff_valid_o <= 1'b1;
                        state         <= ST_IDLE;
                    end

                    default: state <= ST_IDLE;
                endcase
            end
        end
    end

endmodule
