# Vivado project creation script for the digital MIPI CSI-2 capture project.
#
# Usage:
#   vivado -mode batch -source 02_vivado_project_and_sim/vivado/create_project.tcl \
#          -tclargs [fpga_part] [project_name] [top_module] [xdc_profile]
#
# Default example:
#   vivado -mode batch -source 02_vivado_project_and_sim/vivado/create_project.tcl \
#          -tclargs xczu9eg-ffvb1156-2-e mipi_csi2_capture mipi_csi2_capture_top all
#
# This repository now defaults to AMD Zynq UltraScale+ MPSoC
# xczu9eg-ffvb1156-2-e. This aligns with the existing XDC placeholder and with
# AMD MIPI CSI-2 RX validation platforms such as ZCU102. The part can still be
# overridden by the first positional argument or the FPGA_PART environment
# variable.

set script_dir [file normalize [file dirname [info script]]]
set repo_root  [file normalize [file join $script_dir ../..]]

set project_name "mipi_csi2_capture"
set top_module   "mipi_csi2_capture_top"
set fpga_part    "xczu9eg-ffvb1156-2-e"
set xdc_profile  "all"

if {[info exists ::env(FPGA_PART)] && ($::env(FPGA_PART) ne "")} {
    set fpga_part $::env(FPGA_PART)
}

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
    set xdc_profile [lindex $argv 3]
}

if {$fpga_part eq "FPGA_PART_PLACEHOLDER"} {
    puts "ERROR: FPGA part is invalid."
    puts "       Pass a concrete Vivado part as the first -tclargs value,"
    puts "       or export FPGA_PART before running this script."
    return -code error "invalid FPGA part"
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

proc clear_windows_readonly_dir {dir_path} {
    catch {file attributes $dir_path -readonly 0}
    if {[info exists ::tcl_platform(platform)] && ($::tcl_platform(platform) eq "windows")} {
        catch {exec attrib -R [file nativename $dir_path]}
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

set project_root [file join $work_base $project_name]
set report_root  [file join $report_base $project_name]
set rtl_root     [file join $repo_root 01_source_code rtl]
set xdc_root     [file join $repo_root 02_vivado_project_and_sim xdc]

if {![file isdirectory $rtl_root] && [file isdirectory [file join $repo_root rtl]]} {
    set rtl_root [file join $repo_root rtl]
}
if {![file isdirectory $xdc_root] && [file isdirectory [file join $repo_root fpga xdc]]} {
    set xdc_root [file join $repo_root fpga xdc]
}

file mkdir $project_root
file mkdir $report_root
clear_windows_readonly_dir $project_root
clear_windows_readonly_dir $report_root

puts "INFO: Repository root : $repo_root"
puts "INFO: Project name    : $project_name"
puts "INFO: Project root    : $project_root"
puts "INFO: FPGA part       : $fpga_part"
puts "INFO: Requested top   : $top_module"
puts "INFO: XDC profile     : $xdc_profile"
puts "INFO: RTL root        : $rtl_root"
puts "INFO: XDC root        : $xdc_root"

create_project $project_name $project_root -part $fpga_part -force

set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]

set rtl_files [collect_files_recursive $rtl_root [list "*.sv" "*.v"]]
if {[llength $rtl_files] == 0} {
    return -code error "no RTL files found under $rtl_root"
}
add_files -fileset sources_1 $rtl_files

set xdc_files_all [collect_files_recursive $xdc_root [list "*.xdc"]]
set xdc_files {}

if {$xdc_profile eq "all"} {
    set xdc_files $xdc_files_all
} elseif {$xdc_profile eq "dphy_minimal"} {
    set dphy_xdc [file normalize [file join $xdc_root dphy_wrapper_constraints.xdc]]
    if {![file exists $dphy_xdc]} {
        return -code error "dphy_minimal XDC profile requested but missing $dphy_xdc"
    }
    set xdc_files [list $dphy_xdc]
} else {
    return -code error "unknown XDC profile '$xdc_profile'; expected 'all' or 'dphy_minimal'"
}

if {[llength $xdc_files] > 0} {
    add_files -fileset constrs_1 $xdc_files
} else {
    puts "WARNING: No XDC files found under $xdc_root"
}

if {[file_list_has_module $rtl_files $top_module]} {
    set_property top $top_module [current_fileset]
    puts "INFO: Top module set to $top_module"
} else {
    puts "WARNING: Top module '$top_module' was not found under $rtl_root."
    puts "WARNING: Project was created as a source/constraint skeleton only."
    puts "WARNING: Add top integration RTL before running synthesis."
}

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "INFO: Added [llength $rtl_files] RTL source files."
puts "INFO: Added [llength $xdc_files] XDC constraint files."
puts "INFO: Vivado project creation completed."
