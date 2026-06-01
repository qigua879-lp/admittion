`timescale 1ns/1ps

module tb_fpga_wrapper_axi_mem_closure;

    parameter int LANE_NUM    = 2;
    parameter int LINE_COUNT  = 1;

    localparam logic [5:0] DATA_TYPE          = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID              = 2'd0;
    localparam int PAYLOAD_BYTES              = (LANE_NUM == 4) ? 2 : csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE);
    localparam int PIXELS_PER_LINE            = PAYLOAD_BYTES;
    localparam int TOTAL_PIXELS               = LINE_COUNT * PIXELS_PER_LINE;
    localparam int LINE_PACKET_BYTES          = 4 + (4 + PAYLOAD_BYTES + 2) + 4;
    localparam int STREAM_BYTES               = 4 + (LINE_COUNT * LINE_PACKET_BYTES) + 4;
    localparam logic [31:0] FRAME_BASE_ADDR  = 32'd0;
    localparam logic [31:0] LINE_STRIDE_BYTES = 32'd4096;

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
    logic [3:0]               sensor_lane_valid;
    logic [3:0][7:0]          sensor_lane_data;
    logic [LANE_NUM-1:0]      sensor_lane_ready;
    logic                     exp_valid;
    logic                     exp_ready;
    logic [23:0]              exp_pixel_data;
    logic                     exp_pixel_sof;
    logic                     exp_pixel_sol;
    logic                     act_valid;
    logic                     act_ready;
    logic [23:0]              act_pixel_data;
    logic                     act_pixel_sof;
    logic                     act_pixel_sol;

    logic                     finish_scoreboard;
    logic                     pass;
    logic                     fail;
    logic [31:0]              sb_frame_cnt;
    logic [31:0]              exp_pixel_cnt;
    logic [31:0]              act_pixel_cnt;
    logic [31:0]              mismatch_cnt;

    logic sensor_done_seen;
    logic frame_start_seen;
    logic frame_end_seen;
    logic line_start_seen;
    logic line_end_seen;

    logic [7:0] stream_bytes [0:STREAM_BYTES-1];
    integer byte_write_idx;
    integer aw_burst_count;
    integer w_beat_count;

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

    scoreboard #(
        .MAX_PIXELS(TOTAL_PIXELS + 16)
    ) u_scoreboard (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(1'b0),
        .exp_valid_i(exp_valid),
        .exp_ready_o(exp_ready),
        .exp_data_i(exp_pixel_data),
        .exp_sof_i(exp_pixel_sof),
        .exp_sol_i(exp_pixel_sol),
        .act_valid_i(act_valid),
        .act_ready_o(act_ready),
        .act_data_i(act_pixel_data),
        .act_sof_i(act_pixel_sof),
        .act_sol_i(act_pixel_sol),
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
            if (byte_write_idx >= STREAM_BYTES) begin
                tb_fail("stream byte overflow");
            end
            stream_bytes[byte_write_idx] = byte_val;
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

    task automatic build_stream;
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
            if (byte_write_idx != STREAM_BYTES) begin
                tb_fail("unexpected stream size");
            end
        end
    endtask

    task automatic push_stream_group(input integer start_idx);
        integer lane;
        integer byte_idx;
        integer valid_lanes;
        logic active_ready;
        begin
            valid_lanes  = STREAM_BYTES - start_idx;
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
                sensor_lane_data[lane]  = stream_bytes[byte_idx];
            end

            @(posedge clk_byte);
            @(negedge clk_byte);
            clear_lane_drive();
        end
    endtask

    task automatic drive_frame;
        int idx;
        begin
            for (idx = 0; idx < STREAM_BYTES; idx = idx + LANE_NUM) begin
                push_stream_group(idx);
            end
            sensor_done = 1'b1;
            @(posedge clk_byte);
            sensor_done = 1'b0;
        end
    endtask

    task automatic feed_expected_pixels;
        int line_idx;
        int pixel_idx;
        begin
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

            @(negedge clk_sys);
            exp_valid      = 1'b0;
            exp_pixel_data = 24'd0;
            exp_pixel_sof  = 1'b0;
            exp_pixel_sol  = 1'b0;
        end
    endtask

    task automatic feed_actual_pixels_from_mem;
        int line_idx;
        int pixel_idx;
        int word_idx;
        logic [31:0] mem_word;
        begin
            for (line_idx = 0; line_idx < LINE_COUNT; line_idx = line_idx + 1) begin
                for (pixel_idx = 0; pixel_idx < PIXELS_PER_LINE; pixel_idx = pixel_idx + 1) begin
                    word_idx = ((FRAME_BASE_ADDR + (line_idx * LINE_STRIDE_BYTES)) >> 2) + pixel_idx;
                    mem_word = dut.u_axi_write_null_slave.mem[word_idx];
                    if (mem_word[31:24] !== 8'h00) begin
                        tb_fail("readback high byte not zero");
                    end

                    @(negedge clk_sys);
                    act_valid      = 1'b1;
                    act_pixel_data = mem_word[23:0];
                    act_pixel_sof  = (line_idx == 0) && (pixel_idx == 0);
                    act_pixel_sol  = (pixel_idx == 0);
                    do begin
                        @(posedge clk_sys);
                    end while (!act_ready);
                end

                word_idx = ((FRAME_BASE_ADDR + (line_idx * LINE_STRIDE_BYTES)) >> 2) + PIXELS_PER_LINE;
                if (dut.u_axi_write_null_slave.mem[word_idx] !== 32'd0) begin
                    tb_fail("line stride gap should stay zero");
                end
            end

            @(negedge clk_sys);
            act_valid      = 1'b0;
            act_pixel_data = 24'd0;
            act_pixel_sof  = 1'b0;
            act_pixel_sol  = 1'b0;
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

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            sensor_done_seen <= 1'b0;
            frame_start_seen <= 1'b0;
            frame_end_seen   <= 1'b0;
            line_start_seen  <= 1'b0;
            line_end_seen    <= 1'b0;
        end else begin
            if (sensor_done) begin
                sensor_done_seen <= 1'b1;
            end
            if (frame_start_o) begin
                frame_start_seen <= 1'b1;
            end
            if (frame_end_o) begin
                frame_end_seen <= 1'b1;
            end
            if (line_start_o) begin
                line_start_seen <= 1'b1;
            end
            if (line_end_o) begin
                line_end_seen <= 1'b1;
            end
        end
    end

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            aw_burst_count <= 0;
            w_beat_count   <= 0;
        end else begin
            if (dut.u_mipi_csi2_capture_top.m_axi_awvalid_o &&
                dut.u_mipi_csi2_capture_top.m_axi_awready_i) begin
                aw_burst_count <= aw_burst_count + 1;
            end
            if (dut.u_mipi_csi2_capture_top.m_axi_wvalid_o &&
                dut.u_mipi_csi2_capture_top.m_axi_wready_i) begin
                w_beat_count <= w_beat_count + 1;
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
        act_valid         = 1'b0;
        act_pixel_data    = 24'd0;
        act_pixel_sof     = 1'b0;
        act_pixel_sol     = 1'b0;
        finish_scoreboard = 1'b0;
        build_stream();
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
        repeat (4) @(posedge clk_byte);

        fork
            feed_expected_pixels();
            drive_frame();
        join

        fork
            begin : timeout_block
                repeat (10000) @(posedge clk_sys);
                $display("FAIL: axi mem closure timeout lane=%0d cfg=%0b sensor=%0b frame=%0b/%0b line=%0b/%0b exp=%0d act=%0d mismatch=%0d",
                         LANE_NUM, cfg_init_done_o, sensor_done_seen, frame_start_seen, frame_end_seen,
                         line_start_seen, line_end_seen, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt);
                $fatal(1);
            end

            begin : main_check_block
                wait (frame_end_seen);
                repeat (40) @(posedge clk_axi);
                wait (!dut.u_mipi_csi2_capture_top.axi_busy);
                repeat (8) @(posedge clk_axi);

                feed_actual_pixels_from_mem();

                repeat (8) @(posedge clk_sys);
                @(negedge clk_sys);
                finish_scoreboard = 1'b1;
                @(negedge clk_sys);
                finish_scoreboard = 1'b0;
                @(posedge clk_sys);

                if (!pass || fail) begin
                    $display("FAIL: axi mem closure scoreboard lane=%0d pass=%0b fail=%0b exp=%0d act=%0d mismatch=%0d",
                             LANE_NUM, pass, fail, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt);
                    $fatal(1);
                end

                if (!frame_start_seen || !frame_end_seen || !line_start_seen || !line_end_seen) begin
                    $display("FAIL: axi mem closure lane=%0d missing markers fs=%0b fe=%0b ls=%0b le=%0b",
                             LANE_NUM, frame_start_seen, frame_end_seen, line_start_seen, line_end_seen);
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o || err_sync_o) begin
                    $display("FAIL: axi mem closure lane=%0d unexpected errors ecc=%0b crc=%0b sync=%0b",
                             LANE_NUM, err_ecc_o, err_crc_o, err_sync_o);
                    $fatal(1);
                end

                if (dut.u_axi_write_null_slave.mem_overflow_q) begin
                    tb_fail("axi write sink overflow");
                end

                $display("PASS: tb_fpga_wrapper_axi_mem_closure lane=%0d lines=%0d exp=%0d act=%0d aw_bursts=%0d w_beats=%0d",
                         LANE_NUM, LINE_COUNT, exp_pixel_cnt, act_pixel_cnt, aw_burst_count, w_beat_count);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        release dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_num_minus1_o;
        release dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_enable_mask_o;
        release dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_o;
        $finish;
    end

endmodule
