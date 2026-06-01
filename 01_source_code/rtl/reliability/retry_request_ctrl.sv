`timescale 1ns/1ps

// Captures the latest error context and raises a retry request pulse for the
// upstream control path. retry_mode_o: 0 = frame retry, 1 = line retry.
module retry_request_ctrl (
    input  logic        clk_sys,
    input  logic        rst_n,

    input  logic        clear_i,
    input  logic        ack_i,

    input  logic        cfg_enable_retry_i,
    input  logic        cfg_retry_line_mode_i,

    input  logic        err_valid_i,
    input  logic [2:0]  err_type_i,
    input  logic [31:0] frame_id_i,
    input  logic [31:0] line_id_i,
    input  logic [1:0]  vc_i,
    input  logic [5:0]  dt_i,

    output logic        retry_req_o,
    output logic        retry_pending_o,
    output logic        retry_mode_o,
    output logic [2:0]  retry_err_type_o,
    output logic [31:0] retry_frame_id_o,
    output logic [31:0] retry_line_id_o,
    output logic [1:0]  retry_vc_o,
    output logic [5:0]  retry_dt_o
);

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            retry_req_o      <= 1'b0;
            retry_pending_o  <= 1'b0;
            retry_mode_o     <= 1'b0;
            retry_err_type_o <= 3'd0;
            retry_frame_id_o <= 32'd0;
            retry_line_id_o  <= 32'd0;
            retry_vc_o       <= 2'd0;
            retry_dt_o       <= 6'd0;
        end else begin
            retry_req_o <= 1'b0;

            if (clear_i) begin
                retry_pending_o <= 1'b0;
            end else if (ack_i) begin
                retry_pending_o <= 1'b0;
            end

            if (cfg_enable_retry_i && err_valid_i) begin
                retry_req_o      <= 1'b1;
                retry_pending_o  <= 1'b1;
                retry_mode_o     <= cfg_retry_line_mode_i;
                retry_err_type_o <= err_type_i;
                retry_frame_id_o <= frame_id_i;
                retry_line_id_o  <= line_id_i;
                retry_vc_o       <= vc_i;
                retry_dt_o       <= dt_i;
            end
        end
    end

endmodule
