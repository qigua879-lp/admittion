set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
    create_wave_config
}
log_wave -r /
add_wave /tb_fpga_wrapper_resync_metrics/clk_sys
add_wave /tb_fpga_wrapper_resync_metrics/err_sync_o
add_wave /tb_fpga_wrapper_resync_metrics/dut/u_mipi_csi2_capture_top/resync_req
add_wave /tb_fpga_wrapper_resync_metrics/dut/u_mipi_csi2_capture_top/resync_busy
add_wave /tb_fpga_wrapper_resync_metrics/dut/u_mipi_csi2_capture_top/resync_clear_pulse_sys
add_wave /tb_fpga_wrapper_resync_metrics/dut/u_mipi_csi2_capture_top/u_resync_ctrl_fsm/resync_done_o
set_property needs_save false [current_wave_config]
run 650 ns
