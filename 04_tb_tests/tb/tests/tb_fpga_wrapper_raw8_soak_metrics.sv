`timescale 1ns/1ps

module tb_fpga_wrapper_raw8_soak_metrics;

    parameter int LANE_NUM             = 2;
    parameter int BYTE_FIFO_ADDR_WIDTH = 2;
    parameter int AXI_FIFO_ADDR_WIDTH  = 3;
    parameter int AXI_STALL_CYCLES     = 0;
    parameter int FRAME_COUNT          = 32;
    parameter int LINE_COUNT           = 8;

    localparam logic [5:0] DATA_TYPE      = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID          = 2'd0;
    localparam int PAYLOAD_BYTES          = csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE);
    localparam int PIXELS_PER_LINE        = csi2_reference_helpers_pkg::csi2_expected_pixel_count(DATA_TYPE);
    localparam int TOTAL_LINES            = FRAME_COUNT * LINE_COUNT;
    localparam int TOTAL_PIXELS           = TOTAL_LINES * PIXELS_PER_LINE;
    localparam int LINE_PACKET_BYTES      = 4 + (4 + PAYLOAD_BYTES + 2) + 4;
    localparam int FRAME_STREAM_BYTES     = 4 + (LINE_COUNT * LINE_PACKET_BYTES) + 4;

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

    logic                sensor_done;
    logic [3:0]          sensor_lane_valid;
    logic [3:0][7:0]     sensor_lane_data;
    logic [LANE_NUM-1:0] sensor_lane_ready;
    logic                exp_valid;
    logic                exp_ready;
    logic [23:0]         exp_pixel_data;
    logic                exp_pixel_sof;
    logic                exp_pixel_sol;

    logic                finish_scoreboard;
    logic                pass;
    logic                fail;
    logic [31:0]         sb_frame_cnt;
    logic [31:0]         exp_pixel_cnt;
    logic [31:0]         act_pixel_cnt;
    logic [31:0]         mismatch_cnt;

    logic [7:0] frame_stream [0:FRAME_STREAM_BYTES-1];
    integer byte_write_idx;

    integer frame_start_count;
    integer frame_end_count;
    integer line_start_count;
    integer line_end_count;
    integer pixel_sof_count;
    integer pixel_sol_count;
    integer lane_bp_cycles;
    integer aw_stall_cycles;
    integer w_stall_cycles;
    integer aw_burst_count;
    integer w_beat_count;
    integer max_byte_fifo_level;
    integer max_axi_fifo_level;

    logic frame_start_seen;
    logic frame_end_seen;
    logic lane_bp_seen;
    logic aw_stall_seen;
    logic w_stall_seen;

    integer byte_cycle_counter;
    integer axi_cycle_counter;
    integer start_byte_cycle;
    integer end_byte_cycle;
    integer start_axi_cycle;
    integer end_axi_cycle;
    integer byte_window_cycles;
    integer axi_window_cycles;
    integer pixels_per_byte_clk_x1000;
    integer pixels_per_axi_clk_x1000;
    integer lane_idx;
    logic lane_bp_this_cycle;

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
        .MAX_PIXELS(TOTAL_PIXELS + 64)
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

    function automatic logic [7:0] payload_byte(input int idx);
        begin
            payload_byte = csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, idx);
        end
    endfunction

    task automatic tb_fail(input string msg);
        begin
            $display("FAIL: %s", msg);
            $fatal(1);
        end
    endtask

    task automatic clear_lane_drive;
        begin
            sensor_lane_valid = 4'b0000;
            sensor_lane_data  = '0;
        end
    endtask

    task automatic append_byte(input logic [7:0] byte_val);
        begin
            if (byte_write_idx >= FRAME_STREAM_BYTES) begin
                tb_fail("frame stream byte overflow");
            end
            frame_stream[byte_write_idx] = byte_val;
            byte_write_idx = byte_write_idx + 1;
        end
    endtask

    task automatic append_short_packet(input logic [5:0] dt);
        logic [31:0] header;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, dt, 16'd0, 1'b0);
            append_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 0));
            append_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 1));
            append_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 2));
            append_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 3));
        end
    endtask

    task automatic append_long_packet;
        logic [31:0] header;
        logic [15:0] crc;
        int idx;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, DATA_TYPE, PAYLOAD_BYTES, 1'b0);
            crc    = csi2_reference_helpers_pkg::csi2_payload_crc(DATA_TYPE);

            append_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 0));
            append_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 1));
            append_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 2));
            append_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 3));
            for (idx = 0; idx < PAYLOAD_BYTES; idx = idx + 1) begin
                append_byte(payload_byte(idx));
            end
            append_byte(crc[7:0]);
            append_byte(crc[15:8]);
        end
    endtask

    task automatic build_frame_stream;
        int line_idx;
        begin
            byte_write_idx = 0;
            append_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            for (line_idx = 0; line_idx < LINE_COUNT; line_idx = line_idx + 1) begin
                append_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
                append_long_packet();
                append_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
            end
            append_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
            if (byte_write_idx != FRAME_STREAM_BYTES) begin
                tb_fail("unexpected frame stream size");
            end
        end
    endtask

    task automatic push_stream_group(input integer start_idx);
        integer lane;
        integer byte_idx;
        integer valid_lanes;
        logic active_ready;
        begin
            valid_lanes = FRAME_STREAM_BYTES - start_idx;
            if (valid_lanes > LANE_NUM) begin
                valid_lanes = LANE_NUM;
            end

            active_ready = 1'b0;
            while (!active_ready) begin
                active_ready = 1'b1;
                for (lane = 0; lane < valid_lanes; lane = lane + 1) begin
                    if (!sensor_lane_ready[lane]) begin
                        active_ready = 1'b0;
                    end
                end
                if (!active_ready) begin
                    @(posedge clk_byte);
                end
            end

            @(negedge clk_byte);
            clear_lane_drive();
            for (lane = 0; lane < valid_lanes; lane = lane + 1) begin
                byte_idx = start_idx + lane;
                sensor_lane_valid[lane] = 1'b1;
                sensor_lane_data[lane]  = frame_stream[byte_idx];
            end

            @(posedge clk_byte);
            @(negedge clk_byte);
            clear_lane_drive();
        end
    endtask

    task automatic drive_frames;
        int frame_idx;
        int idx;
        begin
            for (frame_idx = 0; frame_idx < FRAME_COUNT; frame_idx = frame_idx + 1) begin
                for (idx = 0; idx < FRAME_STREAM_BYTES; idx = idx + LANE_NUM) begin
                    push_stream_group(idx);
                end
            end
            sensor_done = 1'b1;
            @(posedge clk_byte);
            sensor_done = 1'b0;
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

    assign lane_data_0  = {24'd0, sensor_lane_data[0]};
    assign lane_data_1  = {24'd0, sensor_lane_data[1]};
    assign lane_data_2  = {24'd0, sensor_lane_data[2]};
    assign lane_data_3  = {24'd0, sensor_lane_data[3]};
    assign lane_valid_0 = sensor_lane_valid[0];
    assign lane_valid_1 = sensor_lane_valid[1];
    assign lane_valid_2 = sensor_lane_valid[2];
    assign lane_valid_3 = sensor_lane_valid[3];

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
            byte_cycle_counter <= 0;
            lane_bp_cycles     <= 0;
            lane_bp_seen       <= 1'b0;
        end else begin
            byte_cycle_counter <= byte_cycle_counter + 1;
            lane_bp_this_cycle = 1'b0;
            for (lane_idx = 0; lane_idx < LANE_NUM; lane_idx = lane_idx + 1) begin
                if (!sensor_lane_ready[lane_idx]) begin
                    lane_bp_this_cycle = 1'b1;
                end
            end
            if (lane_bp_this_cycle) begin
                lane_bp_seen   <= 1'b1;
                lane_bp_cycles <= lane_bp_cycles + 1;
            end
        end
    end

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            axi_cycle_counter  <= 0;
            aw_stall_cycles    <= 0;
            w_stall_cycles     <= 0;
            aw_burst_count     <= 0;
            w_beat_count       <= 0;
            aw_stall_seen      <= 1'b0;
            w_stall_seen       <= 1'b0;
            max_axi_fifo_level <= 0;
        end else begin
            axi_cycle_counter <= axi_cycle_counter + 1;
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
            if (dut.u_mipi_csi2_capture_top.m_axi_awvalid_o &&
                dut.u_mipi_csi2_capture_top.m_axi_awready_i) begin
                aw_burst_count <= aw_burst_count + 1;
            end
            if (dut.u_mipi_csi2_capture_top.m_axi_wvalid_o &&
                dut.u_mipi_csi2_capture_top.m_axi_wready_i) begin
                w_beat_count <= w_beat_count + 1;
            end
            if ($signed(dut.u_mipi_csi2_capture_top.u_pixel_to_axi_writer.data_fifo_wr_level_unused) > max_axi_fifo_level) begin
                max_axi_fifo_level <= dut.u_mipi_csi2_capture_top.u_pixel_to_axi_writer.data_fifo_wr_level_unused;
            end
        end
    end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            frame_start_count   <= 0;
            frame_end_count     <= 0;
            line_start_count    <= 0;
            line_end_count      <= 0;
            pixel_sof_count     <= 0;
            pixel_sol_count     <= 0;
            frame_start_seen    <= 1'b0;
            frame_end_seen      <= 1'b0;
            max_byte_fifo_level <= 0;
            start_byte_cycle    <= -1;
            end_byte_cycle      <= -1;
            start_axi_cycle     <= -1;
            end_axi_cycle       <= -1;
        end else begin
            if (frame_start_o) begin
                frame_start_seen  <= 1'b1;
                frame_start_count <= frame_start_count + 1;
                if (start_byte_cycle < 0) begin
                    start_byte_cycle <= byte_cycle_counter;
                    start_axi_cycle  <= axi_cycle_counter;
                end
            end
            if (frame_end_o) begin
                frame_end_seen  <= 1'b1;
                frame_end_count <= frame_end_count + 1;
                end_byte_cycle  <= byte_cycle_counter;
                end_axi_cycle   <= axi_cycle_counter;
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
            if ($signed(dut.u_mipi_csi2_capture_top.fifo_wr_level_unused) > max_byte_fifo_level) begin
                max_byte_fifo_level <= dut.u_mipi_csi2_capture_top.fifo_wr_level_unused;
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
        build_frame_stream();
        clear_lane_drive();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_o = 1'b1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_num_minus1_o = LANE_NUM - 1;
        case (LANE_NUM)
            1: force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_enable_mask_o = 4'b0001;
            2: force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_enable_mask_o = 4'b0011;
            default: force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_enable_mask_o = 4'b1111;
        endcase
        repeat (4) @(posedge clk_sys);
        repeat (4) @(posedge clk_axi);

        if (AXI_STALL_CYCLES > 0) begin
            force dut.m_axi_awready = 1'b0;
            force dut.m_axi_wready  = 1'b0;
        end

        fork : launch_block
            begin
                fork
                    feed_expected_pixels();
                    drive_frames();
                join
            end
            begin : aw_staller
                if (AXI_STALL_CYCLES > 0) begin
                    forever begin
                        wait (dut.u_mipi_csi2_capture_top.m_axi_awvalid_o);
                        repeat (AXI_STALL_CYCLES) @(posedge clk_axi);
                        release dut.m_axi_awready;
                        @(posedge clk_axi);
                        force dut.m_axi_awready = 1'b0;
                    end
                end
            end
            begin : w_staller
                if (AXI_STALL_CYCLES > 0) begin
                    forever begin
                        wait (dut.u_mipi_csi2_capture_top.m_axi_wvalid_o);
                        repeat (AXI_STALL_CYCLES) @(posedge clk_axi);
                        release dut.m_axi_wready;
                        @(posedge clk_axi);
                        force dut.m_axi_wready = 1'b0;
                    end
                end
            end
        join_none

        fork
            begin : timeout_block
                repeat (120000) @(posedge clk_sys);
                $display("FAIL: raw8 soak timeout lane=%0d frames=%0d lines=%0d fs=%0d fe=%0d exp=%0d act=%0d mismatch=%0d",
                         LANE_NUM, FRAME_COUNT, LINE_COUNT, frame_start_count, frame_end_count,
                         exp_pixel_cnt, act_pixel_cnt, mismatch_cnt);
                $fatal(1);
            end

            begin : main_check_block
                wait (act_pixel_cnt == TOTAL_PIXELS);
                wait (frame_end_count == FRAME_COUNT);
                repeat (80) @(posedge clk_axi);
                wait (!dut.u_mipi_csi2_capture_top.axi_busy);
                repeat (8) @(posedge clk_axi);

                @(negedge clk_sys);
                finish_scoreboard = 1'b1;
                @(negedge clk_sys);
                finish_scoreboard = 1'b0;
                @(posedge clk_sys);

                if (!pass || fail) begin
                    $display("FAIL: raw8 soak scoreboard pass=%0b fail=%0b exp=%0d act=%0d mismatch=%0d",
                             pass, fail, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt);
                    $fatal(1);
                end

                if (frame_start_count != FRAME_COUNT || frame_end_count != FRAME_COUNT ||
                    line_start_count != TOTAL_LINES || line_end_count != TOTAL_LINES ||
                    pixel_sof_count != FRAME_COUNT || pixel_sol_count != TOTAL_LINES) begin
                    $display("FAIL: raw8 soak marker count fs=%0d fe=%0d ls=%0d le=%0d psof=%0d psol=%0d",
                             frame_start_count, frame_end_count, line_start_count,
                             line_end_count, pixel_sof_count, pixel_sol_count);
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o || err_sync_o) begin
                    $display("FAIL: unexpected protocol errors during raw8 soak");
                    $fatal(1);
                end

                byte_window_cycles = (end_byte_cycle - start_byte_cycle) + 1;
                axi_window_cycles  = (end_axi_cycle - start_axi_cycle) + 1;
                if (byte_window_cycles <= 0 || axi_window_cycles <= 0) begin
                    tb_fail("invalid throughput window");
                end
                pixels_per_byte_clk_x1000 = (TOTAL_PIXELS * 1000) / byte_window_cycles;
                pixels_per_axi_clk_x1000  = (TOTAL_PIXELS * 1000) / axi_window_cycles;

                $display("RESULT: lane=%0d byte_fifo_aw=%0d axi_fifo_aw=%0d stall=%0d frames=%0d lines_per_frame=%0d total_lines=%0d total_pixels=%0d aw_bursts=%0d w_beats=%0d aw_stall_cycles=%0d w_stall_cycles=%0d lane_bp_seen=%0b lane_bp_cycles=%0d max_byte_fifo=%0d max_axi_fifo=%0d pix_per_byte_clk_x1000=%0d pix_per_axi_clk_x1000=%0d byte_window_cycles=%0d axi_window_cycles=%0d",
                         LANE_NUM,
                         BYTE_FIFO_ADDR_WIDTH,
                         AXI_FIFO_ADDR_WIDTH,
                         AXI_STALL_CYCLES,
                         FRAME_COUNT,
                         LINE_COUNT,
                         TOTAL_LINES,
                         TOTAL_PIXELS,
                         aw_burst_count,
                         w_beat_count,
                         aw_stall_cycles,
                         w_stall_cycles,
                         lane_bp_seen,
                         lane_bp_cycles,
                         max_byte_fifo_level,
                         max_axi_fifo_level,
                         pixels_per_byte_clk_x1000,
                         pixels_per_axi_clk_x1000,
                         byte_window_cycles,
                         axi_window_cycles);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        disable launch_block;
        if (AXI_STALL_CYCLES > 0) begin
            release dut.m_axi_awready;
            release dut.m_axi_wready;
        end
        release dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_num_minus1_o;
        release dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_enable_mask_o;
        release dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_o;
        $finish;
    end

endmodule
