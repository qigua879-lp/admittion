`timescale 1ns/1ps

module tb_pixel_frame_stats_v1;

    localparam logic [2:0] PIXFMT_RAW8   = 3'd0;
    localparam logic [2:0] PIXFMT_RGB888 = 3'd2;

    logic        clk_sys;
    logic        rst_n;
    logic        enable_i;
    logic        clear_i;
    logic [2:0]  pixel_format_i;
    logic        frame_end_i;
    logic        pixel_valid_i;
    logic        pixel_ready_i;
    logic [23:0] pixel_data_i;
    logic        pixel_sof_i;
    logic        stats_valid_o;
    logic [31:0] pixel_cnt_o;
    logic [15:0] mean_r_o;
    logic [15:0] mean_g_o;
    logic [15:0] mean_b_o;
    logic [7:0]  luma_min_o;
    logic [7:0]  luma_max_o;
    logic [31:0] dark_cnt_o;
    logic [31:0] bright_cnt_o;

    pixel_frame_stats_v1 dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .enable_i(enable_i),
        .clear_i(clear_i),
        .pixel_format_i(pixel_format_i),
        .frame_end_i(frame_end_i),
        .pixel_valid_i(pixel_valid_i),
        .pixel_ready_i(pixel_ready_i),
        .pixel_data_i(pixel_data_i),
        .pixel_sof_i(pixel_sof_i),
        .stats_valid_o(stats_valid_o),
        .pixel_cnt_o(pixel_cnt_o),
        .mean_r_o(mean_r_o),
        .mean_g_o(mean_g_o),
        .mean_b_o(mean_b_o),
        .luma_min_o(luma_min_o),
        .luma_max_o(luma_max_o),
        .dark_cnt_o(dark_cnt_o),
        .bright_cnt_o(bright_cnt_o)
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
            rst_n          = 1'b0;
            enable_i       = 1'b1;
            clear_i        = 1'b0;
            pixel_format_i = PIXFMT_RGB888;
            frame_end_i    = 1'b0;
            pixel_valid_i  = 1'b0;
            pixel_ready_i  = 1'b1;
            pixel_data_i   = 24'd0;
            pixel_sof_i    = 1'b0;
            repeat (4) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic send_pixel(input logic [23:0] data, input logic sof);
        begin
            @(negedge clk_sys);
            pixel_valid_i = 1'b1;
            pixel_data_i  = data;
            pixel_sof_i   = sof;
            @(posedge clk_sys);
            #1;
            pixel_valid_i = 1'b0;
            pixel_sof_i   = 1'b0;
        end
    endtask

    task automatic pulse_frame_end;
        begin
            @(negedge clk_sys);
            frame_end_i = 1'b1;
            @(posedge clk_sys);
            #1;
            frame_end_i = 1'b0;
        end
    endtask

    initial begin
        apply_reset();

        pixel_format_i = PIXFMT_RGB888;
        send_pixel(24'h102030, 1'b1);
        send_pixel(24'h203040, 1'b0);
        send_pixel(24'h304050, 1'b0);
        send_pixel(24'h405060, 1'b0);
        pulse_frame_end();

        if (!stats_valid_o) begin
            fail("expected rgb frame stats_valid pulse");
        end
        if (pixel_cnt_o !== 32'd4 ||
            mean_r_o !== 16'd40 ||
            mean_g_o !== 16'd56 ||
            mean_b_o !== 16'd72 ||
            luma_min_o !== 8'd32 ||
            luma_max_o !== 8'd80 ||
            dark_cnt_o !== 32'd0 ||
            bright_cnt_o !== 32'd0) begin
            fail($sformatf("rgb stats mismatch cnt=%0d mean=%0d/%0d/%0d luma=%0d..%0d dark=%0d bright=%0d",
                           pixel_cnt_o, mean_r_o, mean_g_o, mean_b_o,
                           luma_min_o, luma_max_o, dark_cnt_o, bright_cnt_o));
        end

        repeat (2) @(posedge clk_sys);

        pixel_format_i = PIXFMT_RAW8;
        send_pixel(24'h000005, 1'b1);
        send_pixel(24'h0000f8, 1'b0);
        pulse_frame_end();

        if (!stats_valid_o) begin
            fail("expected raw8 frame stats_valid pulse");
        end
        if (pixel_cnt_o !== 32'd2 ||
            mean_r_o !== 16'd126 ||
            mean_g_o !== 16'd126 ||
            mean_b_o !== 16'd126 ||
            luma_min_o !== 8'd5 ||
            luma_max_o !== 8'd248 ||
            dark_cnt_o !== 32'd1 ||
            bright_cnt_o !== 32'd1) begin
            fail("raw8 stats mismatch");
        end

        @(negedge clk_sys);
        clear_i = 1'b1;
        @(posedge clk_sys);
        #1;
        clear_i = 1'b0;
        if (pixel_cnt_o !== 32'd0 || mean_r_o !== 16'd0 || luma_min_o !== 8'd0 || luma_max_o !== 8'd0) begin
            fail("clear did not reset latched stats");
        end

        $display("[%0t] PASS: tb_pixel_frame_stats_v1", $time);
        $finish;
    end

endmodule
