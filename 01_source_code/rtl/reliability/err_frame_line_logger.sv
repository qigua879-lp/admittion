`timescale 1ns/1ps

module err_frame_line_logger (
    input  logic        clk_sys,
    input  logic        rst_n,

    input  logic        clear_i,

    input  logic        err_valid_i,
    output logic        err_ready_o,
    input  logic [2:0]  err_type_i,
    input  logic [1:0]  err_priority_i,
    input  logic [31:0] frame_id_i,
    input  logic [31:0] line_id_i,
    input  logic [1:0]  vc_i,
    input  logic [5:0]  dt_i,

    output logic        err_pending_o,
    output logic [2:0]  last_err_type_o,
    output logic [1:0]  last_err_priority_o,
    output logic [31:0] last_frame_id_o,
    output logic [31:0] last_line_id_o,
    output logic [1:0]  last_vc_o,
    output logic [5:0]  last_dt_o,

    output logic [31:0] total_err_cnt_o,
    output logic [31:0] ecc_err_cnt_o,
    output logic [31:0] crc_err_cnt_o,
    output logic [31:0] sync_err_cnt_o,
    output logic [31:0] lane_err_cnt_o
);

    localparam logic [2:0] ERR_TYPE_ECC  = 3'd1;
    localparam logic [2:0] ERR_TYPE_CRC  = 3'd2;
    localparam logic [2:0] ERR_TYPE_SYNC = 3'd3;
    localparam logic [2:0] ERR_TYPE_LANE = 3'd4;

    assign err_ready_o = 1'b1;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            err_pending_o       <= 1'b0;
            last_err_type_o     <= 3'd0;
            last_err_priority_o <= 2'd0;
            last_frame_id_o     <= 32'd0;
            last_line_id_o      <= 32'd0;
            last_vc_o           <= 2'd0;
            last_dt_o           <= 6'd0;
            total_err_cnt_o     <= 32'd0;
            ecc_err_cnt_o       <= 32'd0;
            crc_err_cnt_o       <= 32'd0;
            sync_err_cnt_o      <= 32'd0;
            lane_err_cnt_o      <= 32'd0;
        end else begin
            if (clear_i) begin
                err_pending_o <= 1'b0;
            end

            if (err_valid_i && err_ready_o) begin
                err_pending_o       <= 1'b1;
                last_err_type_o     <= err_type_i;
                last_err_priority_o <= err_priority_i;
                last_frame_id_o     <= frame_id_i;
                last_line_id_o      <= line_id_i;
                last_vc_o           <= vc_i;
                last_dt_o           <= dt_i;
                total_err_cnt_o     <= total_err_cnt_o + 32'd1;

                case (err_type_i)
                    ERR_TYPE_ECC:  ecc_err_cnt_o  <= ecc_err_cnt_o + 32'd1;
                    ERR_TYPE_CRC:  crc_err_cnt_o  <= crc_err_cnt_o + 32'd1;
                    ERR_TYPE_SYNC: sync_err_cnt_o <= sync_err_cnt_o + 32'd1;
                    ERR_TYPE_LANE: lane_err_cnt_o <= lane_err_cnt_o + 32'd1;
                    default: begin
                    end
                endcase
            end
        end
    end

endmodule
