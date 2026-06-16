param(
    [string]$VivadoCmd = "vivado",
    [string]$FpgaPart = "xczu9eg-ffvb1156-2-e",
    [string]$ProjectName = "mipi_csi2_capture_dphy_wrapper_timing_direct",
    [string]$TopModule = "mipi_csi2_capture_dphy_wrapper",
    [int]$Jobs = 4,
    [string]$ReportRoot = "",
    [bool]$CoreTimingOnly = $true
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$oldReportRoot = $env:VIVADO_REPORT_ROOT
$oldCoreTimingOnly = $env:DPHY_CORE_TIMING_ONLY

if ($ReportRoot -ne "") {
    $env:VIVADO_REPORT_ROOT = $ReportRoot
}
if ($CoreTimingOnly) {
    $env:DPHY_CORE_TIMING_ONLY = "1"
} else {
    $env:DPHY_CORE_TIMING_ONLY = "0"
}
$coreTimingArg = $env:DPHY_CORE_TIMING_ONLY

if ($env:VIVADO_REPORT_ROOT -ne "") {
    $projectReportRoot = Join-Path $env:VIVADO_REPORT_ROOT $ProjectName
} else {
    $projectReportRoot = Join-Path $scriptDir "reports\\$ProjectName"
}
New-Item -ItemType Directory -Force -Path $projectReportRoot | Out-Null

$logFile = Join-Path $projectReportRoot "vivado_timing_direct.log"
$journalFile = Join-Path $projectReportRoot "vivado_timing_direct.jou"

Write-Host "INFO: Vivado command : $VivadoCmd"
Write-Host "INFO: FPGA part      : $FpgaPart"
Write-Host "INFO: Project name   : $ProjectName"
Write-Host "INFO: Top module     : $TopModule"
Write-Host "INFO: XDC profile    : dphy_minimal"
Write-Host "INFO: Jobs           : $Jobs"
Write-Host "INFO: Core timing    : $CoreTimingOnly"
Write-Host "INFO: Report root    : $env:VIVADO_REPORT_ROOT"
Write-Host "INFO: Project report : $projectReportRoot"
Write-Host "INFO: Vivado log     : $logFile"

try {
    & $VivadoCmd -mode batch `
        -log $logFile `
        -journal $journalFile `
        -source (Join-Path $scriptDir "run_dphy_wrapper_timing_direct.tcl") `
        -tclargs $FpgaPart $ProjectName $TopModule $Jobs $coreTimingArg

    if ($LASTEXITCODE -ne 0) {
        throw "Vivado D-PHY wrapper direct timing flow failed."
    }

    Write-Host "INFO: D-PHY wrapper direct timing reports are under $projectReportRoot"
} finally {
    $env:VIVADO_REPORT_ROOT = $oldReportRoot
    $env:DPHY_CORE_TIMING_ONLY = $oldCoreTimingOnly
}
