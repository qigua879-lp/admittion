`timescale 1ns/1ps

module tb_lane_reorder_merge;

    logic clk_byte;
    logic rst_n;
    logic clear_i;

    logic            group1_valid;
    logic            group1_ready;
    logic [0:0][7:0] group1_data;
    logic            byte1_valid;
    logic            byte1_ready;
    logic [7:0]      byte1_data;
    logic            done1;

    logic            group2_valid;
    logic            group2_ready;
    logic [1:0][7:0] group2_data;
    logic            byte2_valid;
    logic            byte2_ready;
    logic [7:0]      byte2_data;
    logic            done2;

    logic            group4_valid;
    logic            group4_ready;
    logic [3:0][7:0] group4_data;
    logic            byte4_valid;
    logic            byte4_ready;
    logic [7:0]      byte4_data;
    logic            done4;

    lane_reorder_merge #(.LANE_NUM(1)) dut_lane1 (
        .clk_byte(clk_byte),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .lane_group_valid_i(group1_valid),
        .lane_group_ready_o(group1_ready),
        .lane_group_data_i(group1_data),
        .byte_valid_o(byte1_valid),
        .byte_ready_i(byte1_ready),
        .byte_data_o(byte1_data),
        .group_done_o(done1)
    );

    lane_reorder_merge #(.LANE_NUM(2)) dut_lane2 (
        .clk_byte(clk_byte),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .lane_group_valid_i(group2_valid),
        .lane_group_ready_o(group2_ready),
        .lane_group_data_i(group2_data),
        .byte_valid_o(byte2_valid),
        .byte_ready_i(byte2_ready),
        .byte_data_o(byte2_data),
        .group_done_o(done2)
    );

    lane_reorder_merge #(.LANE_NUM(4)) dut_lane4 (
        .clk_byte(clk_byte),
        .rst_n(rst_n),
        .clear_i(clear_i),
        .lane_group_valid_i(group4_valid),
        .lane_group_ready_o(group4_ready),
        .lane_group_data_i(group4_data),
        .byte_valid_o(byte4_valid),
        .byte_ready_i(byte4_ready),
        .byte_data_o(byte4_data),
        .group_done_o(done4)
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
            rst_n        = 1'b0;
            clear_i      = 1'b0;
            group1_valid = 1'b0;
            group1_data  = '0;
            byte1_ready  = 1'b0;
            group2_valid = 1'b0;
            group2_data  = '0;
            byte2_ready  = 1'b0;
            group4_valid = 1'b0;
            group4_data  = '0;
            byte4_ready  = 1'b0;
            repeat (5) @(posedge clk_byte);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_byte);
        end
    endtask

    task automatic send_group1(input logic [7:0] d0);
        begin
            @(negedge clk_byte);
            group1_valid  = 1'b1;
            group1_data[0] = d0;
            @(posedge clk_byte);
            #1;
            group1_valid = 1'b0;
        end
    endtask

    task automatic send_group2(input logic [7:0] d0, input logic [7:0] d1);
        begin
            @(negedge clk_byte);
            group2_valid  = 1'b1;
            group2_data[0] = d0;
            group2_data[1] = d1;
            @(posedge clk_byte);
            #1;
            group2_valid = 1'b0;
        end
    endtask

    task automatic send_group4(
        input logic [7:0] d0,
        input logic [7:0] d1,
        input logic [7:0] d2,
        input logic [7:0] d3
    );
        begin
            @(negedge clk_byte);
            group4_valid  = 1'b1;
            group4_data[0] = d0;
            group4_data[1] = d1;
            group4_data[2] = d2;
            group4_data[3] = d3;
            @(posedge clk_byte);
            #1;
            group4_valid = 1'b0;
        end
    endtask

    task automatic expect_byte1(input logic [7:0] exp_data, input logic exp_done);
        begin
            while (!byte1_valid) begin
                @(posedge clk_byte);
            end
            if (byte1_data !== exp_data) begin
                fail("lane1 merge data mismatch");
            end
            @(negedge clk_byte);
            byte1_ready = 1'b1;
            #1;
            if (done1 !== exp_done) begin
                fail("lane1 group_done mismatch");
            end
            @(posedge clk_byte);
            #1;
            byte1_ready = 1'b0;
        end
    endtask

    task automatic expect_byte2(input logic [7:0] exp_data, input logic exp_done);
        begin
            while (!byte2_valid) begin
                @(posedge clk_byte);
            end
            if (byte2_data !== exp_data) begin
                fail("lane2 merge data mismatch");
            end
            @(negedge clk_byte);
            byte2_ready = 1'b1;
            #1;
            if (done2 !== exp_done) begin
                fail("lane2 group_done mismatch");
            end
            @(posedge clk_byte);
            #1;
            byte2_ready = 1'b0;
        end
    endtask

    task automatic expect_byte4(input logic [7:0] exp_data, input logic exp_done);
        begin
            while (!byte4_valid) begin
                @(posedge clk_byte);
            end
            if (byte4_data !== exp_data) begin
                fail("lane4 merge data mismatch");
            end
            @(negedge clk_byte);
            byte4_ready = 1'b1;
            #1;
            if (done4 !== exp_done) begin
                fail("lane4 group_done mismatch");
            end
            @(posedge clk_byte);
            #1;
            byte4_ready = 1'b0;
        end
    endtask

    initial begin
        apply_reset();

        send_group1(8'ha1);
        expect_byte1(8'ha1, 1'b1);

        send_group2(8'h10, 8'h20);
        expect_byte2(8'h10, 1'b0);
        expect_byte2(8'h20, 1'b1);

        send_group4(8'h01, 8'h02, 8'h03, 8'h04);
        while (!byte4_valid) begin
            @(posedge clk_byte);
        end
        byte4_ready = 1'b0;
        repeat (3) @(posedge clk_byte);
        if (!byte4_valid || byte4_data !== 8'h01 || done4) begin
            fail("lane4 merge backpressure did not hold first byte");
        end
        expect_byte4(8'h01, 1'b0);
        expect_byte4(8'h02, 1'b0);
        expect_byte4(8'h03, 1'b0);
        expect_byte4(8'h04, 1'b1);

        send_group4(8'h11, 8'h12, 8'h13, 8'h14);
        expect_byte4(8'h11, 1'b0);
        expect_byte4(8'h12, 1'b0);
        expect_byte4(8'h13, 1'b0);
        expect_byte4(8'h14, 1'b1);

        send_group2(8'h91, 8'h92);
        expect_byte2(8'h91, 1'b0);
        @(negedge clk_byte);
        clear_i = 1'b1;
        @(posedge clk_byte);
        #1;
        clear_i = 1'b0;
        if (byte2_valid || !group2_ready) begin
            fail("clear_i did not flush lane reorder state");
        end

        $display("[%0t] PASS: tb_lane_reorder_merge", $time);
        $finish;
    end

endmodule
