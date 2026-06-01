set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
    create_wave_config
}
log_wave -r /
add_wave /tb_fpga_wrapper_raw8_smoke/clk_sys
add_wave /tb_fpga_wrapper_raw8_smoke/frame_start_o
add_wave /tb_fpga_wrapper_raw8_smoke/line_start_o
add_wave /tb_fpga_wrapper_raw8_smoke/pixel_valid_o
add_wave /tb_fpga_wrapper_raw8_smoke/pixel_sof_o
add_wave /tb_fpga_wrapper_raw8_smoke/pixel_sol_o
add_wave /tb_fpga_wrapper_raw8_smoke/line_end_o
add_wave /tb_fpga_wrapper_raw8_smoke/frame_end_o
set_property needs_save false [current_wave_config]
run 650 ns
