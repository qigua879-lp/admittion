`timescale 1ns/1ps

module err_classifier (
    input  logic        clk_sys,
    input  logic        rst_n,

    input  logic        err_ecc_i,
    input  logic        err_crc_i,
    input  logic        err_sync_i,
    input  logic        err_lane_i,
    input  logic [31:0] frame_id_i,
    input  logic [31:0] line_id_i,
    input  logic [1:0]  vc_i,
    input  logic [5:0]  dt_i,

    output logic        err_valid_o,
    input  logic        err_ready_i,
    output logic [2:0]  err_type_o,
    output logic [1:0]  err_priority_o,
    output logic [31:0] frame_id_o,
    output logic [31:0] line_id_o,
    output logic [1:0]  vc_o,
    output logic [5:0]  dt_o,

    output logic [31:0] err_cnt_ecc_o,
    output logic [31:0] err_cnt_crc_o,
    output logic [31:0] err_cnt_sync_o,
    output logic [31:0] err_cnt_lane_o
);

    localparam logic [2:0] ERR_TYPE_NONE = 3'd0;
    localparam logic [2:0] ERR_TYPE_ECC  = 3'd1;
    localparam logic [2:0] ERR_TYPE_CRC  = 3'd2;
    localparam logic [2:0] ERR_TYPE_SYNC = 3'd3;
    localparam logic [2:0] ERR_TYPE_LANE = 3'd4;

    logic any_err;

    assign any_err = err_ecc_i || err_crc_i || err_sync_i || err_lane_i;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            err_valid_o    <= 1'b0;
            err_type_o     <= ERR_TYPE_NONE;
            err_priority_o <= 2'd0;
            frame_id_o     <= 32'd0;
            line_id_o      <= 32'd0;
            vc_o           <= 2'd0;
            dt_o           <= 6'd0;
            err_cnt_ecc_o  <= 32'd0;
            err_cnt_crc_o  <= 32'd0;
            err_cnt_sync_o <= 32'd0;
            err_cnt_lane_o <= 32'd0;
        end else begin
            if (err_ecc_i) begin
                err_cnt_ecc_o <= err_cnt_ecc_o + 32'd1;
            end
            if (err_crc_i) begin
                err_cnt_crc_o <= err_cnt_crc_o + 32'd1;
            end
            if (err_sync_i) begin
                err_cnt_sync_o <= err_cnt_sync_o + 32'd1;
            end
            if (err_lane_i) begin
                err_cnt_lane_o <= err_cnt_lane_o + 32'd1;
            end

            if ((!err_valid_o || err_ready_i) && any_err) begin
                err_valid_o <= 1'b1;
                frame_id_o  <= frame_id_i;
                line_id_o   <= line_id_i;
                vc_o        <= vc_i;
                dt_o        <= dt_i;

                if (err_sync_i) begin
                    err_type_o     <= ERR_TYPE_SYNC;
                    err_priority_o <= 2'd3;
                end else if (err_lane_i) begin
                    err_type_o     <= ERR_TYPE_LANE;
                    err_priority_o <= 2'd2;
                end else if (err_crc_i) begin
                    err_type_o     <= ERR_TYPE_CRC;
                    err_priority_o <= 2'd1;
                end else begin
                    err_type_o     <= ERR_TYPE_ECC;
                    err_priority_o <= 2'd0;
                end
            end else if (err_valid_o && err_ready_i) begin
                err_valid_o <= 1'b0;
            end
        end
    end

endmodule
