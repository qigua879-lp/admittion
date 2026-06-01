`timescale 1ns/1ps

module tb_resync_ctrl;

    logic clk_sys;
    logic rst_n;

    logic enable_resync_i;
    logic sync_error_i;
    logic resync_ack_i;
    logic resync_req_o;
    logic drop_packet_o;
    logic resync_busy_o;
    logic resync_done_o;

    logic       enable_degrade_i;
    logic       lane_error_i;
    logic       good_frame_i;
    logic       degraded_o;
    logic       recovering_o;
    logic [2:0] active_lane_num_o;

    resync_ctrl_fsm u_resync (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .enable_resync_i(enable_resync_i),
        .sync_error_i(sync_error_i),
        .resync_ack_i(resync_ack_i),
        .resync_req_o(resync_req_o),
        .drop_packet_o(drop_packet_o),
        .resync_busy_o(resync_busy_o),
        .resync_done_o(resync_done_o)
    );

    degrade_recover_fsm #(
        .FULL_LANE_NUM(4),
        .DEGRADED_LANE_NUM(2),
        .RECOVER_GOOD_FRAME_TH(2)
    ) u_degrade (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .enable_degrade_i(enable_degrade_i),
        .lane_error_i(lane_error_i),
        .good_frame_i(good_frame_i),
        .degraded_o(degraded_o),
        .recovering_o(recovering_o),
        .active_lane_num_o(active_lane_num_o)
    );

    initial clk_sys = 1'b0;
    always #5 clk_sys = ~clk_sys;

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    task automatic apply_reset;
        begin
            rst_n            = 1'b0;
            enable_resync_i  = 1'b0;
            sync_error_i     = 1'b0;
            resync_ack_i     = 1'b0;
            enable_degrade_i = 1'b0;
            lane_error_i     = 1'b0;
            good_frame_i     = 1'b0;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic pulse_sync_error;
        begin
            @(negedge clk_sys);
            sync_error_i = 1'b1;
            @(posedge clk_sys);
            #1;
            sync_error_i = 1'b0;
        end
    endtask

    task automatic pulse_lane_error;
        begin
            @(negedge clk_sys);
            lane_error_i = 1'b1;
            @(posedge clk_sys);
            #1;
            lane_error_i = 1'b0;
        end
    endtask

    task automatic pulse_good_frame;
        begin
            @(negedge clk_sys);
            good_frame_i = 1'b1;
            @(posedge clk_sys);
            #1;
            good_frame_i = 1'b0;
        end
    endtask

    initial begin
        apply_reset();

        enable_resync_i = 1'b0;
        pulse_sync_error();
        if (resync_req_o || resync_busy_o || drop_packet_o) begin
            fail("disabled resync still requested");
        end

        enable_resync_i = 1'b1;
        pulse_sync_error();
        if (!resync_req_o || !resync_busy_o || !drop_packet_o) begin
            fail("resync request was not asserted");
        end

        @(negedge clk_sys);
        resync_ack_i = 1'b1;
        @(posedge clk_sys);
        #1;
        resync_ack_i = 1'b0;
        if (resync_req_o || resync_busy_o || drop_packet_o || !resync_done_o) begin
            fail("resync ack did not complete request");
        end

        enable_degrade_i = 1'b1;
        pulse_lane_error();
        if (!degraded_o || active_lane_num_o !== 3'd2) begin
            fail("lane error did not enter degraded mode");
        end

        pulse_good_frame();
        if (!degraded_o || !recovering_o || active_lane_num_o !== 3'd2) begin
            fail("first good frame did not enter recovering state");
        end

        pulse_good_frame();
        if (degraded_o || recovering_o || active_lane_num_o !== 3'd4) begin
            fail("good frame threshold did not recover full lanes");
        end

        $display("[%0t] PASS: tb_resync_ctrl", $time);
        $finish;
    end

endmodule
