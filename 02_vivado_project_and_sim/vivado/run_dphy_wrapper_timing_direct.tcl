# Direct non-project D-PHY wrapper timing runner.
#
# This script avoids Vivado project/run infrastructure. It reads RTL and the
# dphy_minimal XDC directly, then runs synth/opt/place/route/report in one batch
# session. Use it when project creation or launch_runs is unreliable in the
# Windows/OneDrive environment.
#
# Usage:
#   vivado -mode batch -source 02_vivado_project_and_sim/vivado/run_dphy_wrapper_timing_direct.tcl \
#          -tclargs [fpga_part] [project_name] [top_module] [jobs] [core_timing_only]

set script_dir [file normalize [file dirname [info script]]]
set repo_root  [file normalize [file join $script_dir ../..]]

set fpga_part    "xczu9eg-ffvb1156-2-e"
set project_name "mipi_csi2_capture_dphy_wrapper_timing_direct"
set top_module   "mipi_csi2_capture_dphy_wrapper"
set jobs         4
set core_timing_only 0

if {[llength $argv] >= 1} {
    set fpga_part [lindex $argv 0]
}
if {[llength $argv] >= 2} {
    set project_name [lindex $argv 1]
}
if {[llength $argv] >= 3} {
    set top_module [lindex $argv 2]
}
if {[llength $argv] >= 4} {
    set jobs [lindex $argv 3]
}
if {[llength $argv] >= 5} {
    set core_timing_only [lindex $argv 4]
}

proc collect_files_recursive {root patterns} {
    set result {}
    if {![file isdirectory $root]} {
        return $result
    }

    foreach item [lsort [glob -nocomplain -directory $root *]] {
        if {[file isdirectory $item]} {
            set result [concat $result [collect_files_recursive $item $patterns]]
        } else {
            foreach pattern $patterns {
                if {[string match $pattern [file tail $item]]} {
                    lappend result [file normalize $item]
                    break
                }
            }
        }
    }
    return $result
}

proc file_list_has_module {files module_name} {
    set module_re [format {(^|[;[:space:]])module[[:space:]]+%s([[:space:]#;(]|$)} $module_name]

    foreach src_file $files {
        if {![file exists $src_file]} {
            continue
        }
        set fp [open $src_file r]
        set text [read $fp]
        close $fp
        if {[regexp $module_re $text]} {
            return 1
        }
    }
    return 0
}

proc warn_if_failed {label script_body} {
    if {[catch {uplevel 1 $script_body} err_msg]} {
        puts "WARNING: $label skipped: $err_msg"
    }
}

proc apply_core_timing_boundary_cuts {} {
    set reset_port [get_ports -quiet rst_n]
    set wrapper_output_ports [get_ports -quiet {
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
        no_backpressure_drop_event_o
        no_backpressure_drop_active_o
    }]

    puts "INFO: Applying direct core timing-only boundary cuts."
    if {[llength $reset_port] > 0} {
        set_false_path -from $reset_port
    }
    if {[llength $wrapper_output_ports] > 0} {
        set_false_path -to $wrapper_output_ports
    }
}

set report_base [file join $script_dir reports]
if {[info exists ::env(VIVADO_REPORT_ROOT)] && ($::env(VIVADO_REPORT_ROOT) ne "")} {
    set report_base [file normalize $::env(VIVADO_REPORT_ROOT)]
}

set rtl_root    [file join $repo_root 01_source_code rtl]
set xdc_file    [file join $repo_root 02_vivado_project_and_sim xdc dphy_wrapper_constraints.xdc]
set report_root [file join $report_base $project_name]

file mkdir $report_root

puts "INFO: Repository root : $repo_root"
puts "INFO: Report root     : $report_root"
puts "INFO: FPGA part       : $fpga_part"
puts "INFO: Top module      : $top_module"
puts "INFO: Jobs            : $jobs"
puts "INFO: Core timing     : $core_timing_only"
puts "INFO: RTL root        : $rtl_root"
puts "INFO: XDC file        : $xdc_file"

if {$fpga_part eq "FPGA_PART_PLACEHOLDER"} {
    return -code error "invalid FPGA part"
}
if {![file exists $xdc_file]} {
    return -code error "missing D-PHY wrapper constraints"
}

set rtl_files [collect_files_recursive $rtl_root [list "*.sv" "*.v"]]
if {[llength $rtl_files] == 0} {
    return -code error "no RTL files found under $rtl_root"
}
if {![file_list_has_module $rtl_files $top_module]} {
    return -code error "missing top integration RTL"
}

warn_if_failed "set Vivado thread count" {
    set_param general.maxThreads $jobs
}

set ::env(DPHY_CORE_TIMING_ONLY) $core_timing_only

puts "INFO: Reading [llength $rtl_files] RTL source files."
read_verilog -sv $rtl_files
read_xdc $xdc_file

puts "INFO: Starting direct synth_design."
synth_design -top $top_module -part $fpga_part -flatten_hierarchy rebuilt
if {$core_timing_only} {
    apply_core_timing_boundary_cuts
}
report_utilization -file [file join $report_root synth_utilization.rpt]
report_timing_summary -file [file join $report_root synth_timing_summary.rpt]
report_cdc -file [file join $report_root synth_cdc.rpt]
write_checkpoint -force [file join $report_root post_synth.dcp]
warn_if_failed "write_edif" {
    write_edif -force [file join $report_root "${project_name}_synth.edf"]
}
warn_if_failed "write_verilog synth netlist" {
    write_verilog -force [file join $report_root "${project_name}_synth_netlist.v"]
}
warn_if_failed "write_xdc synth constraints" {
    write_xdc -no_fixed_only -force [file join $report_root "${project_name}_synth.xdc"]
}

puts "INFO: Starting opt/place/route timing-only flow."
opt_design
write_checkpoint -force [file join $report_root post_opt.dcp]
report_drc -file [file join $report_root impl_drc_opted.rpt]

place_design
write_checkpoint -force [file join $report_root post_place.dcp]
report_io -file [file join $report_root impl_io_placed.rpt]
report_utilization -file [file join $report_root impl_utilization_placed.rpt]
report_control_sets -file [file join $report_root impl_control_sets_placed.rpt]

route_design
write_checkpoint -force [file join $report_root post_impl.dcp]
report_drc -file [file join $report_root impl_drc.rpt]
report_methodology -file [file join $report_root impl_methodology_drc.rpt]
report_power -file [file join $report_root impl_power.rpt]
report_route_status -file [file join $report_root impl_route_status.rpt]
report_cdc -file [file join $report_root impl_cdc.rpt]
report_timing_summary \
    -report_unconstrained \
    -check_timing_verbose \
    -file [file join $report_root impl_timing_summary.rpt]
report_clock_utilization -file [file join $report_root impl_clock_utilization.rpt]
report_utilization -file [file join $report_root impl_utilization.rpt]

puts "INFO: D-PHY wrapper direct timing reports written to $report_root"
