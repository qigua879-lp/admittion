param(
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)][string]$Top,
    [Parameter(Mandatory = $true)][string]$TestFile,
    [Parameter(Mandatory = $true)][string]$Snapshot,
    [string]$VivadoBin = "D:\Xilinx\Vivado\2017.3\bin",
    [string]$RepoRoot = "C:\mipi_all",
    [string]$OutTag = "vivado_xsim_waveforms_20260519"
)

$ErrorActionPreference = "Stop"

$LogRoot = Join-Path $RepoRoot ("sim\logs\" + $OutTag)
$LogDir = Join-Path $LogRoot $Name
$FileList = Join-Path $RepoRoot "sim\vcs\compile.f"

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Sources = Get-Content $FileList |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and !$_.StartsWith("#") -and !$_.StartsWith("+incdir+") } |
    ForEach-Object { Join-Path $RepoRoot $_ }

$SnapshotDir = Join-Path $RepoRoot ("xsim.dir\" + $Snapshot)
if (Test-Path $SnapshotDir) {
    Remove-Item -Recurse -Force $SnapshotDir
}

& (Join-Path $VivadoBin "xvlog.bat") -sv -i (Join-Path $RepoRoot "rtl") -i (Join-Path $RepoRoot "tb") `
    -log (Join-Path $LogDir "xvlog.log") @Sources (Join-Path $RepoRoot $TestFile)
if ($LASTEXITCODE -ne 0) {
    throw "xvlog failed for $Name"
}

& (Join-Path $VivadoBin "xelab.bat") -debug typical -top $Top -snapshot $Snapshot `
    -log (Join-Path $LogDir "xelab.log")
if ($LASTEXITCODE -ne 0) {
    throw "xelab failed for $Name"
}

Write-Host "Built $Snapshot"
