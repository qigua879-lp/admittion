set script_dir [file normalize [file dirname [info script]]]
set repo_root  [file normalize [file join $script_dir ../..]]
set project_xpr [file join $repo_root fpga vivado work_gui mipi_csi2_capture mipi_csi2_capture.xpr]

set opened_here 0
if {[current_project -quiet] eq ""} {
    open_project $project_xpr
    set opened_here 1
}

set simset [get_filesets sim_1]

# Keep GUI simulation focused on one known-good system testbench. Adding every
# tb/tests/*.sv at once gives Vivado many possible tops and makes the source
# properties noisy in 2017.3.
set old_sim_files [get_files -quiet -of_objects $simset]
if {[llength $old_sim_files] != 0} {
    remove_files -fileset $simset $old_sim_files
}

set sim_files [list \
    [file join $repo_root tb refs csi2_reference_helpers.sv] \
    [file join $repo_root tb models sensor_model.sv] \
    [file join $repo_root tb scoreboard scoreboard.sv] \
    [file join $repo_root tb top tb_mipi_csi2_capture_top.sv] \
]

add_files -fileset $simset -norecurse $sim_files
set_property file_type SystemVerilog [get_files -of_objects $simset]
set_property used_in {simulation} [get_files -of_objects $simset]
set_property top tb_mipi_csi2_capture_top $simset
set_property top mipi_csi2_capture_top [get_filesets sources_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "INFO: fixed sim_1 files:"
foreach f [get_files -of_objects $simset] {
    puts "  $f :: USED_IN=[get_property USED_IN $f]"
}
puts "INFO: sim_1 top: [get_property top $simset]"

save_project
if {$opened_here} {
    close_project
}
