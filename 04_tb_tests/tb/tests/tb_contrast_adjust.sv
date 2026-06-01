`timescale 1ns/1ps

module tb_contrast_adjust;

    logic              clk_sys;
    logic              rst_n;
    logic              bypass_i;
    logic [7:0]        cfg_gain_i;
    logic signed [8:0] cfg_bias_i;
    logic              pixel_valid_i;
    logic              pixel_ready_o;
    logic [23:0]       pixel_data_i;
    logic              pixel_sof_i;
    logic              pixel_sol_i;
    logic              pixel_valid_o;
    logic              pixel_ready_i;
    logic [23:0]       pixel_data_o;
    logic              pixel_sof_o;
    logic              pixel_sol_o;

    contrast_adjust dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .bypass_i(bypass_i),
        .cfg_gain_i(cfg_gain_i),
        .cfg_bias_i(cfg_bias_i),
        .pixel_valid_i(pixel_valid_i),
        .pixel_ready_o(pixel_ready_o),
        .pixel_data_i(pixel_data_i),
        .pixel_sof_i(pixel_sof_i),
        .pixel_sol_i(pixel_sol_i),
        .pixel_valid_o(pixel_valid_o),
        .pixel_ready_i(pixel_ready_i),
        .pixel_data_o(pixel_data_o),
        .pixel_sof_o(pixel_sof_o),
        .pixel_sol_o(pixel_sol_o)
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
            rst_n         = 1'b0;
            bypass_i      = 1'b0;
            cfg_gain_i    = 8'h80;
            cfg_bias_i    = 9'sd0;
            pixel_valid_i = 1'b0;
            pixel_data_i  = 24'd0;
            pixel_sof_i   = 1'b0;
            pixel_sol_i   = 1'b0;
            pixel_ready_i = 1'b1;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic send_pixel(input logic [23:0] data, input logic sof, input logic sol);
        begin
            @(negedge clk_sys);
            pixel_valid_i = 1'b1;
            pixel_data_i  = data;
            pixel_sof_i   = sof;
            pixel_sol_i   = sol;
            while (!pixel_ready_o) begin
                @(posedge clk_sys);
            end
            @(posedge clk_sys);
            #1;
            pixel_valid_i = 1'b0;
            pixel_sof_i   = 1'b0;
            pixel_sol_i   = 1'b0;
        end
    endtask

    task automatic expect_pixel(input logic [23:0] data, input logic sof, input logic sol);
        begin
            while (!pixel_valid_o) begin
                @(posedge clk_sys);
                #1;
            end
            if (pixel_data_o !== data || pixel_sof_o !== sof || pixel_sol_o !== sol) begin
                fail($sformatf("contrast mismatch exp=%06h/%0b/%0b got=%06h/%0b/%0b",
                               data, sof, sol, pixel_data_o, pixel_sof_o, pixel_sol_o));
            end
            @(posedge clk_sys);
            #1;
        end
    endtask

    initial begin
        apply_reset();

        cfg_gain_i = 8'h80;
        cfg_bias_i = 9'sd0;
        send_pixel(24'h406080, 1'b1, 1'b1);
        expect_pixel(24'h406080, 1'b1, 1'b1);

        cfg_gain_i = 8'h40;
        cfg_bias_i = 9'sd10;
        send_pixel(24'h4080c0, 1'b0, 1'b0);
        expect_pixel(24'h6a8aaa, 1'b0, 1'b0);

        cfg_gain_i = 8'hff;
        cfg_bias_i = 9'sd40;
        send_pixel(24'h00f080, 1'b0, 1'b1);
        expect_pixel(24'h00ffa8, 1'b0, 1'b1);

        bypass_i   = 1'b1;
        cfg_gain_i = 8'hff;
        cfg_bias_i = -9'sd100;
        send_pixel(24'habcdef, 1'b0, 1'b0);
        expect_pixel(24'habcdef, 1'b0, 1'b0);

        bypass_i      = 1'b0;
        cfg_gain_i    = 8'h80;
        cfg_bias_i    = 9'sd5;
        pixel_ready_i = 1'b0;
        send_pixel(24'h102030, 1'b1, 1'b0);
        repeat (3) @(posedge clk_sys);
        if (!pixel_valid_o || pixel_data_o !== 24'h152535 || !pixel_sof_o || pixel_sol_o || pixel_ready_o) begin
            fail("contrast backpressure hold failed");
        end
        pixel_ready_i = 1'b1;
        @(posedge clk_sys);

        $display("[%0t] PASS: tb_contrast_adjust", $time);
        $finish;
    end

endmodule
