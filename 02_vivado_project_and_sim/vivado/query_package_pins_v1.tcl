# Query usable package pins for the configured FPGA part.
#
# Usage:
#   vivado -mode batch -source query_package_pins_v1.tcl \
#          -tclargs [fpga_part] [report_file]

set fpga_part "xczu9eg-ffvb1156-2-e"
set report_file ""

if {[llength $argv] >= 1} {
    set fpga_part [lindex $argv 0]
}
if {[llength $argv] >= 2} {
    set report_file [lindex $argv 1]
}

if {$report_file eq ""} {
    set script_dir [file normalize [file dirname [info script]]]
    set report_file [file join $script_dir reports package_pins_${fpga_part}.txt]
}

file mkdir [file dirname $report_file]

create_project package_pin_probe [file join [file dirname $report_file] package_pin_probe] -part $fpga_part -force
link_design -part $fpga_part

set fp [open $report_file w]
puts $fp "FPGA_PART $fpga_part"
puts $fp "PACKAGE_PIN_COUNT [llength [get_package_pins]]"

set sample [lindex [get_package_pins] 0]
puts $fp "SAMPLE_PIN $sample"
foreach prop [lsort [list_property $sample]] {
    set value [get_property $prop $sample]
    puts $fp "SAMPLE_PROP $prop=$value"
}

puts $fp "ALL_PACKAGE_PINS"
foreach pin [lsort [get_package_pins]] {
    puts $fp $pin
}

puts $fp "USABLE_IO_PACKAGE_PINS"
puts $fp "PIN,BANK,PIN_FUNC,IS_GLOBAL_CLK,IS_DIFFERENTIAL,DIFF_PAIR_PIN"
foreach pin [lsort [get_package_pins -filter {IS_BONDED == 1 && IS_GENERAL_PURPOSE == 1}]] {
    puts $fp "[get_property NAME $pin],[get_property BANK $pin],[get_property PIN_FUNC $pin],[get_property IS_GLOBAL_CLK $pin],[get_property IS_DIFFERENTIAL $pin],[get_property DIFF_PAIR_PIN $pin]"
}

close $fp
close_project
