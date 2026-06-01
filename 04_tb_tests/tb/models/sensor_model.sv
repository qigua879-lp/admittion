`timescale 1ns/1ps

module sensor_model #(
    parameter int        LANE_NUM  = 2,
    parameter logic [5:0] DATA_TYPE = csi2_reference_helpers_pkg::CSI2_DT_RAW8,
    parameter logic [1:0] VC_ID     = 2'd0,
    parameter bit        INCLUDE_CRC_TRAILER = 1'b0
) (
    input  logic                     clk_sys,
    input  logic                     rst_n,
    input  logic                     start_i,
    input  logic                     inject_header_ecc_error_i,
    input  logic                     inject_payload_error_i,

    output logic                     sp_valid_o,
    input  logic                     sp_ready_i,
    output logic [31:0]              sp_header_o,

    output logic [LANE_NUM-1:0]      lane_valid_o,
    input  logic [LANE_NUM-1:0]      lane_ready_i,
    output logic [LANE_NUM-1:0][7:0] lane_data_o,

    output logic                     exp_valid_o,
    input  logic                     exp_ready_i,
    output logic [23:0]              exp_pixel_data_o,
    output logic                     exp_pixel_sof_o,
    output logic                     exp_pixel_sol_o,

    output logic                     done_o
);

    localparam int PAYLOAD_BYTES = csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE);
    localparam int CRC_BYTES     = INCLUDE_CRC_TRAILER ? 2 : 0;
    localparam int TOTAL_BYTES   = PAYLOAD_BYTES + 4 + CRC_BYTES;
    localparam int PIXEL_COUNT   = csi2_reference_helpers_pkg::csi2_expected_pixel_count(DATA_TYPE);
    localparam logic [15:0] PAYLOAD_WORD_COUNT = PAYLOAD_BYTES;

    typedef enum logic [3:0] {
        ST_IDLE,
        ST_FS,
        ST_LS,
        ST_EXPECT,
        ST_LONG,
        ST_LE,
        ST_FE,
        ST_DONE
    } sensor_state_t;

    sensor_state_t state;
    int unsigned   long_byte_idx;
    int unsigned   exp_pixel_idx;
    logic [31:0]   long_header;
    logic          all_lane_ready;

    function automatic logic [7:0] long_stream_byte(input int unsigned idx);
        logic [7:0] payload_byte;
        logic [15:0] payload_crc;
        begin
            payload_crc = csi2_reference_helpers_pkg::csi2_payload_crc(DATA_TYPE);
            if (idx < 4) begin
                long_stream_byte = csi2_reference_helpers_pkg::csi2_packet_byte(long_header, idx);
            end else if (idx < (4 + PAYLOAD_BYTES)) begin
                payload_byte = csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, idx - 4);
                if (inject_payload_error_i && (idx == 4)) begin
                    payload_byte = payload_byte ^ 8'h01;
                end
                long_stream_byte = payload_byte;
            end else if (idx == (4 + PAYLOAD_BYTES)) begin
                long_stream_byte = payload_crc[7:0];
            end else if (idx == (5 + PAYLOAD_BYTES)) begin
                long_stream_byte = payload_crc[15:8];
            end else begin
                long_stream_byte = 8'h00;
            end
        end
    endfunction

    integer i;
    integer lane_idx;

    always_comb begin
        all_lane_ready = 1'b1;
        for (i = 0; i < LANE_NUM; i = i + 1) begin
            if (!lane_ready_i[i]) begin
                all_lane_ready = 1'b0;
            end
        end
    end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            state            <= ST_IDLE;
            sp_valid_o       <= 1'b0;
            sp_header_o      <= 32'd0;
            lane_valid_o     <= '0;
            lane_data_o      <= '0;
            exp_valid_o      <= 1'b0;
            exp_pixel_data_o <= 24'd0;
            exp_pixel_sof_o  <= 1'b0;
            exp_pixel_sol_o  <= 1'b0;
            done_o           <= 1'b0;
            long_byte_idx    <= 0;
            exp_pixel_idx    <= 0;
            long_header      <= 32'd0;
        end else begin
            done_o <= 1'b0;
            lane_valid_o <= '0;

            case (state)
                ST_IDLE: begin
                    sp_valid_o  <= 1'b0;
                    exp_valid_o <= 1'b0;
                    if (start_i) begin
                        sp_header_o <= csi2_reference_helpers_pkg::csi2_pack_header(
                            VC_ID,
                            csi2_reference_helpers_pkg::CSI2_DT_FS,
                            16'd0,
                            inject_header_ecc_error_i
                        );
                        sp_valid_o  <= 1'b1;
                        state       <= ST_FS;
                    end
                end

                ST_FS: begin
                    if (sp_valid_o && sp_ready_i) begin
                        sp_header_o <= csi2_reference_helpers_pkg::csi2_pack_header(
                            VC_ID,
                            csi2_reference_helpers_pkg::CSI2_DT_LS,
                            16'd0,
                            inject_header_ecc_error_i
                        );
                        sp_valid_o  <= 1'b1;
                        state       <= ST_LS;
                    end
                end

                ST_LS: begin
                    if (sp_valid_o && sp_ready_i) begin
                        sp_valid_o    <= 1'b0;
                        exp_pixel_idx <= 0;
                        state         <= ST_EXPECT;
                    end
                end

                ST_EXPECT: begin
                    if (!exp_valid_o || exp_ready_i) begin
                        exp_valid_o      <= 1'b1;
                        exp_pixel_data_o <= csi2_reference_helpers_pkg::csi2_expected_pixel(DATA_TYPE, exp_pixel_idx);
                        exp_pixel_sof_o  <= (exp_pixel_idx == 0);
                        exp_pixel_sol_o  <= (exp_pixel_idx == 0);
                        if (exp_pixel_idx == PIXEL_COUNT - 1) begin
                            exp_pixel_idx <= 0;
                            long_byte_idx <= 0;
                            long_header   <= csi2_reference_helpers_pkg::csi2_pack_header(
                                VC_ID,
                                DATA_TYPE,
                                PAYLOAD_WORD_COUNT,
                                inject_header_ecc_error_i
                            );
                            state <= ST_LONG;
                        end else begin
                            exp_pixel_idx <= exp_pixel_idx + 1;
                        end
                    end
                end

                ST_LONG: begin
                    exp_valid_o <= 1'b0;
                    if (all_lane_ready) begin
                        for (lane_idx = 0; lane_idx < LANE_NUM; lane_idx = lane_idx + 1) begin
                            lane_valid_o[lane_idx] <= 1'b1;
                            lane_data_o[lane_idx]  <= long_stream_byte(long_byte_idx + lane_idx);
                        end

                        if (long_byte_idx + LANE_NUM >= TOTAL_BYTES) begin
                            long_byte_idx <= 0;
                            sp_header_o   <= csi2_reference_helpers_pkg::csi2_pack_header(
                                VC_ID,
                                csi2_reference_helpers_pkg::CSI2_DT_LE,
                                16'd0,
                                inject_header_ecc_error_i
                            );
                            sp_valid_o    <= 1'b1;
                            state         <= ST_LE;
                        end else begin
                            long_byte_idx <= long_byte_idx + LANE_NUM;
                        end
                    end
                end

                ST_LE: begin
                    if (sp_valid_o && sp_ready_i) begin
                        sp_header_o <= csi2_reference_helpers_pkg::csi2_pack_header(
                            VC_ID,
                            csi2_reference_helpers_pkg::CSI2_DT_FE,
                            16'd0,
                            inject_header_ecc_error_i
                        );
                        sp_valid_o  <= 1'b1;
                        state       <= ST_FE;
                    end
                end

                ST_FE: begin
                    if (sp_valid_o && sp_ready_i) begin
                        sp_valid_o <= 1'b0;
                        state      <= ST_DONE;
                    end
                end

                ST_DONE: begin
                    done_o <= 1'b1;
                    state  <= ST_IDLE;
                end

                default: begin
                    state <= ST_IDLE;
                end
            endcase
        end
    end

endmodule
