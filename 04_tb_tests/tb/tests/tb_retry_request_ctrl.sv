`timescale 1ns/1ps

module tb_retry_request_ctrl;

    logic        clk_sys;
    logic        rst_n;
    logic        clear_i;
    logic        ack_i;
    logic        cfg_enable_retry_i;
    logic        cfg_retry_line_mode_i;
    logic        err_valid_i;
    logic [2:0]  err_type_i;
    logic [31:0] frame_id_i;
    logic [31:0] line_id_i;
    logic [1:0]  vc_i;
    logic [5:0]  dt_i;
    logic        retry_req_o;
    logic        retry_pending_o;
    logic        retry_mode_o;
    logic [2:0]  retry_err_type_o;
    logic [31:0] retry_frame_id_o;
    logic [31:0] retry_line_id_o;
    logic [1:0]  retry_vc_o;
    logic [5:0]  retry_dt_o;

    retry_request_ctrl dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .ack_i(ack_i),
        .cfg_enable_retry_i(cfg_enable_retry_i),
        .cfg_retry_line_mode_i(cfg_retry_line_mode_i),
        .err_valid_i(err_valid_i),
        .err_type_i(err_type_i),
        .frame_id_i(frame_id_i),
        .line_id_i(line_id_i),
        .vc_i(vc_i),
        .dt_i(dt_i),
        .retry_req_o(retry_req_o),
        .retry_pending_o(retry_pending_o),
        .retry_mode_o(retry_mode_o),
        .retry_err_type_o(retry_err_type_o),
        .retry_frame_id_o(retry_frame_id_o),
        .retry_line_id_o(retry_line_id_o),
        .retry_vc_o(retry_vc_o),
        .retry_dt_o(retry_dt_o)
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
            rst_n                 = 1'b0;
            clear_i               = 1'b0;
            ack_i                 = 1'b0;
            cfg_enable_retry_i    = 1'b0;
            cfg_retry_line_mode_i = 1'b0;
            err_valid_i           = 1'b0;
            err_type_i            = 3'd0;
            frame_id_i            = 32'd0;
            line_id_i             = 32'd0;
            vc_i                  = 2'd0;
            dt_i                  = 6'd0;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic send_error(
        input logic        line_mode,
        input logic [2:0]  err_type,
        input logic [31:0] frame_id,
        input logic [31:0] line_id,
        input logic [1:0]  vc,
        input logic [5:0]  dt
    );
        begin
            @(negedge clk_sys);
            cfg_retry_line_mode_i = line_mode;
            err_valid_i           = 1'b1;
            err_type_i            = err_type;
            frame_id_i            = frame_id;
            line_id_i             = line_id;
            vc_i                  = vc;
            dt_i                  = dt;
            @(posedge clk_sys);
            #1;
            if (!retry_req_o || !retry_pending_o) begin
                fail("retry request was not raised");
            end
            if (retry_mode_o !== line_mode || retry_err_type_o !== err_type ||
                retry_frame_id_o !== frame_id || retry_line_id_o !== line_id ||
                retry_vc_o !== vc || retry_dt_o !== dt) begin
                fail("retry context mismatch");
            end
            @(negedge clk_sys);
            err_valid_i = 1'b0;
            @(posedge clk_sys);
            #1;
            if (retry_req_o) begin
                fail("retry_req_o should be a one-cycle pulse");
            end
        end
    endtask

    initial begin
        apply_reset();

        @(negedge clk_sys);
        cfg_enable_retry_i = 1'b1;
        send_error(1'b0, 3'd2, 32'd5, 32'd12, 2'd1, 6'h2a);

        @(negedge clk_sys);
        ack_i = 1'b1;
        @(posedge clk_sys);
        #1;
        ack_i = 1'b0;
        if (retry_pending_o) begin
            fail("ack_i did not clear retry_pending_o");
        end

        send_error(1'b1, 3'd2, 32'd6, 32'd13, 2'd2, 6'h2b);

        @(negedge clk_sys);
        clear_i = 1'b1;
        @(posedge clk_sys);
        #1;
        clear_i = 1'b0;
        if (retry_pending_o) begin
            fail("clear_i did not clear retry_pending_o");
        end

        @(negedge clk_sys);
        cfg_enable_retry_i = 1'b0;
        err_valid_i        = 1'b1;
        err_type_i         = 3'd3;
        frame_id_i         = 32'd8;
        line_id_i          = 32'd21;
        @(posedge clk_sys);
        #1;
        if (retry_req_o || retry_pending_o) begin
            fail("retry request should stay low when disabled");
        end

        $display("[%0t] PASS: tb_retry_request_ctrl", $time);
        $finish;
    end

endmodule
