`timescale 1ns/1ps

// Line-level recapture write-back controller.
//
// Closes the loop that retry_request_ctrl only opened: retry_request_ctrl
// locates the errored line and raises retry_pending; this block translates an
// outstanding LINE-level request, together with a controllable image source
// that re-sends that line, into a write-back command for pixel_to_axi_writer so
// the corrected line overwrites its original slot in the frame buffer.
//
// Feasibility precondition (single-directional CSI-2 link has no inherent
// retransmit): the upstream source must be controllable and must signal, via
// src_recap_line_valid_i, that the line currently being streamed is the
// re-sent recapture line. recap_line_id_o then addresses the located slot.
//
// Frame-level requests (retry_mode_i == 0) are intentionally NOT handled here:
// they fall back to the existing drop-and-wait-next-frame path. The innovation
// is deliberately concentrated on the line level.
module recapture_writeback_ctrl (
    input  logic        clk_sys,
    input  logic        rst_n,

    // From retry_request_ctrl
    input  logic        retry_pending_i,
    input  logic        retry_mode_i,        // 1 = line recapture, 0 = frame
    input  logic [31:0] retry_line_id_i,

    // From the controllable image source (recapture line being streamed)
    input  logic        src_recap_line_valid_i,
    // Line-end strobe of the line currently passing (from frame_line_sync_fsm)
    input  logic        line_end_i,

    // To pixel_to_axi_writer recapture write-back port
    output logic        recap_active_o,
    output logic [15:0] recap_line_id_o,

    // Back to retry_request_ctrl ack: clears retry_pending once the recapture
    // line has been written back.
    output logic        retry_ack_o
);

    // A recapture write-back is armed only when all three hold: there is an
    // outstanding line-level request, and the source is actively re-sending the
    // recapture line. This triple gate rejects stray source pulses.
    assign recap_active_o  = retry_pending_i && retry_mode_i && src_recap_line_valid_i;

    // Index-basis conversion: the located line index (retry_line_id) follows the
    // sync FSM line count, which is 1-based within the (first) frame, whereas the
    // AXI writer addresses frame-buffer slots 0-based. Map to the writer slot so
    // the corrected line overwrites the dropped line's slot. (Guarded against
    // underflow; valid for the in-frame recapture case.)
    assign recap_line_id_o = (retry_line_id_i == 32'd0) ? 16'd0
                                                        : retry_line_id_i[15:0] - 16'd1;

    // The recapture line is committed at its line-end; pulse ack to release the
    // pending request. line_end_i is a one-cycle strobe, so this is one pulse.
    assign retry_ack_o     = recap_active_o && line_end_i;

endmodule
