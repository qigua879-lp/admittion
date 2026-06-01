# Vivado synthesis / implementation runner for the digital MIPI CSI-2 capture project.
#
# Usage:
#   vivado -mode batch -source fpga/vivado/run_synth_impl.tcl \
#          -tclargs [project_name] [top_module] [jobs]
#
# Example:
#   vivado -mode batch -source fpga/vivado/run_synth_impl.tcl \
#          -tclargs mipi_csi2_capture mipi_csi2_capture_top 8
#
# Run fpga/vivado/create_project.tcl first. This script intentionally requires
# a real top integration module before synthesis starts.

set script_dir [file normalize [file dirname [info script]]]

set project_name "mipi_csi2_capture"
set top_module   "mipi_csi2_capture_top"
set jobs         4

if {[info exists ::env(VIVADO_JOBS)] && ($::env(VIVADO_JOBS) ne "")} {
    set jobs $::env(VIVADO_JOBS)
}

if {[llength $argv] >= 1} {
    set project_name [lindex $argv 0]
}
if {[llength $argv] >= 2} {
    set top_module [lindex $argv 1]
}
if {[llength $argv] >= 3} {
    set jobs [lindex $argv 2]
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

proc assert_run_complete {run_name} {
    set run_obj [get_runs $run_name]
    set progress [get_property PROGRESS $run_obj]
    set status   [get_property STATUS $run_obj]

    if {($progress ne "100%") || ![regexp {Complete} $status]} {
        puts "ERROR: Run $run_name did not complete successfully."
        puts "ERROR: PROGRESS=$progress"
        puts "ERROR: STATUS=$status"
        return -code error "$run_name failed"
    }
}

set project_file [file join $script_dir work $project_name "${project_name}.xpr"]
set report_root  [file join $script_dir reports $project_name]

if {![file exists $project_file]} {
    puts "ERROR: Vivado project not found: $project_file"
    puts "ERROR: Run fpga/vivado/create_project.tcl first."
    return -code error "missing Vivado project"
}

file mkdir $report_root

puts "INFO: Opening project : $project_file"
puts "INFO: Requested top   : $top_module"
puts "INFO: Jobs            : $jobs"

open_project $project_file

set source_files [get_files -quiet -of_objects [get_filesets sources_1]]
if {![file_list_has_module $source_files $top_module]} {
    puts "ERROR: Top module '$top_module' was not found in current project sources."
    puts "ERROR: This stage only provides scripts; add top integration RTL before running synthesis."
    close_project
    return -code error "missing top integration RTL"
}

set_property top $top_module [current_fileset]
update_compile_order -fileset sources_1

puts "INFO: Starting synthesis."
reset_run synth_1
launch_runs synth_1 -jobs $jobs
wait_on_run synth_1
assert_run_complete synth_1

open_run synth_1 -name synth_1
report_utilization -file [file join $report_root synth_utilization.rpt]
report_timing_summary -file [file join $report_root synth_timing_summary.rpt]
report_cdc -file [file join $report_root synth_cdc.rpt]
write_checkpoint -force [file join $report_root post_synth.dcp]
write_edif -force [file join $report_root "${project_name}_synth.edf"]
write_verilog -force [file join $report_root "${project_name}_synth_netlist.v"]
write_xdc -no_fixed_only -force [file join $report_root "${project_name}_synth.xdc"]

puts "INFO: Starting implementation through bitstream generation."
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs $jobs
wait_on_run impl_1
assert_run_complete impl_1

open_run impl_1 -name impl_1
report_utilization -file [file join $report_root impl_utilization.rpt]
report_timing_summary \
    -delay_type max \
    -report_unconstrained \
    -check_timing_verbose \
    -file [file join $report_root impl_timing_summary.rpt]
report_power -file [file join $report_root impl_power.rpt]
report_drc -file [file join $report_root impl_drc.rpt]
write_checkpoint -force [file join $report_root post_impl.dcp]

set impl_dir [get_property DIRECTORY [get_runs impl_1]]
set bit_files [glob -nocomplain -directory $impl_dir *.bit]
foreach bit_file $bit_files {
    file copy -force $bit_file [file join $report_root [file tail $bit_file]]
}

puts "INFO: Reports written to $report_root"
puts "INFO: Synthesis and implementation completed."

close_project
