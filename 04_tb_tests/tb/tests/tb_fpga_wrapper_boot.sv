`timescale 1ns/1ps

module tb_fpga_wrapper_boot;

    logic        clk_sys;
    logic        clk_byte;
    logic        clk_axi;
    logic        clk_ddr;
    logic        rst_n;

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

    mipi_csi2_capture_fpga_wrapper dut (
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

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    initial begin
        rst_n        = 1'b0;
        lane_data_0  = 32'd0;
        lane_data_1  = 32'd0;
        lane_data_2  = 32'd0;
        lane_data_3  = 32'd0;
        lane_valid_0 = 1'b0;
        lane_valid_1 = 1'b0;
        lane_valid_2 = 1'b0;
        lane_valid_3 = 1'b0;
        hs_mode      = 1'b1;
        lp_mode      = 1'b0;

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        repeat (80) @(posedge clk_sys);
        if (!cfg_init_done_o) begin
            fail("boot APB configurator did not finish");
        end

        if (frame_start_o || frame_end_o || line_start_o || line_end_o ||
            err_ecc_o || err_crc_o || err_sync_o || pixel_valid_o ||
            pixel_sof_o || pixel_sol_o || pixel_data_o !== 24'd0) begin
            fail("wrapper produced unexpected activity in idle boot state");
        end

        $display("[%0t] PASS: tb_fpga_wrapper_boot", $time);
        $finish;
    end

endmodule
