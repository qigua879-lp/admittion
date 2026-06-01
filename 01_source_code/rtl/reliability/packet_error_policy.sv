`timescale 1ns/1ps

// Packet-level policy helper. It currently provides a synthesizable effect for
// bad-ECC long packets and a CRC drop request pulse that can be consumed by a
// future line-buffer-aware discard path.
module packet_error_policy (
    input  logic        clk_sys,
    input  logic        rst_n,

    input  logic        cfg_mark_ecc_error_i,
    input  logic        cfg_drop_on_crc_error_i,

    input  logic        hdr_valid_i,
    input  logic        hdr_ready_i,
    input  logic [15:0] pkt_word_count_i,
    input  logic        pkt_ecc_ok_i,
    input  logic        packet_done_i,
    input  logic        crc_error_i,

    input  logic        resync_drop_packet_i,
    input  logic        unsupported_dt_i,

    output logic        payload_drop_o,
    output logic        crc_drop_req_o
);

    logic drop_due_ecc_q;
    logic long_packet_hdr_fire;

    assign long_packet_hdr_fire = hdr_valid_i && hdr_ready_i && (pkt_word_count_i != 16'd0);
    assign crc_drop_req_o       = cfg_drop_on_crc_error_i && crc_error_i;
    assign payload_drop_o       = resync_drop_packet_i || unsupported_dt_i || drop_due_ecc_q;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            drop_due_ecc_q <= 1'b0;
        end else begin
            if (packet_done_i) begin
                drop_due_ecc_q <= 1'b0;
            end

            if (long_packet_hdr_fire) begin
                drop_due_ecc_q <= cfg_mark_ecc_error_i && !pkt_ecc_ok_i;
            end
        end
    end

endmodule
