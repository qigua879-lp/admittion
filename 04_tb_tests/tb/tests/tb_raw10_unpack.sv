`timescale 1ns/1ps

module tb_raw10_unpack;

    logic        clk_sys;
    logic        rst_n;
    logic        clear_i;
    logic        payload_valid_i;
    logic        payload_ready_o;
    logic [7:0]  payload_data_i;
    logic        payload_sof_i;
    logic        payload_sol_i;
    logic        pixel_valid_o;
    logic        pixel_ready_i;
    logic [23:0] pixel_data_o;
    logic        pixel_sof_o;
    logic        pixel_sol_o;

    raw10_unpack dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .payload_valid_i(payload_valid_i),
        .payload_ready_o(payload_ready_o),
        .payload_data_i(payload_data_i),
        .payload_sof_i(payload_sof_i),
        .payload_sol_i(payload_sol_i),
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
            rst_n           = 1'b0;
            clear_i         = 1'b0;
            payload_valid_i = 1'b0;
            payload_data_i  = 8'd0;
            payload_sof_i   = 1'b0;
            payload_sol_i   = 1'b0;
            pixel_ready_i   = 1'b0;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic send_byte(input logic [7:0] data, input logic sof, input logic sol);
        begin
            @(negedge clk_sys);
            payload_valid_i = 1'b1;
            payload_data_i  = data;
            payload_sof_i   = sof;
            payload_sol_i   = sol;
            while (!payload_ready_o) begin
                @(posedge clk_sys);
            end
            @(posedge clk_sys);
            #1;
            payload_valid_i = 1'b0;
            payload_sof_i   = 1'b0;
            payload_sol_i   = 1'b0;
        end
    endtask

    task automatic send_group(
        input logic [7:0] b0,
        input logic [7:0] b1,
        input logic [7:0] b2,
        input logic [7:0] b3,
        input logic [7:0] b4,
        input logic       sof,
        input logic       sol
    );
        begin
            send_byte(b0, sof, sol);
            send_byte(b1, 1'b0, 1'b0);
            send_byte(b2, 1'b0, 1'b0);
            send_byte(b3, 1'b0, 1'b0);
            send_byte(b4, 1'b0, 1'b0);
        end
    endtask

    task automatic expect_pixel(input logic [23:0] data, input logic sof, input logic sol);
        begin
            while (!pixel_valid_o) begin
                @(posedge clk_sys);
            end
            if (pixel_data_o !== data || pixel_sof_o !== sof || pixel_sol_o !== sol) begin
                fail($sformatf("RAW10 pixel mismatch exp=%06h/%0b/%0b got=%06h/%0b/%0b",
                               data, sof, sol, pixel_data_o, pixel_sof_o, pixel_sol_o));
            end
            @(negedge clk_sys);
            pixel_ready_i = 1'b1;
            @(posedge clk_sys);
            #1;
            pixel_ready_i = 1'b0;
        end
    endtask

    initial begin
        apply_reset();

        send_group(8'h12, 8'h23, 8'h34, 8'h45, 8'he4, 1'b1, 1'b1);
        expect_pixel(24'h000048, 1'b1, 1'b1);
        expect_pixel(24'h00008d, 1'b0, 1'b0);
        expect_pixel(24'h0000d2, 1'b0, 1'b0);
        expect_pixel(24'h000117, 1'b0, 1'b0);

        pixel_ready_i = 1'b0;
        send_group(8'h01, 8'h02, 8'h03, 8'h04, 8'h1b, 1'b0, 1'b1);
        repeat (3) @(posedge clk_sys);
        if (!pixel_valid_o || pixel_data_o !== 24'h000007 || !pixel_sol_o || payload_ready_o) begin
            fail("RAW10 backpressure hold failed");
        end
        expect_pixel(24'h000007, 1'b0, 1'b1);
        expect_pixel(24'h00000a, 1'b0, 1'b0);
        expect_pixel(24'h00000d, 1'b0, 1'b0);
        expect_pixel(24'h000010, 1'b0, 1'b0);

        $display("[%0t] PASS: tb_raw10_unpack", $time);
        $finish;
    end

endmodule
