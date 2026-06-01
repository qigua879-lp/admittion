`timescale 1ns/1ps

module csi2_header_ecc_checker (
    input  logic        clk_sys,
    input  logic        rst_n,

    input  logic        hdr_valid,
    output logic        hdr_ready,
    input  logic [23:0] hdr_data,
    input  logic [5:0]  hdr_ecc,

    output logic        ecc_valid,
    input  logic        ecc_ready,
    output logic [5:0]  ecc_calc,
    output logic [5:0]  ecc_syndrome,
    output logic        ecc_error,
    output logic        ecc_correctable
);

    logic [5:0] calc_next;
    logic [5:0] syndrome_next;

    function automatic logic [5:0] calc_csi2_header_ecc(
        input logic [23:0] data
    );
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
            calc_csi2_header_ecc = ecc;
        end
    endfunction

    function automatic logic syndrome_is_single_bit_error(
        input logic [5:0] syndrome
    );
        begin
            case (syndrome)
                6'h01, 6'h02, 6'h04, 6'h08, 6'h10, 6'h20,
                6'h07, 6'h0b, 6'h0d, 6'h0e, 6'h13, 6'h15,
                6'h16, 6'h19, 6'h1a, 6'h1c, 6'h23, 6'h25, 6'h26,
                6'h29, 6'h2a, 6'h2c, 6'h31, 6'h32, 6'h34,
                6'h38, 6'h1f, 6'h2f, 6'h37, 6'h3b:
                    syndrome_is_single_bit_error = 1'b1;
                default:
                    syndrome_is_single_bit_error = 1'b0;
            endcase
        end
    endfunction

    assign hdr_ready = !ecc_valid || ecc_ready;
    assign calc_next = calc_csi2_header_ecc(hdr_data);
    assign syndrome_next = calc_next ^ hdr_ecc;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            ecc_valid       <= 1'b0;
            ecc_calc        <= 6'd0;
            ecc_syndrome    <= 6'd0;
            ecc_error       <= 1'b0;
            ecc_correctable <= 1'b0;
        end else begin
            if (hdr_valid && hdr_ready) begin
                ecc_valid       <= 1'b1;
                ecc_calc        <= calc_next;
                ecc_syndrome    <= syndrome_next;
                ecc_error       <= (syndrome_next != 6'd0);
                ecc_correctable <= syndrome_is_single_bit_error(syndrome_next);
            end else if (ecc_ready) begin
                ecc_valid <= 1'b0;
            end
        end
    end

endmodule
