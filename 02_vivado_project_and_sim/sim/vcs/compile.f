+incdir+rtl
+incdir+tb

rtl/buffer/async_fifo.sv

rtl/reg_if/cfg_reg_if_apb.sv
rtl/phy_adapter/phy_digital_adapter.sv
rtl/phy_adapter/mipi_dphy_ppi_adapter.sv

rtl/csi2_rx/csi2_header_ecc_checker.sv
rtl/csi2_rx/csi2_payload_crc_checker.sv
rtl/csi2_rx/csi2_short_packet_parser.sv
rtl/csi2_rx/csi2_long_packet_parser.sv
rtl/csi2_rx/frame_line_sync_fsm.sv
rtl/csi2_rx/lane_deskew_buffer.sv
rtl/csi2_rx/lane_reorder_merge.sv

rtl/pixel/raw8_unpack.sv
rtl/pixel/raw10_unpack.sv
rtl/pixel/rgb888_unpack.sv
rtl/pixel/yuv422_unpack.sv

rtl/reliability/err_classifier.sv
rtl/reliability/err_frame_line_logger.sv
rtl/reliability/retry_request_ctrl.sv
rtl/reliability/recapture_writeback_ctrl.sv
rtl/reliability/packet_error_policy.sv
rtl/reliability/resync_ctrl_fsm.sv
rtl/reliability/degrade_recover_fsm.sv

rtl/axi/axi_burst_gen.sv
rtl/axi/axi_write_master.sv
rtl/axi/axi_write_null_slave.sv
rtl/axi/addr_gen_frame_based.sv
rtl/axi/mem_map_ctrl.sv
rtl/axi/pixel_to_axi_writer.sv

rtl/preprocess/brightness_adjust.sv
rtl/preprocess/contrast_adjust.sv
rtl/preprocess/gray_balance.sv
rtl/preprocess/preprocess_bypass_mux.sv
rtl/preprocess/adaptive_v1/pixel_frame_stats_v1.sv
rtl/preprocess/adaptive_v1/adaptive_preprocess_ctrl_v1.sv

rtl/top/fpga_apb_boot_cfg.sv
rtl/top/mipi_csi2_capture_top.sv
rtl/top/mipi_csi2_capture_fpga_wrapper.sv
rtl/top/mipi_csi2_capture_dphy_wrapper.sv

tb/refs/csi2_reference_helpers.sv
tb/models/sensor_model.sv
tb/scoreboard/scoreboard.sv
