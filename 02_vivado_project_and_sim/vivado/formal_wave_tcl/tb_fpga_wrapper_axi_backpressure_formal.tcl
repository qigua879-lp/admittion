set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
    create_wave_config
}
log_wave -r /
add_wave /tb_fpga_wrapper_axi_backpressure/clk_axi
add_wave /tb_fpga_wrapper_axi_backpressure/pixel_valid_o
add_wave /tb_fpga_wrapper_axi_backpressure/dut/u_mipi_csi2_capture_top/axi_busy
add_wave /tb_fpga_wrapper_axi_backpressure/dut/u_mipi_csi2_capture_top/m_axi_awvalid_o
add_wave /tb_fpga_wrapper_axi_backpressure/dut/u_mipi_csi2_capture_top/m_axi_awready_i
add_wave /tb_fpga_wrapper_axi_backpressure/dut/u_mipi_csi2_capture_top/m_axi_wvalid_o
add_wave /tb_fpga_wrapper_axi_backpressure/dut/u_mipi_csi2_capture_top/m_axi_wready_i
set_property needs_save false [current_wave_config]
run 900 ns
