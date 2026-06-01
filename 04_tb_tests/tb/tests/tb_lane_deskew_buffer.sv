`timescale 1ns/1ps

module tb_lane_deskew_buffer;

    logic clk_byte;
    logic rst_n;
    logic clear_i;

    logic [0:0]      lane1_valid;
    logic [0:0]      lane1_ready;
    logic [0:0][7:0] lane1_data;
    logic            deskew1_valid;
    logic            deskew1_ready;
    logic [0:0][7:0] deskew1_data;
    logic            err1_overflow;

    logic [1:0]      lane2_valid;
    logic [1:0]      lane2_ready;
    logic [1:0][7:0] lane2_data;
    logic            deskew2_valid;
    logic            deskew2_ready;
    logic [1:0][7:0] deskew2_data;
    logic            err2_overflow;

    logic [3:0]      lane4_valid;
    logic [3:0]      lane4_ready;
    logic [3:0][7:0] lane4_data;
    logic            deskew4_valid;
    logic            deskew4_ready;
    logic [3:0][7:0] deskew4_data;
    logic            err4_overflow;

    lane_deskew_buffer #(.LANE_NUM(1), .DESKEW_DEPTH(2)) dut_lane1 (
        .clk_byte(clk_byte),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .lane_valid_i(lane1_valid),
        .lane_ready_o(lane1_ready),
        .lane_data_i(lane1_data),
        .deskew_valid_o(deskew1_valid),
        .deskew_ready_i(deskew1_ready),
        .deskew_data_o(deskew1_data),
        .err_overflow_o(err1_overflow)
    );

    lane_deskew_buffer #(.LANE_NUM(2), .DESKEW_DEPTH(2)) dut_lane2 (
        .clk_byte(clk_byte),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .lane_valid_i(lane2_valid),
        .lane_ready_o(lane2_ready),
        .lane_data_i(lane2_data),
        .deskew_valid_o(deskew2_valid),
        .deskew_ready_i(deskew2_ready),
        .deskew_data_o(deskew2_data),
        .err_overflow_o(err2_overflow)
    );

    lane_deskew_buffer #(.LANE_NUM(4), .DESKEW_DEPTH(2)) dut_lane4 (
        .clk_byte(clk_byte),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .lane_valid_i(lane4_valid),
        .lane_ready_o(lane4_ready),
        .lane_data_i(lane4_data),
        .deskew_valid_o(deskew4_valid),
        .deskew_ready_i(deskew4_ready),
        .deskew_data_o(deskew4_data),
        .err_overflow_o(err4_overflow)
    );

    initial clk_byte = 1'b0;
    always #5 clk_byte = ~clk_byte;

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    task automatic apply_reset;
        begin
            rst_n         = 1'b0;
            clear_i       = 1'b0;
            lane1_valid   = '0;
            lane1_data    = '0;
            deskew1_ready = 1'b0;
            lane2_valid   = '0;
            lane2_data    = '0;
            deskew2_ready = 1'b0;
            lane4_valid   = '0;
            lane4_data    = '0;
            deskew4_ready = 1'b0;
            repeat (5) @(posedge clk_byte);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_byte);
        end
    endtask

    task automatic drive_lane1(input logic [7:0] data);
        begin
            @(negedge clk_byte);
            lane1_valid[0] = 1'b1;
            lane1_data[0]  = data;
            @(posedge clk_byte);
            #1;
            lane1_valid[0] = 1'b0;
        end
    endtask

    task automatic drive_lane2(input int lane, input logic [7:0] data);
        begin
            @(negedge clk_byte);
            lane2_valid[lane] = 1'b1;
            lane2_data[lane]  = data;
            @(posedge clk_byte);
            #1;
            lane2_valid[lane] = 1'b0;
        end
    endtask

    task automatic drive_lane4(input int lane, input logic [7:0] data);
        begin
            @(negedge clk_byte);
            lane4_valid[lane] = 1'b1;
            lane4_data[lane]  = data;
            @(posedge clk_byte);
            #1;
            lane4_valid[lane] = 1'b0;
        end
    endtask

    task automatic pop_lane1(input logic [7:0] exp0);
        begin
            while (!deskew1_valid) begin
                @(posedge clk_byte);
            end
            if (deskew1_data[0] !== exp0) begin
                fail("lane1 deskew data mismatch");
            end
            @(negedge clk_byte);
            deskew1_ready = 1'b1;
            @(posedge clk_byte);
            #1;
            deskew1_ready = 1'b0;
        end
    endtask

    task automatic pop_lane2(input logic [7:0] exp0, input logic [7:0] exp1);
        begin
            while (!deskew2_valid) begin
                @(posedge clk_byte);
            end
            if (deskew2_data[0] !== exp0 || deskew2_data[1] !== exp1) begin
                fail("lane2 deskew data mismatch");
            end
            @(negedge clk_byte);
            deskew2_ready = 1'b1;
            @(posedge clk_byte);
            #1;
            deskew2_ready = 1'b0;
        end
    endtask

    task automatic pop_lane4(
        input logic [7:0] exp0,
        input logic [7:0] exp1,
        input logic [7:0] exp2,
        input logic [7:0] exp3
    );
        begin
            while (!deskew4_valid) begin
                @(posedge clk_byte);
            end
            if (deskew4_data[0] !== exp0 || deskew4_data[1] !== exp1 ||
                deskew4_data[2] !== exp2 || deskew4_data[3] !== exp3) begin
                fail("lane4 deskew data mismatch");
            end
            @(negedge clk_byte);
            deskew4_ready = 1'b1;
            @(posedge clk_byte);
            #1;
            deskew4_ready = 1'b0;
        end
    endtask

    initial begin
        apply_reset();

        drive_lane1(8'ha1);
        pop_lane1(8'ha1);

        drive_lane2(0, 8'h10);
        repeat (2) @(posedge clk_byte);
        drive_lane2(1, 8'h20);
        pop_lane2(8'h10, 8'h20);

        drive_lane4(0, 8'h10);
        drive_lane4(0, 8'h11);
        drive_lane4(2, 8'h30);
        drive_lane4(1, 8'h20);
        drive_lane4(3, 8'h40);
        drive_lane4(2, 8'h31);
        drive_lane4(1, 8'h21);
        drive_lane4(3, 8'h41);

        while (!deskew4_valid) begin
            @(posedge clk_byte);
        end
        repeat (3) @(posedge clk_byte);
        if (!deskew4_valid || deskew4_data[0] !== 8'h10 || deskew4_data[3] !== 8'h40) begin
            fail("lane4 backpressure did not hold aligned group");
        end
        pop_lane4(8'h10, 8'h20, 8'h30, 8'h40);
        pop_lane4(8'h11, 8'h21, 8'h31, 8'h41);

        drive_lane4(0, 8'h55);
        drive_lane4(0, 8'h56);
        @(negedge clk_byte);
        lane4_valid[0] = 1'b1;
        lane4_data[0]  = 8'h57;
        @(posedge clk_byte);
        #1;
        if (!err4_overflow) begin
            fail("overflow was not reported");
        end
        lane4_valid[0] = 1'b0;

        drive_lane2(0, 8'h81);
        drive_lane2(1, 8'h82);
        @(negedge clk_byte);
        clear_i = 1'b1;
        @(posedge clk_byte);
        #1;
        clear_i = 1'b0;
        if (deskew2_valid || !lane2_ready[0] || !lane2_ready[1]) begin
            fail("clear_i did not flush lane deskew state");
        end

        $display("[%0t] PASS: tb_lane_deskew_buffer", $time);
        $finish;
    end

endmodule
