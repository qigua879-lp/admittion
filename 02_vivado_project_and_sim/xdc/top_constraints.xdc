# Top-level constraint skeleton for the FPGA build entry.
#
# Vivado 2017.3 compatibility rules for this file:
# - Use plain XDC commands only.
# - Do not use if/foreach/proc or other general Tcl flow control.
# - Keep this file safe for direct parsing by older Vivado releases.
#
# This file still does not assume a concrete board pinout or IO bank voltage.
# It provides only placeholder clocks for the current FPGA wrapper top.

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
# Pin placeholders
###############################################################################

# Fill these only after a real package pinout and schematic are selected.
#
# set_property PACKAGE_PIN <PIN> [get_ports clk_sys]
# set_property IOSTANDARD  <IOSTANDARD> [get_ports clk_sys]
#
# set_property PACKAGE_PIN <PIN> [get_ports rst_n]
# set_property IOSTANDARD  <IOSTANDARD> [get_ports rst_n]
#
# set_property PACKAGE_PIN <PIN> [get_ports {lane_data_0[0]}]
# set_property IOSTANDARD  <IOSTANDARD> [get_ports {lane_data_0[0]}]

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
# Therefore these two clocks are intentionally asynchronous for timing analysis.
set_clock_groups -asynchronous \
    -group [get_clocks clk_byte] \
    -group [get_clocks clk_sys]
#
# clk_axi and clk_ddr relationships remain board/integration dependent here.
