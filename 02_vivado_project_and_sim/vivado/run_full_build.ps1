param(
    [string]$VivadoCmd = "vivado",
    [string]$FpgaPart = "xczu9eg-ffvb1156-2-e",
    [string]$ProjectName = "mipi_csi2_capture",
    [string]$TopModule = "mipi_csi2_capture_fpga_wrapper",
    [int]$Jobs = 4
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "INFO: Vivado command : $VivadoCmd"
Write-Host "INFO: FPGA part      : $FpgaPart"
Write-Host "INFO: Project name   : $ProjectName"
Write-Host "INFO: Top module     : $TopModule"
Write-Host "INFO: Jobs           : $Jobs"

& $VivadoCmd -mode batch `
    -source (Join-Path $scriptDir "create_project.tcl") `
    -tclargs $FpgaPart $ProjectName $TopModule

if ($LASTEXITCODE -ne 0) {
    throw "Vivado project creation failed."
}

& $VivadoCmd -mode batch `
    -source (Join-Path $scriptDir "run_synth_impl.tcl") `
    -tclargs $ProjectName $TopModule $Jobs

if ($LASTEXITCODE -ne 0) {
    throw "Vivado synthesis/implementation failed."
}

$reportRoot = Join-Path $scriptDir "reports\\$ProjectName"
Write-Host "INFO: Build completed. Artifacts are under $reportRoot"
