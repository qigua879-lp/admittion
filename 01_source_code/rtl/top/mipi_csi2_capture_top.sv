`timescale 1ns/1ps

// Minimum synthesizable integration wrapper for the digital MIPI CSI-2 capture
// front end. This top keeps the project-level IO style stable while connecting
// the verified receive, pixel, preprocess, reliability, and AXI placeholder
// blocks. See docs/spec/top_integration_notes.md for current TODOs.
module mipi_csi2_capture_top #(
    parameter int LANE_NUM             = 4,
    parameter int DESKEW_DEPTH         = 16,
    parameter int BYTE_FIFO_ADDR_WIDTH = 4,
    parameter int AXI_FIFO_ADDR_WIDTH  = 6,
    parameter int AXI_ADDR_WIDTH       = 32,
    parameter int AXI_DATA_WIDTH       = 32,
    parameter int AXI_MAX_BURST_LEN    = 16
) (
    input  logic                         clk_sys,
    input  logic                         clk_byte,
    input  logic                         clk_axi,
    input  logic                         clk_ddr,
    input  logic                         rst_n,

    input  logic [31:0]                  lane_data_0,
    input  logic [31:0]                  lane_data_1,
    input  logic [31:0]                  lane_data_2,
    input  logic [31:0]                  lane_data_3,
    input  logic                         lane_valid_0,
    input  logic                         lane_valid_1,
    input  logic                         lane_valid_2,
    input  logic                         lane_valid_3,
    input  logic                         hs_mode,
    input  logic                         lp_mode,

    input  logic                         psel,
    input  logic                         penable,
    input  logic                         pwrite,
    input  logic [15:0]                  paddr,
    input  logic [31:0]                  pwdata,
    output logic [31:0]                  prdata,
    output logic                         pready,
    output logic                         pslverr,

    output logic [AXI_ADDR_WIDTH-1:0]    m_axi_awaddr_o,
    output logic [7:0]                   m_axi_awlen_o,
    output logic [2:0]                   m_axi_awsize_o,
    output logic [1:0]                   m_axi_awburst_o,
    output logic                         m_axi_awvalid_o,
    input  logic                         m_axi_awready_i,
    output logic [AXI_DATA_WIDTH-1:0]    m_axi_wdata_o,
    output logic [(AXI_DATA_WIDTH/8)-1:0] m_axi_wstrb_o,
    output logic                         m_axi_wlast_o,
    output logic                         m_axi_wvalid_o,
    input  logic                         m_axi_wready_i,
    input  logic [1:0]                   m_axi_bresp_i,
    input  logic                         m_axi_bvalid_i,
    output logic                         m_axi_bready_o,

    output logic                         frame_start_o,
    output logic                         frame_end_o,
    output logic                         line_start_o,
    output logic                         line_end_o,
    output logic                         err_ecc_o,
    output logic                         err_crc_o,
    output logic                         err_sync_o,
    output logic [31:0]                  frame_cnt_o,
    output logic [31:0]                  line_cnt_o,
    output logic [31:0]                  err_cnt_ecc_o,
    output logic [31:0]                  err_cnt_crc_o,
    output logic                         retry_req_o,
    output logic                         retry_pending_o,
    output logic                         retry_mode_o,
    output logic [31:0]                  retry_frame_id_o,
    output logic [31:0]                  retry_line_id_o,

    output logic [23:0]                  pixel_data_o,
    output logic                         pixel_valid_o,
    output logic                         pixel_sof_o,
    output logic                         pixel_sol_o
);

    localparam logic [5:0] DT_FS     = 6'h00;
    localparam logic [5:0] DT_FE     = 6'h01;
    localparam logic [5:0] DT_LS     = 6'h02;
    localparam logic [5:0] DT_LE     = 6'h03;
    localparam logic [5:0] DT_YUV422 = 6'h1e;
    localparam logic [5:0] DT_RGB888 = 6'h24;
    localparam logic [5:0] DT_RAW8   = 6'h2a;
    localparam logic [5:0] DT_RAW10  = 6'h2b;

    localparam int DEGRADED_LANE_NUM = (LANE_NUM <= 1) ? 1 : (LANE_NUM / 2);
    localparam logic [2:0] PIXFMT_RAW8   = 3'd0;
    localparam logic [2:0] PIXFMT_RAW10  = 3'd1;
    localparam logic [2:0] PIXFMT_RGB888 = 3'd2;
    localparam logic [2:0] PIXFMT_YUV422 = 3'd3;

    logic cfg_preprocess_bypass;
    logic cfg_enable_resync;
    logic cfg_enable_degrade;
    logic cfg_enable_retry;
    logic cfg_retry_line_mode;
    logic cfg_retry_ack_pulse;
    logic cfg_enable_err_log;
    logic cfg_mark_ecc_error;
    logic cfg_drop_on_crc_error;
    logic cfg_adaptive_enable;
    logic cfg_adaptive_awb_enable;
    logic cfg_adaptive_stretch_enable;
    logic cfg_capture_enable;
    logic cfg_soft_reset_pulse;
    logic cfg_start_capture_pulse_unused;
    logic [1:0] cfg_lane_num_minus1;
    logic [3:0] cfg_lane_enable_mask;
    logic [7:0] cfg_dt_code;
    logic [7:0] cfg_vc_id;
    logic [AXI_ADDR_WIDTH-1:0] cfg_frame_base_addr;
    logic [AXI_ADDR_WIDTH-1:0] cfg_line_stride;
    logic [15:0] cfg_img_width;
    logic [15:0] cfg_img_height;
    logic [8:0]  cfg_axi_max_burst_len;
    logic [31:0] cfg_dbg_sel_unused;

    logic [LANE_NUM-1:0]      phy_lane_valid;
    logic [LANE_NUM-1:0]      phy_lane_ready;
    logic [LANE_NUM-1:0][7:0] phy_lane_data;
    logic [LANE_NUM-1:0]      phy_lane_enable_unused;
    logic                     phy_active_unused;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [1:0] cfg_lane_num_meta_byte;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [1:0] cfg_lane_num_byte;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [3:0] cfg_lane_enable_mask_meta_byte;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [3:0] cfg_lane_enable_mask_byte;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [2:0] active_lane_num_meta_byte;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [2:0] active_lane_num_byte;
    logic [2:0]               effective_lane_num_byte;
    logic [1:0]               effective_lane_num_minus1_byte;

    logic                     deskew_valid;
    logic                     deskew_ready;
    logic [LANE_NUM-1:0][7:0] deskew_data;
    logic                     deskew_overflow;

    logic                     lane_err_toggle_byte;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic lane_err_sync_meta;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic lane_err_sync;
    logic                     lane_err_sync_d;
    logic                     lane_error_event_sys;

    logic                     merge_byte_valid;
    logic                     merge_byte_ready;
    logic [7:0]               merge_byte_data;
    logic                     merge_group_done_unused;

    logic                     fifo_rd_valid;
    logic                     fifo_rd_ready;
    logic [7:0]               fifo_rd_data;
    logic                     fifo_full_unused;
    logic                     fifo_empty_unused;
    logic [BYTE_FIFO_ADDR_WIDTH:0] fifo_wr_level_unused;
    logic [BYTE_FIFO_ADDR_WIDTH:0] fifo_rd_level_unused;

    logic        hdr_valid;
    logic        hdr_ready;
    logic [1:0]  pkt_vc;
    logic [5:0]  pkt_dt;
    logic [15:0] pkt_word_count;
    logic        pkt_ecc_ok;
    logic        pkt_ecc_correctable_unused;
    logic [5:0]  pkt_ecc_syndrome_unused;
    logic        payload_valid;
    logic        payload_ready;
    logic        payload_sink_ready;
    logic [7:0]  payload_data;
    logic        payload_start;
    logic        payload_end;
    logic        parser_busy;
    logic        packet_done_unused;
    logic        expected_crc_valid;
    logic        expected_crc_ready;
    logic [15:0] expected_crc;
    logic        crc_start;
    logic        crc_payload_ready;
    logic        crc_valid;
    logic        crc_error;
    logic [15:0] crc_calc_unused;

    logic [5:0]  payload_dt_reg;
    logic        payload_fire;
    logic        payload_drop;
    logic        payload_unsupported_dt;
    logic        payload_vc_mismatch;
    logic        short_vc_match;
    logic        payload_is_raw8;
    logic        payload_is_raw10;
    logic        payload_is_rgb888;
    logic        payload_is_yuv422;

    logic        short_event_valid;
    logic        short_event_ready_unused;
    logic        frame_active;
    logic        line_active;
    logic        frame_start;
    logic        frame_end;
    logic        line_start;
    logic        line_end;
    logic [31:0] frame_cnt;
    logic [31:0] line_cnt;
    logic [1:0]  active_vc_unused;
    logic        sync_error;

    logic pending_sof;
    logic pending_sol;

    logic        raw8_payload_ready;
    logic        raw8_pixel_valid;
    logic        raw8_pixel_ready;
    logic [23:0] raw8_pixel_data;
    logic        raw8_pixel_sof;
    logic        raw8_pixel_sol;

    logic        raw10_payload_ready;
    logic        raw10_pixel_valid;
    logic        raw10_pixel_ready;
    logic [23:0] raw10_pixel_data;
    logic        raw10_pixel_sof;
    logic        raw10_pixel_sol;

    logic        rgb888_payload_ready;
    logic        rgb888_pixel_valid;
    logic        rgb888_pixel_ready;
    logic [23:0] rgb888_pixel_data;
    logic        rgb888_pixel_sof;
    logic        rgb888_pixel_sol;

    logic        yuv422_payload_ready;
    logic        yuv422_pixel_valid;
    logic        yuv422_pixel_ready;
    logic [23:0] yuv422_pixel_data;
    logic        yuv422_pixel_sof;
    logic        yuv422_pixel_sol;

    logic        repack_pixel_valid;
    logic        repack_pixel_ready;
    logic [23:0] repack_pixel_data;
    logic        repack_pixel_sof;
    logic        repack_pixel_sol;

    logic        bright_ready;
    logic        bright_valid;
    logic [23:0] bright_data;
    logic        bright_sof;
    logic        bright_sol;

    logic        contrast_ready;
    logic        contrast_valid;
    logic [23:0] contrast_data;
    logic        contrast_sof;
    logic        contrast_sol;

    logic        gray_ready;
    logic        gray_valid;
    logic [23:0] gray_data;
    logic        gray_sof;
    logic        gray_sol;

    logic        bypass_raw_ready;
    logic        bypass_proc_ready;
    logic        final_pixel_valid;
    logic        final_pixel_ready;
    logic [23:0] final_pixel_data;
    logic        final_pixel_sof;
    logic        final_pixel_sol;

    logic        err_ecc_event;
    logic        err_crc_event;
    logic        crc_drop_req;
    logic        err_valid;
    logic        err_ready;
    logic [2:0]  err_type;
    logic [1:0]  err_priority;
    logic [31:0] err_frame_id;
    logic [31:0] err_line_id;
    logic [1:0]  err_vc;
    logic [5:0]  err_dt;
    logic [31:0] err_cnt_sync;
    logic [31:0] err_cnt_lane;

    logic        err_pending;
    logic        err_valid_to_logger;
    logic [2:0]  last_err_type;
    logic [1:0]  last_err_priority;
    logic [31:0] last_frame_id;
    logic [31:0] last_line_id;
    logic [1:0]  last_vc;
    logic [5:0]  last_dt;
    logic [31:0] total_err_cnt_unused;
    logic [31:0] logger_ecc_cnt_unused;
    logic [31:0] logger_crc_cnt_unused;
    logic [31:0] logger_sync_cnt_unused;
    logic [31:0] logger_lane_cnt_unused;
    logic        line_crc_drop_pending;
    logic        retry_req;
    logic        retry_pending;
    logic        retry_mode;
    logic [2:0]  retry_err_type;
    logic [31:0] retry_frame_id;
    logic [31:0] retry_line_id;
    logic [1:0]  retry_vc;
    logic [5:0]  retry_dt;

    logic        resync_req;
    logic        resync_drop_packet;
    logic        resync_busy;
    logic        resync_done_unused;
    logic        resync_req_d;
    logic        resync_clear_pulse_sys;
    logic        resync_toggle_sys;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic resync_toggle_meta_byte;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic resync_toggle_byte;
    logic        resync_toggle_byte_d;
    logic        resync_clear_pulse_byte;
    logic        degraded;
    logic        recovering;
    logic [2:0]  active_lane_num;

    logic        axi_busy;
    logic        axi_done;
    logic        err_axi;
    logic        axi_clear_busy;
    logic        clk_ddr_unused;
    logic [2:0]  stats_pixel_format;
    logic        adaptive_awb_active;
    logic        adaptive_stretch_active;
    logic        stats_valid;
    logic        adapt_coeff_valid_unused;
    logic [31:0] stats_pixel_cnt;
    logic [15:0] stats_mean_r;
    logic [15:0] stats_mean_g;
    logic [15:0] stats_mean_b;
    logic [7:0]  stats_luma_min;
    logic [7:0]  stats_luma_max;
    logic [31:0] stats_dark_cnt_unused;
    logic [31:0] stats_bright_cnt_unused;
    logic [7:0]  adaptive_awb_gain_r;
    logic [7:0]  adaptive_awb_gain_g;
    logic [7:0]  adaptive_awb_gain_b;
    logic [7:0]  adaptive_stretch_gain;
    logic signed [8:0] adaptive_stretch_bias;

    assign clk_ddr_unused = clk_ddr;

    always_ff @(posedge clk_byte) begin
        if (!rst_n) begin
            cfg_lane_num_meta_byte        <= 2'd1;
            cfg_lane_num_byte             <= 2'd1;
            cfg_lane_enable_mask_meta_byte <= 4'b0011;
            cfg_lane_enable_mask_byte      <= 4'b0011;
            active_lane_num_meta_byte     <= LANE_NUM[2:0];
            active_lane_num_byte          <= LANE_NUM[2:0];
            resync_toggle_meta_byte       <= 1'b0;
            resync_toggle_byte            <= 1'b0;
            resync_toggle_byte_d          <= 1'b0;
        end else begin
            cfg_lane_num_meta_byte         <= cfg_lane_num_minus1;
            cfg_lane_num_byte              <= cfg_lane_num_meta_byte;
            cfg_lane_enable_mask_meta_byte <= cfg_lane_enable_mask;
            cfg_lane_enable_mask_byte      <= cfg_lane_enable_mask_meta_byte;
            active_lane_num_meta_byte      <= active_lane_num;
            active_lane_num_byte           <= active_lane_num_meta_byte;
            resync_toggle_meta_byte        <= resync_toggle_sys;
            resync_toggle_byte             <= resync_toggle_meta_byte;
            resync_toggle_byte_d           <= resync_toggle_byte;
        end
    end

    assign resync_clear_pulse_byte = resync_toggle_byte ^ resync_toggle_byte_d;

    always_comb begin
        if (active_lane_num_byte == 3'd0) begin
            effective_lane_num_byte = 3'd1;
        end else if ({1'b0, cfg_lane_num_byte} + 3'd1 < active_lane_num_byte) begin
            effective_lane_num_byte = {1'b0, cfg_lane_num_byte} + 3'd1;
        end else begin
            effective_lane_num_byte = active_lane_num_byte;
        end

        case (effective_lane_num_byte)
            3'd1: effective_lane_num_minus1_byte = 2'd0;
            3'd2: effective_lane_num_minus1_byte = 2'd1;
            3'd3: effective_lane_num_minus1_byte = 2'd2;
            default: effective_lane_num_minus1_byte = 2'd3;
        endcase
    end

    cfg_reg_if_apb #(
        .ADDR_WIDTH(16),
        .DATA_WIDTH(32),
        .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
        .AXI_MAX_BURST_LEN(AXI_MAX_BURST_LEN)
    ) u_cfg_reg_if_apb (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .psel_i(psel),
        .penable_i(penable),
        .pwrite_i(pwrite),
        .paddr_i(paddr),
        .pwdata_i(pwdata),
        .prdata_o(prdata),
        .pready_o(pready),
        .pslverr_o(pslverr),
        .cfg_enable_o(cfg_capture_enable),
        .cfg_soft_reset_pulse_o(cfg_soft_reset_pulse),
        .cfg_start_capture_pulse_o(cfg_start_capture_pulse_unused),
        .cfg_preprocess_bypass_o(cfg_preprocess_bypass),
        .cfg_enable_err_log_o(cfg_enable_err_log),
        .cfg_mark_ecc_error_o(cfg_mark_ecc_error),
        .cfg_drop_on_crc_error_o(cfg_drop_on_crc_error),
        .cfg_enable_resync_o(cfg_enable_resync),
        .cfg_enable_degrade_o(cfg_enable_degrade),
        .cfg_enable_retry_o(cfg_enable_retry),
        .cfg_retry_line_mode_o(cfg_retry_line_mode),
        .cfg_retry_ack_pulse_o(cfg_retry_ack_pulse),
        .cfg_adaptive_enable_o(cfg_adaptive_enable),
        .cfg_adaptive_awb_enable_o(cfg_adaptive_awb_enable),
        .cfg_adaptive_stretch_enable_o(cfg_adaptive_stretch_enable),
        .cfg_lane_num_minus1_o(cfg_lane_num_minus1),
        .cfg_lane_enable_mask_o(cfg_lane_enable_mask),
        .cfg_dt_code_o(cfg_dt_code),
        .cfg_vc_id_o(cfg_vc_id),
        .cfg_frame_base_addr_o(cfg_frame_base_addr),
        .cfg_line_stride_o(cfg_line_stride),
        .cfg_img_width_o(cfg_img_width),
        .cfg_img_height_o(cfg_img_height),
        .cfg_dbg_sel_o(cfg_dbg_sel_unused),
        .cfg_axi_max_burst_len_o(cfg_axi_max_burst_len),
        .frame_active_i(frame_active),
        .line_active_i(line_active),
        .parser_busy_i(parser_busy),
        .axi_busy_i(axi_busy),
        .err_pending_i(err_pending),
        .overflow_event_i(lane_error_event_sys),
        .active_lane_num_i(active_lane_num),
        .hs_mode_i(hs_mode),
        .lp_mode_i(lp_mode),
        .frame_cnt_i(frame_cnt),
        .line_cnt_i(line_cnt),
        .err_cnt_ecc_i(err_cnt_ecc_o),
        .err_cnt_crc_i(err_cnt_crc_o),
        .err_cnt_sync_i(err_cnt_sync),
        .last_err_type_i(last_err_type),
        .last_err_priority_i(last_err_priority),
        .last_err_frame_id_i(last_frame_id),
        .last_err_line_id_i(last_line_id),
        .last_err_vc_i(last_vc),
        .last_err_dt_i(last_dt),
        .retry_pending_i(retry_pending),
        .retry_mode_i(retry_mode),
        .retry_err_type_i(retry_err_type),
        .retry_frame_id_i(retry_frame_id),
        .retry_line_id_i(retry_line_id),
        .retry_vc_i(retry_vc),
        .retry_dt_i(retry_dt),
        .adaptive_stretch_gain_i(adaptive_stretch_gain),
        .adaptive_awb_gain_r_i(adaptive_awb_gain_r),
        .adaptive_awb_gain_g_i(adaptive_awb_gain_g),
        .adaptive_awb_gain_b_i(adaptive_awb_gain_b),
        .stats_mean_r_i(stats_mean_r),
        .stats_mean_g_i(stats_mean_g),
        .stats_mean_b_i(stats_mean_b),
        .stats_luma_min_i(stats_luma_min),
        .stats_luma_max_i(stats_luma_max)
    );

    phy_digital_adapter #(
        .LANE_NUM(LANE_NUM)
    ) u_phy_digital_adapter (
        .hs_mode_i(hs_mode),
        .lp_mode_i(lp_mode),
        .cfg_lane_num_minus1_i(effective_lane_num_minus1_byte),
        .cfg_lane_enable_mask_i(cfg_lane_enable_mask_byte),
        .lane_data_0_i(lane_data_0),
        .lane_data_1_i(lane_data_1),
        .lane_data_2_i(lane_data_2),
        .lane_data_3_i(lane_data_3),
        .lane_valid_0_i(lane_valid_0),
        .lane_valid_1_i(lane_valid_1),
        .lane_valid_2_i(lane_valid_2),
        .lane_valid_3_i(lane_valid_3),
        .lane_valid_o(phy_lane_valid),
        .lane_data_o(phy_lane_data),
        .lane_enable_o(phy_lane_enable_unused),
        .phy_active_o(phy_active_unused)
    );

    // Byte-domain lane alignment and merge. The merged byte stream crosses into
    // clk_sys through the async FIFO below before packet parsing.
    lane_deskew_buffer #(
        .LANE_NUM(LANE_NUM),
        .DESKEW_DEPTH(DESKEW_DEPTH)
    ) u_lane_deskew_buffer (
        .clk_byte(clk_byte),
        .rst_n(rst_n),
        .clear_i(resync_clear_pulse_byte),
        .lane_valid_i(phy_lane_valid),
        .lane_ready_o(phy_lane_ready),
        .lane_data_i(phy_lane_data),
        .deskew_valid_o(deskew_valid),
        .deskew_ready_i(deskew_ready),
        .deskew_data_o(deskew_data),
        .err_overflow_o(deskew_overflow)
    );

    lane_reorder_merge #(
        .LANE_NUM(LANE_NUM)
    ) u_lane_reorder_merge (
        .clk_byte(clk_byte),
        .rst_n(rst_n),
        .clear_i(resync_clear_pulse_byte),
        .lane_group_valid_i(deskew_valid),
        .lane_group_ready_o(deskew_ready),
        .lane_group_data_i(deskew_data),
        .byte_valid_o(merge_byte_valid),
        .byte_ready_i(merge_byte_ready),
        .byte_data_o(merge_byte_data),
        .group_done_o(merge_group_done_unused)
    );

    async_fifo #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(BYTE_FIFO_ADDR_WIDTH)
    ) u_byte_to_sys_fifo (
        .clk_wr(clk_byte),
        .clk_rd(clk_sys),
        .rst_n(rst_n),
        .clear_wr_i(resync_clear_pulse_byte),
        .clear_rd_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .wr_valid(merge_byte_valid),
        .wr_ready(merge_byte_ready),
        .wr_data(merge_byte_data),
        .rd_valid(fifo_rd_valid),
        .rd_ready(fifo_rd_ready),
        .rd_data(fifo_rd_data),
        .full(fifo_full_unused),
        .empty(fifo_empty_unused),
        .wr_level(fifo_wr_level_unused),
        .rd_level(fifo_rd_level_unused)
    );

    // Lane overflow originates in clk_byte. A toggle synchronizer reports it as
    // a one-cycle event in clk_sys for the reliability monitor.
    always_ff @(posedge clk_byte) begin
        if (!rst_n) begin
            lane_err_toggle_byte <= 1'b0;
        end else if (deskew_overflow) begin
            lane_err_toggle_byte <= ~lane_err_toggle_byte;
        end
    end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            lane_err_sync_meta <= 1'b0;
            lane_err_sync      <= 1'b0;
            lane_err_sync_d    <= 1'b0;
            resync_req_d       <= 1'b0;
            resync_toggle_sys  <= 1'b0;
        end else begin
            lane_err_sync_meta <= lane_err_toggle_byte;
            lane_err_sync      <= lane_err_sync_meta;
            lane_err_sync_d    <= lane_err_sync;
            resync_req_d       <= resync_req;

            if (resync_req && !resync_req_d) begin
                resync_toggle_sys <= ~resync_toggle_sys;
            end
        end
    end

    assign lane_error_event_sys = lane_err_sync ^ lane_err_sync_d;
    assign resync_clear_pulse_sys = resync_req && !resync_req_d;

    // A single long-packet parser is used for both zero-word-count short events
    // and nonzero long-packet payloads in this minimum top.
    csi2_long_packet_parser #(
        .ENABLE_CRC_TRAILER(1'b1)
    ) u_csi2_long_packet_parser (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .byte_valid(fifo_rd_valid),
        .byte_ready(fifo_rd_ready),
        .byte_data(fifo_rd_data),
        .hdr_valid(hdr_valid),
        .hdr_ready(hdr_ready),
        .vc(pkt_vc),
        .dt(pkt_dt),
        .word_count(pkt_word_count),
        .ecc_ok(pkt_ecc_ok),
        .ecc_correctable(pkt_ecc_correctable_unused),
        .ecc_syndrome(pkt_ecc_syndrome_unused),
        .payload_valid(payload_valid),
        .payload_ready(payload_ready),
        .payload_data(payload_data),
        .payload_start(payload_start),
        .payload_end(payload_end),
        .expected_crc_valid(expected_crc_valid),
        .expected_crc_ready(expected_crc_ready),
        .expected_crc(expected_crc),
        .parser_busy(parser_busy),
        .packet_done(packet_done_unused)
    );

    assign hdr_ready = 1'b1;
    assign payload_fire = payload_valid && payload_ready;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            payload_dt_reg <= DT_RAW8;
        end else if (cfg_soft_reset_pulse || resync_clear_pulse_sys) begin
            payload_dt_reg <= DT_RAW8;
        end else if (hdr_valid && hdr_ready && (pkt_word_count != 16'd0)) begin
            payload_dt_reg <= pkt_dt;
        end
    end

    assign payload_is_raw8   = (payload_dt_reg == DT_RAW8);
    assign payload_is_raw10  = (payload_dt_reg == DT_RAW10);
    assign payload_is_rgb888 = (payload_dt_reg == DT_RGB888);
    assign payload_is_yuv422 = (payload_dt_reg == DT_YUV422);
    assign adaptive_awb_active =
        cfg_adaptive_enable && cfg_adaptive_awb_enable && payload_is_rgb888;
    assign adaptive_stretch_active =
        cfg_adaptive_enable && cfg_adaptive_stretch_enable &&
        (payload_is_rgb888 || payload_is_raw8);
    assign payload_vc_mismatch = (pkt_vc != cfg_vc_id[1:0]);
    assign short_vc_match      = (pkt_vc == cfg_vc_id[1:0]);

    packet_error_policy u_packet_error_policy (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .cfg_mark_ecc_error_i(cfg_mark_ecc_error),
        .cfg_drop_on_crc_error_i(cfg_drop_on_crc_error),
        .hdr_valid_i(hdr_valid),
        .hdr_ready_i(hdr_ready),
        .pkt_word_count_i(pkt_word_count),
        .pkt_ecc_ok_i(pkt_ecc_ok),
        .packet_done_i(packet_done_unused),
        .crc_error_i(err_crc_event),
        .resync_drop_packet_i(resync_drop_packet),
        .unsupported_dt_i(payload_unsupported_dt),
        .payload_drop_o(payload_drop),
        .crc_drop_req_o(crc_drop_req)
    );

    always_comb begin
        if (payload_is_rgb888) begin
            stats_pixel_format = PIXFMT_RGB888;
        end else if (payload_is_raw8) begin
            stats_pixel_format = PIXFMT_RAW8;
        end else if (payload_is_raw10) begin
            stats_pixel_format = PIXFMT_RAW10;
        end else if (payload_is_yuv422) begin
            stats_pixel_format = PIXFMT_YUV422;
        end else begin
            stats_pixel_format = PIXFMT_RAW8;
        end
    end

    assign payload_unsupported_dt = payload_vc_mismatch ||
                                    (pkt_dt != cfg_dt_code[5:0]) ||
                                    !(payload_is_raw8 || payload_is_raw10 ||
                                      payload_is_rgb888 || payload_is_yuv422);

    assign payload_sink_ready =
        (payload_drop      ? 1'b1 :
         payload_is_raw8   ? raw8_payload_ready :
         payload_is_raw10  ? raw10_payload_ready :
         payload_is_rgb888 ? rgb888_payload_ready :
         payload_is_yuv422 ? yuv422_payload_ready :
                              1'b1);

    assign payload_ready = payload_sink_ready && crc_payload_ready;

    assign short_event_valid = hdr_valid && (pkt_word_count == 16'd0) && short_vc_match &&
                               ((pkt_dt == DT_FS) || (pkt_dt == DT_FE) ||
                                (pkt_dt == DT_LS) || (pkt_dt == DT_LE));

    frame_line_sync_fsm u_frame_line_sync_fsm (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .event_valid(short_event_valid),
        .event_ready(short_event_ready_unused),
        .event_dt(pkt_dt),
        .event_vc(pkt_vc),
        .frame_active(frame_active),
        .line_active(line_active),
        .frame_start(frame_start),
        .frame_end(frame_end),
        .line_start(line_start),
        .line_end(line_end),
        .frame_cnt(frame_cnt),
        .line_cnt(line_cnt),
        .active_vc(active_vc_unused),
        .sync_error(sync_error)
    );

    // Frame/line event pulses are held until the first payload byte so pixel
    // markers remain aligned with the selected repack output stream.
    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            pending_sof <= 1'b0;
            pending_sol <= 1'b0;
        end else if (cfg_soft_reset_pulse || resync_clear_pulse_sys) begin
            pending_sof <= 1'b0;
            pending_sol <= 1'b0;
        end else begin
            if (frame_start) begin
                pending_sof <= 1'b1;
            end
            if (line_start) begin
                pending_sol <= 1'b1;
            end
            if (payload_fire && payload_start) begin
                pending_sof <= 1'b0;
                pending_sol <= 1'b0;
            end
        end
    end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            line_crc_drop_pending <= 1'b0;
        end else if (cfg_soft_reset_pulse || resync_clear_pulse_sys) begin
            line_crc_drop_pending <= 1'b0;
        end else begin
            if (frame_start) begin
                line_crc_drop_pending <= 1'b0;
            end

            if (crc_drop_req) begin
                line_crc_drop_pending <= 1'b1;
            end

            if (line_end) begin
                line_crc_drop_pending <= 1'b0;
            end
        end
    end

    // Instantiate all supported unpackers and select the active one by packet
    // data type. Unsupported payload types are drained without producing pixels.
    raw8_unpack u_raw8_unpack (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .payload_valid_i(payload_valid && payload_is_raw8 && !payload_drop),
        .payload_ready_o(raw8_payload_ready),
        .payload_data_i(payload_data),
        .payload_sof_i(payload_start && pending_sof),
        .payload_sol_i(payload_start && pending_sol),
        .pixel_valid_o(raw8_pixel_valid),
        .pixel_ready_i(raw8_pixel_ready),
        .pixel_data_o(raw8_pixel_data),
        .pixel_sof_o(raw8_pixel_sof),
        .pixel_sol_o(raw8_pixel_sol)
    );

    raw10_unpack u_raw10_unpack (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .payload_valid_i(payload_valid && payload_is_raw10 && !payload_drop),
        .payload_ready_o(raw10_payload_ready),
        .payload_data_i(payload_data),
        .payload_sof_i(payload_start && pending_sof),
        .payload_sol_i(payload_start && pending_sol),
        .pixel_valid_o(raw10_pixel_valid),
        .pixel_ready_i(raw10_pixel_ready),
        .pixel_data_o(raw10_pixel_data),
        .pixel_sof_o(raw10_pixel_sof),
        .pixel_sol_o(raw10_pixel_sol)
    );

    rgb888_unpack u_rgb888_unpack (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .payload_valid_i(payload_valid && payload_is_rgb888 && !payload_drop),
        .payload_ready_o(rgb888_payload_ready),
        .payload_data_i(payload_data),
        .payload_sof_i(payload_start && pending_sof),
        .payload_sol_i(payload_start && pending_sol),
        .pixel_valid_o(rgb888_pixel_valid),
        .pixel_ready_i(rgb888_pixel_ready),
        .pixel_data_o(rgb888_pixel_data),
        .pixel_sof_o(rgb888_pixel_sof),
        .pixel_sol_o(rgb888_pixel_sol)
    );

    yuv422_unpack u_yuv422_unpack (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .payload_valid_i(payload_valid && payload_is_yuv422 && !payload_drop),
        .payload_ready_o(yuv422_payload_ready),
        .payload_data_i(payload_data),
        .payload_sof_i(payload_start && pending_sof),
        .payload_sol_i(payload_start && pending_sol),
        .pixel_valid_o(yuv422_pixel_valid),
        .pixel_ready_i(yuv422_pixel_ready),
        .pixel_data_o(yuv422_pixel_data),
        .pixel_sof_o(yuv422_pixel_sof),
        .pixel_sol_o(yuv422_pixel_sol)
    );

    always_comb begin
        repack_pixel_valid = 1'b0;
        repack_pixel_data  = 24'd0;
        repack_pixel_sof   = 1'b0;
        repack_pixel_sol   = 1'b0;

        case (payload_dt_reg)
            DT_RAW8: begin
                repack_pixel_valid = raw8_pixel_valid;
                repack_pixel_data  = raw8_pixel_data;
                repack_pixel_sof   = raw8_pixel_sof;
                repack_pixel_sol   = raw8_pixel_sol;
            end

            DT_RAW10: begin
                repack_pixel_valid = raw10_pixel_valid;
                repack_pixel_data  = raw10_pixel_data;
                repack_pixel_sof   = raw10_pixel_sof;
                repack_pixel_sol   = raw10_pixel_sol;
            end

            DT_RGB888: begin
                repack_pixel_valid = rgb888_pixel_valid;
                repack_pixel_data  = rgb888_pixel_data;
                repack_pixel_sof   = rgb888_pixel_sof;
                repack_pixel_sol   = rgb888_pixel_sol;
            end

            DT_YUV422: begin
                repack_pixel_valid = yuv422_pixel_valid;
                repack_pixel_data  = yuv422_pixel_data;
                repack_pixel_sof   = yuv422_pixel_sof;
                repack_pixel_sol   = yuv422_pixel_sol;
            end

            default: begin
                repack_pixel_valid = 1'b0;
            end
        endcase
    end

    assign raw8_pixel_ready   = (payload_dt_reg == DT_RAW8)   ? repack_pixel_ready : 1'b1;
    assign raw10_pixel_ready  = (payload_dt_reg == DT_RAW10)  ? repack_pixel_ready : 1'b1;
    assign rgb888_pixel_ready = (payload_dt_reg == DT_RGB888) ? repack_pixel_ready : 1'b1;
    assign yuv422_pixel_ready = (payload_dt_reg == DT_YUV422) ? repack_pixel_ready : 1'b1;

    assign repack_pixel_ready = cfg_preprocess_bypass ? bypass_raw_ready : bright_ready;

    // adaptive_v1 statistics are collected on the raw repack stream and latched
    // at frame end. The derived coefficients are used on the next frame.
    pixel_frame_stats_v1 u_pixel_frame_stats_v1 (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .enable_i(cfg_adaptive_enable),
        .clear_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .pixel_format_i(stats_pixel_format),
        .frame_end_i(frame_end),
        .pixel_valid_i(repack_pixel_valid),
        .pixel_ready_i(repack_pixel_ready),
        .pixel_data_i(repack_pixel_data),
        .pixel_sof_i(repack_pixel_sof),
        .stats_valid_o(stats_valid),
        .pixel_cnt_o(stats_pixel_cnt),
        .mean_r_o(stats_mean_r),
        .mean_g_o(stats_mean_g),
        .mean_b_o(stats_mean_b),
        .luma_min_o(stats_luma_min),
        .luma_max_o(stats_luma_max),
        .dark_cnt_o(stats_dark_cnt_unused),
        .bright_cnt_o(stats_bright_cnt_unused)
    );

    adaptive_preprocess_ctrl_v1 u_adaptive_preprocess_ctrl_v1 (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .enable_i(cfg_adaptive_enable),
        .awb_enable_i(cfg_adaptive_awb_enable),
        .stretch_enable_i(cfg_adaptive_stretch_enable),
        .clear_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .stats_valid_i(stats_valid),
        .pixel_cnt_i(stats_pixel_cnt),
        .mean_r_i(stats_mean_r),
        .mean_g_i(stats_mean_g),
        .mean_b_i(stats_mean_b),
        .luma_min_i(stats_luma_min),
        .luma_max_i(stats_luma_max),
        .awb_gain_r_o(adaptive_awb_gain_r),
        .awb_gain_g_o(adaptive_awb_gain_g),
        .awb_gain_b_o(adaptive_awb_gain_b),
        .stretch_gain_o(adaptive_stretch_gain),
        .stretch_bias_o(adaptive_stretch_bias),
        .coeff_valid_o(adapt_coeff_valid_unused)
    );

    // Preprocess chain uses identity coefficients by default. The bypass mux
    // allows the raw repack stream to remain the reset/default path.
    brightness_adjust u_brightness_adjust (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .bypass_i(!adaptive_stretch_active),
        .cfg_gain_i(adaptive_stretch_gain),
        .cfg_bias_i(adaptive_stretch_bias),
        .pixel_valid_i(repack_pixel_valid && !cfg_preprocess_bypass),
        .pixel_ready_o(bright_ready),
        .pixel_data_i(repack_pixel_data),
        .pixel_sof_i(repack_pixel_sof),
        .pixel_sol_i(repack_pixel_sol),
        .pixel_valid_o(bright_valid),
        .pixel_ready_i(contrast_ready),
        .pixel_data_o(bright_data),
        .pixel_sof_o(bright_sof),
        .pixel_sol_o(bright_sol)
    );

    contrast_adjust u_contrast_adjust (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .bypass_i(1'b1),
        .cfg_gain_i(8'h80),
        .cfg_bias_i(9'sd0),
        .pixel_valid_i(bright_valid),
        .pixel_ready_o(contrast_ready),
        .pixel_data_i(bright_data),
        .pixel_sof_i(bright_sof),
        .pixel_sol_i(bright_sol),
        .pixel_valid_o(contrast_valid),
        .pixel_ready_i(gray_ready),
        .pixel_data_o(contrast_data),
        .pixel_sof_o(contrast_sof),
        .pixel_sol_o(contrast_sol)
    );

    gray_balance u_gray_balance (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .bypass_i(!adaptive_awb_active),
        .cfg_gain_r_i(adaptive_awb_gain_r),
        .cfg_gain_g_i(adaptive_awb_gain_g),
        .cfg_gain_b_i(adaptive_awb_gain_b),
        .cfg_bias_r_i(9'sd0),
        .cfg_bias_g_i(9'sd0),
        .cfg_bias_b_i(9'sd0),
        .pixel_valid_i(contrast_valid),
        .pixel_ready_o(gray_ready),
        .pixel_data_i(contrast_data),
        .pixel_sof_i(contrast_sof),
        .pixel_sol_i(contrast_sol),
        .pixel_valid_o(gray_valid),
        .pixel_ready_i(bypass_proc_ready),
        .pixel_data_o(gray_data),
        .pixel_sof_o(gray_sof),
        .pixel_sol_o(gray_sol)
    );

    preprocess_bypass_mux u_preprocess_bypass_mux (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .bypass_i(cfg_preprocess_bypass),
        .raw_valid_i(repack_pixel_valid && cfg_preprocess_bypass),
        .raw_ready_o(bypass_raw_ready),
        .raw_data_i(repack_pixel_data),
        .raw_sof_i(repack_pixel_sof),
        .raw_sol_i(repack_pixel_sol),
        .proc_valid_i(gray_valid),
        .proc_ready_o(bypass_proc_ready),
        .proc_data_i(gray_data),
        .proc_sof_i(gray_sof),
        .proc_sol_i(gray_sol),
        .pixel_valid_o(final_pixel_valid),
        .pixel_ready_i(final_pixel_ready),
        .pixel_data_o(final_pixel_data),
        .pixel_sof_o(final_pixel_sof),
        .pixel_sol_o(final_pixel_sol)
    );

    assign crc_start = hdr_valid && hdr_ready && (pkt_word_count != 16'd0);

    // CSI-2 long packets carry a 16-bit payload CRC trailer after word_count
    // payload bytes. The parser extracts that trailer and the checker compares
    // it against the CRC accumulated over the payload stream.
    csi2_payload_crc_checker u_payload_crc_checker (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .crc_start(crc_start),
        .crc_clear(cfg_soft_reset_pulse || resync_req),
        .crc_finish(1'b0),
        .payload_valid(payload_valid && payload_sink_ready),
        .payload_ready(crc_payload_ready),
        .payload_data(payload_data),
        .payload_last(payload_end),
        .expected_crc_valid(expected_crc_valid),
        .expected_crc_ready(expected_crc_ready),
        .expected_crc(expected_crc),
        .crc_valid(crc_valid),
        .crc_ready(1'b1),
        .crc_calc(crc_calc_unused),
        .crc_error(crc_error)
    );

    assign err_ecc_event = hdr_valid && hdr_ready && !pkt_ecc_ok;
    assign err_crc_event = crc_valid && crc_error;

    // Reliability monitor classifies ECC, CRC, sync, and lane errors with the
    // current frame/line/VC/DT context.
    err_classifier u_err_classifier (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .err_ecc_i(err_ecc_event),
        .err_crc_i(err_crc_event),
        .err_sync_i(sync_error),
        .err_lane_i(lane_error_event_sys),
        .frame_id_i(frame_cnt),
        .line_id_i(line_cnt),
        .vc_i(pkt_vc),
        .dt_i(pkt_dt),
        .err_valid_o(err_valid),
        .err_ready_i(err_ready),
        .err_type_o(err_type),
        .err_priority_o(err_priority),
        .frame_id_o(err_frame_id),
        .line_id_o(err_line_id),
        .vc_o(err_vc),
        .dt_o(err_dt),
        .err_cnt_ecc_o(err_cnt_ecc_o),
        .err_cnt_crc_o(err_cnt_crc_o),
        .err_cnt_sync_o(err_cnt_sync),
        .err_cnt_lane_o(err_cnt_lane)
    );

    assign err_valid_to_logger = err_valid && cfg_enable_err_log;

    err_frame_line_logger u_err_frame_line_logger (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .err_valid_i(err_valid_to_logger),
        .err_ready_o(err_ready),
        .err_type_i(err_type),
        .err_priority_i(err_priority),
        .frame_id_i(err_frame_id),
        .line_id_i(err_line_id),
        .vc_i(err_vc),
        .dt_i(err_dt),
        .err_pending_o(err_pending),
        .last_err_type_o(last_err_type),
        .last_err_priority_o(last_err_priority),
        .last_frame_id_o(last_frame_id),
        .last_line_id_o(last_line_id),
        .last_vc_o(last_vc),
        .last_dt_o(last_dt),
        .total_err_cnt_o(total_err_cnt_unused),
        .ecc_err_cnt_o(logger_ecc_cnt_unused),
        .crc_err_cnt_o(logger_crc_cnt_unused),
        .sync_err_cnt_o(logger_sync_cnt_unused),
        .lane_err_cnt_o(logger_lane_cnt_unused)
    );

    retry_request_ctrl u_retry_request_ctrl (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(cfg_soft_reset_pulse),
        .ack_i(cfg_retry_ack_pulse),
        .cfg_enable_retry_i(cfg_enable_retry),
        .cfg_retry_line_mode_i(cfg_retry_line_mode),
        .err_valid_i(err_valid && err_ready),
        .err_type_i(err_type),
        .frame_id_i(err_frame_id),
        .line_id_i(err_line_id),
        .vc_i(err_vc),
        .dt_i(err_dt),
        .retry_req_o(retry_req),
        .retry_pending_o(retry_pending),
        .retry_mode_o(retry_mode),
        .retry_err_type_o(retry_err_type),
        .retry_frame_id_o(retry_frame_id),
        .retry_line_id_o(retry_line_id),
        .retry_vc_o(retry_vc),
        .retry_dt_o(retry_dt)
    );

    resync_ctrl_fsm u_resync_ctrl_fsm (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .enable_resync_i(cfg_enable_resync),
        .sync_error_i(sync_error),
        .resync_ack_i(!axi_clear_busy && resync_clear_pulse_sys),
        .resync_req_o(resync_req),
        .drop_packet_o(resync_drop_packet),
        .resync_busy_o(resync_busy),
        .resync_done_o(resync_done_unused)
    );

    degrade_recover_fsm #(
        .FULL_LANE_NUM(LANE_NUM),
        .DEGRADED_LANE_NUM(DEGRADED_LANE_NUM),
        .RECOVER_GOOD_FRAME_TH(3)
    ) u_degrade_recover_fsm (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .enable_degrade_i(cfg_enable_degrade),
        .lane_error_i(lane_error_event_sys),
        .good_frame_i(frame_end && !err_valid),
        .degraded_o(degraded),
        .recovering_o(recovering),
        .active_lane_num_o(active_lane_num)
    );

    pixel_to_axi_writer #(
        .ADDR_WIDTH(AXI_ADDR_WIDTH),
        .DATA_WIDTH(AXI_DATA_WIDTH),
        .MAX_BURST_LEN(AXI_MAX_BURST_LEN),
        .FIFO_ADDR_WIDTH(AXI_FIFO_ADDR_WIDTH)
    ) u_pixel_to_axi_writer (
        .clk_sys(clk_sys),
        .clk_axi(clk_axi),
        .rst_n(rst_n),
        .enable_i(cfg_capture_enable),
        .clear_i(cfg_soft_reset_pulse || resync_clear_pulse_sys),
        .clear_busy_o(axi_clear_busy),
        .frame_base_addr_i(cfg_frame_base_addr),
        .line_stride_i(cfg_line_stride),
        .frame_height_i(cfg_img_height),
        .max_burst_len_i(cfg_axi_max_burst_len),
        .frame_start_i(frame_start),
        .line_end_i(line_end),
        .discard_line_i(line_end && line_crc_drop_pending),
        .pixel_valid_i(final_pixel_valid),
        .pixel_ready_o(final_pixel_ready),
        .pixel_data_i(final_pixel_data),
        .m_axi_awaddr_o(m_axi_awaddr_o),
        .m_axi_awlen_o(m_axi_awlen_o),
        .m_axi_awsize_o(m_axi_awsize_o),
        .m_axi_awburst_o(m_axi_awburst_o),
        .m_axi_awvalid_o(m_axi_awvalid_o),
        .m_axi_awready_i(m_axi_awready_i),
        .m_axi_wdata_o(m_axi_wdata_o),
        .m_axi_wstrb_o(m_axi_wstrb_o),
        .m_axi_wlast_o(m_axi_wlast_o),
        .m_axi_wvalid_o(m_axi_wvalid_o),
        .m_axi_wready_i(m_axi_wready_i),
        .m_axi_bresp_i(m_axi_bresp_i),
        .m_axi_bvalid_i(m_axi_bvalid_i),
        .m_axi_bready_o(m_axi_bready_o),
        .busy_o(axi_busy),
        .done_o(axi_done),
        .err_axi_o(err_axi)
    );

    assign frame_start_o = frame_start;
    assign frame_end_o   = frame_end;
    assign line_start_o  = line_start;
    assign line_end_o    = line_end;
    assign err_ecc_o     = err_ecc_event;
    assign err_crc_o     = err_crc_event;
    assign err_sync_o    = sync_error;
    assign frame_cnt_o   = frame_cnt;
    assign line_cnt_o    = line_cnt;
    assign retry_req_o      = retry_req;
    assign retry_pending_o  = retry_pending;
    assign retry_mode_o     = retry_mode;
    assign retry_frame_id_o = retry_frame_id;
    assign retry_line_id_o  = retry_line_id;

    assign pixel_data_o  = final_pixel_data;
    assign pixel_valid_o = final_pixel_valid;
    assign pixel_sof_o   = final_pixel_sof;
    assign pixel_sol_o   = final_pixel_sol;

endmodule
