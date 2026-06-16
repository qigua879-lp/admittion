# Minimal synthesis/timing constraints for mipi_csi2_capture_dphy_wrapper.
#
# This file intentionally avoids package LOC/IOSTANDARD constraints. It is for
# D-PHY wrapper synthesis entry checks before the real ZCU102/FMC pinout and
# AMD D-PHY RX IP block design are finalized.

###############################################################################
# Timing placeholders
###############################################################################

set CLK_SYS_PERIOD_NS      5.000
set RXBYTECLKHS_PERIOD_NS  5.333
set CLK_AXI_PERIOD_NS      5.000
set CLK_DDR_PERIOD_NS      5.000

set CLK_SYS_UNCERTAINTY_NS      0.100
set RXBYTECLKHS_UNCERTAINTY_NS  0.100
set CLK_AXI_UNCERTAINTY_NS      0.100
set CLK_DDR_UNCERTAINTY_NS      0.100

set DPHY_INPUT_DELAY_MAX_NS  1.000
set DPHY_INPUT_DELAY_MIN_NS  0.000
set SYS_OUTPUT_DELAY_MAX_NS  2.000
set SYS_OUTPUT_DELAY_MIN_NS  0.000
set RESET_DELAY_MAX_NS       2.000
set RESET_DELAY_MIN_NS       0.000

# When this wrapper is used as an artificial top before the AMD D-PHY IP and
# board-level pinout are finalized, status/debug outputs and rst_n are not real
# external timing interfaces. Set DPHY_CORE_TIMING_ONLY=1 for routed core timing
# closure without judging those placeholder wrapper boundaries.
set DPHY_CORE_TIMING_ONLY 0
if {[info exists ::env(DPHY_CORE_TIMING_ONLY)] && ($::env(DPHY_CORE_TIMING_ONLY) ne "")} {
    set DPHY_CORE_TIMING_ONLY $::env(DPHY_CORE_TIMING_ONLY)
}

###############################################################################
# Clock constraints
###############################################################################

create_clock -name clk_sys     -period $CLK_SYS_PERIOD_NS     [get_ports clk_sys]
create_clock -name rxbyteclkhs -period $RXBYTECLKHS_PERIOD_NS [get_ports rxbyteclkhs]
create_clock -name clk_axi     -period $CLK_AXI_PERIOD_NS     [get_ports clk_axi]
create_clock -name clk_ddr     -period $CLK_DDR_PERIOD_NS     [get_ports clk_ddr]

set_clock_uncertainty $CLK_SYS_UNCERTAINTY_NS     [get_clocks clk_sys]
set_clock_uncertainty $RXBYTECLKHS_UNCERTAINTY_NS [get_clocks rxbyteclkhs]
set_clock_uncertainty $CLK_AXI_UNCERTAINTY_NS     [get_clocks clk_axi]
set_clock_uncertainty $CLK_DDR_UNCERTAINTY_NS     [get_clocks clk_ddr]

###############################################################################
# IO timing placeholders
###############################################################################

set DPHY_PPI_INPUT_PORTS [get_ports -quiet {
    cl_stopstate
    dl0_rxdatahs[*]
    dl1_rxdatahs[*]
    dl2_rxdatahs[*]
    dl3_rxdatahs[*]
    dl0_rxvalidhs
    dl1_rxvalidhs
    dl2_rxvalidhs
    dl3_rxvalidhs
    dl0_rxactivehs
    dl1_rxactivehs
    dl2_rxactivehs
    dl3_rxactivehs
    dl0_rxsynchs
    dl1_rxsynchs
    dl2_rxsynchs
    dl3_rxsynchs
    dl0_stopstate
    dl1_stopstate
    dl2_stopstate
    dl3_stopstate
    dl0_errsoths
    dl1_errsoths
    dl2_errsoths
    dl3_errsoths
    dl0_errsotsynchs
    dl1_errsotsynchs
    dl2_errsotsynchs
    dl3_errsotsynchs
}]

set DPHY_SYS_OUTPUT_PORTS [get_ports -quiet {
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
    dphy_hs_mode_o
    dphy_lp_mode_o
    dphy_lane_active_hs_o[*]
    dphy_lane_valid_hs_o[*]
    dphy_lane_sync_hs_o[*]
    dphy_lane_stopstate_o[*]
    dphy_err_sot_hs_o
    dphy_err_sot_sync_hs_o
    ila_probe_o[*]
}]

set RESET_PORT [get_ports -quiet rst_n]

set_input_delay -clock [get_clocks rxbyteclkhs] -max $DPHY_INPUT_DELAY_MAX_NS $DPHY_PPI_INPUT_PORTS
set_input_delay -clock [get_clocks rxbyteclkhs] -min $DPHY_INPUT_DELAY_MIN_NS $DPHY_PPI_INPUT_PORTS

set_input_delay -clock [get_clocks clk_sys]     -max $RESET_DELAY_MAX_NS $RESET_PORT
set_input_delay -clock [get_clocks clk_sys]     -min $RESET_DELAY_MIN_NS $RESET_PORT
set_input_delay -clock [get_clocks rxbyteclkhs] -max $RESET_DELAY_MAX_NS -add_delay $RESET_PORT
set_input_delay -clock [get_clocks rxbyteclkhs] -min $RESET_DELAY_MIN_NS -add_delay $RESET_PORT
set_input_delay -clock [get_clocks clk_axi]     -max $RESET_DELAY_MAX_NS -add_delay $RESET_PORT
set_input_delay -clock [get_clocks clk_axi]     -min $RESET_DELAY_MIN_NS -add_delay $RESET_PORT
set_input_delay -clock [get_clocks clk_ddr]     -max $RESET_DELAY_MAX_NS -add_delay $RESET_PORT
set_input_delay -clock [get_clocks clk_ddr]     -min $RESET_DELAY_MIN_NS -add_delay $RESET_PORT

set_output_delay -clock [get_clocks clk_sys] -max $SYS_OUTPUT_DELAY_MAX_NS $DPHY_SYS_OUTPUT_PORTS
set_output_delay -clock [get_clocks clk_sys] -min $SYS_OUTPUT_DELAY_MIN_NS $DPHY_SYS_OUTPUT_PORTS

if {$DPHY_CORE_TIMING_ONLY} {
    puts "INFO: D-PHY core timing-only mode: ignoring artificial reset and status/debug output boundaries."
    set_false_path -from $RESET_PORT
    set_false_path -to $DPHY_SYS_OUTPUT_PORTS
}

###############################################################################
# CDC notes
###############################################################################

set_clock_groups -asynchronous \
    -group [get_clocks rxbyteclkhs] \
    -group [get_clocks clk_sys] \
    -group [get_clocks clk_axi] \
    -group [get_clocks clk_ddr]
