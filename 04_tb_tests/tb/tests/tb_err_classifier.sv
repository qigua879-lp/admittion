`timescale 1ns/1ps

module tb_err_classifier;

    logic        clk_sys;
    logic        rst_n;
    logic        err_ecc_i;
    logic        err_crc_i;
    logic        err_sync_i;
    logic        err_lane_i;
    logic [31:0] frame_id_i;
    logic [31:0] line_id_i;
    logic [1:0]  vc_i;
    logic [5:0]  dt_i;
    logic        err_valid_o;
    logic        err_ready_i;
    logic [2:0]  err_type_o;
    logic [1:0]  err_priority_o;
    logic [31:0] frame_id_o;
    logic [31:0] line_id_o;
    logic [1:0]  vc_o;
    logic [5:0]  dt_o;
    logic [31:0] err_cnt_ecc_o;
    logic [31:0] err_cnt_crc_o;
    logic [31:0] err_cnt_sync_o;
    logic [31:0] err_cnt_lane_o;

    err_classifier dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .err_ecc_i(err_ecc_i),
        .err_crc_i(err_crc_i),
        .err_sync_i(err_sync_i),
        .err_lane_i(err_lane_i),
        .frame_id_i(frame_id_i),
        .line_id_i(line_id_i),
        .vc_i(vc_i),
        .dt_i(dt_i),
        .err_valid_o(err_valid_o),
        .err_ready_i(err_ready_i),
        .err_type_o(err_type_o),
        .err_priority_o(err_priority_o),
        .frame_id_o(frame_id_o),
        .line_id_o(line_id_o),
        .vc_o(vc_o),
        .dt_o(dt_o),
        .err_cnt_ecc_o(err_cnt_ecc_o),
        .err_cnt_crc_o(err_cnt_crc_o),
        .err_cnt_sync_o(err_cnt_sync_o),
        .err_cnt_lane_o(err_cnt_lane_o)
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
            err_ecc_i   = 1'b0;
            err_crc_i   = 1'b0;
            err_sync_i  = 1'b0;
            err_lane_i  = 1'b0;
            frame_id_i  = 32'd0;
            line_id_i   = 32'd0;
            vc_i        = 2'd0;
            dt_i        = 6'd0;
            err_ready_i = 1'b1;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic pulse_error(
        input logic ecc,
        input logic crc,
        input logic sync,
        input logic lane,
        input logic [31:0] frame_id,
        input logic [31:0] line_id,
        input logic [1:0] vc,
        input logic [5:0] dt
    );
        begin
            @(negedge clk_sys);
            err_ecc_i  = ecc;
            err_crc_i  = crc;
            err_sync_i = sync;
            err_lane_i = lane;
            frame_id_i = frame_id;
            line_id_i  = line_id;
            vc_i       = vc;
            dt_i       = dt;
            @(posedge clk_sys);
            #1;
            err_ecc_i  = 1'b0;
            err_crc_i  = 1'b0;
            err_sync_i = 1'b0;
            err_lane_i = 1'b0;
        end
    endtask

    task automatic check_event(
        input logic [2:0] exp_type,
        input logic [1:0] exp_priority,
        input logic [31:0] exp_frame,
        input logic [31:0] exp_line,
        input logic [1:0] exp_vc,
        input logic [5:0] exp_dt
    );
        begin
            if (!err_valid_o || err_type_o !== exp_type || err_priority_o !== exp_priority ||
                frame_id_o !== exp_frame || line_id_o !== exp_line || vc_o !== exp_vc || dt_o !== exp_dt) begin
                fail("classified error event mismatch");
            end
            @(posedge clk_sys);
            #1;
        end
    endtask

    initial begin
        apply_reset();

        pulse_error(1'b1, 1'b0, 1'b0, 1'b0, 32'd1, 32'd2, 2'd1, 6'h2a);
        check_event(3'd1, 2'd0, 32'd1, 32'd2, 2'd1, 6'h2a);

        pulse_error(1'b0, 1'b1, 1'b0, 1'b0, 32'd3, 32'd4, 2'd2, 6'h2b);
        check_event(3'd2, 2'd1, 32'd3, 32'd4, 2'd2, 6'h2b);

        pulse_error(1'b1, 1'b1, 1'b1, 1'b1, 32'd5, 32'd6, 2'd3, 6'h2c);
        check_event(3'd3, 2'd3, 32'd5, 32'd6, 2'd3, 6'h2c);

        pulse_error(1'b0, 1'b0, 1'b0, 1'b1, 32'd7, 32'd8, 2'd0, 6'h2d);
        check_event(3'd4, 2'd2, 32'd7, 32'd8, 2'd0, 6'h2d);

        if (err_cnt_ecc_o !== 32'd2 || err_cnt_crc_o !== 32'd2 ||
            err_cnt_sync_o !== 32'd1 || err_cnt_lane_o !== 32'd2) begin
            fail("error counters mismatch");
        end

        $display("[%0t] PASS: tb_err_classifier", $time);
        $finish;
    end

endmodule
