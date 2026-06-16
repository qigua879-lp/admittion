`timescale 1ns/1ps

module tb_mipi_csi2_capture_dphy_wrapper_raw8_smoke;

    localparam int LANE_NUM = 2;
    localparam logic [5:0] DATA_TYPE = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID = 2'd0;
    localparam int PIXEL_COUNT = csi2_reference_helpers_pkg::csi2_expected_pixel_count(DATA_TYPE);

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

    logic                     sensor_done;
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

    logic sensor_done_seen;
    logic frame_start_seen;
    logic frame_end_seen;
    logic line_start_seen;
    logic line_end_seen;
    logic pixel_sof_seen;
    logic pixel_sol_seen;
    logic dphy_hs_seen;
    logic dphy_lp_seen_after_hs;
    logic dphy_valid_seen;

    mipi_csi2_capture_dphy_wrapper #(
        .LANE_NUM(LANE_NUM),
        .BYTE_FIFO_ADDR_WIDTH(4),
        .AXI_FIFO_ADDR_WIDTH(6),
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
        .dphy_err_sot_sync_hs_o(dphy_err_sot_sync_hs_o)
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
            dl0_rxdatahs   = 8'd0;
            dl1_rxdatahs   = 8'd0;
            dl2_rxdatahs   = 8'd0;
            dl3_rxdatahs   = 8'd0;
            dl0_rxvalidhs  = 1'b0;
            dl1_rxvalidhs  = 1'b0;
            dl2_rxvalidhs  = 1'b0;
            dl3_rxvalidhs  = 1'b0;
            dl0_rxsynchs   = 1'b0;
            dl1_rxsynchs   = 1'b0;
            dl2_rxsynchs   = 1'b0;
            dl3_rxsynchs   = 1'b0;
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

    task automatic feed_expected_pixels;
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

    task automatic drive_raw8_frame;
        begin
            enter_hs();
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_long_packet();
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
            sensor_done = 1'b1;
            @(posedge rxbyteclkhs);
            sensor_done = 1'b0;
            set_lp_idle();
        end
    endtask

    initial begin
        clk_sys = 1'b0;
        forever #5 clk_sys = ~clk_sys;
    end

    initial begin
        clk_axi = 1'b0;
        forever #5 clk_axi = ~clk_axi;
    end

    initial begin
        clk_ddr = 1'b0;
        forever #5 clk_ddr = ~clk_ddr;
    end

    initial begin
        rxbyteclkhs = 1'b0;
        forever #4 rxbyteclkhs = ~rxbyteclkhs;
    end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            sensor_done_seen    <= 1'b0;
            frame_start_seen    <= 1'b0;
            frame_end_seen      <= 1'b0;
            line_start_seen     <= 1'b0;
            line_end_seen       <= 1'b0;
            pixel_sof_seen      <= 1'b0;
            pixel_sol_seen      <= 1'b0;
            dphy_hs_seen        <= 1'b0;
            dphy_lp_seen_after_hs <= 1'b0;
            dphy_valid_seen     <= 1'b0;
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
            if (pixel_sof_o) begin
                pixel_sof_seen <= 1'b1;
            end
            if (pixel_sol_o) begin
                pixel_sol_seen <= 1'b1;
            end
            if (dphy_hs_mode_o) begin
                dphy_hs_seen <= 1'b1;
            end
            if (dphy_hs_seen && dphy_lp_mode_o) begin
                dphy_lp_seen_after_hs <= 1'b1;
            end
            if (dphy_lane_valid_hs_o[1:0] == 2'b11) begin
                dphy_valid_seen <= 1'b1;
            end
        end
    end

    initial begin
        rst_n             = 1'b0;
        sensor_done       = 1'b0;
        exp_valid         = 1'b0;
        exp_pixel_data    = 24'd0;
        exp_pixel_sof     = 1'b0;
        exp_pixel_sol     = 1'b0;
        finish_scoreboard = 1'b0;
        clear_ppi_valid();
        set_lp_idle();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
        repeat (4) @(posedge rxbyteclkhs);

        fork
            feed_expected_pixels();
            drive_raw8_frame();
        join

        fork
            begin : timeout_block
                repeat (5000) @(posedge clk_sys);
                $display("FAIL: dphy raw8 timeout cfg_done=%0b sensor_done=%0b frame=%0b/%0b line=%0b/%0b exp=%0d act=%0d mismatch=%0d crc=%0b sync=%0b dphy_hs=%0b dphy_valid=%0b",
                         cfg_init_done_o, sensor_done_seen, frame_start_seen, frame_end_seen,
                         line_start_seen, line_end_seen, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt,
                         err_crc_o, err_sync_o, dphy_hs_seen, dphy_valid_seen);
                $fatal(1);
            end

            begin : main_check_block
                wait (sensor_done_seen);
                wait (act_pixel_cnt == PIXEL_COUNT);
                repeat (16) @(posedge clk_sys);

                @(negedge clk_sys);
                finish_scoreboard = 1'b1;
                @(negedge clk_sys);
                finish_scoreboard = 1'b0;
                @(posedge clk_sys);

                if (!pass || fail) begin
                    $display("FAIL: dphy raw8 scoreboard pass=%0b fail=%0b exp=%0d act=%0d mismatch=%0d frames=%0d",
                             pass, fail, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt, sb_frame_cnt);
                    $fatal(1);
                end

                if (!frame_start_seen || !frame_end_seen || !line_start_seen || !line_end_seen) begin
                    $display("FAIL: missing markers fs=%0b fe=%0b ls=%0b le=%0b",
                             frame_start_seen, frame_end_seen, line_start_seen, line_end_seen);
                    $fatal(1);
                end

                if (!pixel_sof_seen || !pixel_sol_seen) begin
                    $display("FAIL: missing pixel markers sof=%0b sol=%0b",
                             pixel_sof_seen, pixel_sol_seen);
                    $fatal(1);
                end

                if (!dphy_hs_seen || !dphy_valid_seen || !dphy_lp_seen_after_hs) begin
                    $display("FAIL: missing dphy debug hs=%0b valid=%0b lp_after=%0b active=%b valid_mask=%b",
                             dphy_hs_seen, dphy_valid_seen, dphy_lp_seen_after_hs,
                             dphy_lane_active_hs_o, dphy_lane_valid_hs_o);
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o || err_sync_o || dphy_err_sot_hs_o || dphy_err_sot_sync_hs_o) begin
                    $display("FAIL: unexpected errors ecc=%0b crc=%0b sync=%0b sot=%0b sotsync=%0b",
                             err_ecc_o, err_crc_o, err_sync_o, dphy_err_sot_hs_o, dphy_err_sot_sync_hs_o);
                    $fatal(1);
                end

                $display("PASS: tb_mipi_csi2_capture_dphy_wrapper_raw8_smoke exp=%0d act=%0d frames=%0d",
                         exp_pixel_cnt, act_pixel_cnt, sb_frame_cnt);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        $finish;
    end

endmodule
