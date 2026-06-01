`timescale 1ns/1ps

module tb_fpga_wrapper_resync_metrics;

    localparam int LANE_NUM = 2;
    localparam logic [1:0] VC_ID = 2'd0;

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

    logic                     sensor_done;
    logic [LANE_NUM-1:0]      sensor_lane_valid;
    logic [LANE_NUM-1:0]      sensor_lane_ready;
    logic [LANE_NUM-1:0][7:0] sensor_lane_data;

    int cycle_count_sys;
    int sync_cycle;
    int req_cycle;
    int busy_cycle;
    int done_cycle;
    int clear_cycle;

    mipi_csi2_capture_fpga_wrapper #(
        .LANE_NUM(LANE_NUM)
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

    task automatic push_lane_group(
        input logic [7:0] byte0,
        input logic [7:0] byte1
    );
        begin
            while (!(sensor_lane_ready[0] && sensor_lane_ready[1])) begin
                @(posedge clk_byte);
            end

            @(negedge clk_byte);
            sensor_lane_valid[0] = 1'b1;
            sensor_lane_valid[1] = 1'b1;
            sensor_lane_data[0]  = byte0;
            sensor_lane_data[1]  = byte1;

            @(posedge clk_byte);
            @(negedge clk_byte);
            clear_lane_drive();
        end
    endtask

    task automatic send_short_packet(input logic [5:0] dt);
        logic [31:0] header;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, dt, 16'd0, 1'b0);
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 1)
            );
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 3)
            );
        end
    endtask

    task automatic drive_illegal_sequence;
        begin
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
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

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            cycle_count_sys <= 0;
            sync_cycle      <= -1;
            req_cycle       <= -1;
            busy_cycle      <= -1;
            done_cycle      <= -1;
            clear_cycle     <= -1;
        end else begin
            cycle_count_sys <= cycle_count_sys + 1;

            if ((sync_cycle < 0) && err_sync_o) begin
                sync_cycle <= cycle_count_sys;
            end
            if ((req_cycle < 0) && dut.u_mipi_csi2_capture_top.resync_req) begin
                req_cycle <= cycle_count_sys;
            end
            if ((busy_cycle < 0) && dut.u_mipi_csi2_capture_top.resync_busy) begin
                busy_cycle <= cycle_count_sys;
            end
            if ((done_cycle < 0) && dut.u_mipi_csi2_capture_top.u_resync_ctrl_fsm.resync_done_o) begin
                done_cycle <= cycle_count_sys;
            end
            if ((clear_cycle < 0) && dut.u_mipi_csi2_capture_top.resync_clear_pulse_sys) begin
                clear_cycle <= cycle_count_sys;
            end
        end
    end

    initial begin
        rst_n       = 1'b0;
        hs_mode     = 1'b1;
        lp_mode     = 1'b0;
        sensor_done = 1'b0;
        clear_lane_drive();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
        repeat (4) @(posedge clk_byte);

        drive_illegal_sequence();

        fork
            begin : timeout_block
                repeat (5000) @(posedge clk_sys);
                $display("FAIL: resync metrics timeout sync=%0d req=%0d busy=%0d done=%0d clear=%0d",
                         sync_cycle, req_cycle, busy_cycle, done_cycle, clear_cycle);
                $fatal(1);
            end

            begin : main_check_block
                wait (clear_cycle >= 0);
                repeat (10) @(posedge clk_sys);

                if ((sync_cycle < 0) || (req_cycle < 0) || (busy_cycle < 0) ||
                    (done_cycle < 0) || (clear_cycle < 0)) begin
                    $display("FAIL: resync metrics were not fully observed sync=%0d req=%0d busy=%0d done=%0d clear=%0d",
                             sync_cycle, req_cycle, busy_cycle, done_cycle, clear_cycle);
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o) begin
                    $display("FAIL: unexpected non-sync errors during resync metrics test");
                    $fatal(1);
                end

                $display("PASS: tb_fpga_wrapper_resync_metrics sync_to_req=%0d req_to_busy=%0d busy_to_clear=%0d clear_to_done=%0d sync_to_done=%0d",
                         req_cycle - sync_cycle,
                         busy_cycle - req_cycle,
                         clear_cycle - busy_cycle,
                         done_cycle - clear_cycle,
                         done_cycle - sync_cycle);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        $finish;
    end

endmodule
