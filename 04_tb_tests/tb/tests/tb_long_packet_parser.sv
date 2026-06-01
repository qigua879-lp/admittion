`timescale 1ns/1ps

module tb_long_packet_parser;

    logic        clk_sys;
    logic        rst_n;
    logic        clear_i;
    logic        byte_valid;
    logic        byte_ready;
    logic [7:0]  byte_data;
    logic        hdr_valid;
    logic        hdr_ready;
    logic [1:0]  vc;
    logic [5:0]  dt;
    logic [15:0] word_count;
    logic        ecc_ok;
    logic        ecc_correctable;
    logic [5:0]  ecc_syndrome;
    logic        payload_valid;
    logic        payload_ready;
    logic [7:0]  payload_data;
    logic        payload_start;
    logic        payload_end;
    logic        expected_crc_valid;
    logic [15:0] expected_crc;
    logic        parser_busy;
    logic        packet_done;

    csi2_long_packet_parser dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .byte_valid(byte_valid),
        .byte_ready(byte_ready),
        .byte_data(byte_data),
        .hdr_valid(hdr_valid),
        .hdr_ready(hdr_ready),
        .vc(vc),
        .dt(dt),
        .word_count(word_count),
        .ecc_ok(ecc_ok),
        .ecc_correctable(ecc_correctable),
        .ecc_syndrome(ecc_syndrome),
        .payload_valid(payload_valid),
        .payload_ready(payload_ready),
        .payload_data(payload_data),
        .payload_start(payload_start),
        .payload_end(payload_end),
        .expected_crc_valid(expected_crc_valid),
        .expected_crc_ready(1'b1),
        .expected_crc(expected_crc),
        .parser_busy(parser_busy),
        .packet_done(packet_done)
    );

    initial clk_sys = 1'b0;
    always #5 clk_sys = ~clk_sys;

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    function automatic logic [5:0] ref_ecc(input logic [23:0] data);
        logic [5:0] ecc;
        begin
            ecc[0] = data[0]  ^ data[1]  ^ data[2]  ^ data[4]  ^
                     data[5]  ^ data[7]  ^ data[10] ^ data[11] ^
                     data[13] ^ data[16] ^ data[20] ^ data[21] ^
                     data[22] ^ data[23];
            ecc[1] = data[0]  ^ data[1]  ^ data[3]  ^ data[4]  ^
                     data[6]  ^ data[8]  ^ data[10] ^ data[12] ^
                     data[14] ^ data[17] ^ data[20] ^ data[21] ^
                     data[22] ^ data[23];
            ecc[2] = data[0]  ^ data[2]  ^ data[3]  ^ data[5]  ^
                     data[6]  ^ data[9]  ^ data[11] ^ data[12] ^
                     data[15] ^ data[18] ^ data[20] ^ data[21] ^
                     data[22];
            ecc[3] = data[1]  ^ data[2]  ^ data[3]  ^ data[7]  ^
                     data[8]  ^ data[9]  ^ data[13] ^ data[14] ^
                     data[15] ^ data[19] ^ data[20] ^ data[21] ^
                     data[23];
            ecc[4] = data[4]  ^ data[5]  ^ data[6]  ^ data[7]  ^
                     data[8]  ^ data[9]  ^ data[16] ^ data[17] ^
                     data[18] ^ data[19] ^ data[20] ^ data[22] ^
                     data[23];
            ecc[5] = data[10] ^ data[11] ^ data[12] ^ data[13] ^
                     data[14] ^ data[15] ^ data[16] ^ data[17] ^
                     data[18] ^ data[19] ^ data[21] ^ data[22] ^
                     data[23];
            ref_ecc = ecc;
        end
    endfunction

    task automatic apply_reset;
        begin
            rst_n         = 1'b0;
            clear_i       = 1'b0;
            byte_valid    = 1'b0;
            byte_data     = 8'd0;
            hdr_ready     = 1'b1;
            payload_ready = 1'b1;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic send_byte(input logic [7:0] data);
        begin
            @(posedge clk_sys);
            byte_valid <= 1'b1;
            byte_data  <= data;
            while (!byte_ready) begin
                @(posedge clk_sys);
            end
            @(posedge clk_sys);
            byte_valid <= 1'b0;
            byte_data  <= 8'd0;
        end
    endtask

    task automatic send_header(
        input logic [1:0]  in_vc,
        input logic [5:0]  in_dt,
        input logic [15:0] in_wc,
        input logic        inject_ecc_error
    );
        logic [23:0] hdr_data_local;
        logic [5:0]  ecc_local;
        begin
            hdr_data_local = {in_wc[15:8], in_wc[7:0], in_vc, in_dt};
            ecc_local      = ref_ecc(hdr_data_local);
            if (inject_ecc_error) begin
                ecc_local = ecc_local ^ 6'h01;
            end
            send_byte(hdr_data_local[7:0]);
            send_byte(hdr_data_local[15:8]);
            send_byte(hdr_data_local[23:16]);
            send_byte({2'b00, ecc_local});
        end
    endtask

    task automatic check_header(
        input logic [1:0]  exp_vc,
        input logic [5:0]  exp_dt,
        input logic [15:0] exp_wc,
        input logic        exp_ecc_ok
    );
        begin
            while (!hdr_valid) begin
                @(posedge clk_sys);
            end
            if (vc !== exp_vc || dt !== exp_dt || word_count !== exp_wc) begin
                fail("header parse mismatch");
            end
            if (ecc_ok !== exp_ecc_ok) begin
                fail("long packet ecc_ok mismatch");
            end
            @(posedge clk_sys);
        end
    endtask

    task automatic send_payload_expect(
        input logic [7:0] data,
        input logic       exp_start,
        input logic       exp_end
    );
        begin
            @(posedge clk_sys);
            byte_valid <= 1'b1;
            byte_data  <= data;
            while (!byte_ready) begin
                @(posedge clk_sys);
            end
            @(negedge clk_sys);
            if (!payload_valid || payload_data !== data) begin
                fail("payload byte mismatch");
            end
            if (payload_start !== exp_start) begin
                fail("payload_start mismatch");
            end
            if (payload_end !== exp_end) begin
                fail("payload_end mismatch");
            end
            @(posedge clk_sys);
            byte_valid <= 1'b0;
            byte_data  <= 8'd0;
        end
    endtask

    task automatic wait_done;
        begin
            while (!packet_done) begin
                @(posedge clk_sys);
            end
            @(posedge clk_sys);
        end
    endtask

    initial begin
        apply_reset();

        send_header(2'd1, 6'h2a, 16'd3, 1'b0);
        check_header(2'd1, 6'h2a, 16'd3, 1'b1);
        send_payload_expect(8'h11, 1'b1, 1'b0);
        send_payload_expect(8'h22, 1'b0, 1'b0);
        send_payload_expect(8'h33, 1'b0, 1'b1);
        wait_done();

        send_header(2'd0, 6'h24, 16'd0, 1'b0);
        check_header(2'd0, 6'h24, 16'd0, 1'b1);
        wait_done();
        if (payload_valid) begin
            fail("zero-length packet produced payload_valid");
        end

        send_header(2'd2, 6'h2b, 16'd1, 1'b1);
        check_header(2'd2, 6'h2b, 16'd1, 1'b0);
        if (!ecc_correctable) begin
            fail("single-bit ECC error was not marked correctable");
        end
        send_payload_expect(8'ha5, 1'b1, 1'b1);
        wait_done();

        send_header(2'd3, 6'h2c, 16'd2, 1'b0);
        check_header(2'd3, 6'h2c, 16'd2, 1'b1);
        payload_ready <= 1'b0;
        @(posedge clk_sys);
        byte_valid <= 1'b1;
        byte_data  <= 8'hca;
        repeat (3) @(posedge clk_sys);
        if (byte_ready || !payload_valid || payload_data !== 8'hca || !payload_start) begin
            fail("payload backpressure did not hold first byte");
        end
        payload_ready <= 1'b1;
        @(negedge clk_sys);
        if (!payload_valid || payload_data !== 8'hca || !payload_start || payload_end) begin
            fail("payload backpressure release mismatch");
        end
        @(posedge clk_sys);
        byte_valid <= 1'b0;
        send_payload_expect(8'hfe, 1'b0, 1'b1);
        wait_done();

        send_header(2'd1, 6'h2a, 16'd3, 1'b0);
        check_header(2'd1, 6'h2a, 16'd3, 1'b1);
        send_payload_expect(8'h55, 1'b1, 1'b0);
        @(negedge clk_sys);
        clear_i = 1'b1;
        @(posedge clk_sys);
        #1;
        clear_i = 1'b0;
        if (hdr_valid || payload_valid || parser_busy) begin
            fail("clear_i did not flush parser state");
        end

        $display("[%0t] PASS: tb_long_packet_parser", $time);
        $finish;
    end

endmodule
