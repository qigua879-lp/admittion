`timescale 1ns/1ps

module frame_line_sync_fsm (
    input  logic        clk_sys,
    input  logic        rst_n,
    input  logic        clear_i,

    input  logic        event_valid,
    output logic        event_ready,
    input  logic [5:0]  event_dt,
    input  logic [1:0]  event_vc,

    output logic        frame_active,
    output logic        line_active,
    output logic        frame_start,
    output logic        frame_end,
    output logic        line_start,
    output logic        line_end,
    output logic [31:0] frame_cnt,
    output logic [31:0] line_cnt,
    // Frame-relative line index: resets to 0 on frame start, increments on each
    // line start (1-based within the frame). Unlike line_cnt (free-running over
    // the whole stream), this maps to the per-frame write-buffer slot, which is
    // what the recapture write-back needs so the loop works across frames.
    output logic [31:0] line_in_frame,
    output logic [1:0]  active_vc,
    output logic        sync_error
);

    localparam logic [5:0] DT_FS = 6'h00;
    localparam logic [5:0] DT_FE = 6'h01;
    localparam logic [5:0] DT_LS = 6'h02;
    localparam logic [5:0] DT_LE = 6'h03;

    logic event_fire;

    assign event_ready = 1'b1;
    assign event_fire  = event_valid && event_ready;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            frame_active <= 1'b0;
            line_active  <= 1'b0;
            frame_start  <= 1'b0;
            frame_end    <= 1'b0;
            line_start   <= 1'b0;
            line_end     <= 1'b0;
            frame_cnt    <= 32'd0;
            line_cnt     <= 32'd0;
            line_in_frame <= 32'd0;
            active_vc    <= 2'd0;
            sync_error   <= 1'b0;
        end else if (clear_i) begin
            frame_active <= 1'b0;
            line_active  <= 1'b0;
            frame_start  <= 1'b0;
            frame_end    <= 1'b0;
            line_start   <= 1'b0;
            line_end     <= 1'b0;
            active_vc    <= 2'd0;
            sync_error   <= 1'b0;
        end else begin
            frame_start <= 1'b0;
            frame_end   <= 1'b0;
            line_start  <= 1'b0;
            line_end    <= 1'b0;
            sync_error  <= 1'b0;

            if (event_fire) begin
                case (event_dt)
                    DT_FS: begin
                        if (frame_active) begin
                            sync_error <= 1'b1;
                        end
                        frame_active <= 1'b1;
                        line_active  <= 1'b0;
                        frame_start  <= 1'b1;
                        frame_cnt    <= frame_cnt + 32'd1;
                        line_in_frame <= 32'd0;
                        active_vc    <= event_vc;
                    end

                    DT_FE: begin
                        if (!frame_active || line_active) begin
                            sync_error <= 1'b1;
                        end
                        if (frame_active) begin
                            frame_end <= 1'b1;
                        end
                        frame_active <= 1'b0;
                        line_active  <= 1'b0;
                    end

                    DT_LS: begin
                        if (!frame_active || line_active) begin
                            sync_error <= 1'b1;
                        end else begin
                            line_active <= 1'b1;
                            line_start  <= 1'b1;
                            line_cnt    <= line_cnt + 32'd1;
                            line_in_frame <= line_in_frame + 32'd1;
                        end
                    end

                    DT_LE: begin
                        if (!frame_active || !line_active) begin
                            sync_error <= 1'b1;
                        end else begin
                            line_active <= 1'b0;
                            line_end    <= 1'b1;
                        end
                    end

                    default: begin
                        sync_error <= 1'b0;
                    end
                endcase
            end
        end
    end

endmodule
