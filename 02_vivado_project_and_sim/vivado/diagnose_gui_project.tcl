set script_dir [file normalize [file dirname [info script]]]
set repo_root  [file normalize [file join $script_dir ../..]]
set project_xpr [file join $repo_root fpga vivado work_gui mipi_csi2_capture mipi_csi2_capture.xpr]

set opened_here 0
if {[current_project -quiet] eq ""} {
    open_project $project_xpr
    set opened_here 1
}

puts "INFO: current project: [current_project]"
puts "INFO: design top: [get_property top [get_filesets sources_1]]"
puts "INFO: simulation top: [get_property top [get_filesets sim_1]]"

puts "INFO: sources_1 files:"
foreach f [get_files -of_objects [get_filesets sources_1]] {
    puts "  [get_property FILE_TYPE $f] :: $f"
}

puts "INFO: sim_1 files:"
foreach f [get_files -of_objects [get_filesets sim_1]] {
    puts "  [get_property FILE_TYPE $f] :: $f :: USED_IN=[get_property USED_IN $f]"
}

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "INFO: sim_1 compile order:"
foreach f [get_files -compile_order sources -used_in simulation] {
    puts "  $f"
}

launch_simulation -simset sim_1 -mode behavioral
run all
close_sim
if {$opened_here} {
    close_project
}
