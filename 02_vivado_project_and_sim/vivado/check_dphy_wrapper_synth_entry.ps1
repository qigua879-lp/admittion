param(
    [string]$RepoRoot = (Resolve-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "../..")).Path
)

$ErrorActionPreference = "Stop"

$vivadoDir = Join-Path $RepoRoot "02_vivado_project_and_sim/vivado"
$xdcDir = Join-Path $RepoRoot "02_vivado_project_and_sim/xdc"

$createProject = Join-Path $vivadoDir "create_project.tcl"
$synthOnly = Join-Path $vivadoDir "run_synth_only.tcl"
$routeTimingOnly = Join-Path $vivadoDir "run_synth_route_timing_only.tcl"
$directTimingOnly = Join-Path $vivadoDir "run_dphy_wrapper_timing_direct.tcl"
$dphyBuild = Join-Path $vivadoDir "run_dphy_wrapper_synth.ps1"
$dphyTimingBuild = Join-Path $vivadoDir "run_dphy_wrapper_timing.ps1"
$dphyDirectTimingBuild = Join-Path $vivadoDir "run_dphy_wrapper_timing_direct.ps1"
$dphyXdc = Join-Path $xdcDir "dphy_wrapper_constraints.xdc"

foreach ($path in @($createProject, $synthOnly, $routeTimingOnly, $directTimingOnly, $dphyBuild, $dphyTimingBuild, $dphyDirectTimingBuild, $dphyXdc)) {
    if (-not (Test-Path $path)) {
        throw "Missing required D-PHY synth entry file: $path"
    }
}

$createText = Get-Content $createProject -Raw
$synthText = Get-Content $synthOnly -Raw
$routeTimingText = Get-Content $routeTimingOnly -Raw
$directTimingText = Get-Content $directTimingOnly -Raw
$buildText = Get-Content $dphyBuild -Raw
$timingBuildText = Get-Content $dphyTimingBuild -Raw
$directTimingBuildText = Get-Content $dphyDirectTimingBuild -Raw
$xdcText = Get-Content $dphyXdc -Raw

if ($createText -notmatch "dphy_minimal") {
    throw "create_project.tcl must support the dphy_minimal XDC profile"
}
if ($buildText -notmatch "mipi_csi2_capture_dphy_wrapper" -or $buildText -notmatch "dphy_minimal") {
    throw "run_dphy_wrapper_synth.ps1 must target mipi_csi2_capture_dphy_wrapper with dphy_minimal constraints"
}
if ($buildText -notmatch "run_synth_only.tcl") {
    throw "D-PHY wrapper script must run synthesis-only, not bitstream implementation"
}
if ($synthText -notmatch "report_utilization" -or $synthText -notmatch "report_timing_summary" -or $synthText -notmatch "write_checkpoint") {
    throw "run_synth_only.tcl must emit utilization, timing, and post-synth checkpoint reports"
}
if ($timingBuildText -notmatch "mipi_csi2_capture_dphy_wrapper" -or $timingBuildText -notmatch "dphy_minimal") {
    throw "run_dphy_wrapper_timing.ps1 must target mipi_csi2_capture_dphy_wrapper with dphy_minimal constraints"
}
if ($timingBuildText -notmatch "run_synth_route_timing_only.tcl") {
    throw "D-PHY wrapper timing script must run the timing-only route flow"
}
if ($routeTimingText -notmatch "route_design" -or $routeTimingText -notmatch "report_timing_summary" -or $routeTimingText -notmatch "report_route_status") {
    throw "run_synth_route_timing_only.tcl must route the design and emit timing/route reports"
}
if ($routeTimingText -match "write_bitstream") {
    throw "run_synth_route_timing_only.tcl must not write a bitstream"
}
if ($directTimingBuildText -notmatch "run_dphy_wrapper_timing_direct.tcl") {
    throw "D-PHY direct timing script must run the direct timing Tcl flow"
}
if ($directTimingBuildText -notmatch "DPHY_CORE_TIMING_ONLY") {
    throw "D-PHY direct timing script must set DPHY_CORE_TIMING_ONLY explicitly"
}
if ($directTimingText -notmatch "synth_design" -or $directTimingText -notmatch "route_design" -or $directTimingText -notmatch "report_timing_summary") {
    throw "run_dphy_wrapper_timing_direct.tcl must synthesize, route, and emit timing reports"
}
if ($directTimingText -notmatch "core_timing_only" -or $directTimingText -notmatch "DPHY_CORE_TIMING_ONLY") {
    throw "run_dphy_wrapper_timing_direct.tcl must pass core_timing_only into the XDC environment"
}
if ($directTimingText -notmatch "apply_core_timing_boundary_cuts" -or $directTimingText -notmatch 'set_false_path -to \$wrapper_output_ports') {
    throw "run_dphy_wrapper_timing_direct.tcl must apply direct core timing boundary cuts after synth_design"
}
if ($directTimingText -match "(?m)^\s*(create_project|launch_runs|write_bitstream)\b") {
    throw "run_dphy_wrapper_timing_direct.tcl must avoid project runs and bitstream generation"
}
if ($xdcText -notmatch "rxbyteclkhs" -or $xdcText -notmatch "ila_probe_o") {
    throw "dphy_wrapper_constraints.xdc must constrain rxbyteclkhs and the ILA probe output bus"
}
if ($xdcText -notmatch "DPHY_CORE_TIMING_ONLY" -or $xdcText -notmatch 'set_false_path -to \$DPHY_SYS_OUTPUT_PORTS') {
    throw "dphy_wrapper_constraints.xdc must support core timing-only wrapper boundary cuts"
}
if ($xdcText -match "lane_data_" -or $xdcText -match "lane_valid_[0-3]") {
    throw "dphy_wrapper_constraints.xdc must not constrain old abstract lane_data/lane_valid ports"
}

Write-Output "PASS: check_dphy_wrapper_synth_entry"
