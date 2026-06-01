`timescale 1ns/1ps

module tb_fpga_wrapper_resync_backpressure_multiframe;

    localparam int LANE_NUM             = 2;
    localparam int BYTE_FIFO_ADDR_WIDTH = 2;
    localparam int AXI_FIFO_ADDR_WIDTH  = 3;
    localparam int AXI_STALL_CYCLES     = 12;
    localparam logic [5:0] DATA_TYPE    = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID        = 2'd0;
    localparam int PIXELS_PER_LINE      = csi2_reference_helpers_pkg::csi2_expected_pixel_count(DATA_TYPE);
    localparam int FRAME_COUNT          = 2;
    localparam int LINE_COUNT           = 2;
    localparam int TOTAL_LINES          = FRAME_COUNT * LINE_COUNT;
    localparam int TOTAL_PIXELS         = TOTAL_LINES * PIXELS_PER_LINE;

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
    logic                     scoreboard_clear;
    logic                     finish_scoreboard;
    logic                     pass;
    logic                     fail;
    logic [31:0]              sb_frame_cnt;
    logic [31:0]              exp_pixel_cnt;
    logic [31:0]              act_pixel_cnt;
    logic [31:0]              mismatch_cnt;

    logic resync_req_seen;
    logic resync_busy_seen;
    logic resync_done_seen;
    logic resync_clear_sys_seen;
    logic resync_clear_byte_seen;
    logic post_resync_active;
    logic clean_phase_active;
    logic clean_drive_done;
    logic aw_stall_seen;
    logic w_stall_seen;
    integer frame_start_count;
    integer frame_end_count;
    integer line_start_count;
    integer line_end_count;
    integer pixel_sof_count;
    integer pixel_sol_count;
    integer aw_stall_cycles;
    integer w_stall_cycles;

    mipi_csi2_capture_fpga_wrapper #(
        .LANE_NUM(LANE_NUM),
        .BYTE_FIFO_ADDR_WIDTH(BYTE_FIFO_ADDR_WIDTH),
        .AXI_FIFO_ADDR_WIDTH(AXI_FIFO_ADDR_WIDTH)
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
        .clear_i(scoreboard_clear),
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
        logic [15:0] payload_crc;
        begin
            header      = csi2_reference_helpers_pkg::csi2_pack_header(
                VC_ID,
                DATA_TYPE,
                csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE),
                1'b0
            );
            payload_crc = csi2_reference_helpers_pkg::csi2_payload_crc(DATA_TYPE);

            push_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 1)
            );
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 3)
            );
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 0),
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 1)
            );
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 2),
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 3)
            );
            push_lane_group(payload_crc[7:0], payload_crc[15:8]);
        end
    endtask

    task automatic drive_illegal_sequence;
        begin
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
        end
    endtask

    task automatic feed_expected_pixels;
        int frame_idx;
        int line_idx;
        int pixel_idx;
        begin
            for (frame_idx = 0; frame_idx < FRAME_COUNT; frame_idx = frame_idx + 1) begin
                for (line_idx = 0; line_idx < LINE_COUNT; line_idx = line_idx + 1) begin
                    for (pixel_idx = 0; pixel_idx < PIXELS_PER_LINE; pixel_idx = pixel_idx + 1) begin
                        @(negedge clk_sys);
                        exp_valid      = 1'b1;
                        exp_pixel_data = csi2_reference_helpers_pkg::csi2_expected_pixel(DATA_TYPE, pixel_idx);
                        exp_pixel_sof  = (line_idx == 0) && (pixel_idx == 0);
                        exp_pixel_sol  = (pixel_idx == 0);
                        do begin
                            @(posedge clk_sys);
                        end while (!exp_ready);
                    end
                end
            end

            @(negedge clk_sys);
            exp_valid      = 1'b0;
            exp_pixel_data = 24'd0;
            exp_pixel_sof  = 1'b0;
            exp_pixel_sol  = 1'b0;
        end
    endtask

    task automatic drive_clean_frames;
        int frame_idx;
        int line_idx;
        begin
            clean_phase_active = 1'b1;
            for (frame_idx = 0; frame_idx < FRAME_COUNT; frame_idx = frame_idx + 1) begin
                send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
                for (line_idx = 0; line_idx < LINE_COUNT; line_idx = line_idx + 1) begin
                    send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
                    send_long_packet();
                    send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
                end
                send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
            end
            sensor_done = 1'b1;
            @(posedge clk_byte);
            sensor_done = 1'b0;
            clean_phase_active = 1'b0;
            clean_drive_done   = 1'b1;
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
            resync_req_seen       <= 1'b0;
            resync_busy_seen      <= 1'b0;
            resync_done_seen      <= 1'b0;
            resync_clear_sys_seen <= 1'b0;
            frame_start_count     <= 0;
            frame_end_count       <= 0;
            line_start_count      <= 0;
            line_end_count        <= 0;
            pixel_sof_count       <= 0;
            pixel_sol_count       <= 0;
        end else begin
            if (err_sync_o) begin
                resync_req_seen <= resync_req_seen | dut.u_mipi_csi2_capture_top.resync_req;
            end
            if (dut.u_mipi_csi2_capture_top.resync_req) begin
                resync_req_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.resync_busy) begin
                resync_busy_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.resync_clear_pulse_sys) begin
                resync_clear_sys_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.u_resync_ctrl_fsm.resync_done_o) begin
                resync_done_seen <= 1'b1;
            end

            if (post_resync_active) begin
                if (frame_start_o) begin
                    frame_start_count <= frame_start_count + 1;
                end
                if (frame_end_o) begin
                    frame_end_count <= frame_end_count + 1;
                end
                if (line_start_o) begin
                    line_start_count <= line_start_count + 1;
                end
                if (line_end_o) begin
                    line_end_count <= line_end_count + 1;
                end
                if (pixel_valid_o && pixel_sof_o) begin
                    pixel_sof_count <= pixel_sof_count + 1;
                end
                if (pixel_valid_o && pixel_sol_o) begin
                    pixel_sol_count <= pixel_sol_count + 1;
                end
            end
        end
    end

    always_ff @(posedge clk_byte) begin
        if (!rst_n) begin
            resync_clear_byte_seen <= 1'b0;
        end else if (dut.u_mipi_csi2_capture_top.resync_clear_pulse_byte) begin
            resync_clear_byte_seen <= 1'b1;
        end
    end

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            aw_stall_seen   <= 1'b0;
            w_stall_seen    <= 1'b0;
            aw_stall_cycles <= 0;
            w_stall_cycles  <= 0;
        end else begin
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
        scoreboard_clear  = 1'b0;
        finish_scoreboard = 1'b0;
        post_resync_active = 1'b0;
        clean_phase_active = 1'b0;
        clean_drive_done   = 1'b0;
        clear_lane_drive();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_o = 1'b1;
        repeat (4) @(posedge clk_sys);
        repeat (4) @(posedge clk_axi);
        fork : launch_block
            begin
                wait (post_resync_active && frame_start_count >= 1);
                force dut.m_axi_awready = 1'b0;
                forever begin
                    wait (dut.u_mipi_csi2_capture_top.m_axi_awvalid_o);
                    repeat (AXI_STALL_CYCLES) @(posedge clk_axi);
                    release dut.m_axi_awready;
                    @(posedge clk_axi);
                    force dut.m_axi_awready = 1'b0;
                end
            end
            begin
                wait (post_resync_active && frame_start_count >= 1);
                force dut.m_axi_wready = 1'b0;
                forever begin
                    wait (dut.u_mipi_csi2_capture_top.m_axi_wvalid_o);
                    repeat (AXI_STALL_CYCLES) @(posedge clk_axi);
                    release dut.m_axi_wready;
                    @(posedge clk_axi);
                    force dut.m_axi_wready = 1'b0;
                end
            end
        join_none

        fork
            begin : timeout_block
                repeat (30000) @(posedge clk_sys);
                $display("FAIL: resync/backpressure multiframe timeout req=%0b busy=%0b done=%0b clear_sys=%0b clear_byte=%0b clean_done=%0b aw=%0b w=%0b exp=%0d act=%0d mismatch=%0d fs=%0d fe=%0d ls=%0d le=%0d",
                         resync_req_seen, resync_busy_seen, resync_done_seen,
                         resync_clear_sys_seen, resync_clear_byte_seen, clean_drive_done,
                         aw_stall_seen, w_stall_seen, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt,
                         frame_start_count, frame_end_count, line_start_count, line_end_count);
                $fatal(1);
            end

            begin : main_check_block
                repeat (4) @(posedge clk_byte);
                drive_illegal_sequence();
                wait (resync_done_seen);
                wait (resync_clear_byte_seen);
                while (dut.u_mipi_csi2_capture_top.parser_busy ||
                       dut.u_mipi_csi2_capture_top.frame_active ||
                       dut.u_mipi_csi2_capture_top.line_active  ||
                       dut.u_mipi_csi2_capture_top.fifo_rd_valid ||
                       dut.u_mipi_csi2_capture_top.merge_byte_valid) begin
                    @(posedge clk_sys);
                end
                repeat (8) @(posedge clk_sys);

                @(negedge clk_sys);
                scoreboard_clear = 1'b1;
                @(negedge clk_sys);
                scoreboard_clear = 1'b0;
                post_resync_active = 1'b1;

                fork
                    feed_expected_pixels();
                    drive_clean_frames();
                join

                wait (act_pixel_cnt == TOTAL_PIXELS);
                wait (frame_end_count >= FRAME_COUNT);
                repeat (40) @(posedge clk_axi);
                wait (!dut.u_mipi_csi2_capture_top.axi_busy);
                repeat (8) @(posedge clk_axi);

                @(negedge clk_sys);
                finish_scoreboard = 1'b1;
                @(negedge clk_sys);
                finish_scoreboard = 1'b0;
                @(posedge clk_sys);

                if (!pass || fail) begin
                    $display("FAIL: resync/backpressure multiframe scoreboard pass=%0b fail=%0b exp=%0d act=%0d mismatch=%0d",
                             pass, fail, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt);
                    $fatal(1);
                end

                if (!resync_req_seen || !resync_busy_seen || !resync_done_seen ||
                    !resync_clear_sys_seen || !resync_clear_byte_seen) begin
                    $display("FAIL: resync chain incomplete req=%0b busy=%0b done=%0b clear_sys=%0b clear_byte=%0b",
                             resync_req_seen, resync_busy_seen, resync_done_seen,
                             resync_clear_sys_seen, resync_clear_byte_seen);
                    $fatal(1);
                end

                if (!aw_stall_seen || !w_stall_seen) begin
                    $display("FAIL: expected AXI backpressure observations aw=%0b w=%0b",
                             aw_stall_seen, w_stall_seen);
                    $fatal(1);
                end

                if (frame_start_count != FRAME_COUNT || frame_end_count != FRAME_COUNT ||
                    line_start_count != TOTAL_LINES || line_end_count != TOTAL_LINES ||
                    pixel_sof_count != FRAME_COUNT || pixel_sol_count != TOTAL_LINES) begin
                    $display("FAIL: clean multiframe counters fs=%0d fe=%0d ls=%0d le=%0d psof=%0d psol=%0d",
                             frame_start_count, frame_end_count, line_start_count,
                             line_end_count, pixel_sof_count, pixel_sol_count);
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o) begin
                    $display("FAIL: unexpected ECC/CRC errors during mixed scenario");
                    $fatal(1);
                end

                $display("PASS: tb_fpga_wrapper_resync_backpressure_multiframe frames=%0d lines=%0d exp=%0d act=%0d mismatch=%0d aw_stall_cycles=%0d w_stall_cycles=%0d",
                         FRAME_COUNT, TOTAL_LINES, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt,
                         aw_stall_cycles, w_stall_cycles);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        disable launch_block;
        release dut.m_axi_awready;
        release dut.m_axi_wready;
        release dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_o;
        $finish;
    end

endmodule
