`timescale 1ns/1ps

// adaptive_v1 iteration:
// Frame-based pixel statistics observer for the unified pixel debug stream.
// The module is synthesizable and computes previous-frame statistics used by
// later adaptive preprocess stages. It never backpressures the pixel stream.
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
        end else begin
            stats_valid_o <= 1'b0;

            if (clear_i || !enable_i) begin
                frame_active   <= 1'b0;
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
                    stats_valid_o <= 1'b1;
                    pixel_cnt_o   <= pixel_cnt_acc;
                    mean_r_o      <= sum_r_acc / pixel_cnt_acc;
                    mean_g_o      <= sum_g_acc / pixel_cnt_acc;
                    mean_b_o      <= sum_b_acc / pixel_cnt_acc;
                    luma_min_o    <= luma_min_acc;
                    luma_max_o    <= luma_max_acc;
                    dark_cnt_o    <= dark_cnt_acc;
                    bright_cnt_o  <= bright_cnt_acc;

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
