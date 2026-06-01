`timescale 1ns/1ps

module tb_fpga_wrapper_lane_skew_overflow;

    localparam int LANE_NUM = 2;

    logic clk_sys;
    logic clk_byte;
    logic clk_axi;
    logic clk_ddr;
    logic rst_n;

    logic [31:0] lane_data_0;
    logic [31:0] lane_data_1;
    logic [31:0] lane_data_2;
    logic [31:0] lane_data_3;
    logic        lane_valid_0;
    logic        lane_valid_1;
    logic        lane_valid_2;
    logic        lane_valid_3;
    logic        hs_mode;
    logic        lp_mode;

    logic        frame_start_o;
    logic        frame_end_o;
    logic        line_start_o;
    logic        line_end_o;
    logic        err_ecc_o;
    logic        err_crc_o;
    logic        err_sync_o;
    logic [23:0] pixel_data_o;
    logic        pixel_valid_o;
    logic        pixel_sof_o;
    logic        pixel_sol_o;
    logic        cfg_init_done_o;

    logic [LANE_NUM-1:0]      sensor_lane_valid;
    logic [LANE_NUM-1:0]      sensor_lane_ready;
    logic [LANE_NUM-1:0][7:0] sensor_lane_data;

    logic lane0_backpressure_seen;
    logic overflow_seen;

    mipi_csi2_capture_fpga_wrapper #(
        .LANE_NUM(LANE_NUM),
        .DESKEW_DEPTH(2)
    ) dut (
        .clk_sys(clk_sys),
        .clk_byte(clk_byte),
        .clk_axi(clk_axi),
        .clk_ddr(clk_ddr),
        .rst_n(rst_n),
        .lane_data_0(lane_data_0),
        .lane_data_1(lane_data_1),
        .lane_data_2(lane_data_2),
        .lane_data_3(lane_data_3),
        .lane_valid_0(lane_valid_0),
        .lane_valid_1(lane_valid_1),
        .lane_valid_2(lane_valid_2),
        .lane_valid_3(lane_valid_3),
        .hs_mode(hs_mode),
        .lp_mode(lp_mode),
        .frame_start_o(frame_start_o),
        .frame_end_o(frame_end_o),
        .line_start_o(line_start_o),
        .line_end_o(line_end_o),
        .err_ecc_o(err_ecc_o),
        .err_crc_o(err_crc_o),
        .err_sync_o(err_sync_o),
        .pixel_data_o(pixel_data_o),
        .pixel_valid_o(pixel_valid_o),
        .pixel_sof_o(pixel_sof_o),
        .pixel_sol_o(pixel_sol_o),
        .cfg_init_done_o(cfg_init_done_o)
    );

    assign sensor_lane_ready = dut.u_mipi_csi2_capture_top.phy_lane_ready[LANE_NUM-1:0];

    task automatic clear_lane_drive;
        begin
            sensor_lane_valid = '0;
            sensor_lane_data  = '0;
        end
    endtask

    task automatic drive_lane0_byte_force(input logic [7:0] byte0);
        begin
            @(negedge clk_byte);
            sensor_lane_valid[0] = 1'b1;
            sensor_lane_data[0]  = byte0;
            sensor_lane_valid[1] = 1'b0;
            sensor_lane_data[1]  = 8'h00;
            @(posedge clk_byte);
            @(negedge clk_byte);
            clear_lane_drive();
        end
    endtask

    always_comb begin
        lane_data_0  = {24'd0, sensor_lane_data[0]};
        lane_data_1  = {24'd0, sensor_lane_data[1]};
        lane_data_2  = 32'd0;
        lane_data_3  = 32'd0;
        lane_valid_0 = sensor_lane_valid[0];
        lane_valid_1 = sensor_lane_valid[1];
        lane_valid_2 = 1'b0;
        lane_valid_3 = 1'b0;
    end

    initial begin
        clk_sys = 1'b0;
        forever #5 clk_sys = ~clk_sys;
    end

    initial begin
        clk_byte = 1'b0;
        forever #4 clk_byte = ~clk_byte;
    end

    initial begin
        clk_axi = 1'b0;
        forever #5 clk_axi = ~clk_axi;
    end

    initial begin
        clk_ddr = 1'b0;
        forever #5 clk_ddr = ~clk_ddr;
    end

    always_ff @(posedge clk_byte) begin
        if (!rst_n) begin
            lane0_backpressure_seen <= 1'b0;
            overflow_seen           <= 1'b0;
        end else begin
            if (!sensor_lane_ready[0]) begin
                lane0_backpressure_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.u_lane_deskew_buffer.err_overflow_o) begin
                overflow_seen <= 1'b1;
            end
        end
    end

    initial begin
        rst_n   = 1'b0;
        hs_mode = 1'b1;
        lp_mode = 1'b0;
        clear_lane_drive();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
        repeat (4) @(posedge clk_byte);

        drive_lane0_byte_force(8'hb8);
        drive_lane0_byte_force(8'h2a);
        drive_lane0_byte_force(8'h00);

        fork
            begin : timeout_block
                repeat (2000) @(posedge clk_byte);
                $display("FAIL: lane-skew overflow timeout ready_low=%0b overflow=%0b",
                         lane0_backpressure_seen, overflow_seen);
                $fatal(1);
            end

            begin : main_check_block
                wait (overflow_seen);
                repeat (4) @(posedge clk_byte);

                if (!lane0_backpressure_seen) begin
                    $display("FAIL: lane-skew overflow did not observe lane0 backpressure before overflow");
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o) begin
                    $display("FAIL: unexpected protocol checker errors during skew overflow");
                    $fatal(1);
                end

                $display("PASS: tb_fpga_wrapper_lane_skew_overflow ready_low=%0b overflow=%0b",
                         lane0_backpressure_seen, overflow_seen);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        $finish;
    end

endmodule
