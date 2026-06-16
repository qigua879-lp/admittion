param(
    [string]$VivadoCmd = "vivado",
    [string]$FpgaPart = "xczu9eg-ffvb1156-2-e",
    [string]$ProjectName = "mipi_csi2_capture_dphy_wrapper_timing",
    [string]$TopModule = "mipi_csi2_capture_dphy_wrapper",
    [int]$Jobs = 4,
    [string]$WorkRoot = "",
    [string]$ReportRoot = ""
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$oldWorkRoot = $env:VIVADO_WORK_ROOT
$oldReportRoot = $env:VIVADO_REPORT_ROOT

if ($WorkRoot -ne "") {
    $env:VIVADO_WORK_ROOT = $WorkRoot
}
if ($ReportRoot -ne "") {
    $env:VIVADO_REPORT_ROOT = $ReportRoot
}

Write-Host "INFO: Vivado command : $VivadoCmd"
Write-Host "INFO: FPGA part      : $FpgaPart"
Write-Host "INFO: Project name   : $ProjectName"
Write-Host "INFO: Top module     : $TopModule"
Write-Host "INFO: XDC profile    : dphy_minimal"
Write-Host "INFO: Jobs           : $Jobs"
Write-Host "INFO: Work root      : $env:VIVADO_WORK_ROOT"
Write-Host "INFO: Report root    : $env:VIVADO_REPORT_ROOT"

try {
    & $VivadoCmd -mode batch `
        -source (Join-Path $scriptDir "create_project.tcl") `
        -tclargs $FpgaPart $ProjectName $TopModule dphy_minimal

    if ($LASTEXITCODE -ne 0) {
        throw "Vivado D-PHY wrapper project creation failed."
    }

    & $VivadoCmd -mode batch `
        -source (Join-Path $scriptDir "run_synth_route_timing_only.tcl") `
        -tclargs $ProjectName $TopModule $Jobs

    if ($LASTEXITCODE -ne 0) {
        throw "Vivado D-PHY wrapper timing-only route failed."
    }

    if ($env:VIVADO_REPORT_ROOT -ne "") {
        $projectReportRoot = Join-Path $env:VIVADO_REPORT_ROOT $ProjectName
    } else {
        $projectReportRoot = Join-Path $scriptDir "reports\\$ProjectName"
    }

    Write-Host "INFO: D-PHY wrapper timing-only reports are under $projectReportRoot"
} finally {
    $env:VIVADO_WORK_ROOT = $oldWorkRoot
    $env:VIVADO_REPORT_ROOT = $oldReportRoot
}
