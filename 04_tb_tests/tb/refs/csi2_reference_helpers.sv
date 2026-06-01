`timescale 1ns/1ps

package csi2_reference_helpers_pkg;

    localparam logic [5:0] CSI2_DT_FS     = 6'h00;
    localparam logic [5:0] CSI2_DT_FE     = 6'h01;
    localparam logic [5:0] CSI2_DT_LS     = 6'h02;
    localparam logic [5:0] CSI2_DT_LE     = 6'h03;
    localparam logic [5:0] CSI2_DT_RGB888 = 6'h24;
    localparam logic [5:0] CSI2_DT_RAW8   = 6'h2a;

    function automatic logic [5:0] csi2_header_ecc(input logic [23:0] data);
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
            csi2_header_ecc = ecc;
        end
    endfunction

    function automatic logic [31:0] csi2_pack_header(
        input logic [1:0]  vc,
        input logic [5:0]  dt,
        input logic [15:0] word_count,
        input logic        inject_ecc_error
    );
        logic [23:0] hdr_data;
        logic [5:0]  ecc;
        begin
            hdr_data = {word_count[15:8], word_count[7:0], vc, dt};
            ecc = csi2_header_ecc(hdr_data);
            if (inject_ecc_error) begin
                ecc = ecc ^ 6'h01;
            end
            csi2_pack_header = {2'b00, ecc, hdr_data};
        end
    endfunction

    function automatic logic [7:0] csi2_packet_byte(
        input logic [31:0] header,
        input int unsigned byte_idx
    );
        begin
            case (byte_idx)
                0: csi2_packet_byte = header[7:0];
                1: csi2_packet_byte = header[15:8];
                2: csi2_packet_byte = header[23:16];
                3: csi2_packet_byte = {2'b00, header[29:24]};
                default: csi2_packet_byte = 8'h00;
            endcase
        end
    endfunction

    function automatic int unsigned csi2_payload_byte_count(input logic [5:0] dt);
        begin
            if (dt == CSI2_DT_RGB888) begin
                csi2_payload_byte_count = 12;
            end else begin
                csi2_payload_byte_count = 4;
            end
        end
    endfunction

    function automatic int unsigned csi2_expected_pixel_count(input logic [5:0] dt);
        begin
            if (dt == CSI2_DT_RGB888) begin
                csi2_expected_pixel_count = 4;
            end else begin
                csi2_expected_pixel_count = 4;
            end
        end
    endfunction

    function automatic logic [7:0] csi2_payload_byte(input logic [5:0] dt, input int unsigned byte_idx);
        begin
            if (dt == CSI2_DT_RGB888) begin
                case (byte_idx)
                    0:  csi2_payload_byte = 8'h10;
                    1:  csi2_payload_byte = 8'h20;
                    2:  csi2_payload_byte = 8'h30;
                    3:  csi2_payload_byte = 8'h11;
                    4:  csi2_payload_byte = 8'h21;
                    5:  csi2_payload_byte = 8'h31;
                    6:  csi2_payload_byte = 8'h12;
                    7:  csi2_payload_byte = 8'h22;
                    8:  csi2_payload_byte = 8'h32;
                    9:  csi2_payload_byte = 8'h13;
                    10: csi2_payload_byte = 8'h23;
                    11: csi2_payload_byte = 8'h33;
                    default: csi2_payload_byte = 8'h00;
                endcase
            end else begin
                case (byte_idx)
                    0: csi2_payload_byte = 8'h11;
                    1: csi2_payload_byte = 8'h22;
                    2: csi2_payload_byte = 8'h33;
                    3: csi2_payload_byte = 8'h44;
                    default: csi2_payload_byte = 8'h00;
                endcase
            end
        end
    endfunction

    function automatic logic [15:0] csi2_crc16_next_byte(
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
            csi2_crc16_next_byte = crc_tmp;
        end
    endfunction

    function automatic logic [15:0] csi2_payload_crc(input logic [5:0] dt);
        logic [15:0] crc;
        int unsigned byte_idx;
        begin
            crc = 16'hffff;
            for (byte_idx = 0; byte_idx < csi2_payload_byte_count(dt); byte_idx = byte_idx + 1) begin
                crc = csi2_crc16_next_byte(crc, csi2_payload_byte(dt, byte_idx));
            end
            csi2_payload_crc = crc;
        end
    endfunction

    function automatic logic [23:0] csi2_expected_pixel(input logic [5:0] dt, input int unsigned pixel_idx);
        begin
            if (dt == CSI2_DT_RGB888) begin
                csi2_expected_pixel = {
                    csi2_payload_byte(dt, pixel_idx * 3),
                    csi2_payload_byte(dt, pixel_idx * 3 + 1),
                    csi2_payload_byte(dt, pixel_idx * 3 + 2)
                };
            end else begin
                csi2_expected_pixel = {16'd0, csi2_payload_byte(dt, pixel_idx)};
            end
        end
    endfunction

endpackage
