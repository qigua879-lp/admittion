`timescale 1ns/1ps

module tb_frame_line_sync;

    localparam logic [5:0] DT_FS = 6'h00;
    localparam logic [5:0] DT_FE = 6'h01;
    localparam logic [5:0] DT_LS = 6'h02;
    localparam logic [5:0] DT_LE = 6'h03;

    logic        clk_sys;
    logic        rst_n;
    logic        clear_i;
    logic        event_valid;
    logic        event_ready;
    logic [5:0]  event_dt;
    logic [1:0]  event_vc;
    logic        frame_active;
    logic        line_active;
    logic        frame_start;
    logic        frame_end;
    logic        line_start;
    logic        line_end;
    logic [31:0] frame_cnt;
    logic [31:0] line_cnt;
    logic [1:0]  active_vc;
    logic        sync_error;

    frame_line_sync_fsm dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .event_valid(event_valid),
        .event_ready(event_ready),
        .event_dt(event_dt),
        .event_vc(event_vc),
        .frame_active(frame_active),
        .line_active(line_active),
        .frame_start(frame_start),
        .frame_end(frame_end),
        .line_start(line_start),
        .line_end(line_end),
        .frame_cnt(frame_cnt),
        .line_cnt(line_cnt),
        .active_vc(active_vc),
        .sync_error(sync_error)
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
            rst_n       = 1'b0;
            clear_i     = 1'b0;
            event_valid = 1'b0;
            event_dt    = 6'd0;
            event_vc    = 2'd0;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic send_event(input logic [5:0] dt, input logic [1:0] vc);
        begin
            @(negedge clk_sys);
            event_valid = 1'b1;
            event_dt    = dt;
            event_vc    = vc;
            @(posedge clk_sys);
            #1;
            event_valid = 1'b0;
        end
    endtask

    initial begin
        apply_reset();

        send_event(DT_FS, 2'd1);
        if (!frame_start || !frame_active || line_active || frame_cnt !== 32'd1 || active_vc !== 2'd1 || sync_error) begin
            fail("FS normal transition failed");
        end

        send_event(DT_LS, 2'd1);
        if (!line_start || !frame_active || !line_active || line_cnt !== 32'd1 || sync_error) begin
            fail("LS normal transition failed");
        end

        send_event(DT_LE, 2'd1);
        if (!line_end || !frame_active || line_active || sync_error) begin
            fail("LE normal transition failed");
        end

        send_event(DT_FE, 2'd1);
        if (!frame_end || frame_active || line_active || sync_error) begin
            fail("FE normal transition failed");
        end

        send_event(DT_LS, 2'd0);
        if (!sync_error || line_start || line_active) begin
            fail("LS outside frame did not raise sync_error");
        end

        send_event(DT_FE, 2'd0);
        if (!sync_error || frame_end || frame_active) begin
            fail("FE outside frame did not raise sync_error");
        end

        send_event(DT_FS, 2'd2);
        if (!frame_start || !frame_active || sync_error) begin
            fail("FS after errors failed");
        end

        send_event(DT_FS, 2'd2);
        if (!sync_error || !frame_start || !frame_active) begin
            fail("duplicate FS did not raise sync_error");
        end

        send_event(DT_LS, 2'd2);
        if (!line_start || !line_active || sync_error) begin
            fail("LS after duplicate FS failed");
        end

        send_event(DT_LS, 2'd2);
        if (!sync_error || line_start !== 1'b0 || !line_active) begin
            fail("duplicate LS did not raise sync_error");
        end

        send_event(DT_LE, 2'd2);
        send_event(DT_FE, 2'd2);
        if (frame_active || line_active) begin
            fail("FSM did not recover to idle");
        end

        send_event(DT_FS, 2'd3);
        send_event(DT_LS, 2'd3);
        @(negedge clk_sys);
        clear_i = 1'b1;
        @(posedge clk_sys);
        #1;
        clear_i = 1'b0;
        if (frame_active || line_active || sync_error) begin
            fail("clear_i did not flush active frame/line state");
        end

        $display("[%0t] PASS: tb_frame_line_sync", $time);
        $finish;
    end

endmodule
