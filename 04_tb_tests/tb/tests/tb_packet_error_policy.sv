`timescale 1ns/1ps

module tb_packet_error_policy;

    logic        clk_sys;
    logic        rst_n;
    logic        cfg_mark_ecc_error_i;
    logic        cfg_drop_on_crc_error_i;
    logic        hdr_valid_i;
    logic        hdr_ready_i;
    logic [15:0] pkt_word_count_i;
    logic        pkt_ecc_ok_i;
    logic        packet_done_i;
    logic        crc_error_i;
    logic        resync_drop_packet_i;
    logic        unsupported_dt_i;
    logic        payload_drop_o;
    logic        crc_drop_req_o;

    packet_error_policy dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .cfg_mark_ecc_error_i(cfg_mark_ecc_error_i),
        .cfg_drop_on_crc_error_i(cfg_drop_on_crc_error_i),
        .hdr_valid_i(hdr_valid_i),
        .hdr_ready_i(hdr_ready_i),
        .pkt_word_count_i(pkt_word_count_i),
        .pkt_ecc_ok_i(pkt_ecc_ok_i),
        .packet_done_i(packet_done_i),
        .crc_error_i(crc_error_i),
        .resync_drop_packet_i(resync_drop_packet_i),
        .unsupported_dt_i(unsupported_dt_i),
        .payload_drop_o(payload_drop_o),
        .crc_drop_req_o(crc_drop_req_o)
    );

    initial begin
        clk_sys = 1'b0;
        forever #5 clk_sys = ~clk_sys;
    end

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    task automatic pulse_long_hdr(input logic ecc_ok, input logic [15:0] wc);
        begin
            @(negedge clk_sys);
            hdr_valid_i      = 1'b1;
            hdr_ready_i      = 1'b1;
            pkt_ecc_ok_i     = ecc_ok;
            pkt_word_count_i = wc;
            @(posedge clk_sys);
            #1;
            hdr_valid_i      = 1'b0;
            pkt_word_count_i = 16'd0;
        end
    endtask

    task automatic pulse_packet_done;
        begin
            @(negedge clk_sys);
            packet_done_i = 1'b1;
            @(posedge clk_sys);
            #1;
            packet_done_i = 1'b0;
        end
    endtask

    task automatic pulse_crc_error;
        begin
            @(negedge clk_sys);
            crc_error_i = 1'b1;
            @(posedge clk_sys);
            #1;
            crc_error_i = 1'b0;
        end
    endtask

    initial begin
        rst_n                    = 1'b0;
        cfg_mark_ecc_error_i     = 1'b0;
        cfg_drop_on_crc_error_i  = 1'b0;
        hdr_valid_i              = 1'b0;
        hdr_ready_i              = 1'b1;
        pkt_word_count_i         = 16'd0;
        pkt_ecc_ok_i             = 1'b1;
        packet_done_i            = 1'b0;
        crc_error_i              = 1'b0;
        resync_drop_packet_i     = 1'b0;
        unsupported_dt_i         = 1'b0;

        repeat (5) @(posedge clk_sys);
        rst_n = 1'b1;
        repeat (2) @(posedge clk_sys);

        if (payload_drop_o || crc_drop_req_o) begin
            fail("reset state mismatch");
        end

        pulse_long_hdr(1'b0, 16'd64);
        if (payload_drop_o) begin
            fail("bad ECC should not drop when policy disabled");
        end

        cfg_mark_ecc_error_i = 1'b1;
        pulse_long_hdr(1'b0, 16'd32);
        if (!payload_drop_o) begin
            fail("bad ECC long packet should drop when policy enabled");
        end
        pulse_packet_done;
        if (payload_drop_o) begin
            fail("packet_done should clear ECC drop latch");
        end

        unsupported_dt_i = 1'b1;
        #1;
        if (!payload_drop_o) begin
            fail("unsupported DT should force payload drop");
        end
        unsupported_dt_i = 1'b0;

        resync_drop_packet_i = 1'b1;
        #1;
        if (!payload_drop_o) begin
            fail("resync drop should force payload drop");
        end
        resync_drop_packet_i = 1'b0;

        pulse_crc_error;
        if (crc_drop_req_o) begin
            fail("CRC drop request should stay low when policy disabled");
        end

        cfg_drop_on_crc_error_i = 1'b1;
        pulse_crc_error;
        if (!crc_drop_req_o) begin
            fail("CRC drop request pulse missing");
        end
        @(posedge clk_sys);
        #1;
        if (crc_drop_req_o) begin
            fail("CRC drop request should be a pulse");
        end

        $display("[%0t] PASS: tb_packet_error_policy", $time);
        $finish;
    end

endmodule
