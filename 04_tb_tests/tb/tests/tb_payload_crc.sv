`timescale 1ns/1ps

module tb_payload_crc;

    logic        clk_sys;
    logic        rst_n;
    logic        crc_start;
    logic        crc_clear;
    logic        crc_finish;
    logic        payload_valid;
    logic        payload_ready;
    logic [7:0]  payload_data;
    logic        payload_last;
    logic        expected_crc_valid;
    logic        expected_crc_ready;
    logic [15:0] expected_crc;
    logic        crc_valid;
    logic        crc_ready;
    logic [15:0] crc_calc;
    logic        crc_error;

    csi2_payload_crc_checker dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .crc_start(crc_start),
        .crc_clear(crc_clear),
        .crc_finish(crc_finish),
        .payload_valid(payload_valid),
        .payload_ready(payload_ready),
        .payload_data(payload_data),
        .payload_last(payload_last),
        .expected_crc_valid(expected_crc_valid),
        .expected_crc_ready(expected_crc_ready),
        .expected_crc(expected_crc),
        .crc_valid(crc_valid),
        .crc_ready(crc_ready),
        .crc_calc(crc_calc),
        .crc_error(crc_error)
    );

    initial clk_sys = 1'b0;
    always #5 clk_sys = ~clk_sys;

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    function automatic logic [15:0] ref_crc_next_byte(
        input logic [15:0] crc_in,
        input logic [7:0]  data_in
    );
        logic [15:0] crc_tmp;
        logic        feedback;
        int          i;
        begin
            crc_tmp = crc_in;
            for (i = 0; i < 8; i = i + 1) begin
                feedback = crc_tmp[0] ^ data_in[i];
                crc_tmp  = {1'b0, crc_tmp[15:1]};
                if (feedback) begin
                    crc_tmp = crc_tmp ^ 16'h8408;
                end
            end
            ref_crc_next_byte = crc_tmp;
        end
    endfunction

    task automatic apply_reset;
        begin
            rst_n              = 1'b0;
            crc_start          = 1'b0;
            crc_clear          = 1'b0;
            crc_finish         = 1'b0;
            payload_valid      = 1'b0;
            payload_data       = 8'd0;
            payload_last       = 1'b0;
            expected_crc_valid = 1'b0;
            expected_crc       = 16'd0;
            crc_ready          = 1'b1;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic pulse_start;
        begin
            @(posedge clk_sys);
            crc_start <= 1'b1;
            @(posedge clk_sys);
            crc_start <= 1'b0;
        end
    endtask

    task automatic pulse_finish;
        begin
            @(posedge clk_sys);
            crc_finish <= 1'b1;
            @(posedge clk_sys);
            crc_finish <= 1'b0;
        end
    endtask

    task automatic send_byte(input logic [7:0] data, input logic last);
        begin
            @(posedge clk_sys);
            payload_valid <= 1'b1;
            payload_data  <= data;
            payload_last  <= last;
            while (!payload_ready) begin
                @(posedge clk_sys);
            end
            @(posedge clk_sys);
            payload_valid <= 1'b0;
            payload_data  <= 8'd0;
            payload_last  <= 1'b0;
        end
    endtask

    task automatic send_expected(input logic [15:0] value);
        begin
            @(posedge clk_sys);
            expected_crc_valid <= 1'b1;
            expected_crc       <= value;
            while (!expected_crc_ready) begin
                @(posedge clk_sys);
            end
            @(posedge clk_sys);
            expected_crc_valid <= 1'b0;
            expected_crc       <= 16'd0;
        end
    endtask

    task automatic wait_result(input logic [15:0] exp_crc, input logic exp_error);
        begin
            while (!crc_valid) begin
                @(posedge clk_sys);
            end
            if (crc_calc !== exp_crc) begin
                fail($sformatf("CRC calc mismatch: expected 0x%04h got 0x%04h", exp_crc, crc_calc));
            end
            if (crc_error !== exp_error) begin
                fail("crc_error mismatch");
            end
            @(posedge clk_sys);
        end
    endtask

    initial begin
        logic [15:0] crc_abc;

        apply_reset();

        pulse_start();
        send_expected(16'hffff);
        pulse_finish();
        wait_result(16'hffff, 1'b0);

        pulse_start();
        send_byte(8'h31, 1'b0);
        send_byte(8'h32, 1'b0);
        send_byte(8'h33, 1'b0);
        send_byte(8'h34, 1'b0);
        send_byte(8'h35, 1'b0);
        send_byte(8'h36, 1'b0);
        send_byte(8'h37, 1'b0);
        send_byte(8'h38, 1'b0);
        send_byte(8'h39, 1'b1);
        send_expected(16'h6f91);
        wait_result(16'h6f91, 1'b0);

        pulse_start();
        send_byte(8'ha5, 1'b0);
        send_byte(8'h5a, 1'b1);
        send_expected(ref_crc_next_byte(ref_crc_next_byte(16'hffff, 8'ha5), 8'h5a) ^ 16'h0001);
        wait_result(ref_crc_next_byte(ref_crc_next_byte(16'hffff, 8'ha5), 8'h5a), 1'b1);

        crc_abc = ref_crc_next_byte(ref_crc_next_byte(ref_crc_next_byte(16'hffff, 8'h41), 8'h42), 8'h43);
        pulse_start();
        send_expected(crc_abc);
        send_byte(8'h41, 1'b0);
        send_byte(8'h42, 1'b0);
        send_byte(8'h43, 1'b1);
        wait_result(crc_abc, 1'b0);

        pulse_start();
        send_byte(8'hff, 1'b0);
        @(posedge clk_sys);
        crc_clear <= 1'b1;
        @(posedge clk_sys);
        crc_clear <= 1'b0;
        pulse_start();
        send_expected(16'hffff);
        pulse_finish();
        wait_result(16'hffff, 1'b0);

        $display("[%0t] PASS: tb_payload_crc", $time);
        $finish;
    end

endmodule
