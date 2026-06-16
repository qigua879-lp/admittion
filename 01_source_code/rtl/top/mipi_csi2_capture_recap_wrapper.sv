`timescale 1ns/1ps

// Verification wrapper for the line-level recapture closed loop.
//
// Same structure as mipi_csi2_capture_fpga_wrapper (self-booting APB config +
// internal AXI sink memory), but:
//   * exposes src_recap_line_valid_i so a controllable source (the testbench
//     camera) can drive the recapture sideband into the core, and
//   * boots ERR_POLICY in line-level recapture mode (CRC-drop + retry line mode)
//     with a small demo frame geometry.
//
// This wrapper exists only for the recapture closed-loop testbench; the
// production wrapper (mipi_csi2_capture_fpga_wrapper) ties the sideband to 0.
module mipi_csi2_capture_recap_wrapper #(
    parameter int LANE_NUM             = 2,
    parameter int DESKEW_DEPTH         = 16,
    parameter int BYTE_FIFO_ADDR_WIDTH = 4,
    parameter int AXI_FIFO_ADDR_WIDTH  = 6,
    parameter int AXI_ADDR_WIDTH       = 32,
    parameter int AXI_DATA_WIDTH       = 128,
    parameter int AXI_MAX_BURST_LEN    = 16,
    parameter int AXI_SINK_MEM_ADDR_WIDTH = 12,
    // Demo frame geometry (small): RAW8, 4 px/line.
    parameter logic [15:0] IMG_WIDTH   = 16'd4,
    parameter logic [15:0] IMG_HEIGHT  = 16'd4,
    parameter logic [AXI_ADDR_WIDTH-1:0] LINE_STRIDE = 32'd64,
    // ERR_POLICY: 0x7D = err_log(0) + crc_drop(2) + resync(3) + degrade(4)
    //                 + retry_enable(5) + retry_line_mode(6)
    parameter logic [31:0] ERR_POLICY_VALUE = 32'h0000_007D
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

    // Controllable-source recapture sideband (driven by the TB camera).
    input  logic                         src_recap_line_valid_i,

    output logic                         frame_start_o,
    output logic                         frame_end_o,
    output logic                         line_start_o,
    output logic                         line_end_o,
    output logic                         err_ecc_o,
    output logic                         err_crc_o,
    output logic                         err_sync_o,
    output logic [23:0]                  pixel_data_o,
    output logic                         pixel_valid_o,
    output logic                         pixel_sof_o,
    output logic                         pixel_sol_o,
    output logic                         retry_req_o,
    output logic                         retry_pending_o,
    output logic                         retry_mode_o,
    output logic [31:0]                  retry_frame_id_o,
    output logic [31:0]                  retry_line_id_o,
    output logic                         cfg_init_done_o
);

    logic                         psel;
    logic                         penable;
    logic                         pwrite;
    logic [15:0]                  paddr;
    logic [31:0]                  pwdata;
    logic [31:0]                  prdata;
    logic                         pready;
    logic                         pslverr;

    logic [AXI_ADDR_WIDTH-1:0]    m_axi_awaddr;
    logic [7:0]                   m_axi_awlen;
    logic [2:0]                   m_axi_awsize;
    logic [1:0]                   m_axi_awburst;
    logic                         m_axi_awvalid;
    logic                         m_axi_awready;
    logic [AXI_DATA_WIDTH-1:0]    m_axi_wdata;
    logic [(AXI_DATA_WIDTH/8)-1:0] m_axi_wstrb;
    logic                         m_axi_wlast;
    logic                         m_axi_wvalid;
    logic                         m_axi_wready;
    logic [1:0]                   m_axi_bresp;
    logic                         m_axi_bvalid;
    logic                         m_axi_bready;

    logic                         no_bp_drop_event_unused;
    logic                         no_bp_drop_active_unused;
    logic [31:0] frame_cnt_unused;
    logic [31:0] line_cnt_unused;
    logic [31:0] err_cnt_ecc_unused;
    logic [31:0] err_cnt_crc_unused;

    fpga_apb_boot_cfg #(
        .ADDR_WIDTH(16),
        .DATA_WIDTH(32),
        .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
        .AXI_MAX_BURST_LEN(AXI_MAX_BURST_LEN),
        .IMG_WIDTH(IMG_WIDTH),
        .IMG_HEIGHT(IMG_HEIGHT),
        .LANE_NUM_MINUS1(LANE_NUM[1:0] - 2'd1),
        .LANE_ENABLE_MASK(4'b0011),
        .DT_CODE(8'h2a),
        .LINE_STRIDE(LINE_STRIDE),
        .ERR_POLICY_VALUE(ERR_POLICY_VALUE)
    ) u_fpga_apb_boot_cfg (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .psel_o(psel),
        .penable_o(penable),
        .pwrite_o(pwrite),
        .paddr_o(paddr),
        .pwdata_o(pwdata),
        .prdata_i(prdata),
        .pready_i(pready),
        .pslverr_i(pslverr),
        .init_done_o(cfg_init_done_o)
    );

    mipi_csi2_capture_top #(
        .LANE_NUM(LANE_NUM),
        .DESKEW_DEPTH(DESKEW_DEPTH),
        .BYTE_FIFO_ADDR_WIDTH(BYTE_FIFO_ADDR_WIDTH),
        .AXI_FIFO_ADDR_WIDTH(AXI_FIFO_ADDR_WIDTH),
        .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
        .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
        .AXI_MAX_BURST_LEN(AXI_MAX_BURST_LEN)
    ) u_mipi_csi2_capture_top (
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
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .paddr(paddr),
        .pwdata(pwdata),
        .prdata(prdata),
        .pready(pready),
        .pslverr(pslverr),
        .m_axi_awaddr_o(m_axi_awaddr),
        .m_axi_awlen_o(m_axi_awlen),
        .m_axi_awsize_o(m_axi_awsize),
        .m_axi_awburst_o(m_axi_awburst),
        .m_axi_awvalid_o(m_axi_awvalid),
        .m_axi_awready_i(m_axi_awready),
        .m_axi_wdata_o(m_axi_wdata),
        .m_axi_wstrb_o(m_axi_wstrb),
        .m_axi_wlast_o(m_axi_wlast),
        .m_axi_wvalid_o(m_axi_wvalid),
        .m_axi_wready_i(m_axi_wready),
        .m_axi_bresp_i(m_axi_bresp),
        .m_axi_bvalid_i(m_axi_bvalid),
        .m_axi_bready_o(m_axi_bready),
        .frame_start_o(frame_start_o),
        .frame_end_o(frame_end_o),
        .line_start_o(line_start_o),
        .line_end_o(line_end_o),
        .err_ecc_o(err_ecc_o),
        .err_crc_o(err_crc_o),
        .err_sync_o(err_sync_o),
        .frame_cnt_o(frame_cnt_unused),
        .line_cnt_o(line_cnt_unused),
        .err_cnt_ecc_o(err_cnt_ecc_unused),
        .err_cnt_crc_o(err_cnt_crc_unused),
        .retry_req_o(retry_req_o),
        .retry_pending_o(retry_pending_o),
        .retry_mode_o(retry_mode_o),
        .retry_frame_id_o(retry_frame_id_o),
        .retry_line_id_o(retry_line_id_o),
        .src_recap_line_valid_i(src_recap_line_valid_i),
        .no_backpressure_drop_event_o(no_bp_drop_event_unused),
        .no_backpressure_drop_active_o(no_bp_drop_active_unused),
        .pixel_data_o(pixel_data_o),
        .pixel_valid_o(pixel_valid_o),
        .pixel_sof_o(pixel_sof_o),
        .pixel_sol_o(pixel_sol_o)
    );

    axi_write_null_slave #(
        .ADDR_WIDTH(AXI_ADDR_WIDTH),
        .DATA_WIDTH(AXI_DATA_WIDTH),
        .MEM_ADDR_WIDTH(AXI_SINK_MEM_ADDR_WIDTH)
    ) u_axi_write_null_slave (
        .clk_axi(clk_axi),
        .rst_n(rst_n),
        .s_axi_awaddr_i(m_axi_awaddr),
        .s_axi_awlen_i(m_axi_awlen),
        .s_axi_awsize_i(m_axi_awsize),
        .s_axi_awburst_i(m_axi_awburst),
        .s_axi_awvalid_i(m_axi_awvalid),
        .s_axi_awready_o(m_axi_awready),
        .s_axi_wdata_i(m_axi_wdata),
        .s_axi_wstrb_i(m_axi_wstrb),
        .s_axi_wlast_i(m_axi_wlast),
        .s_axi_wvalid_i(m_axi_wvalid),
        .s_axi_wready_o(m_axi_wready),
        .s_axi_bresp_o(m_axi_bresp),
        .s_axi_bvalid_o(m_axi_bvalid),
        .s_axi_bready_i(m_axi_bready)
    );

endmodule
