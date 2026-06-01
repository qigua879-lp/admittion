`timescale 1ns/1ps

module tb_fpga_wrapper_buffer_depth_sweep;

    parameter int LANE_NUM             = 2;
    parameter int BYTE_FIFO_ADDR_WIDTH = 4;
    parameter int AXI_FIFO_ADDR_WIDTH  = 6;
    parameter int AXI_STALL_CYCLES     = 12;
    parameter int PIXEL_COUNT          = 16;
    parameter int AXI_DATA_WIDTH       = 128;
    localparam logic [5:0] DATA_TYPE    = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID        = 2'd0;

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
    logic                     exp_valid;
    logic                     exp_ready;
    logic [23:0]              exp_pixel_data;
    logic                     exp_pixel_sof;
    logic                     exp_pixel_sol;

    logic                     finish_scoreboard;
    logic                     pass;
    logic                     fail;
    logic [31:0]              sb_frame_cnt;
    logic [31:0]              exp_pixel_cnt;
    logic [31:0]              act_pixel_cnt;
    logic [31:0]              mismatch_cnt;

    integer axi_cycle_cnt;
    integer aw_stall_cycles;
    integer w_stall_cycles;
    integer pixel_ready_stall_cycles;
    integer lane_ready_drop_cycles;
    integer busy_start_cycle;
    integer busy_end_cycle;
    integer max_byte_fifo_level;
    integer max_axi_fifo_level;

    logic sensor_done_seen;
    logic frame_end_seen;
    logic cfg_enable_seen;
    logic busy_seen;
    logic busy_end_seen;
    logic aw_stall_seen;
    logic w_stall_seen;
    logic lane_ready_drop_seen;
    logic pixel_ready_stall_seen;

    function automatic logic [7:0] payload_byte(input int unsigned idx);
        begin
            payload_byte = idx[7:0];
        end
    endfunction

    function automatic logic [15:0] payload_crc;
        logic [15:0] crc;
        int unsigned idx;
        begin
            crc = 16'hffff;
            for (idx = 0; idx < PIXEL_COUNT; idx = idx + 1) begin
                crc = csi2_reference_helpers_pkg::csi2_crc16_next_byte(crc, payload_byte(idx));
            end
            payload_crc = crc;
        end
    endfunction

    mipi_csi2_capture_fpga_wrapper #(
        .LANE_NUM(LANE_NUM),
        .BYTE_FIFO_ADDR_WIDTH(BYTE_FIFO_ADDR_WIDTH),
        .AXI_FIFO_ADDR_WIDTH(AXI_FIFO_ADDR_WIDTH),
        .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
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

    scoreboard #(
        .MAX_PIXELS(128)
    ) u_scoreboard (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(1'b0),
        .exp_valid_i(exp_valid),
        .exp_ready_o(exp_ready),
        .exp_data_i(exp_pixel_data),
        .exp_sof_i(exp_pixel_sof),
        .exp_sol_i(exp_pixel_sol),
        .act_valid_i(pixel_valid_o),
        .act_ready_o(),
        .act_data_i(pixel_data_o),
        .act_sof_i(pixel_sof_o),
        .act_sol_i(pixel_sol_o),
        .finish_i(finish_scoreboard),
        .pass_o(pass),
        .fail_o(fail),
        .frame_cnt_o(sb_frame_cnt),
        .exp_pixel_cnt_o(exp_pixel_cnt),
        .act_pixel_cnt_o(act_pixel_cnt),
        .mismatch_cnt_o(mismatch_cnt)
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

    task automatic send_long_packet;
        logic [31:0] header;
        logic [15:0] crc;
        int idx;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, DATA_TYPE, PIXEL_COUNT, 1'b0);
            crc    = payload_crc();

            push_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 1)
            );
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 3)
            );

            for (idx = 0; idx < PIXEL_COUNT; idx = idx + 2) begin
                push_lane_group(payload_byte(idx), payload_byte(idx + 1));
            end

            push_lane_group(crc[7:0], crc[15:8]);
        end
    endtask

    task automatic feed_expected_pixels;
        int idx;
        begin
            for (idx = 0; idx < PIXEL_COUNT; idx = idx + 1) begin
                @(negedge clk_sys);
                exp_valid      = 1'b1;
                exp_pixel_data = {16'd0, payload_byte(idx)};
                exp_pixel_sof  = (idx == 0);
                exp_pixel_sol  = (idx == 0);
                do begin
                    @(posedge clk_sys);
                end while (!exp_ready);
            end

            @(negedge clk_sys);
            exp_valid      = 1'b0;
            exp_pixel_data = 24'd0;
            exp_pixel_sof  = 1'b0;
            exp_pixel_sol  = 1'b0;
        end
    endtask

    task automatic drive_frame;
        begin
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_long_packet();
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
            sensor_done = 1'b1;
            @(posedge clk_byte);
            sensor_done = 1'b0;
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
            sensor_done_seen         <= 1'b0;
            frame_end_seen           <= 1'b0;
            cfg_enable_seen          <= 1'b0;
            pixel_ready_stall_seen   <= 1'b0;
            pixel_ready_stall_cycles <= 0;
            max_byte_fifo_level      <= 0;
            max_axi_fifo_level       <= 0;
        end else begin
            if (sensor_done) begin
                sensor_done_seen <= 1'b1;
            end
            if (frame_end_o) begin
                frame_end_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.cfg_capture_enable) begin
                cfg_enable_seen <= 1'b1;
            end
            if (pixel_valid_o && !dut.u_mipi_csi2_capture_top.final_pixel_ready) begin
                pixel_ready_stall_seen   <= 1'b1;
                pixel_ready_stall_cycles <= pixel_ready_stall_cycles + 1;
            end
            if ($signed(dut.u_mipi_csi2_capture_top.fifo_wr_level_unused) > max_byte_fifo_level) begin
                max_byte_fifo_level <= dut.u_mipi_csi2_capture_top.fifo_wr_level_unused;
            end
            if ($signed(dut.u_mipi_csi2_capture_top.u_pixel_to_axi_writer.data_fifo_wr_level_unused) > max_axi_fifo_level) begin
                max_axi_fifo_level <= dut.u_mipi_csi2_capture_top.u_pixel_to_axi_writer.data_fifo_wr_level_unused;
            end
        end
    end

    always_ff @(posedge clk_byte) begin
        if (!rst_n) begin
            lane_ready_drop_seen   <= 1'b0;
            lane_ready_drop_cycles <= 0;
        end else if (!sensor_lane_ready[0] || !sensor_lane_ready[1]) begin
            lane_ready_drop_seen   <= 1'b1;
            lane_ready_drop_cycles <= lane_ready_drop_cycles + 1;
        end
    end

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            axi_cycle_cnt    <= 0;
            aw_stall_cycles  <= 0;
            w_stall_cycles   <= 0;
            busy_start_cycle <= -1;
            busy_end_cycle   <= -1;
            busy_seen        <= 1'b0;
            busy_end_seen    <= 1'b0;
            aw_stall_seen    <= 1'b0;
            w_stall_seen     <= 1'b0;
        end else begin
            axi_cycle_cnt <= axi_cycle_cnt + 1;

            if (dut.u_mipi_csi2_capture_top.axi_busy) begin
                busy_seen <= 1'b1;
                if (busy_start_cycle < 0) begin
                    busy_start_cycle <= axi_cycle_cnt;
                end
            end
            if (dut.u_mipi_csi2_capture_top.m_axi_awvalid_o &&
                !dut.u_mipi_csi2_capture_top.m_axi_awready_i) begin
                aw_stall_seen   <= 1'b1;
                aw_stall_cycles <= aw_stall_cycles + 1;
            end
            if (dut.u_mipi_csi2_capture_top.m_axi_wvalid_o &&
                !dut.u_mipi_csi2_capture_top.m_axi_wready_i) begin
                w_stall_seen   <= 1'b1;
                w_stall_cycles <= w_stall_cycles + 1;
            end
            if (busy_seen && !busy_end_seen && !dut.u_mipi_csi2_capture_top.axi_busy) begin
                busy_end_seen  <= 1'b1;
                busy_end_cycle <= axi_cycle_cnt;
            end
        end
    end

    initial begin
        rst_n             = 1'b0;
        hs_mode           = 1'b1;
        lp_mode           = 1'b0;
        sensor_done       = 1'b0;
        exp_valid         = 1'b0;
        exp_pixel_data    = 24'd0;
        exp_pixel_sof     = 1'b0;
        exp_pixel_sol     = 1'b0;
        finish_scoreboard = 1'b0;
        clear_lane_drive();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_o = 1'b1;
        repeat (4) @(posedge clk_sys);
        repeat (4) @(posedge clk_axi);
        force dut.m_axi_awready = 1'b0;
        force dut.m_axi_wready  = 1'b0;

        fork : launch_block
            begin
                repeat (4) @(posedge clk_byte);
                fork
                    feed_expected_pixels();
                    drive_frame();
                join
            end
            begin
                wait (dut.u_mipi_csi2_capture_top.m_axi_awvalid_o);
                repeat (AXI_STALL_CYCLES) @(posedge clk_axi);
                release dut.m_axi_awready;

                wait (dut.u_mipi_csi2_capture_top.m_axi_wvalid_o);
                repeat (AXI_STALL_CYCLES) @(posedge clk_axi);
                release dut.m_axi_wready;
            end
        join_none

        fork
            begin : timeout_block
                repeat (12000) @(posedge clk_sys);
                $display("FAIL: buffer sweep timeout byte_fifo_aw=%0d axi_fifo_aw=%0d stall=%0d cfg=%0b sensor=%0b frame_end=%0b busy=%0b exp=%0d act=%0d mismatch=%0d",
                         BYTE_FIFO_ADDR_WIDTH, AXI_FIFO_ADDR_WIDTH, AXI_STALL_CYCLES,
                         cfg_enable_seen, sensor_done_seen, frame_end_seen, busy_seen,
                         exp_pixel_cnt, act_pixel_cnt, mismatch_cnt);
                $fatal(1);
            end

            begin : main_check_block
                wait (act_pixel_cnt == PIXEL_COUNT);
                wait (frame_end_seen);
                repeat (20) @(posedge clk_axi);
                wait (!dut.u_mipi_csi2_capture_top.axi_busy);
                repeat (8) @(posedge clk_axi);

                @(negedge clk_sys);
                finish_scoreboard = 1'b1;
                @(negedge clk_sys);
                finish_scoreboard = 1'b0;
                @(posedge clk_sys);

                if (!pass || fail) begin
                    $display("FAIL: buffer sweep scoreboard byte_fifo_aw=%0d axi_fifo_aw=%0d stall=%0d pass=%0b fail=%0b exp=%0d act=%0d mismatch=%0d",
                             BYTE_FIFO_ADDR_WIDTH, AXI_FIFO_ADDR_WIDTH, AXI_STALL_CYCLES,
                             pass, fail, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt);
                    $fatal(1);
                end

                if (!cfg_enable_seen || !busy_seen || !busy_end_seen || !aw_stall_seen || !w_stall_seen) begin
                    $display("FAIL: buffer sweep missing observations byte_fifo_aw=%0d axi_fifo_aw=%0d stall=%0d cfg=%0b busy=%0b busy_end=%0b awstall=%0b wstall=%0b",
                             BYTE_FIFO_ADDR_WIDTH, AXI_FIFO_ADDR_WIDTH, AXI_STALL_CYCLES,
                             cfg_enable_seen, busy_seen, busy_end_seen, aw_stall_seen, w_stall_seen);
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o || err_sync_o) begin
                    $display("FAIL: unexpected protocol errors during buffer sweep");
                    $fatal(1);
                end

                $display("RESULT: byte_fifo_aw=%0d axi_fifo_aw=%0d stall=%0d exp=%0d act=%0d max_byte_fifo=%0d max_axi_fifo=%0d lane_bp_cycles=%0d pixel_stall_cycles=%0d aw_stall_cycles=%0d w_stall_cycles=%0d axi_busy_duration=%0d",
                         BYTE_FIFO_ADDR_WIDTH,
                         AXI_FIFO_ADDR_WIDTH,
                         AXI_STALL_CYCLES,
                         exp_pixel_cnt,
                         act_pixel_cnt,
                         max_byte_fifo_level,
                         max_axi_fifo_level,
                         lane_ready_drop_cycles,
                         pixel_ready_stall_cycles,
                         aw_stall_cycles,
                         w_stall_cycles,
                         busy_end_cycle - busy_start_cycle);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        release dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_o;
        $finish;
    end

endmodule
