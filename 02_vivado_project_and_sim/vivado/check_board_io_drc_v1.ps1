param(
    [string]$ProjectName = "mipi_csi2_capture_board_io_v1_clkfix5",
    [string]$ReportRoot = "C:\vivado_admittion\reports",
    [string]$LogRoot = "C:\vivado_admittion\logs"
)

$ErrorActionPreference = "Stop"

$projectReportDir = Join-Path $ReportRoot $ProjectName
$bitFile = Join-Path $projectReportDir "$ProjectName.bit"
$drcReport = Join-Path $projectReportDir "impl_drc.rpt"
$timingReport = Join-Path $projectReportDir "impl_timing_summary.rpt"
$vivadoLog = Join-Path $LogRoot "direct_board_io_v1_clkfix5_r2.vivado.log"

if (-not (Test-Path $projectReportDir)) {
    throw "Missing report directory: $projectReportDir"
}
if (-not (Test-Path $bitFile)) {
    throw "Missing bitstream: $bitFile"
}
if (-not (Test-Path $drcReport)) {
    throw "Missing DRC report: $drcReport"
}
if (-not (Test-Path $vivadoLog)) {
    throw "Missing Vivado log: $vivadoLog"
}

$drcText = Get-Content -Path $drcReport -Raw
$logText = Get-Content -Path $vivadoLog -Raw

if ($drcText -notmatch "Violations found:\s+0") {
    throw "impl_drc.rpt does not report zero violations"
}
if ($logText -notmatch "write_bitstream completed successfully") {
    throw "Vivado log does not show write_bitstream completion"
}
if ($logText -notmatch "DRC finished with 0 Errors") {
    throw "Vivado log does not show a zero-error bitstream DRC"
}
if ($logText -match "ERROR:\s+\[DRC\s+NSTD-1\]") {
    throw "Vivado log still contains NSTD-1"
}
if ($logText -match "ERROR:\s+\[DRC\s+UCIO-1\]") {
    throw "Vivado log still contains UCIO-1"
}

$bitInfo = Get-Item -Path $bitFile

Write-Output "PASS: board_io_drc_v1"
Write-Output "project=$ProjectName"
Write-Output "bitstream=$bitFile"
Write-Output "bitstream_bytes=$($bitInfo.Length)"
Write-Output "impl_drc=Violations found: 0"
Write-Output "bitgen_drc=0 Errors"

if (Test-Path $timingReport) {
    $timingText = Get-Content -Path $timingReport -Raw
    if ($timingText -match "Timing constraints are not met") {
        Write-Output "timing_status=NOT_MET"
    } else {
        Write-Output "timing_status=MET_OR_NOT_REPORTED_AS_FAILING"
    }
}
