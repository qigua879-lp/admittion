`timescale 1ns/1ps

// APB configuration and status block for the digital MIPI CSI-2 capture top.
// This module centralizes the draft register map so the top-level datapath no
// longer carries scattered APB decode logic.
module cfg_reg_if_apb #(
    parameter int ADDR_WIDTH = 16,
    parameter int DATA_WIDTH = 32,
    parameter int AXI_ADDR_WIDTH = 32,
    parameter int AXI_MAX_BURST_LEN = 16
) (
    input  logic                         clk_sys,
    input  logic                         rst_n,

    input  logic                         psel_i,
    input  logic                         penable_i,
    input  logic                         pwrite_i,
    input  logic [ADDR_WIDTH-1:0]        paddr_i,
    input  logic [DATA_WIDTH-1:0]        pwdata_i,
    output logic [DATA_WIDTH-1:0]        prdata_o,
    output logic                         pready_o,
    output logic                         pslverr_o,

    output logic                         cfg_enable_o,
    output logic                         cfg_soft_reset_pulse_o,
    output logic                         cfg_start_capture_pulse_o,
    output logic                         cfg_preprocess_bypass_o,
    output logic                         cfg_enable_err_log_o,
    output logic                         cfg_mark_ecc_error_o,
    output logic                         cfg_drop_on_crc_error_o,
    output logic                         cfg_enable_resync_o,
    output logic                         cfg_enable_degrade_o,
    output logic                         cfg_enable_retry_o,
    output logic                         cfg_retry_line_mode_o,
    output logic                         cfg_retry_ack_pulse_o,
    output logic                         cfg_adaptive_enable_o,
    output logic                         cfg_adaptive_awb_enable_o,
    output logic                         cfg_adaptive_stretch_enable_o,
    output logic [1:0]                   cfg_lane_num_minus1_o,
    output logic [3:0]                   cfg_lane_enable_mask_o,
    output logic [7:0]                   cfg_dt_code_o,
    output logic [7:0]                   cfg_vc_id_o,
    output logic [AXI_ADDR_WIDTH-1:0]    cfg_frame_base_addr_o,
    output logic [AXI_ADDR_WIDTH-1:0]    cfg_line_stride_o,
    output logic [15:0]                  cfg_img_width_o,
    output logic [15:0]                  cfg_img_height_o,
    output logic [31:0]                  cfg_dbg_sel_o,
    output logic [8:0]                   cfg_axi_max_burst_len_o,

    input  logic                         frame_active_i,
    input  logic                         line_active_i,
    input  logic                         parser_busy_i,
    input  logic                         axi_busy_i,
    input  logic                         err_pending_i,
    input  logic                         overflow_event_i,
    input  logic [2:0]                   active_lane_num_i,
    input  logic                         hs_mode_i,
    input  logic                         lp_mode_i,
    input  logic [31:0]                  frame_cnt_i,
    input  logic [31:0]                  line_cnt_i,
    input  logic [31:0]                  err_cnt_ecc_i,
    input  logic [31:0]                  err_cnt_crc_i,
    input  logic [31:0]                  err_cnt_sync_i,
    input  logic [2:0]                   last_err_type_i,
    input  logic [1:0]                   last_err_priority_i,
    input  logic [31:0]                  last_err_frame_id_i,
    input  logic [31:0]                  last_err_line_id_i,
    input  logic [1:0]                   last_err_vc_i,
    input  logic [5:0]                   last_err_dt_i,
    input  logic                         retry_pending_i,
    input  logic                         retry_mode_i,
    input  logic [2:0]                   retry_err_type_i,
    input  logic [31:0]                  retry_frame_id_i,
    input  logic [31:0]                  retry_line_id_i,
    input  logic [1:0]                   retry_vc_i,
    input  logic [5:0]                   retry_dt_i,
    input  logic [7:0]                   adaptive_stretch_gain_i,
    input  logic [7:0]                   adaptive_awb_gain_r_i,
    input  logic [7:0]                   adaptive_awb_gain_g_i,
    input  logic [7:0]                   adaptive_awb_gain_b_i,
    input  logic [15:0]                  stats_mean_r_i,
    input  logic [15:0]                  stats_mean_g_i,
    input  logic [15:0]                  stats_mean_b_i,
    input  logic [7:0]                   stats_luma_min_i,
    input  logic [7:0]                   stats_luma_max_i
);

    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_CTRL            = 16'h0000;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_STATUS          = 16'h0004;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_IMG_WIDTH       = 16'h0008;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_IMG_HEIGHT      = 16'h000c;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_LANE_CFG        = 16'h0010;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_DT_CFG          = 16'h0014;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_FRAME_BASE_ADDR = 16'h0018;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_LINE_STRIDE     = 16'h001c;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_ERR_CNT_ECC     = 16'h0020;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_ERR_CNT_CRC     = 16'h0024;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_ERR_CNT_SYNC    = 16'h0028;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_FRAME_CNT       = 16'h002c;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_LINE_CNT        = 16'h0030;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_ERR_POLICY      = 16'h0034;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_PREPROC_CFG     = 16'h0038;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_DBG_SEL         = 16'h003c;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_AXI_CFG         = 16'h0040;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_LAST_ERR        = 16'h0044;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_ADAPT_GAIN      = 16'h0048;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_ADAPT_STAT0     = 16'h004c;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_ADAPT_STAT1     = 16'h0050;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_LAST_ERR_FRAME  = 16'h0054;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_LAST_ERR_LINE   = 16'h0058;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_RETRY_STATUS    = 16'h005c;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_RETRY_FRAME     = 16'h0060;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_RETRY_LINE      = 16'h0064;

    logic        apb_write_fire;
    logic        status_idle;
    logic        status_receiving;
    logic        overflow_sticky_q;
    logic [31:0] reg_lane_cfg;
    logic [31:0] reg_dt_cfg;
    logic [31:0] reg_err_policy;
    logic [31:0] reg_preproc_cfg;

    assign pready_o       = 1'b1;
    assign pslverr_o      = 1'b0;
    assign apb_write_fire = psel_i && penable_i && pwrite_i;
    assign status_idle    = !(frame_active_i || line_active_i || parser_busy_i || axi_busy_i);
    assign status_receiving = frame_active_i || line_active_i || parser_busy_i;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            cfg_enable_o                  <= 1'b0;
            cfg_soft_reset_pulse_o        <= 1'b0;
            cfg_start_capture_pulse_o     <= 1'b0;
            cfg_preprocess_bypass_o       <= 1'b1;
            cfg_enable_err_log_o          <= 1'b1;
            cfg_mark_ecc_error_o          <= 1'b0;
            cfg_drop_on_crc_error_o       <= 1'b0;
            cfg_enable_resync_o           <= 1'b1;
            cfg_enable_degrade_o          <= 1'b1;
            cfg_enable_retry_o            <= 1'b1;
            cfg_retry_line_mode_o         <= 1'b0;
            cfg_retry_ack_pulse_o         <= 1'b0;
            cfg_adaptive_enable_o         <= 1'b0;
            cfg_adaptive_awb_enable_o     <= 1'b0;
            cfg_adaptive_stretch_enable_o <= 1'b0;
            cfg_lane_num_minus1_o         <= 2'd1;
            cfg_lane_enable_mask_o        <= 4'b0011;
            cfg_dt_code_o                 <= 8'h2a;
            cfg_vc_id_o                   <= 8'd0;
            cfg_frame_base_addr_o         <= '0;
            cfg_line_stride_o             <= '0;
            cfg_img_width_o               <= 16'd1920;
            cfg_img_height_o              <= 16'd1080;
            cfg_dbg_sel_o                 <= 32'd0;
            cfg_axi_max_burst_len_o       <= AXI_MAX_BURST_LEN[8:0];
            overflow_sticky_q             <= 1'b0;
        end else begin
            cfg_soft_reset_pulse_o    <= 1'b0;
            cfg_start_capture_pulse_o <= 1'b0;
            cfg_retry_ack_pulse_o     <= 1'b0;

            if (overflow_event_i) begin
                overflow_sticky_q <= 1'b1;
            end

            if (apb_write_fire) begin
                case (paddr_i)
                    APB_ADDR_CTRL: begin
                        cfg_enable_o <= pwdata_i[0];
                        if (pwdata_i[1]) begin
                            cfg_soft_reset_pulse_o <= 1'b1;
                            overflow_sticky_q      <= 1'b0;
                        end
                        if (pwdata_i[2]) begin
                            cfg_start_capture_pulse_o <= 1'b1;
                        end
                        if (pwdata_i[3]) begin
                            cfg_retry_ack_pulse_o <= 1'b1;
                        end
                    end

                    APB_ADDR_IMG_WIDTH: begin
                        cfg_img_width_o <= pwdata_i[15:0];
                    end

                    APB_ADDR_IMG_HEIGHT: begin
                        cfg_img_height_o <= pwdata_i[15:0];
                    end

                    APB_ADDR_LANE_CFG: begin
                        cfg_lane_num_minus1_o  <= pwdata_i[1:0];
                        cfg_lane_enable_mask_o <= pwdata_i[7:4];
                    end

                    APB_ADDR_DT_CFG: begin
                        cfg_dt_code_o <= pwdata_i[7:0];
                        cfg_vc_id_o   <= pwdata_i[15:8];
                    end

                    APB_ADDR_FRAME_BASE_ADDR: begin
                        cfg_frame_base_addr_o <= pwdata_i[AXI_ADDR_WIDTH-1:0];
                    end

                    APB_ADDR_LINE_STRIDE: begin
                        cfg_line_stride_o <= pwdata_i[AXI_ADDR_WIDTH-1:0];
                    end

                    APB_ADDR_ERR_POLICY: begin
                        cfg_enable_err_log_o       <= pwdata_i[0];
                        cfg_mark_ecc_error_o       <= pwdata_i[1];
                        cfg_drop_on_crc_error_o    <= pwdata_i[2];
                        cfg_enable_resync_o        <= pwdata_i[3];
                        cfg_enable_degrade_o       <= pwdata_i[4];
                        cfg_enable_retry_o         <= pwdata_i[5];
                        cfg_retry_line_mode_o      <= pwdata_i[6];
                    end

                    APB_ADDR_PREPROC_CFG: begin
                        cfg_preprocess_bypass_o       <= pwdata_i[0];
                        cfg_adaptive_enable_o         <= pwdata_i[1];
                        cfg_adaptive_awb_enable_o     <= pwdata_i[2];
                        cfg_adaptive_stretch_enable_o <= pwdata_i[3];
                    end

                    APB_ADDR_DBG_SEL: begin
                        cfg_dbg_sel_o <= pwdata_i;
                    end

                    APB_ADDR_AXI_CFG: begin
                        cfg_axi_max_burst_len_o <= pwdata_i[8:0];
                    end

                    default: begin
                    end
                endcase
            end
        end
    end

    always_comb begin
        reg_lane_cfg    = 32'd0;
        reg_dt_cfg      = 32'd0;
        reg_err_policy  = 32'd0;
        reg_preproc_cfg = 32'd0;
        prdata_o        = 32'd0;

        reg_lane_cfg[1:0]  = cfg_lane_num_minus1_o;
        reg_lane_cfg[7:4]  = cfg_lane_enable_mask_o;
        reg_dt_cfg[7:0]    = cfg_dt_code_o;
        reg_dt_cfg[15:8]   = cfg_vc_id_o;
        reg_err_policy[0]  = cfg_enable_err_log_o;
        reg_err_policy[1]  = cfg_mark_ecc_error_o;
        reg_err_policy[2]  = cfg_drop_on_crc_error_o;
        reg_err_policy[3]  = cfg_enable_resync_o;
        reg_err_policy[4]  = cfg_enable_degrade_o;
        reg_err_policy[5]  = cfg_enable_retry_o;
        reg_err_policy[6]  = cfg_retry_line_mode_o;
        reg_preproc_cfg[0] = cfg_preprocess_bypass_o;
        reg_preproc_cfg[1] = cfg_adaptive_enable_o;
        reg_preproc_cfg[2] = cfg_adaptive_awb_enable_o;
        reg_preproc_cfg[3] = cfg_adaptive_stretch_enable_o;

        case (paddr_i)
            APB_ADDR_CTRL: begin
                prdata_o[0] = cfg_enable_o;
            end

            APB_ADDR_STATUS: begin
                prdata_o[0]    = status_idle;
                prdata_o[1]    = status_receiving;
                prdata_o[2]    = frame_active_i;
                prdata_o[3]    = line_active_i;
                prdata_o[4]    = overflow_sticky_q;
                prdata_o[5]    = axi_busy_i;
                prdata_o[6]    = err_pending_i;
                prdata_o[10:8] = active_lane_num_i;
                prdata_o[16]   = hs_mode_i;
                prdata_o[17]   = lp_mode_i;
            end

            APB_ADDR_IMG_WIDTH: begin
                prdata_o[15:0] = cfg_img_width_o;
            end

            APB_ADDR_IMG_HEIGHT: begin
                prdata_o[15:0] = cfg_img_height_o;
            end

            APB_ADDR_LANE_CFG: begin
                prdata_o = reg_lane_cfg;
            end

            APB_ADDR_DT_CFG: begin
                prdata_o = reg_dt_cfg;
            end

            APB_ADDR_FRAME_BASE_ADDR: begin
                prdata_o = cfg_frame_base_addr_o;
            end

            APB_ADDR_LINE_STRIDE: begin
                prdata_o = cfg_line_stride_o;
            end

            APB_ADDR_ERR_CNT_ECC: begin
                prdata_o = err_cnt_ecc_i;
            end

            APB_ADDR_ERR_CNT_CRC: begin
                prdata_o = err_cnt_crc_i;
            end

            APB_ADDR_ERR_CNT_SYNC: begin
                prdata_o = err_cnt_sync_i;
            end

            APB_ADDR_FRAME_CNT: begin
                prdata_o = frame_cnt_i;
            end

            APB_ADDR_LINE_CNT: begin
                prdata_o = line_cnt_i;
            end

            APB_ADDR_ERR_POLICY: begin
                prdata_o = reg_err_policy;
            end

            APB_ADDR_PREPROC_CFG: begin
                prdata_o = reg_preproc_cfg;
            end

            APB_ADDR_DBG_SEL: begin
                prdata_o = cfg_dbg_sel_o;
            end

            APB_ADDR_AXI_CFG: begin
                prdata_o[8:0] = cfg_axi_max_burst_len_o;
            end

            APB_ADDR_LAST_ERR: begin
                prdata_o[2:0]   = last_err_type_i;
                prdata_o[5:4]   = last_err_priority_i;
                prdata_o[15:8]  = {2'd0, last_err_dt_i};
                prdata_o[17:16] = last_err_vc_i;
            end

            APB_ADDR_LAST_ERR_FRAME: begin
                prdata_o = last_err_frame_id_i;
            end

            APB_ADDR_LAST_ERR_LINE: begin
                prdata_o = last_err_line_id_i;
            end

            APB_ADDR_RETRY_STATUS: begin
                prdata_o[0]     = retry_pending_i;
                prdata_o[1]     = retry_mode_i;
                prdata_o[4:2]   = retry_err_type_i;
                prdata_o[15:8]  = {2'd0, retry_dt_i};
                prdata_o[17:16] = retry_vc_i;
            end

            APB_ADDR_RETRY_FRAME: begin
                prdata_o = retry_frame_id_i;
            end

            APB_ADDR_RETRY_LINE: begin
                prdata_o = retry_line_id_i;
            end

            APB_ADDR_ADAPT_GAIN: begin
                prdata_o[7:0]   = adaptive_stretch_gain_i;
                prdata_o[15:8]  = adaptive_awb_gain_r_i;
                prdata_o[23:16] = adaptive_awb_gain_g_i;
                prdata_o[31:24] = adaptive_awb_gain_b_i;
            end

            APB_ADDR_ADAPT_STAT0: begin
                prdata_o[15:0]  = stats_mean_r_i;
                prdata_o[31:16] = stats_mean_g_i;
            end

            APB_ADDR_ADAPT_STAT1: begin
                prdata_o[15:0]  = stats_mean_b_i;
                prdata_o[23:16] = stats_luma_min_i;
                prdata_o[31:24] = stats_luma_max_i;
            end

            default: begin
                prdata_o = 32'd0;
            end
        endcase
    end

endmodule
