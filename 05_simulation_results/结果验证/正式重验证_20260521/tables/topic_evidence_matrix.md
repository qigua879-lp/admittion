# 2026-05-21 主题证据矩阵

| 主题 | testbench 数量 | 完成数量 | 失败数量 | 覆盖 testbench |
| --- | --- | --- | --- | --- |
| buffer/AXI 写通路 | 6 | 6 | 0 | tb_addr_gen_frame_based<br>tb_axi_write_master<br>tb_fpga_wrapper_axi_backpressure<br>tb_fpga_wrapper_axi_backpressure_metrics<br>tb_fpga_wrapper_axi_mem_closure<br>tb_fpga_wrapper_buffer_depth_sweep |
| CSI-2 包解析与校验 | 7 | 7 | 0 | tb_fpga_wrapper_crc_error<br>tb_fpga_wrapper_ecc_error<br>tb_header_ecc<br>tb_long_packet_parser<br>tb_packet_error_policy<br>tb_payload_crc<br>tb_short_packet_parser |
| D-PHY 数字适配 | 1 | 1 | 0 | tb_phy_digital_adapter |
| lane 对齐与 skew | 6 | 6 | 0 | tb_fpga_wrapper_lane_skew_overflow<br>tb_fpga_wrapper_lane_skew_scan<br>tb_fpga_wrapper_lane_skew_tolerance<br>tb_fpga_wrapper_raw8_lane_config_smoke<br>tb_lane_deskew_buffer<br>tb_lane_reorder_merge |
| 错误分类与策略 | 2 | 2 | 0 | tb_err_classifier<br>tb_err_logger |
| 寄存器接口 | 1 | 1 | 0 | tb_cfg_reg_if_apb |
| 同步/恢复 | 9 | 9 | 0 | tb_async_fifo<br>tb_fpga_wrapper_resync_backpressure_multiframe<br>tb_fpga_wrapper_resync_clean_frame<br>tb_fpga_wrapper_resync_metrics<br>tb_fpga_wrapper_resync_recovery<br>tb_fpga_wrapper_resync_repeated_error<br>tb_fpga_wrapper_sync_illegal_order<br>tb_frame_line_sync<br>tb_resync_ctrl |
| 像素格式与主链路 | 17 | 17 | 0 | tb_fpga_wrapper_raw10_metrics<br>tb_fpga_wrapper_raw10_smoke<br>tb_fpga_wrapper_raw8_backpressure_stress<br>tb_fpga_wrapper_raw8_metrics<br>tb_fpga_wrapper_raw8_multiframe_stability<br>tb_fpga_wrapper_raw8_smoke<br>tb_fpga_wrapper_raw8_soak_metrics<br>tb_fpga_wrapper_rgb888_metrics<br>tb_fpga_wrapper_rgb888_smoke<br>tb_fpga_wrapper_yuv422_metrics<br>tb_fpga_wrapper_yuv422_smoke<br>tb_pixel_frame_stats_v1<br>tb_pixel_to_axi_writer<br>tb_raw10_unpack<br>tb_raw8_unpack<br>tb_rgb888_unpack<br>tb_yuv422_unpack |
| 预处理 | 4 | 4 | 0 | tb_adaptive_preprocess_ctrl_v1<br>tb_brightness_adjust<br>tb_contrast_adjust<br>tb_gray_balance |
| 综合验证 | 2 | 2 | 0 | tb_fpga_wrapper_boot<br>tb_mipi_csi2_capture_top |
