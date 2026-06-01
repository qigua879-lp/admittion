`timescale 1ns/1ps

module tb_err_logger;

    logic        clk_sys;
    logic        rst_n;
    logic        clear_i;
    logic        err_valid_i;
    logic        err_ready_o;
    logic [2:0]  err_type_i;
    logic [1:0]  err_priority_i;
    logic [31:0] frame_id_i;
    logic [31:0] line_id_i;
    logic [1:0]  vc_i;
    logic [5:0]  dt_i;
    logic        err_pending_o;
    logic [2:0]  last_err_type_o;
    logic [1:0]  last_err_priority_o;
    logic [31:0] last_frame_id_o;
    logic [31:0] last_line_id_o;
    logic [1:0]  last_vc_o;
    logic [5:0]  last_dt_o;
    logic [31:0] total_err_cnt_o;
    logic [31:0] ecc_err_cnt_o;
    logic [31:0] crc_err_cnt_o;
    logic [31:0] sync_err_cnt_o;
    logic [31:0] lane_err_cnt_o;

    err_frame_line_logger dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .err_valid_i(err_valid_i),
        .err_ready_o(err_ready_o),
        .err_type_i(err_type_i),
        .err_priority_i(err_priority_i),
        .frame_id_i(frame_id_i),
        .line_id_i(line_id_i),
        .vc_i(vc_i),
        .dt_i(dt_i),
        .err_pending_o(err_pending_o),
        .last_err_type_o(last_err_type_o),
        .last_err_priority_o(last_err_priority_o),
        .last_frame_id_o(last_frame_id_o),
        .last_line_id_o(last_line_id_o),
        .last_vc_o(last_vc_o),
        .last_dt_o(last_dt_o),
        .total_err_cnt_o(total_err_cnt_o),
        .ecc_err_cnt_o(ecc_err_cnt_o),
        .crc_err_cnt_o(crc_err_cnt_o),
        .sync_err_cnt_o(sync_err_cnt_o),
        .lane_err_cnt_o(lane_err_cnt_o)
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
            rst_n          = 1'b0;
            clear_i        = 1'b0;
            err_valid_i    = 1'b0;
            err_type_i     = 3'd0;
            err_priority_i = 2'd0;
            frame_id_i     = 32'd0;
            line_id_i      = 32'd0;
            vc_i           = 2'd0;
            dt_i           = 6'd0;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic send_error(
        input logic [2:0] err_type,
        input logic [1:0] err_priority,
        input logic [31:0] frame_id,
        input logic [31:0] line_id,
        input logic [1:0] vc,
        input logic [5:0] dt
    );
        begin
            @(negedge clk_sys);
            err_valid_i    = 1'b1;
            err_type_i     = err_type;
            err_priority_i = err_priority;
            frame_id_i     = frame_id;
            line_id_i      = line_id;
            vc_i           = vc;
            dt_i           = dt;
            @(posedge clk_sys);
            #1;
            err_valid_i = 1'b0;
        end
    endtask

    initial begin
        apply_reset();

        send_error(3'd1, 2'd0, 32'd10, 32'd20, 2'd1, 6'h2a);
        if (!err_pending_o || last_err_type_o !== 3'd1 || last_frame_id_o !== 32'd10 ||
            last_line_id_o !== 32'd20 || last_vc_o !== 2'd1 || last_dt_o !== 6'h2a) begin
            fail("ECC log mismatch");
        end

        send_error(3'd2, 2'd1, 32'd11, 32'd21, 2'd2, 6'h2b);
        send_error(3'd3, 2'd3, 32'd12, 32'd22, 2'd3, 6'h2c);
        send_error(3'd4, 2'd2, 32'd13, 32'd23, 2'd0, 6'h2d);

        if (last_err_type_o !== 3'd4 || last_err_priority_o !== 2'd2 ||
            total_err_cnt_o !== 32'd4 || ecc_err_cnt_o !== 32'd1 ||
            crc_err_cnt_o !== 32'd1 || sync_err_cnt_o !== 32'd1 ||
            lane_err_cnt_o !== 32'd1) begin
            fail("logger counters mismatch");
        end

        @(negedge clk_sys);
        clear_i = 1'b1;
        @(posedge clk_sys);
        #1;
        clear_i = 1'b0;
        if (err_pending_o) begin
            fail("err_pending was not cleared");
        end

        $display("[%0t] PASS: tb_err_logger", $time);
        $finish;
    end

endmodule
