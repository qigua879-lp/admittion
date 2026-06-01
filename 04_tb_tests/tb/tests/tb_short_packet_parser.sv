`timescale 1ns/1ps

module tb_short_packet_parser;

    logic        clk_sys;
    logic        rst_n;
    logic        sp_valid;
    logic        sp_ready;
    logic [31:0] sp_header;
    logic        pkt_valid;
    logic        pkt_ready;
    logic [1:0]  vc;
    logic [5:0]  dt;
    logic [15:0] word_count;
    logic        ecc_ok;
    logic        ecc_correctable;
    logic [5:0]  ecc_syndrome;

    csi2_short_packet_parser dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .sp_valid(sp_valid),
        .sp_ready(sp_ready),
        .sp_header(sp_header),
        .pkt_valid(pkt_valid),
        .pkt_ready(pkt_ready),
        .vc(vc),
        .dt(dt),
        .word_count(word_count),
        .ecc_ok(ecc_ok),
        .ecc_correctable(ecc_correctable),
        .ecc_syndrome(ecc_syndrome)
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

    function automatic logic [31:0] make_header(
        input logic [1:0]  in_vc,
        input logic [5:0]  in_dt,
        input logic [15:0] in_wc,
        input logic        inject_ecc_error
    );
        logic [23:0] hdr_data;
        logic [5:0]  ecc;
        begin
            hdr_data = {in_wc[15:8], in_wc[7:0], in_vc, in_dt};
            ecc      = ref_ecc(hdr_data);
            if (inject_ecc_error) begin
                ecc = ecc ^ 6'h01;
            end
            make_header = {2'b00, ecc, hdr_data};
        end
    endfunction

    task automatic apply_reset;
        begin
            rst_n     = 1'b0;
            sp_valid  = 1'b0;
            sp_header = 32'd0;
            pkt_ready = 1'b1;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic send_and_check(
        input logic [1:0]  exp_vc,
        input logic [5:0]  exp_dt,
        input logic [15:0] exp_wc,
        input logic        inject_ecc_error
    );
        begin
            @(posedge clk_sys);
            sp_valid  <= 1'b1;
            sp_header <= make_header(exp_vc, exp_dt, exp_wc, inject_ecc_error);
            while (!sp_ready) begin
                @(posedge clk_sys);
            end
            @(posedge clk_sys);
            sp_valid  <= 1'b0;
            sp_header <= 32'd0;

            while (!pkt_valid) begin
                @(posedge clk_sys);
            end

            if (vc !== exp_vc) begin
                fail("VC mismatch");
            end
            if (dt !== exp_dt) begin
                fail("DT mismatch");
            end
            if (word_count !== exp_wc) begin
                fail("word_count mismatch");
            end
            if (ecc_ok !== !inject_ecc_error) begin
                fail("ecc_ok mismatch");
            end
            if (inject_ecc_error && !ecc_correctable) begin
                fail("single-bit ECC error was not marked correctable");
            end
            @(posedge clk_sys);
        end
    endtask

    initial begin
        apply_reset();

        send_and_check(2'd0, 6'h00, 16'h0001, 1'b0);
        send_and_check(2'd1, 6'h01, 16'h0002, 1'b0);
        send_and_check(2'd2, 6'h02, 16'h1234, 1'b0);
        send_and_check(2'd3, 6'h03, 16'habcd, 1'b1);

        pkt_ready <= 1'b0;
        @(posedge clk_sys);
        sp_valid  <= 1'b1;
        sp_header <= make_header(2'd2, 6'h00, 16'h55aa, 1'b0);
        while (!sp_ready) begin
            @(posedge clk_sys);
        end
        @(posedge clk_sys);
        sp_valid <= 1'b0;
        while (!pkt_valid) begin
            @(posedge clk_sys);
        end
        repeat (3) @(posedge clk_sys);
        if (!pkt_valid || vc !== 2'd2 || dt !== 6'h00 || word_count !== 16'h55aa) begin
            fail("packet output was not held under backpressure");
        end
        pkt_ready <= 1'b1;
        @(posedge clk_sys);

        $display("[%0t] PASS: tb_short_packet_parser", $time);
        $finish;
    end

endmodule
