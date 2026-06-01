`timescale 1ns/1ps

module tb_raw8_unpack;

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

    raw8_unpack dut (
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
            pixel_ready_i   = 1'b1;
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

    task automatic expect_pixel(input logic [23:0] data, input logic sof, input logic sol);
        begin
            while (!pixel_valid_o) begin
                @(posedge clk_sys);
            end
            if (pixel_data_o !== data || pixel_sof_o !== sof || pixel_sol_o !== sol) begin
                fail("RAW8 pixel mismatch");
            end
            @(posedge clk_sys);
        end
    endtask

    initial begin
        apply_reset();

        send_byte(8'h12, 1'b1, 1'b1);
        expect_pixel(24'h000012, 1'b1, 1'b1);

        send_byte(8'hab, 1'b0, 1'b0);
        expect_pixel(24'h0000ab, 1'b0, 1'b0);

        pixel_ready_i = 1'b0;
        send_byte(8'h34, 1'b0, 1'b1);
        repeat (3) @(posedge clk_sys);
        if (!pixel_valid_o || pixel_data_o !== 24'h000034 || !pixel_sol_o || payload_ready_o) begin
            fail("RAW8 backpressure hold failed");
        end
        pixel_ready_i = 1'b1;
        @(posedge clk_sys);

        $display("[%0t] PASS: tb_raw8_unpack", $time);
        $finish;
    end

endmodule
