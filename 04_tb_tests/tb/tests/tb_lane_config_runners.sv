`timescale 1ns/1ps

// Lane-count runners: bind LANE_NUM in RTL so 1/2/4-lane configs can each be
// elaborated by module name (local Vivado arg parser mishandles '=' overrides).
//   xelab tb_lane_cfg_1 / tb_lane_cfg_2 / tb_lane_cfg_4
module tb_lane_cfg_1; tb_fpga_wrapper_raw8_lane_config_smoke #(.LANE_NUM(1)) u_dut (); endmodule
module tb_lane_cfg_2; tb_fpga_wrapper_raw8_lane_config_smoke #(.LANE_NUM(2)) u_dut (); endmodule
module tb_lane_cfg_4; tb_fpga_wrapper_raw8_lane_config_smoke #(.LANE_NUM(4)) u_dut (); endmodule
