`timescale 1ns/1ps

module tb_header_ecc;

    logic        clk_sys;
    logic        rst_n;
    logic        hdr_valid;
    logic        hdr_ready;
    logic [23:0] hdr_data;
    logic [5:0]  hdr_ecc;
    logic        ecc_valid;
    logic        ecc_ready;
    logic [5:0]  ecc_calc;
    logic [5:0]  ecc_syndrome;
    logic        ecc_error;
    logic        ecc_correctable;

    csi2_header_ecc_checker dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .hdr_valid(hdr_valid),
        .hdr_ready(hdr_ready),
        .hdr_data(hdr_data),
        .hdr_ecc(hdr_ecc),
        .ecc_valid(ecc_valid),
        .ecc_ready(ecc_ready),
        .ecc_calc(ecc_calc),
        .ecc_syndrome(ecc_syndrome),
        .ecc_error(ecc_error),
        .ecc_correctable(ecc_correctable)
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
            rst_n     = 1'b0;
            hdr_valid = 1'b0;
            hdr_data  = 24'd0;
            hdr_ecc   = 6'd0;
            ecc_ready = 1'b1;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic send_and_check(
        input logic [23:0] data,
        input logic [5:0]  ecc,
        input logic        exp_error
    );
        logic [5:0] exp_calc;
        begin
            exp_calc = ref_ecc(data);
            @(posedge clk_sys);
            hdr_valid <= 1'b1;
            hdr_data  <= data;
            hdr_ecc   <= ecc;
            while (!hdr_ready) begin
                @(posedge clk_sys);
            end
            @(posedge clk_sys);
            hdr_valid <= 1'b0;

            while (!ecc_valid) begin
                @(posedge clk_sys);
            end
            if (ecc_calc !== exp_calc) begin
                fail($sformatf("ECC calc mismatch for 0x%06h", data));
            end
            if (ecc_syndrome !== (exp_calc ^ ecc)) begin
                fail("syndrome mismatch");
            end
            if (ecc_error !== exp_error) begin
                fail("ecc_error mismatch");
            end
            if (exp_error && !ecc_correctable) begin
                fail("single-bit injected error was not marked correctable");
            end
            @(posedge clk_sys);
        end
    endtask

    initial begin
        logic [5:0] good_ecc;

        apply_reset();

        send_and_check(24'h000000, 6'h00, 1'b0);
        send_and_check(24'h000001, 6'h07, 1'b0);
        send_and_check(24'h800000, 6'h3b, 1'b0);

        good_ecc = ref_ecc(24'h123456);
        send_and_check(24'h123456, good_ecc, 1'b0);
        send_and_check(24'h123456, good_ecc ^ 6'h01, 1'b1);
        send_and_check(24'h123457, good_ecc, 1'b1);

        ecc_ready <= 1'b0;
        @(posedge clk_sys);
        hdr_valid <= 1'b1;
        hdr_data  <= 24'habcdef;
        hdr_ecc   <= ref_ecc(24'habcdef);
        @(posedge clk_sys);
        hdr_valid <= 1'b0;
        repeat (3) @(posedge clk_sys);
        if (!ecc_valid || ecc_calc !== ref_ecc(24'habcdef)) begin
            fail("output was not held under backpressure");
        end
        ecc_ready <= 1'b1;
        @(posedge clk_sys);

        $display("[%0t] PASS: tb_header_ecc", $time);
        $finish;
    end

endmodule
