`timescale 1ns/1ps

module tb_cfg_reg_if_apb;

    logic         clk_sys;
    logic         rst_n;
    logic         psel_i;
    logic         penable_i;
    logic         pwrite_i;
    logic [15:0]  paddr_i;
    logic [31:0]  pwdata_i;
    logic [31:0]  prdata_o;
    logic         pready_o;
    logic         pslverr_o;

    logic         cfg_enable_o;
    logic         cfg_soft_reset_pulse_o;
    logic         cfg_start_capture_pulse_o;
    logic         cfg_preprocess_bypass_o;
    logic         cfg_enable_err_log_o;
    logic         cfg_mark_ecc_error_o;
    logic         cfg_drop_on_crc_error_o;
    logic         cfg_enable_resync_o;
    logic         cfg_enable_degrade_o;
    logic         cfg_enable_retry_o;
    logic         cfg_retry_line_mode_o;
    logic         cfg_retry_ack_pulse_o;
    logic         cfg_adaptive_enable_o;
    logic         cfg_adaptive_awb_enable_o;
    logic         cfg_adaptive_stretch_enable_o;
    logic [1:0]   cfg_lane_num_minus1_o;
    logic [3:0]   cfg_lane_enable_mask_o;
    logic [7:0]   cfg_dt_code_o;
    logic [7:0]   cfg_vc_id_o;
    logic [31:0]  cfg_frame_base_addr_o;
    logic [31:0]  cfg_line_stride_o;
    logic [15:0]  cfg_img_width_o;
    logic [15:0]  cfg_img_height_o;
    logic [31:0]  cfg_dbg_sel_o;
    logic [8:0]   cfg_axi_max_burst_len_o;

    logic         frame_active_i;
    logic         line_active_i;
    logic         parser_busy_i;
    logic         axi_busy_i;
    logic         err_pending_i;
    logic         overflow_event_i;
    logic [2:0]   active_lane_num_i;
    logic         hs_mode_i;
    logic         lp_mode_i;
    logic [31:0]  frame_cnt_i;
    logic [31:0]  line_cnt_i;
    logic [31:0]  err_cnt_ecc_i;
    logic [31:0]  err_cnt_crc_i;
    logic [31:0]  err_cnt_sync_i;
    logic [2:0]   last_err_type_i;
    logic [1:0]   last_err_priority_i;
    logic [31:0]  last_err_frame_id_i;
    logic [31:0]  last_err_line_id_i;
    logic [1:0]   last_err_vc_i;
    logic [5:0]   last_err_dt_i;
    logic         retry_pending_i;
    logic         retry_mode_i;
    logic [2:0]   retry_err_type_i;
    logic [31:0]  retry_frame_id_i;
    logic [31:0]  retry_line_id_i;
    logic [1:0]   retry_vc_i;
    logic [5:0]   retry_dt_i;
    logic [7:0]   adaptive_stretch_gain_i;
    logic [7:0]   adaptive_awb_gain_r_i;
    logic [7:0]   adaptive_awb_gain_g_i;
    logic [7:0]   adaptive_awb_gain_b_i;
    logic [15:0]  stats_mean_r_i;
    logic [15:0]  stats_mean_g_i;
    logic [15:0]  stats_mean_b_i;
    logic [7:0]   stats_luma_min_i;
    logic [7:0]   stats_luma_max_i;

    cfg_reg_if_apb dut (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .psel_i(psel_i),
        .penable_i(penable_i),
        .pwrite_i(pwrite_i),
        .paddr_i(paddr_i),
        .pwdata_i(pwdata_i),
        .prdata_o(prdata_o),
        .pready_o(pready_o),
        .pslverr_o(pslverr_o),
        .cfg_enable_o(cfg_enable_o),
        .cfg_soft_reset_pulse_o(cfg_soft_reset_pulse_o),
        .cfg_start_capture_pulse_o(cfg_start_capture_pulse_o),
        .cfg_preprocess_bypass_o(cfg_preprocess_bypass_o),
        .cfg_enable_err_log_o(cfg_enable_err_log_o),
        .cfg_mark_ecc_error_o(cfg_mark_ecc_error_o),
        .cfg_drop_on_crc_error_o(cfg_drop_on_crc_error_o),
        .cfg_enable_resync_o(cfg_enable_resync_o),
        .cfg_enable_degrade_o(cfg_enable_degrade_o),
        .cfg_enable_retry_o(cfg_enable_retry_o),
        .cfg_retry_line_mode_o(cfg_retry_line_mode_o),
        .cfg_retry_ack_pulse_o(cfg_retry_ack_pulse_o),
        .cfg_adaptive_enable_o(cfg_adaptive_enable_o),
        .cfg_adaptive_awb_enable_o(cfg_adaptive_awb_enable_o),
        .cfg_adaptive_stretch_enable_o(cfg_adaptive_stretch_enable_o),
        .cfg_lane_num_minus1_o(cfg_lane_num_minus1_o),
        .cfg_lane_enable_mask_o(cfg_lane_enable_mask_o),
        .cfg_dt_code_o(cfg_dt_code_o),
        .cfg_vc_id_o(cfg_vc_id_o),
        .cfg_frame_base_addr_o(cfg_frame_base_addr_o),
        .cfg_line_stride_o(cfg_line_stride_o),
        .cfg_img_width_o(cfg_img_width_o),
        .cfg_img_height_o(cfg_img_height_o),
        .cfg_dbg_sel_o(cfg_dbg_sel_o),
        .cfg_axi_max_burst_len_o(cfg_axi_max_burst_len_o),
        .frame_active_i(frame_active_i),
        .line_active_i(line_active_i),
        .parser_busy_i(parser_busy_i),
        .axi_busy_i(axi_busy_i),
        .err_pending_i(err_pending_i),
        .overflow_event_i(overflow_event_i),
        .active_lane_num_i(active_lane_num_i),
        .hs_mode_i(hs_mode_i),
        .lp_mode_i(lp_mode_i),
        .frame_cnt_i(frame_cnt_i),
        .line_cnt_i(line_cnt_i),
        .err_cnt_ecc_i(err_cnt_ecc_i),
        .err_cnt_crc_i(err_cnt_crc_i),
        .err_cnt_sync_i(err_cnt_sync_i),
        .last_err_type_i(last_err_type_i),
        .last_err_priority_i(last_err_priority_i),
        .last_err_frame_id_i(last_err_frame_id_i),
        .last_err_line_id_i(last_err_line_id_i),
        .last_err_vc_i(last_err_vc_i),
        .last_err_dt_i(last_err_dt_i),
        .retry_pending_i(retry_pending_i),
        .retry_mode_i(retry_mode_i),
        .retry_err_type_i(retry_err_type_i),
        .retry_frame_id_i(retry_frame_id_i),
        .retry_line_id_i(retry_line_id_i),
        .retry_vc_i(retry_vc_i),
        .retry_dt_i(retry_dt_i),
        .adaptive_stretch_gain_i(adaptive_stretch_gain_i),
        .adaptive_awb_gain_r_i(adaptive_awb_gain_r_i),
        .adaptive_awb_gain_g_i(adaptive_awb_gain_g_i),
        .adaptive_awb_gain_b_i(adaptive_awb_gain_b_i),
        .stats_mean_r_i(stats_mean_r_i),
        .stats_mean_g_i(stats_mean_g_i),
        .stats_mean_b_i(stats_mean_b_i),
        .stats_luma_min_i(stats_luma_min_i),
        .stats_luma_max_i(stats_luma_max_i)
    );

    initial begin
        clk_sys = 1'b0;
        forever #5 clk_sys = ~clk_sys;
    end

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    task automatic apb_write(input logic [15:0] addr, input logic [31:0] data);
        begin
            @(negedge clk_sys);
            psel_i    = 1'b1;
            penable_i = 1'b0;
            pwrite_i  = 1'b1;
            paddr_i   = addr;
            pwdata_i  = data;
            @(negedge clk_sys);
            penable_i = 1'b1;
            @(negedge clk_sys);
            psel_i    = 1'b0;
            penable_i = 1'b0;
            pwrite_i  = 1'b0;
            paddr_i   = 16'd0;
            pwdata_i  = 32'd0;
        end
    endtask

    task automatic apb_expect(input logic [15:0] addr, input logic [31:0] expected);
        begin
            @(negedge clk_sys);
            psel_i    = 1'b1;
            penable_i = 1'b0;
            pwrite_i  = 1'b0;
            paddr_i   = addr;
            @(negedge clk_sys);
            penable_i = 1'b1;
            #1;
            if (prdata_o !== expected) begin
                fail($sformatf("APB read mismatch addr=0x%04h expected=0x%08h got=0x%08h", addr, expected, prdata_o));
            end
            @(negedge clk_sys);
            psel_i    = 1'b0;
            penable_i = 1'b0;
            paddr_i   = 16'd0;
        end
    endtask

    initial begin
        rst_n                    = 1'b0;
        psel_i                   = 1'b0;
        penable_i                = 1'b0;
        pwrite_i                 = 1'b0;
        paddr_i                  = 16'd0;
        pwdata_i                 = 32'd0;
        frame_active_i           = 1'b0;
        line_active_i            = 1'b0;
        parser_busy_i            = 1'b0;
        axi_busy_i               = 1'b0;
        err_pending_i            = 1'b0;
        overflow_event_i         = 1'b0;
        active_lane_num_i        = 3'd2;
        hs_mode_i                = 1'b1;
        lp_mode_i                = 1'b0;
        frame_cnt_i              = 32'd7;
        line_cnt_i               = 32'd23;
        err_cnt_ecc_i            = 32'd3;
        err_cnt_crc_i            = 32'd4;
        err_cnt_sync_i           = 32'd5;
        last_err_type_i          = 3'd2;
        last_err_priority_i      = 2'd1;
        last_err_frame_id_i      = 32'd44;
        last_err_line_id_i       = 32'd55;
        last_err_vc_i            = 2'd3;
        last_err_dt_i            = 6'h2b;
        retry_pending_i          = 1'b1;
        retry_mode_i             = 1'b1;
        retry_err_type_i         = 3'd2;
        retry_frame_id_i         = 32'd6;
        retry_line_id_i          = 32'd13;
        retry_vc_i               = 2'd1;
        retry_dt_i               = 6'h2a;
        adaptive_stretch_gain_i  = 8'h88;
        adaptive_awb_gain_r_i    = 8'h91;
        adaptive_awb_gain_g_i    = 8'h92;
        adaptive_awb_gain_b_i    = 8'h93;
        stats_mean_r_i           = 16'h0102;
        stats_mean_g_i           = 16'h0304;
        stats_mean_b_i           = 16'h0506;
        stats_luma_min_i         = 8'h11;
        stats_luma_max_i         = 8'hee;

        repeat (5) @(posedge clk_sys);
        rst_n = 1'b1;
        repeat (2) @(posedge clk_sys);

        if (!pready_o || pslverr_o) begin
            fail("APB ready/slverr reset state mismatch");
        end
        if (cfg_enable_o !== 1'b0 || cfg_preprocess_bypass_o !== 1'b1) begin
            fail("control defaults mismatch");
        end
        if (cfg_img_width_o !== 16'd1920 || cfg_img_height_o !== 16'd1080) begin
            fail("image size defaults mismatch");
        end

        apb_expect(16'h0004, 32'h0001_0201);

        apb_write(16'h0000, 32'h0000_0005);
        if (!cfg_enable_o || !cfg_start_capture_pulse_o) begin
            fail("CTRL write did not update enable/start_capture");
        end
        @(posedge clk_sys);
        #1;
        if (cfg_start_capture_pulse_o) begin
            fail("start_capture pulse should clear after one cycle");
        end

        apb_write(16'h0018, 32'h1000_0000);
        apb_write(16'h001c, 32'h0000_0800);
        apb_write(16'h0008, 32'h0000_0500);
        apb_write(16'h000c, 32'h0000_02d0);
        apb_write(16'h0034, 32'h0000_0077);
        apb_write(16'h0038, 32'h0000_000e);
        apb_write(16'h0040, 32'h0000_0010);
        apb_expect(16'h0018, 32'h1000_0000);
        apb_expect(16'h001c, 32'h0000_0800);
        apb_expect(16'h0008, 32'h0000_0500);
        apb_expect(16'h000c, 32'h0000_02d0);
        apb_expect(16'h0034, 32'h0000_0077);
        apb_expect(16'h0038, 32'h0000_000e);
        apb_expect(16'h0040, 32'h0000_0010);

        @(negedge clk_sys);
        overflow_event_i = 1'b1;
        @(negedge clk_sys);
        overflow_event_i = 1'b0;
        apb_expect(16'h0004, 32'h0001_0211);

        apb_write(16'h0000, 32'h0000_0002);
        if (!cfg_soft_reset_pulse_o) begin
            fail("soft_reset pulse missing");
        end
        @(posedge clk_sys);
        #1;
        if (cfg_soft_reset_pulse_o) begin
            fail("soft_reset pulse should clear after one cycle");
        end
        apb_expect(16'h0004, 32'h0001_0201);

        apb_expect(16'h0020, 32'd3);
        apb_expect(16'h0024, 32'd4);
        apb_expect(16'h0028, 32'd5);
        apb_expect(16'h002c, 32'd7);
        apb_expect(16'h0030, 32'd23);
        apb_expect(16'h0044, 32'h0003_2b12);
        apb_expect(16'h0054, 32'd44);
        apb_expect(16'h0058, 32'd55);
        apb_expect(16'h005c, 32'h0001_2a0b);
        apb_expect(16'h0060, 32'd6);
        apb_expect(16'h0064, 32'd13);
        apb_expect(16'h0048, 32'h93_92_91_88);
        apb_expect(16'h004c, 32'h0304_0102);
        apb_expect(16'h0050, 32'hee_11_0506);

        apb_write(16'h0000, 32'h0000_0008);
        if (!cfg_retry_ack_pulse_o) begin
            fail("retry ack pulse missing");
        end
        @(posedge clk_sys);
        #1;
        if (cfg_retry_ack_pulse_o) begin
            fail("retry ack pulse should clear after one cycle");
        end

        if (!cfg_enable_err_log_o || !cfg_mark_ecc_error_o || !cfg_drop_on_crc_error_o ||
            !cfg_enable_retry_o || !cfg_retry_line_mode_o) begin
            fail("ERR_POLICY outputs mismatch");
        end

        $display("[%0t] PASS: tb_cfg_reg_if_apb", $time);
        $finish;
    end

endmodule
