`timescale 1ns/1ps

module tb_adaptive_preprocess_ctrl_v1;

    logic              clk_sys;
    logic              rst_n;
    logic              enable_i;
    logic              awb_enable_i;
    logic              stretch_enable_i;
    logic              clear_i;
    logic              stats_valid_i;
    logic [31:0]       pixel_cnt_i;
    logic [15:0]       mean_r_i;
    logic [15:0]       mean_g_i;
    logic [15:0]       mean_b_i;
    logic [7:0]        luma_min_i;
    logic [7:0]        luma_max_i;
    logic [7:0]        awb_gain_r_o;
    logic [7:0]        awb_gain_g_o;
    logic [7:0]        awb_gain_b_o;
    logic [7:0]        stretch_gain_o;
    logic signed [8:0] stretch_bias_o;
    logic              coeff_valid_o;

    adaptive_preprocess_ctrl_v1 dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .enable_i(enable_i),
        .awb_enable_i(awb_enable_i),
        .stretch_enable_i(stretch_enable_i),
        .clear_i(clear_i),
        .stats_valid_i(stats_valid_i),
        .pixel_cnt_i(pixel_cnt_i),
        .mean_r_i(mean_r_i),
        .mean_g_i(mean_g_i),
        .mean_b_i(mean_b_i),
        .luma_min_i(luma_min_i),
        .luma_max_i(luma_max_i),
        .awb_gain_r_o(awb_gain_r_o),
        .awb_gain_g_o(awb_gain_g_o),
        .awb_gain_b_o(awb_gain_b_o),
        .stretch_gain_o(stretch_gain_o),
        .stretch_bias_o(stretch_bias_o),
        .coeff_valid_o(coeff_valid_o)
    );

    initial clk_sys = 1'b0;
    always #5 clk_sys = ~clk_sys;

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    task automatic apply_reset;
        begin
            rst_n             = 1'b0;
            enable_i          = 1'b1;
            awb_enable_i      = 1'b1;
            stretch_enable_i  = 1'b1;
            clear_i           = 1'b0;
            stats_valid_i     = 1'b0;
            pixel_cnt_i       = 32'd0;
            mean_r_i          = 16'd0;
            mean_g_i          = 16'd0;
            mean_b_i          = 16'd0;
            luma_min_i        = 8'd0;
            luma_max_i        = 8'd0;
            repeat (4) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic drive_stats(
        input logic [15:0] mean_r,
        input logic [15:0] mean_g,
        input logic [15:0] mean_b,
        input logic [7:0]  luma_min,
        input logic [7:0]  luma_max
    );
        begin
            @(negedge clk_sys);
            stats_valid_i = 1'b1;
            pixel_cnt_i   = 32'd128;
            mean_r_i      = mean_r;
            mean_g_i      = mean_g;
            mean_b_i      = mean_b;
            luma_min_i    = luma_min;
            luma_max_i    = luma_max;
            @(posedge clk_sys);
            #1;
            stats_valid_i = 1'b0;
        end
    endtask

    initial begin
        apply_reset();

        drive_stats(16'd64, 16'd96, 16'd128, 8'd16, 8'd200);
        if (!coeff_valid_o) begin
            fail("expected coeff_valid pulse");
        end
        if (!(awb_gain_r_o > 8'h80) || awb_gain_g_o !== 8'h80 || !(awb_gain_b_o < 8'h80)) begin
            fail($sformatf("unexpected awb gains r=%0d g=%0d b=%0d",
                           awb_gain_r_o, awb_gain_g_o, awb_gain_b_o));
        end
        if (stretch_gain_o <= 8'h80 || stretch_bias_o >= 9'sd0) begin
            fail($sformatf("unexpected stretch coeff gain=%0d bias=%0d",
                           stretch_gain_o, stretch_bias_o));
        end

        awb_enable_i = 1'b0;
        stretch_enable_i = 1'b0;
        drive_stats(16'd32, 16'd32, 16'd32, 8'd4, 8'd250);
        if (awb_gain_r_o !== 8'h80 || awb_gain_g_o !== 8'h80 || awb_gain_b_o !== 8'h80 ||
            stretch_gain_o !== 8'h80 || stretch_bias_o !== 9'sd0) begin
            fail("disable bits did not force identity coefficients");
        end

        enable_i = 1'b0;
        drive_stats(16'd10, 16'd40, 16'd90, 8'd10, 8'd90);
        if (awb_gain_r_o !== 8'h80 || stretch_gain_o !== 8'h80) begin
            fail("global disable should keep identity coefficients");
        end

        enable_i = 1'b1;
        awb_enable_i = 1'b1;
        stretch_enable_i = 1'b1;
        @(negedge clk_sys);
        clear_i = 1'b1;
        @(posedge clk_sys);
        #1;
        clear_i = 1'b0;
        if (awb_gain_r_o !== 8'h80 || awb_gain_g_o !== 8'h80 || awb_gain_b_o !== 8'h80 ||
            stretch_gain_o !== 8'h80 || stretch_bias_o !== 9'sd0) begin
            fail("clear did not restore identity");
        end

        $display("[%0t] PASS: tb_adaptive_preprocess_ctrl_v1", $time);
        $finish;
    end

endmodule
