`timescale 1ns/1ps

module tb_mipi_csi2_capture_dphy_no_backpressure_guard;

    localparam int LANE_NUM             = 2;
    localparam int BYTE_FIFO_ADDR_WIDTH = 6;
    localparam logic [5:0] DATA_TYPE    = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID        = 2'd0;
    localparam int PIXEL_COUNT          = csi2_reference_helpers_pkg::csi2_expected_pixel_count(DATA_TYPE);

    logic clk_sys;
    logic clk_axi;
    logic clk_ddr;
    logic rxbyteclkhs;
    logic rst_n;
    logic cl_stopstate;

    logic [7:0] dl0_rxdatahs;
    logic [7:0] dl1_rxdatahs;
    logic [7:0] dl2_rxdatahs;
    logic [7:0] dl3_rxdatahs;
    logic       dl0_rxvalidhs;
    logic       dl1_rxvalidhs;
    logic       dl2_rxvalidhs;
    logic       dl3_rxvalidhs;
    logic       dl0_rxactivehs;
    logic       dl1_rxactivehs;
    logic       dl2_rxactivehs;
    logic       dl3_rxactivehs;
    logic       dl0_rxsynchs;
    logic       dl1_rxsynchs;
    logic       dl2_rxsynchs;
    logic       dl3_rxsynchs;
    logic       dl0_stopstate;
    logic       dl1_stopstate;
    logic       dl2_stopstate;
    logic       dl3_stopstate;
    logic       dl0_errsoths;
    logic       dl1_errsoths;
    logic       dl2_errsoths;
    logic       dl3_errsoths;
    logic       dl0_errsotsynchs;
    logic       dl1_errsotsynchs;
    logic       dl2_errsotsynchs;
    logic       dl3_errsotsynchs;

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
    logic        retry_req_o;
    logic        retry_pending_o;
    logic        retry_mode_o;
    logic [31:0] retry_frame_id_o;
    logic [31:0] retry_line_id_o;
    logic        cfg_init_done_o;
    logic        dphy_hs_mode_o;
    logic        dphy_lp_mode_o;
    logic [3:0]  dphy_lane_active_hs_o;
    logic [3:0]  dphy_lane_valid_hs_o;
    logic [3:0]  dphy_lane_sync_hs_o;
    logic [3:0]  dphy_lane_stopstate_o;
    logic        dphy_err_sot_hs_o;
    logic        dphy_err_sot_sync_hs_o;
    logic [63:0] ila_probe_o;

    logic        exp_valid;
    logic        exp_ready;
    logic [23:0] exp_pixel_data;
    logic        exp_pixel_sof;
    logic        exp_pixel_sol;
    logic        finish_scoreboard;
    logic        pass;
    logic        fail;
    logic [31:0] sb_frame_cnt;
    logic [31:0] exp_pixel_cnt;
    logic [31:0] act_pixel_cnt;
    logic [31:0] mismatch_cnt;

    logic first_frame_done;
    logic clean_frame_done;
    logic preclean_frame_seen;
    logic preclean_pixel_seen;
    logic clean_frame_start_seen;
    logic clean_frame_end_seen;
    logic clean_line_start_seen;
    logic clean_line_end_seen;
    logic fifo_pressure_seen;
    logic lane_ready_low_seen;
    int   max_byte_fifo_level;
    int   post_drop_fifo_read_count;
    int   post_drop_hdr_count;
    int   post_drop_fs_hdr_count;
    int   post_drop_guard_trigger_count;
    int   post_drop_byte_drop_count;
    int   post_drop_ppi_valid_count;
    int   post_drop_hs_count;
    int   post_drop_lp_count;
    int   post_drop_dphy_valid_count;
    int   post_drop_raw_phy_valid_count;
    int   post_drop_phy_valid_count;
    int   post_drop_merge_valid_count;
    int   post_drop_fifo_write_count;
    int   post_drop_trig_deskew_count;
    int   post_drop_trig_merge_bp_count;
    int   post_drop_trig_level_count;

    mipi_csi2_capture_dphy_wrapper #(
        .LANE_NUM(LANE_NUM),
        .DESKEW_DEPTH(16),
        .BYTE_FIFO_ADDR_WIDTH(BYTE_FIFO_ADDR_WIDTH),
        .BYTE_FIFO_GUARD_MARGIN(0),
        .AXI_FIFO_ADDR_WIDTH(4),
        .AXI_DATA_WIDTH(128)
    ) dut (
        .clk_sys(clk_sys),
        .clk_axi(clk_axi),
        .clk_ddr(clk_ddr),
        .rst_n(rst_n),
        .rxbyteclkhs(rxbyteclkhs),
        .cl_stopstate(cl_stopstate),
        .dl0_rxdatahs(dl0_rxdatahs),
        .dl1_rxdatahs(dl1_rxdatahs),
        .dl2_rxdatahs(dl2_rxdatahs),
        .dl3_rxdatahs(dl3_rxdatahs),
        .dl0_rxvalidhs(dl0_rxvalidhs),
        .dl1_rxvalidhs(dl1_rxvalidhs),
        .dl2_rxvalidhs(dl2_rxvalidhs),
        .dl3_rxvalidhs(dl3_rxvalidhs),
        .dl0_rxactivehs(dl0_rxactivehs),
        .dl1_rxactivehs(dl1_rxactivehs),
        .dl2_rxactivehs(dl2_rxactivehs),
        .dl3_rxactivehs(dl3_rxactivehs),
        .dl0_rxsynchs(dl0_rxsynchs),
        .dl1_rxsynchs(dl1_rxsynchs),
        .dl2_rxsynchs(dl2_rxsynchs),
        .dl3_rxsynchs(dl3_rxsynchs),
        .dl0_stopstate(dl0_stopstate),
        .dl1_stopstate(dl1_stopstate),
        .dl2_stopstate(dl2_stopstate),
        .dl3_stopstate(dl3_stopstate),
        .dl0_errsoths(dl0_errsoths),
        .dl1_errsoths(dl1_errsoths),
        .dl2_errsoths(dl2_errsoths),
        .dl3_errsoths(dl3_errsoths),
        .dl0_errsotsynchs(dl0_errsotsynchs),
        .dl1_errsotsynchs(dl1_errsotsynchs),
        .dl2_errsotsynchs(dl2_errsotsynchs),
        .dl3_errsotsynchs(dl3_errsotsynchs),
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
        .retry_req_o(retry_req_o),
        .retry_pending_o(retry_pending_o),
        .retry_mode_o(retry_mode_o),
        .retry_frame_id_o(retry_frame_id_o),
        .retry_line_id_o(retry_line_id_o),
        .cfg_init_done_o(cfg_init_done_o),
        .dphy_hs_mode_o(dphy_hs_mode_o),
        .dphy_lp_mode_o(dphy_lp_mode_o),
        .dphy_lane_active_hs_o(dphy_lane_active_hs_o),
        .dphy_lane_valid_hs_o(dphy_lane_valid_hs_o),
        .dphy_lane_sync_hs_o(dphy_lane_sync_hs_o),
        .dphy_lane_stopstate_o(dphy_lane_stopstate_o),
        .dphy_err_sot_hs_o(dphy_err_sot_hs_o),
        .dphy_err_sot_sync_hs_o(dphy_err_sot_sync_hs_o),
        .ila_probe_o(ila_probe_o)
    );

    scoreboard #(
        .MAX_PIXELS(64)
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

    always #5 clk_sys = ~clk_sys;
    always #5 clk_axi = ~clk_axi;
    always #6 clk_ddr = ~clk_ddr;
    always #4 rxbyteclkhs = ~rxbyteclkhs;

    task automatic fail_msg(input string msg);
        begin
            $display("FAIL: %s", msg);
            $fatal(1);
        end
    endtask

    task automatic set_lp_idle;
        begin
            cl_stopstate      = 1'b1;
            dl0_rxvalidhs     = 1'b0;
            dl1_rxvalidhs     = 1'b0;
            dl2_rxvalidhs     = 1'b0;
            dl3_rxvalidhs     = 1'b0;
            dl0_rxactivehs    = 1'b0;
            dl1_rxactivehs    = 1'b0;
            dl2_rxactivehs    = 1'b0;
            dl3_rxactivehs    = 1'b0;
            dl0_rxsynchs      = 1'b0;
            dl1_rxsynchs      = 1'b0;
            dl2_rxsynchs      = 1'b0;
            dl3_rxsynchs      = 1'b0;
            dl0_stopstate     = 1'b1;
            dl1_stopstate     = 1'b1;
            dl2_stopstate     = 1'b1;
            dl3_stopstate     = 1'b1;
            dl0_errsoths      = 1'b0;
            dl1_errsoths      = 1'b0;
            dl2_errsoths      = 1'b0;
            dl3_errsoths      = 1'b0;
            dl0_errsotsynchs  = 1'b0;
            dl1_errsotsynchs  = 1'b0;
            dl2_errsotsynchs  = 1'b0;
            dl3_errsotsynchs  = 1'b0;
        end
    endtask

    task automatic enter_hs;
        begin
            cl_stopstate   = 1'b0;
            dl0_rxactivehs = 1'b1;
            dl1_rxactivehs = 1'b1;
            dl0_stopstate  = 1'b0;
            dl1_stopstate  = 1'b0;
        end
    endtask

    task automatic clear_ppi_valid;
        begin
            dl0_rxdatahs  = 8'd0;
            dl1_rxdatahs  = 8'd0;
            dl2_rxdatahs  = 8'd0;
            dl3_rxdatahs  = 8'd0;
            dl0_rxvalidhs = 1'b0;
            dl1_rxvalidhs = 1'b0;
            dl2_rxvalidhs = 1'b0;
            dl3_rxvalidhs = 1'b0;
            dl0_rxsynchs  = 1'b0;
            dl1_rxsynchs  = 1'b0;
            dl2_rxsynchs  = 1'b0;
            dl3_rxsynchs  = 1'b0;
        end
    endtask

    task automatic push_ppi_lane_group(
        input logic [7:0] byte0,
        input logic [7:0] byte1,
        input logic       sync_marker
    );
        begin
            @(negedge rxbyteclkhs);
            dl0_rxdatahs  = byte0;
            dl1_rxdatahs  = byte1;
            dl0_rxvalidhs = 1'b1;
            dl1_rxvalidhs = 1'b1;
            dl0_rxsynchs  = sync_marker;
            dl1_rxsynchs  = sync_marker;

            @(posedge rxbyteclkhs);
            @(negedge rxbyteclkhs);
            clear_ppi_valid();
        end
    endtask

    task automatic send_short_packet(input logic [5:0] dt);
        logic [31:0] header;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, dt, 16'd0, 1'b0);
            push_ppi_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 1),
                1'b1
            );
            push_ppi_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 3),
                1'b0
            );
        end
    endtask

    task automatic send_long_packet;
        logic [31:0] header;
        logic [15:0] payload_crc;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(
                VC_ID,
                DATA_TYPE,
                csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE),
                1'b0
            );
            payload_crc = csi2_reference_helpers_pkg::csi2_payload_crc(DATA_TYPE);

            push_ppi_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 1),
                1'b1
            );
            push_ppi_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 3),
                1'b0
            );
            push_ppi_lane_group(
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 0),
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 1),
                1'b0
            );
            push_ppi_lane_group(
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 2),
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 3),
                1'b0
            );
            push_ppi_lane_group(payload_crc[7:0], payload_crc[15:8], 1'b0);
        end
    endtask

    task automatic send_long_packet_bytes(input int unsigned payload_bytes);
        logic [31:0] header;
        int unsigned byte_idx;
        logic [7:0] payload_byte0;
        logic [7:0] payload_byte1;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(
                VC_ID,
                DATA_TYPE,
                payload_bytes[15:0],
                1'b0
            );

            push_ppi_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 1),
                1'b1
            );
            push_ppi_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 3),
                1'b0
            );

            for (byte_idx = 0; byte_idx < payload_bytes; byte_idx = byte_idx + 2) begin
                payload_byte0 = byte_idx[7:0];
                payload_byte1 = (byte_idx + 1) & 8'hff;
                push_ppi_lane_group(payload_byte0, payload_byte1, 1'b0);
            end

            push_ppi_lane_group(8'h00, 8'h00, 1'b0);
        end
    endtask

    task automatic drive_raw8_frame;
        begin
            enter_hs();
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_long_packet();
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
            set_lp_idle();
        end
    endtask

    task automatic drive_overflow_burst;
        begin
            enter_hs();
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_long_packet_bytes(96);
            set_lp_idle();
        end
    endtask

    task automatic feed_expected_clean_frame;
        int idx;
        begin
            for (idx = 0; idx < PIXEL_COUNT; idx = idx + 1) begin
                @(negedge clk_sys);
                exp_valid      = 1'b1;
                exp_pixel_data = csi2_reference_helpers_pkg::csi2_expected_pixel(DATA_TYPE, idx);
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

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            preclean_frame_seen     <= 1'b0;
            preclean_pixel_seen     <= 1'b0;
            clean_frame_start_seen  <= 1'b0;
            clean_frame_end_seen    <= 1'b0;
            clean_line_start_seen   <= 1'b0;
            clean_line_end_seen     <= 1'b0;
            fifo_pressure_seen      <= 1'b0;
            max_byte_fifo_level     <= 0;
            post_drop_fifo_read_count <= 0;
            post_drop_hdr_count       <= 0;
            post_drop_fs_hdr_count    <= 0;
        end else begin
            if (!clean_frame_done && !first_frame_done) begin
                if (frame_start_o) begin
                    preclean_frame_seen <= 1'b1;
                end
                if (pixel_valid_o) begin
                    preclean_pixel_seen <= 1'b1;
                end
            end

            if (first_frame_done && !clean_frame_done) begin
                if (frame_start_o) begin
                    preclean_frame_seen <= 1'b1;
                end
                if (pixel_valid_o) begin
                    preclean_pixel_seen <= 1'b1;
                end
            end

            if (clean_frame_done) begin
                if (frame_start_o) begin
                    clean_frame_start_seen <= 1'b1;
                end
                if (frame_end_o) begin
                    clean_frame_end_seen <= 1'b1;
                end
                if (line_start_o) begin
                    clean_line_start_seen <= 1'b1;
                end
                if (line_end_o) begin
                    clean_line_end_seen <= 1'b1;
                end
            end

            if ($signed(dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_wr_level_unused) > max_byte_fifo_level) begin
                max_byte_fifo_level <= dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_wr_level_unused;
            end

            if (dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_wr_level_unused >=
                (1 << BYTE_FIFO_ADDR_WIDTH) - 1) begin
                fifo_pressure_seen <= 1'b1;
            end

            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_rd_valid &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_rd_ready) begin
                post_drop_fifo_read_count <= post_drop_fifo_read_count + 1;
            end

            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.hdr_valid &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.hdr_ready) begin
                post_drop_hdr_count <= post_drop_hdr_count + 1;
                if (dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.pkt_dt ==
                    csi2_reference_helpers_pkg::CSI2_DT_FS) begin
                    post_drop_fs_hdr_count <= post_drop_fs_hdr_count + 1;
                end
            end
        end
    end

    always_ff @(posedge rxbyteclkhs) begin
        if (!rst_n) begin
            lane_ready_low_seen <= 1'b0;
            post_drop_guard_trigger_count <= 0;
            post_drop_byte_drop_count     <= 0;
            post_drop_ppi_valid_count      <= 0;
            post_drop_hs_count             <= 0;
            post_drop_lp_count             <= 0;
            post_drop_dphy_valid_count     <= 0;
            post_drop_raw_phy_valid_count  <= 0;
            post_drop_phy_valid_count      <= 0;
            post_drop_merge_valid_count   <= 0;
            post_drop_fifo_write_count    <= 0;
            post_drop_trig_deskew_count   <= 0;
            post_drop_trig_merge_bp_count <= 0;
            post_drop_trig_level_count    <= 0;
        end else begin
            if (!dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.phy_lane_ready[0] ||
                !dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.phy_lane_ready[1]) begin
                lane_ready_low_seen <= 1'b1;
            end

            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.no_bp_guard_trigger_byte) begin
                post_drop_guard_trigger_count <= post_drop_guard_trigger_count + 1;
            end
            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.deskew_overflow) begin
                post_drop_trig_deskew_count <= post_drop_trig_deskew_count + 1;
            end
            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.merge_byte_valid &&
                !dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.merge_byte_ready) begin
                post_drop_trig_merge_bp_count <= post_drop_trig_merge_bp_count + 1;
            end
            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.merge_byte_valid &&
                (dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_wr_level_unused >=
                 dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.BYTE_FIFO_GUARD_LEVEL)) begin
                post_drop_trig_level_count <= post_drop_trig_level_count + 1;
            end
            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.no_bp_guard_drop_active_byte) begin
                post_drop_byte_drop_count <= post_drop_byte_drop_count + 1;
            end
            if (first_frame_done && dl0_rxvalidhs && dl1_rxvalidhs) begin
                post_drop_ppi_valid_count <= post_drop_ppi_valid_count + 1;
            end
            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.hs_mode) begin
                post_drop_hs_count <= post_drop_hs_count + 1;
            end
            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.lp_mode) begin
                post_drop_lp_count <= post_drop_lp_count + 1;
            end
            if (first_frame_done && (dphy_lane_valid_hs_o[1:0] == 2'b11)) begin
                post_drop_dphy_valid_count <= post_drop_dphy_valid_count + 1;
            end
            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.phy_lane_valid[0] &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.phy_lane_valid[1]) begin
                post_drop_raw_phy_valid_count <= post_drop_raw_phy_valid_count + 1;
            end
            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.phy_lane_valid_guarded[0] &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.phy_lane_valid_guarded[1]) begin
                post_drop_phy_valid_count <= post_drop_phy_valid_count + 1;
            end
            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.merge_byte_valid) begin
                post_drop_merge_valid_count <= post_drop_merge_valid_count + 1;
            end
            if (first_frame_done &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.merge_byte_valid_to_fifo &&
                dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.merge_byte_ready) begin
                post_drop_fifo_write_count <= post_drop_fifo_write_count + 1;
            end
        end
    end

    initial begin
        clk_sys           = 1'b0;
        clk_axi           = 1'b0;
        clk_ddr           = 1'b0;
        rxbyteclkhs       = 1'b0;
        rst_n             = 1'b0;
        exp_valid         = 1'b0;
        exp_pixel_data    = 24'd0;
        exp_pixel_sof     = 1'b0;
        exp_pixel_sol     = 1'b0;
        finish_scoreboard = 1'b0;
        first_frame_done  = 1'b0;
        clean_frame_done  = 1'b0;
        clear_ppi_valid();
        set_lp_idle();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
        repeat (4) @(posedge rxbyteclkhs);

        force dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_rd_ready = 1'b0;
        drive_overflow_burst();
        first_frame_done = 1'b1;
        repeat (8) @(posedge clk_sys);
        release dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_rd_ready;

        repeat (300) @(posedge clk_sys);
        if (!fifo_pressure_seen && !lane_ready_low_seen) begin
            fail_msg("test did not create byte-side pressure");
        end
        if (preclean_frame_seen || preclean_pixel_seen) begin
            $display("FAIL: stale dropped frame escaped before clean frame pre_fs=%0b pre_pix=%0b exp=%0d act=%0d mismatch=%0d max_fifo=%0d lane_ready_low=%0b",
                     preclean_frame_seen, preclean_pixel_seen, exp_pixel_cnt,
                     act_pixel_cnt, mismatch_cnt, max_byte_fifo_level, lane_ready_low_seen);
            $fatal(1);
        end

        clean_frame_done = 1'b1;
        fork
            feed_expected_clean_frame();
            drive_raw8_frame();
        join

        fork
            begin : timeout_block
                repeat (5000) @(posedge clk_sys);
                $display("FAIL: no-backpressure guard timeout exp=%0d act=%0d mismatch=%0d clean_fs=%0b clean_fe=%0b max_fifo=%0d guard_evt=%0b guard_active=%0b byte_drop=%0b sys_drop=%0b reads=%0d hdrs=%0d fs_hdrs=%0d guard_trig=%0d trig_deskew=%0d trig_merge_bp=%0d trig_level=%0d byte_drop_cyc=%0d ppi_valid=%0d hs=%0d lp=%0d dphy_valid=%0d raw_phy=%0d phy_valid=%0d merge_valid=%0d fifo_writes=%0d rdv=%0b rdr=%0b rdlvl=%0d wrlvl=%0d cfg_mask=%b eff_lane_m1=%0d busy=%0b dt=%02h wc=%0d",
                         exp_pixel_cnt, act_pixel_cnt, mismatch_cnt,
                         clean_frame_start_seen, clean_frame_end_seen, max_byte_fifo_level,
                         dut.no_backpressure_drop_event_o,
                         dut.no_backpressure_drop_active_o,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.no_bp_guard_drop_active_byte,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.drop_current_frame,
                         post_drop_fifo_read_count,
                         post_drop_hdr_count,
                         post_drop_fs_hdr_count,
                         post_drop_guard_trigger_count,
                         post_drop_trig_deskew_count,
                         post_drop_trig_merge_bp_count,
                         post_drop_trig_level_count,
                         post_drop_byte_drop_count,
                         post_drop_ppi_valid_count,
                         post_drop_hs_count,
                         post_drop_lp_count,
                         post_drop_dphy_valid_count,
                         post_drop_raw_phy_valid_count,
                         post_drop_phy_valid_count,
                         post_drop_merge_valid_count,
                         post_drop_fifo_write_count,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_rd_valid,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_rd_ready,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_rd_level_unused,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.fifo_wr_level_unused,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.cfg_lane_enable_mask_byte,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.effective_lane_num_minus1_byte,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.parser_busy,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.pkt_dt,
                         dut.u_mipi_csi2_capture_fpga_wrapper.u_mipi_csi2_capture_top.pkt_word_count);
                $fatal(1);
            end

            begin : main_check_block
                wait (act_pixel_cnt == PIXEL_COUNT);
                wait (clean_frame_end_seen);
                repeat (8) @(posedge clk_sys);

                @(negedge clk_sys);
                finish_scoreboard = 1'b1;
                @(negedge clk_sys);
                finish_scoreboard = 1'b0;
                @(posedge clk_sys);

                if (!pass || fail) begin
                    $display("FAIL: no-backpressure guard scoreboard pass=%0b fail=%0b exp=%0d act=%0d mismatch=%0d frames=%0d",
                             pass, fail, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt, sb_frame_cnt);
                    $fatal(1);
                end

                if (!clean_frame_start_seen || !clean_frame_end_seen ||
                    !clean_line_start_seen || !clean_line_end_seen) begin
                    $display("FAIL: clean frame markers missing fs=%0b fe=%0b ls=%0b le=%0b",
                             clean_frame_start_seen, clean_frame_end_seen,
                             clean_line_start_seen, clean_line_end_seen);
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o || err_sync_o ||
                    dphy_err_sot_hs_o || dphy_err_sot_sync_hs_o) begin
                    $display("FAIL: unexpected terminal errors ecc=%0b crc=%0b sync=%0b sot=%0b sotsync=%0b",
                             err_ecc_o, err_crc_o, err_sync_o,
                             dphy_err_sot_hs_o, dphy_err_sot_sync_hs_o);
                    $fatal(1);
                end

                $display("PASS: tb_mipi_csi2_capture_dphy_no_backpressure_guard exp=%0d act=%0d frames=%0d max_fifo=%0d lane_ready_low=%0b",
                         exp_pixel_cnt, act_pixel_cnt, sb_frame_cnt,
                         max_byte_fifo_level, lane_ready_low_seen);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        $finish;
    end

endmodule
