`timescale 1ns/1ps

module resync_ctrl_fsm (
    input  logic clk_sys,
    input  logic rst_n,

    input  logic enable_resync_i,
    input  logic sync_error_i,
    input  logic resync_ack_i,

    output logic resync_req_o,
    output logic drop_packet_o,
    output logic resync_busy_o,
    output logic resync_done_o
);

    localparam logic STATE_IDLE = 1'b0;
    localparam logic STATE_REQ  = 1'b1;

    logic state;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            state         <= STATE_IDLE;
            resync_req_o  <= 1'b0;
            drop_packet_o <= 1'b0;
            resync_busy_o <= 1'b0;
            resync_done_o <= 1'b0;
        end else begin
            resync_done_o <= 1'b0;

            case (state)
                STATE_IDLE: begin
                    resync_req_o  <= 1'b0;
                    drop_packet_o <= 1'b0;
                    resync_busy_o <= 1'b0;
                    if (enable_resync_i && sync_error_i) begin
                        resync_req_o  <= 1'b1;
                        drop_packet_o <= 1'b1;
                        resync_busy_o <= 1'b1;
                        state         <= STATE_REQ;
                    end
                end

                STATE_REQ: begin
                    resync_req_o  <= 1'b1;
                    drop_packet_o <= 1'b1;
                    resync_busy_o <= 1'b1;
                    if (resync_ack_i) begin
                        resync_req_o  <= 1'b0;
                        drop_packet_o <= 1'b0;
                        resync_busy_o <= 1'b0;
                        resync_done_o <= 1'b1;
                        state         <= STATE_IDLE;
                    end
                end

                default: begin
                    state <= STATE_IDLE;
                end
            endcase
        end
    end

endmodule
