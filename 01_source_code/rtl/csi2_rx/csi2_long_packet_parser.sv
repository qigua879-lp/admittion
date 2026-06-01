`timescale 1ns/1ps

module csi2_long_packet_parser #(
    parameter bit ENABLE_CRC_TRAILER = 1'b0
) (
    input  logic        clk_sys,
    input  logic        rst_n,
    input  logic        clear_i,

    input  logic        byte_valid,
    output logic        byte_ready,
    input  logic [7:0]  byte_data,

    output logic        hdr_valid,
    input  logic        hdr_ready,
    output logic [1:0]  vc,
    output logic [5:0]  dt,
    output logic [15:0] word_count,
    output logic        ecc_ok,
    output logic        ecc_correctable,
    output logic [5:0]  ecc_syndrome,

    output logic        payload_valid,
    input  logic        payload_ready,
    output logic [7:0]  payload_data,
    output logic        payload_start,
    output logic        payload_end,

    output logic        expected_crc_valid,
    input  logic        expected_crc_ready,
    output logic [15:0] expected_crc,

    output logic        parser_busy,
    output logic        packet_done
);

    localparam logic [2:0] ST_HDR0     = 3'd0;
    localparam logic [2:0] ST_HDR1     = 3'd1;
    localparam logic [2:0] ST_HDR2     = 3'd2;
    localparam logic [2:0] ST_HDR3     = 3'd3;
    localparam logic [2:0] ST_ECC_REQ  = 3'd4;
    localparam logic [2:0] ST_WAIT_ECC = 3'd5;
    localparam logic [2:0] ST_HDR_OUT  = 3'd6;
    localparam logic [2:0] ST_PAYLOAD  = 3'd7;
    localparam logic [3:0] ST_CRC0     = 4'd8;
    localparam logic [3:0] ST_CRC1     = 4'd9;

    logic [3:0]  state;
    logic [23:0] header_data_reg;
    logic [5:0]  header_ecc_reg;
    logic [15:0] payload_cnt;
    logic [7:0]  crc_lsb_reg;

    logic        ecc_hdr_valid;
    logic        ecc_hdr_ready;
    logic        ecc_valid;
    logic        ecc_ready;
    logic [5:0]  ecc_calc_unused;
    logic        ecc_error;
    logic        byte_fire;
    logic        payload_fire;
    logic        payload_last_byte;

    csi2_header_ecc_checker u_header_ecc_checker (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .hdr_valid(ecc_hdr_valid),
        .hdr_ready(ecc_hdr_ready),
        .hdr_data(header_data_reg),
        .hdr_ecc(header_ecc_reg),
        .ecc_valid(ecc_valid),
        .ecc_ready(ecc_ready),
        .ecc_calc(ecc_calc_unused),
        .ecc_syndrome(ecc_syndrome),
        .ecc_error(ecc_error),
        .ecc_correctable(ecc_correctable)
    );

    assign byte_ready = ((state == ST_HDR0) ||
                         (state == ST_HDR1) ||
                         (state == ST_HDR2) ||
                         (state == ST_HDR3)) ? 1'b1 :
                        ((state == ST_PAYLOAD) ? payload_ready :
                         (state == ST_CRC0)    ? 1'b1 :
                         (state == ST_CRC1)    ? expected_crc_ready :
                                                  1'b0);

    assign byte_fire         = byte_valid && byte_ready;
    assign payload_fire      = byte_valid && byte_ready && (state == ST_PAYLOAD);
    assign payload_last_byte = (payload_cnt == (word_count - 16'd1));

    assign ecc_hdr_valid = (state == ST_ECC_REQ);
    assign ecc_ready     = (state == ST_WAIT_ECC);

    assign hdr_valid     = (state == ST_HDR_OUT);
    assign payload_valid = byte_valid && (state == ST_PAYLOAD);
    assign payload_data  = byte_data;
    assign payload_start = payload_valid && (payload_cnt == 16'd0);
    assign payload_end   = payload_valid && payload_last_byte;
    assign expected_crc_valid = byte_valid && (state == ST_CRC1);
    assign expected_crc       = {byte_data, crc_lsb_reg};
    assign parser_busy   = (state != ST_HDR0);

    always_ff @(posedge clk_sys) begin
        if (!rst_n || clear_i) begin
            state           <= ST_HDR0;
            header_data_reg <= 24'd0;
            header_ecc_reg  <= 6'd0;
            vc              <= 2'd0;
            dt              <= 6'd0;
            word_count      <= 16'd0;
            ecc_ok          <= 1'b0;
            payload_cnt     <= 16'd0;
            crc_lsb_reg     <= 8'd0;
            packet_done     <= 1'b0;
        end else begin
            packet_done <= 1'b0;

            case (state)
                ST_HDR0: begin
                    payload_cnt <= 16'd0;
                    if (byte_fire) begin
                        header_data_reg[7:0] <= byte_data;
                        state                <= ST_HDR1;
                    end
                end

                ST_HDR1: begin
                    if (byte_fire) begin
                        header_data_reg[15:8] <= byte_data;
                        state                 <= ST_HDR2;
                    end
                end

                ST_HDR2: begin
                    if (byte_fire) begin
                        header_data_reg[23:16] <= byte_data;
                        state                  <= ST_HDR3;
                    end
                end

                ST_HDR3: begin
                    if (byte_fire) begin
                        header_ecc_reg <= byte_data[5:0];
                        state          <= ST_ECC_REQ;
                    end
                end

                ST_ECC_REQ: begin
                    if (ecc_hdr_ready) begin
                        state <= ST_WAIT_ECC;
                    end
                end

                ST_WAIT_ECC: begin
                    if (ecc_valid) begin
                        vc         <= header_data_reg[7:6];
                        dt         <= header_data_reg[5:0];
                        word_count <= header_data_reg[23:8];
                        ecc_ok     <= !ecc_error;
                        state      <= ST_HDR_OUT;
                    end
                end

                ST_HDR_OUT: begin
                    if (hdr_ready) begin
                        payload_cnt <= 16'd0;
                        if (word_count == 16'd0) begin
                            packet_done <= 1'b1;
                            state       <= ST_HDR0;
                        end else begin
                            state <= ST_PAYLOAD;
                        end
                    end
                end

                ST_PAYLOAD: begin
                    if (payload_fire) begin
                        if (payload_last_byte) begin
                            payload_cnt <= 16'd0;
                            if (ENABLE_CRC_TRAILER) begin
                                state <= ST_CRC0;
                            end else begin
                                packet_done <= 1'b1;
                                state       <= ST_HDR0;
                            end
                        end else begin
                            payload_cnt <= payload_cnt + 16'd1;
                        end
                    end
                end

                ST_CRC0: begin
                    if (byte_fire) begin
                        crc_lsb_reg <= byte_data;
                        state       <= ST_CRC1;
                    end
                end

                ST_CRC1: begin
                    if (byte_fire) begin
                        packet_done <= 1'b1;
                        state       <= ST_HDR0;
                    end
                end

                default: begin
                    state <= ST_HDR0;
                end
            endcase
        end
    end

endmodule
