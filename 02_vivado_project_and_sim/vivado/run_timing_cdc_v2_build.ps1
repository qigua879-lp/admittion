param(
    [string]$VivadoCmd = "vivado",
    [string]$FpgaPart = "xczu9eg-ffvb1156-2-e",
    [int]$Jobs = 4
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectName = "mipi_csi2_capture_fpga_timing_cdc_v2"
$topModule = "mipi_csi2_capture_fpga_wrapper"

Write-Host "INFO: Running timing_cdc_v2 Vivado build."
Write-Host "INFO: Project name : $projectName"
Write-Host "INFO: Top module   : $topModule"
Write-Host "INFO: Flow         : synth + direct route-only implementation"

& $VivadoCmd -mode batch `
    -source (Join-Path $scriptDir "create_project.tcl") `
    -tclargs $FpgaPart $projectName $topModule

if ($LASTEXITCODE -ne 0) {
    throw "Vivado project creation failed."
}

& $VivadoCmd -mode batch `
    -source (Join-Path $scriptDir "run_synth_route_direct.tcl") `
    -tclargs $projectName $topModule $Jobs

if ($LASTEXITCODE -ne 0) {
    throw "Vivado synthesis/direct route implementation failed."
}

Write-Host "INFO: timing_cdc_v2 reports are under $(Join-Path $scriptDir "reports\$projectName")"
