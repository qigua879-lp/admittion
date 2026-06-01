# Vivado XSim smoke runner for the digital MIPI CSI-2 capture project.
#
# Usage:
#   vivado -mode batch -source fpga/vivado/run_xsim_smoke.tcl
#
# This script intentionally runs a small Vivado-native smoke set. The broader
# VCS/Icarus regressions remain under sim/vcs/.

set script_dir [file normalize [file dirname [info script]]]
set repo_root  [file normalize [file join $script_dir ../..]]
set filelist   [file join $repo_root sim vcs compile.f]
set out_root   [file join $repo_root sim logs xsim]
set source_files {}

if {[info exists ::env(XILINX_VIVADO)]} {
    set vivado_bin [file join $::env(XILINX_VIVADO) bin]
} else {
    set vivado_bin [file normalize "D:/Xilinx/Vivado/2017.3/bin"]
}

if {$::tcl_platform(platform) eq "windows"} {
    set xvlog_cmd [list cmd /c [file nativename [file join $vivado_bin xvlog.bat]]]
    set xelab_cmd [list cmd /c [file nativename [file join $vivado_bin xelab.bat]]]
    set xsim_cmd  [list cmd /c [file nativename [file join $vivado_bin xsim.bat]]]
} else {
    set xvlog_cmd [list [file join $vivado_bin xvlog]]
    set xelab_cmd [list [file join $vivado_bin xelab]]
    set xsim_cmd  [list [file join $vivado_bin xsim]]
}

file mkdir $out_root
cd $repo_root

set fp [open $filelist r]
while {[gets $fp line] >= 0} {
    set line [string trim $line]
    if {$line eq ""} {
        continue
    }
    if {[string match "#*" $line]} {
        continue
    }
    if {[string match "+incdir+*" $line]} {
        continue
    }
    lappend source_files [file join $repo_root $line]
}
close $fp

proc run_cmd {cmd} {
    puts "INFO: exec $cmd"
    if {[catch {exec {*}$cmd} result options]} {
        puts $result
        puts "ERROR: command failed"
        return -code error $result
    }
    if {$result ne ""} {
        puts $result
    }
}

proc run_xsim_test {name top test_file} {
    global repo_root source_files out_root xvlog_cmd xelab_cmd xsim_cmd

    set test_path [file normalize [file join $repo_root $test_file]]
    set log_dir   [file join $out_root $name]
    set snapshot  "snap_$name"

    file mkdir $log_dir

    puts "INFO: XSIM $name"
    run_cmd [concat $xvlog_cmd [list -sv -i [file join $repo_root rtl] -i [file join $repo_root tb] \
                 -log [file join $log_dir xvlog.log]] $source_files [list $test_path]]
    run_cmd [concat $xelab_cmd [list -debug typical -top $top -snapshot $snapshot \
                 -log [file join $log_dir xelab.log]]]
    run_cmd [concat $xsim_cmd [list $snapshot -runall \
                 -log [file join $log_dir xsim.log]]]
}

proc run_xsim_elab {name top} {
    global repo_root source_files out_root xvlog_cmd xelab_cmd

    set log_dir  [file join $out_root $name]
    set snapshot "snap_$name"

    file mkdir $log_dir

    puts "INFO: ELAB $name"
    run_cmd [concat $xvlog_cmd [list -sv -i [file join $repo_root rtl] -i [file join $repo_root tb] \
                 -log [file join $log_dir xvlog.log]] $source_files]
    run_cmd [concat $xelab_cmd [list -debug typical -top $top -snapshot $snapshot \
                 -log [file join $log_dir xelab.log]]]
}

run_xsim_test tb_payload_crc         tb_payload_crc         tb/tests/tb_payload_crc.sv
run_xsim_test tb_long_packet_parser  tb_long_packet_parser  tb/tests/tb_long_packet_parser.sv
run_xsim_test tb_system_default      tb_mipi_csi2_capture_top tb/top/tb_mipi_csi2_capture_top.sv
run_xsim_elab mipi_csi2_capture_top  mipi_csi2_capture_top

puts "PASS: Vivado XSim smoke completed. Logs: $out_root"
