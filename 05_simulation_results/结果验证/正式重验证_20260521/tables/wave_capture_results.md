# 2026-05-21 正式波形截图汇总

## 截图原则

- 所有截图均先由 XSim batch 生成 WDB/WCFG，再由 Vivado 2017.3 GUI 打开静态波形库截图。
- 截图前聚焦 Wave pane，并裁切到单独的波形子窗口区域。
- 每个 Tcl 只运行到指定时间窗，截图必须保留对应关键跳变。
- 波形 GUI 不并行抓取，避免窗口焦点和布局互相干扰。

## 波形截图表

| 编号 | 主题 | top | 时间窗 | 必须保留的关键跳变 | 状态 | 截图 | Tcl | XSim batch 日志 | Vivado 打开日志 | 备注 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 01_raw8_main_path_xsim | RAW8 主链路 frame/line/pixel 闭合 | tb_fpga_wrapper_raw8_smoke | 0-650 ns | 保留 500 ns 后 frame_start/line_start/pixel_valid/line_end/frame_end 单帧闭合跳变 | PASS | 05_simulation_results/结果验证/正式重验证_20260521/waves/01_raw8_main_path_xsim.png | 02_vivado_project_and_sim/vivado/formal_wave_tcl/tb_fpga_wrapper_raw8_formal.tcl | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/01_raw8_main_path_xsim/xsim_batch.log | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/01_raw8_main_path_xsim/vivado_open.log |  |
| 02_crc_error_xsim | CRC 错误注入 | tb_fpga_wrapper_crc_error | 0-750 ns | 保留 err_crc_o 脉冲和 err_cnt_crc_o 从 0 到 1 的计数跳变 | PASS | 05_simulation_results/结果验证/正式重验证_20260521/waves/02_crc_error_xsim.png | 02_vivado_project_and_sim/vivado/formal_wave_tcl/tb_fpga_wrapper_crc_formal.tcl | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/02_crc_error_xsim/xsim_batch.log | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/02_crc_error_xsim/vivado_open.log |  |
| 03_ecc_error_xsim | Header ECC 错误注入 | tb_fpga_wrapper_ecc_error | 0-500 ns | 保留 err_ecc_o 脉冲和 err_cnt_ecc_o 计数跳变 | PASS | 05_simulation_results/结果验证/正式重验证_20260521/waves/03_ecc_error_xsim.png | 02_vivado_project_and_sim/vivado/formal_wave_tcl/tb_fpga_wrapper_ecc_formal.tcl | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/03_ecc_error_xsim/xsim_batch.log | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/03_ecc_error_xsim/vivado_open.log |  |
| 04_resync_recovery_xsim | resync 恢复链 | tb_fpga_wrapper_resync_metrics | 0-650 ns | 保留 err_sync_o、resync_req、resync_busy、clear、done 的连续恢复跳变 | PASS | 05_simulation_results/结果验证/正式重验证_20260521/waves/04_resync_recovery_xsim.png | 02_vivado_project_and_sim/vivado/formal_wave_tcl/tb_fpga_wrapper_resync_formal.tcl | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/04_resync_recovery_xsim/xsim_batch.log | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/04_resync_recovery_xsim/vivado_open.log |  |
| 05_lane_skew_overflow_xsim | lane skew overflow | tb_fpga_wrapper_lane_skew_overflow | 0-330 ns | 保留 sensor_lane_ready 回压和 err_overflow_o 触发跳变 | PASS | 05_simulation_results/结果验证/正式重验证_20260521/waves/05_lane_skew_overflow_xsim.png | 02_vivado_project_and_sim/vivado/formal_wave_tcl/tb_fpga_wrapper_lane_skew_formal.tcl | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/05_lane_skew_overflow_xsim/xsim_batch.log | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/05_lane_skew_overflow_xsim/vivado_open.log |  |
| 06_axi_backpressure_xsim | AXI AW/W 背压 | tb_fpga_wrapper_axi_backpressure | 0-900 ns | 保留 AW/W ready 阻塞、valid 保持、背压释放和 axi_busy 变化 | PASS | 05_simulation_results/结果验证/正式重验证_20260521/waves/06_axi_backpressure_xsim.png | 02_vivado_project_and_sim/vivado/formal_wave_tcl/tb_fpga_wrapper_axi_backpressure_formal.tcl | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/06_axi_backpressure_xsim/xsim_batch.log | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/06_axi_backpressure_xsim/vivado_open.log |  |
| 07_resync_clean_frame_xsim | resync 后 clean frame 恢复输出 | tb_fpga_wrapper_resync_clean_frame | 0-1550 ns | 保留 900 ns 后 clean frame 重新输出 frame/line/pixel 的闭合跳变 | PASS | 05_simulation_results/结果验证/正式重验证_20260521/waves/07_resync_clean_frame_xsim.png | 02_vivado_project_and_sim/vivado/formal_wave_tcl/tb_fpga_wrapper_resync_clean_frame_formal.tcl | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/07_resync_clean_frame_xsim/xsim_batch.log | 05_simulation_results/结果验证/正式重验证_20260521/xsim_wave_logs/07_resync_clean_frame_xsim/vivado_open.log |  |
