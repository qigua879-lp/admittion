# Top-level timing constraint file for the FPGA build entry.
#
# Vivado 2017.3 compatibility rules for this file:
# - Keep command syntax compatible with older Vivado releases.
# - Keep board/package LOCs in board_lab_placeholder_v1.xdc so that the
#   lab pinout can be replaced without touching timing constraints.

###############################################################################
# Timing placeholders
###############################################################################

# Default target part used by the project scripts:
# - FPGA part: xczu9eg-ffvb1156-2-e
# - Placeholder byte clock for a 1.5 Gb/s per-lane style target:
#   187.5 MHz byte clock => 5.333 ns period
# - Keep clk_sys/clk_axi/clk_ddr at 200 MHz placeholders until the final
#   board clock tree and memory interface are frozen.

set CLK_SYS_PERIOD_NS   5.000
set CLK_BYTE_PERIOD_NS  5.333
set CLK_AXI_PERIOD_NS   5.000
set CLK_DDR_PERIOD_NS   5.000

set CLK_SYS_UNCERTAINTY_NS  0.100
set CLK_BYTE_UNCERTAINTY_NS 0.100
set CLK_AXI_UNCERTAINTY_NS  0.100
set CLK_DDR_UNCERTAINTY_NS  0.100

set BOARD_INPUT_DELAY_MAX_NS  1.500
set BOARD_INPUT_DELAY_MIN_NS  0.300
set BOARD_RESET_DELAY_MAX_NS  2.000
set BOARD_RESET_DELAY_MIN_NS  0.000
set BOARD_OUTPUT_DELAY_MAX_NS 2.000
set BOARD_OUTPUT_DELAY_MIN_NS 0.000

###############################################################################
# Clock constraints
###############################################################################

create_clock -name clk_sys  -period $CLK_SYS_PERIOD_NS  [get_ports clk_sys]
create_clock -name clk_byte -period $CLK_BYTE_PERIOD_NS [get_ports clk_byte]
create_clock -name clk_axi  -period $CLK_AXI_PERIOD_NS  [get_ports clk_axi]
create_clock -name clk_ddr  -period $CLK_DDR_PERIOD_NS  [get_ports clk_ddr]

set_clock_uncertainty $CLK_SYS_UNCERTAINTY_NS  [get_clocks clk_sys]
set_clock_uncertainty $CLK_BYTE_UNCERTAINTY_NS [get_clocks clk_byte]
set_clock_uncertainty $CLK_AXI_UNCERTAINTY_NS  [get_clocks clk_axi]
set_clock_uncertainty $CLK_DDR_UNCERTAINTY_NS  [get_clocks clk_ddr]

###############################################################################
# IO timing constraints
###############################################################################

set BOARD_BYTE_INPUT_PORTS [get_ports -quiet {
    lane_data_0[*]
    lane_data_1[*]
    lane_data_2[*]
    lane_data_3[*]
    lane_valid_0
    lane_valid_1
    lane_valid_2
    lane_valid_3
    hs_mode
    lp_mode
}]

set BOARD_SYS_OUTPUT_PORTS [get_ports -quiet {
    frame_start_o
    frame_end_o
    line_start_o
    line_end_o
    err_ecc_o
    err_crc_o
    err_sync_o
    pixel_data_o[*]
    pixel_valid_o
    pixel_sof_o
    pixel_sol_o
    retry_req_o
    retry_pending_o
    retry_mode_o
    retry_frame_id_o[*]
    retry_line_id_o[*]
    cfg_init_done_o
}]

set BOARD_RESET_PORT [get_ports -quiet rst_n]

set_input_delay -clock [get_clocks clk_byte] -max $BOARD_INPUT_DELAY_MAX_NS $BOARD_BYTE_INPUT_PORTS
set_input_delay -clock [get_clocks clk_byte] -min $BOARD_INPUT_DELAY_MIN_NS $BOARD_BYTE_INPUT_PORTS

set_input_delay -clock [get_clocks clk_sys]  -max $BOARD_RESET_DELAY_MAX_NS $BOARD_RESET_PORT
set_input_delay -clock [get_clocks clk_sys]  -min $BOARD_RESET_DELAY_MIN_NS $BOARD_RESET_PORT
set_input_delay -clock [get_clocks clk_byte] -max $BOARD_RESET_DELAY_MAX_NS -add_delay $BOARD_RESET_PORT
set_input_delay -clock [get_clocks clk_byte] -min $BOARD_RESET_DELAY_MIN_NS -add_delay $BOARD_RESET_PORT
set_input_delay -clock [get_clocks clk_axi]  -max $BOARD_RESET_DELAY_MAX_NS -add_delay $BOARD_RESET_PORT
set_input_delay -clock [get_clocks clk_axi]  -min $BOARD_RESET_DELAY_MIN_NS -add_delay $BOARD_RESET_PORT
set_input_delay -clock [get_clocks clk_ddr]  -max $BOARD_RESET_DELAY_MAX_NS -add_delay $BOARD_RESET_PORT
set_input_delay -clock [get_clocks clk_ddr]  -min $BOARD_RESET_DELAY_MIN_NS -add_delay $BOARD_RESET_PORT

set_output_delay -clock [get_clocks clk_sys] -max $BOARD_OUTPUT_DELAY_MAX_NS $BOARD_SYS_OUTPUT_PORTS
set_output_delay -clock [get_clocks clk_sys] -min $BOARD_OUTPUT_DELAY_MIN_NS $BOARD_SYS_OUTPUT_PORTS

set_property DRIVE 8 $BOARD_SYS_OUTPUT_PORTS
set_property SLEW SLOW $BOARD_SYS_OUTPUT_PORTS

###############################################################################
# CDC and reset notes
###############################################################################

# rst_n is an active-low synchronous reset in the RTL guidelines.
# Do not add asynchronous reset false paths here unless the architecture changes.
#
# clk_byte, clk_sys, clk_axi, and clk_ddr are separate domains in the spec.
# The implemented top crosses clk_byte <-> clk_sys only through CDC structures:
# - byte stream: async_fifo u_byte_to_sys_fifo
# - byte overflow event: two-flop toggle synchronizer
# - sys resync event/config sampling: synchronized into the byte domain
# Therefore these clocks are intentionally separated for timing analysis.
set_clock_groups -asynchronous \
    -group [get_clocks clk_byte] \
    -group [get_clocks clk_sys] \
    -group [get_clocks clk_axi] \
    -group [get_clocks clk_ddr]
