`timescale 1ns/1ps

module tb_fpga_wrapper_resync_clean_frame;

    localparam int LANE_NUM = 2;
    localparam logic [5:0] DATA_TYPE = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID = 2'd0;
    localparam int PIXEL_COUNT = csi2_reference_helpers_pkg::csi2_expected_pixel_count(DATA_TYPE);

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
    logic [31:0]              sb_frame_cnt_unused;
    logic [31:0]              exp_pixel_cnt_unused;
    logic [31:0]              act_pixel_cnt_unused;
    logic [31:0]              mismatch_cnt_unused;

    logic sync_seen;
    logic resync_req_seen;
    logic resync_busy_seen;
    logic resync_done_seen;
    logic resync_clear_seen;
    logic resync_clear_byte_seen;
    logic sensor_done_seen;
    logic post_resync_frame_start_seen;
    logic post_resync_frame_end_seen;
    logic post_resync_line_start_seen;
    logic post_resync_line_end_seen;
    logic post_resync_active;
    int   post_resync_hdr_cnt;
    int   post_resync_payload_cnt;
    int   post_resync_raw8_pixel_cnt;
    int   clean_pixel_cnt;
    int   clean_pixel_mismatch_cnt;

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
        .MAX_PIXELS(64)
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
        .finish_i(1'b0),
        .pass_o(),
        .fail_o(),
        .frame_cnt_o(sb_frame_cnt_unused),
        .exp_pixel_cnt_o(exp_pixel_cnt_unused),
        .act_pixel_cnt_o(act_pixel_cnt_unused),
        .mismatch_cnt_o(mismatch_cnt_unused)
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

    task automatic drive_clean_raw8_frame;
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
            sync_seen                  <= 1'b0;
            resync_req_seen            <= 1'b0;
            resync_busy_seen           <= 1'b0;
            resync_done_seen           <= 1'b0;
            resync_clear_seen          <= 1'b0;
            resync_clear_byte_seen     <= 1'b0;
            sensor_done_seen           <= 1'b0;
            post_resync_frame_start_seen <= 1'b0;
            post_resync_frame_end_seen <= 1'b0;
            post_resync_line_start_seen <= 1'b0;
            post_resync_line_end_seen  <= 1'b0;
            post_resync_hdr_cnt        <= 0;
            post_resync_payload_cnt    <= 0;
            post_resync_raw8_pixel_cnt <= 0;
            clean_pixel_cnt            <= 0;
            clean_pixel_mismatch_cnt   <= 0;
        end else begin
            if (err_sync_o) begin
                sync_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.resync_req) begin
                resync_req_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.resync_busy) begin
                resync_busy_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.resync_clear_pulse_sys) begin
                resync_clear_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.resync_clear_pulse_byte) begin
                resync_clear_byte_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.u_resync_ctrl_fsm.resync_done_o) begin
                resync_done_seen <= 1'b1;
            end
            if (sensor_done) begin
                sensor_done_seen <= 1'b1;
            end

            if (post_resync_active) begin
                if (dut.u_mipi_csi2_capture_top.hdr_valid && dut.u_mipi_csi2_capture_top.hdr_ready) begin
                    post_resync_hdr_cnt <= post_resync_hdr_cnt + 1;
                end
                if (dut.u_mipi_csi2_capture_top.payload_valid && dut.u_mipi_csi2_capture_top.payload_ready) begin
                    post_resync_payload_cnt <= post_resync_payload_cnt + 1;
                end
                if (dut.u_mipi_csi2_capture_top.raw8_pixel_valid && dut.u_mipi_csi2_capture_top.raw8_pixel_ready) begin
                    post_resync_raw8_pixel_cnt <= post_resync_raw8_pixel_cnt + 1;
                end
                if (frame_start_o) begin
                    post_resync_frame_start_seen <= 1'b1;
                end
                if (frame_end_o) begin
                    post_resync_frame_end_seen <= 1'b1;
                end
                if (line_start_o) begin
                    post_resync_line_start_seen <= 1'b1;
                end
                if (line_end_o) begin
                    post_resync_line_end_seen <= 1'b1;
                end
                if (pixel_valid_o) begin
                    if (clean_pixel_cnt >= PIXEL_COUNT) begin
                        clean_pixel_mismatch_cnt <= clean_pixel_mismatch_cnt + 1;
                    end else if (pixel_data_o != csi2_reference_helpers_pkg::csi2_expected_pixel(DATA_TYPE, clean_pixel_cnt)) begin
                        clean_pixel_mismatch_cnt <= clean_pixel_mismatch_cnt + 1;
                    end
                    clean_pixel_cnt <= clean_pixel_cnt + 1;
                end
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
        post_resync_active = 1'b0;
        clear_lane_drive();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
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

        drive_clean_raw8_frame();

        fork
            begin : timeout_block
                repeat (6000) @(posedge clk_sys);
                $display("FAIL: resync clean-frame timeout sync=%0b req=%0b busy=%0b done=%0b clear_sys=%0b clear_byte=%0b clean_fs=%0b clean_fe=%0b clean_ls=%0b clean_le=%0b hdr=%0d payload=%0d raw8pix=%0d clean_pixels=%0d clean_mismatch=%0d",
                         sync_seen, resync_req_seen, resync_busy_seen, resync_done_seen, resync_clear_seen, resync_clear_byte_seen,
                         post_resync_frame_start_seen, post_resync_frame_end_seen,
                         post_resync_line_start_seen, post_resync_line_end_seen,
                         post_resync_hdr_cnt, post_resync_payload_cnt, post_resync_raw8_pixel_cnt,
                         clean_pixel_cnt, clean_pixel_mismatch_cnt);
                $fatal(1);
            end

            begin : main_check_block
                wait (clean_pixel_cnt == PIXEL_COUNT);
                wait (post_resync_frame_end_seen);
                repeat (16) @(posedge clk_sys);

                if (!sync_seen || !resync_req_seen || !resync_busy_seen || !resync_done_seen || !resync_clear_seen || !resync_clear_byte_seen) begin
                    $display("FAIL: resync chain incomplete before clean frame sync=%0b req=%0b busy=%0b done=%0b clear_sys=%0b clear_byte=%0b",
                             sync_seen, resync_req_seen, resync_busy_seen, resync_done_seen, resync_clear_seen, resync_clear_byte_seen);
                    $fatal(1);
                end

                if ((clean_pixel_cnt != PIXEL_COUNT) || (clean_pixel_mismatch_cnt != 0)) begin
                    $display("FAIL: resync clean-frame pixel compare clean_pixels=%0d clean_mismatch=%0d",
                             clean_pixel_cnt, clean_pixel_mismatch_cnt);
                    $fatal(1);
                end

                if (!post_resync_frame_start_seen || !post_resync_frame_end_seen ||
                    !post_resync_line_start_seen) begin
                    $display("FAIL: missing clean-frame markers after resync fs=%0b fe=%0b ls=%0b le=%0b",
                             post_resync_frame_start_seen, post_resync_frame_end_seen,
                             post_resync_line_start_seen, post_resync_line_end_seen);
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o) begin
                    $display("FAIL: unexpected non-sync errors during resync clean-frame test");
                    $fatal(1);
                end

                $display("PASS: tb_fpga_wrapper_resync_clean_frame sync=%0b req=%0b busy=%0b done=%0b clear_sys=%0b clear_byte=%0b clean_pixels=%0d clean_mismatch=%0d hdr=%0d payload=%0d raw8pix=%0d",
                         sync_seen, resync_req_seen, resync_busy_seen, resync_done_seen,
                         resync_clear_seen, resync_clear_byte_seen,
                         clean_pixel_cnt, clean_pixel_mismatch_cnt,
                         post_resync_hdr_cnt, post_resync_payload_cnt, post_resync_raw8_pixel_cnt);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        $finish;
    end

endmodule
