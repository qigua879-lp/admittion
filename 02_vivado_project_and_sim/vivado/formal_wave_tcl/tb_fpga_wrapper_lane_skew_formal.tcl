set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
    create_wave_config
}
log_wave -r /
add_wave /tb_fpga_wrapper_lane_skew_overflow/clk_sys
add_wave /tb_fpga_wrapper_lane_skew_overflow/sensor_lane_valid
add_wave /tb_fpga_wrapper_lane_skew_overflow/sensor_lane_ready
add_wave /tb_fpga_wrapper_lane_skew_overflow/dut/u_mipi_csi2_capture_top/u_lane_deskew_buffer/err_overflow_o
set_property needs_save false [current_wave_config]
run 330 ns
