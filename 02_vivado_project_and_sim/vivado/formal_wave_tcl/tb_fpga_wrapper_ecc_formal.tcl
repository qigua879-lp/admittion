set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
    create_wave_config
}
log_wave -r /
add_wave /tb_fpga_wrapper_ecc_error/clk_sys
add_wave /tb_fpga_wrapper_ecc_error/frame_start_o
add_wave /tb_fpga_wrapper_ecc_error/line_start_o
add_wave /tb_fpga_wrapper_ecc_error/err_ecc_o
add_wave /tb_fpga_wrapper_ecc_error/dut/u_mipi_csi2_capture_top/err_cnt_ecc_o
add_wave /tb_fpga_wrapper_ecc_error/pixel_valid_o
add_wave /tb_fpga_wrapper_ecc_error/line_end_o
set_property needs_save false [current_wave_config]
run 500 ns
