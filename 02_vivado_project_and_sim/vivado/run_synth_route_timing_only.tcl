# Vivado synthesis / direct route timing-only runner.
#
# This flow runs synthesis, opens the synthesized checkpoint, performs
# opt/place/route in the current Vivado batch session, and emits routed timing
# reports without writing a bitstream. It is useful for artificial wrapper tops
# that do not yet have a final board pinout or IOSTANDARD set.
#
# Usage:
#   vivado -mode batch -source 02_vivado_project_and_sim/vivado/run_synth_route_timing_only.tcl \
#          -tclargs [project_name] [top_module] [jobs]

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

proc clear_windows_readonly_dir {dir_path} {
    catch {file attributes $dir_path -readonly 0}
    if {[info exists ::tcl_platform(platform)] && ($::tcl_platform(platform) eq "windows")} {
        catch {exec attrib -R [file nativename $dir_path]}
    }
}

proc warn_if_failed {label script_body} {
    if {[catch {uplevel 1 $script_body} err_msg]} {
        puts "WARNING: $label skipped: $err_msg"
    }
}

set work_base   [file join $script_dir work]
set report_base [file join $script_dir reports]

if {[info exists ::env(VIVADO_WORK_ROOT)] && ($::env(VIVADO_WORK_ROOT) ne "")} {
    set work_base [file normalize $::env(VIVADO_WORK_ROOT)]
}
if {[info exists ::env(VIVADO_REPORT_ROOT)] && ($::env(VIVADO_REPORT_ROOT) ne "")} {
    set report_base [file normalize $::env(VIVADO_REPORT_ROOT)]
}

set project_file [file join $work_base $project_name "${project_name}.xpr"]
set report_root  [file join $report_base $project_name]

if {![file exists $project_file]} {
    puts "ERROR: Vivado project not found: $project_file"
    puts "ERROR: Run create_project.tcl first."
    return -code error "missing Vivado project"
}

file mkdir $report_root
clear_windows_readonly_dir $report_root
clear_windows_readonly_dir [file dirname $project_file]

puts "INFO: Opening project : $project_file"
puts "INFO: Requested top   : $top_module"
puts "INFO: Jobs            : $jobs"

open_project $project_file

set source_files [get_files -quiet -of_objects [get_filesets sources_1]]
set constraint_files [get_files -quiet -of_objects [get_filesets constrs_1]]
if {![file_list_has_module $source_files $top_module]} {
    puts "ERROR: Top module '$top_module' was not found in current project sources."
    close_project
    return -code error "missing top integration RTL"
}

set_property top $top_module [current_fileset]
update_compile_order -fileset sources_1

puts "INFO: Starting synthesis."
clear_windows_readonly_dir [file dirname $project_file]
reset_run synth_1
launch_runs synth_1 -jobs $jobs
wait_on_run synth_1
assert_run_complete synth_1

open_run synth_1 -name synth_1
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

puts "INFO: Starting direct route timing-only implementation."
set synth_dcp [file join $work_base $project_name "${project_name}.runs" "synth_1" "${top_module}.dcp"]
if {![file exists $synth_dcp]} {
    puts "ERROR: Synthesized checkpoint not found: $synth_dcp"
    close_project
    return -code error "missing synthesized checkpoint"
}

open_checkpoint $synth_dcp
foreach constraint_file $constraint_files {
    puts "INFO: Applying implementation constraint file: $constraint_file"
    read_xdc $constraint_file
}

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

puts "INFO: Direct route timing-only reports written to $report_root"
close_design
close_project
