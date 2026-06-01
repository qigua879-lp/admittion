param(
    [string]$VivadoBin = "D:\Xilinx\Vivado\2017.3\bin",
    [string]$OutTag = "vivado_xsim_20260506_fpga_wrapper"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..")
$FileList = Join-Path $RepoRoot "sim\vcs\compile.f"
$OutRoot  = Join-Path $RepoRoot ("sim\logs\" + $OutTag)

function Resolve-VivadoTool {
    param(
        [string]$BinRoot,
        [string]$ToolStem
    )

    $Candidates = @(
        (Join-Path $BinRoot ($ToolStem + ".bat")),
        (Join-Path $BinRoot ($ToolStem + ".exe")),
        (Join-Path (Join-Path $BinRoot "..\unwrapped\win64.o") ($ToolStem + ".exe"))
    )

    foreach ($Candidate in $Candidates) {
        if (Test-Path $Candidate) {
            return (Resolve-Path $Candidate).Path
        }
    }

    throw "Vivado simulator tool not found for $ToolStem under $BinRoot"
}

$Xvlog = Resolve-VivadoTool $VivadoBin "xvlog"
$Xelab = Resolve-VivadoTool $VivadoBin "xelab"
$Xsim  = Resolve-VivadoTool $VivadoBin "xsim"

New-Item -ItemType Directory -Force -Path $OutRoot | Out-Null
Set-Location $RepoRoot

$Sources = Get-Content $FileList |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and !$_.StartsWith("#") -and !$_.StartsWith("+incdir+") } |
    ForEach-Object { Join-Path $RepoRoot $_ }

function Invoke-CheckedCommand {
    param(
        [string]$Name,
        [string]$Exe,
        [string[]]$CommandArgs,
        [string]$OptionalLog = ""
    )

    Write-Host "INFO: $Name"
    & $Exe @CommandArgs
    $ExitCode = $LASTEXITCODE
    if ($ExitCode -eq 0) {
        return
    }

    # Vivado 2017.3 on Windows/OneDrive can build the snapshot successfully,
    # then return 1 because it cannot remove xsim.dir/<snapshot>/obj.
    if ($OptionalLog -and (Test-Path $OptionalLog)) {
        $LogText = Get-Content $OptionalLog -Raw
        if (($LogText -match "Built simulation snapshot") -and
            ($LogText -match "Could not remove the obj directory")) {
            Write-Warning "$Name returned $ExitCode after snapshot build; continuing after known obj cleanup warning."
            return
        }
    }

    throw "$Name failed with exit code $ExitCode"
}

function Invoke-XSimTest {
    param(
        [string]$Name,
        [string]$Top,
        [string]$TestFile
    )

    $LogDir = Join-Path $OutRoot $Name
    $Snapshot = "snap_$Name"
    $TestPath = Join-Path $RepoRoot $TestFile

    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

    Invoke-CheckedCommand "xvlog $Name" $Xvlog (
        @("-sv", "-i", (Join-Path $RepoRoot "rtl"), "-i", (Join-Path $RepoRoot "tb"),
          "-log", (Join-Path $LogDir "xvlog.log")) + $Sources + @($TestPath)
    )

    $XelabLog = Join-Path $LogDir "xelab.log"
    Invoke-CheckedCommand "xelab $Name" $Xelab (
        @("-debug", "typical", "-top", $Top, "-snapshot", $Snapshot, "-log", $XelabLog)
    ) $XelabLog

    Invoke-CheckedCommand "xsim $Name" $Xsim (
        @($Snapshot, "-runall", "-log", (Join-Path $LogDir "xsim.log"))
    )
}

function Invoke-XSimElab {
    param(
        [string]$Name,
        [string]$Top
    )

    $LogDir = Join-Path $OutRoot $Name
    $Snapshot = "snap_$Name"

    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

    Invoke-CheckedCommand "xvlog $Name" $Xvlog (
        @("-sv", "-i", (Join-Path $RepoRoot "rtl"), "-i", (Join-Path $RepoRoot "tb"),
          "-log", (Join-Path $LogDir "xvlog.log")) + $Sources
    )

    $XelabLog = Join-Path $LogDir "xelab.log"
    Invoke-CheckedCommand "xelab $Name" $Xelab (
        @("-debug", "typical", "-top", $Top, "-snapshot", $Snapshot, "-log", $XelabLog)
    ) $XelabLog
}

Invoke-XSimTest "tb_payload_crc" "tb_payload_crc" "tb\tests\tb_payload_crc.sv"
Invoke-XSimTest "tb_long_packet_parser" "tb_long_packet_parser" "tb\tests\tb_long_packet_parser.sv"
Invoke-XSimTest "tb_fpga_wrapper_boot" "tb_fpga_wrapper_boot" "tb\tests\tb_fpga_wrapper_boot.sv"
Invoke-XSimTest "tb_system_default" "tb_mipi_csi2_capture_top" "tb\top\tb_mipi_csi2_capture_top.sv"
Invoke-XSimElab "mipi_csi2_capture_top" "mipi_csi2_capture_top"
Invoke-XSimElab "mipi_csi2_capture_fpga_wrapper" "mipi_csi2_capture_fpga_wrapper"

Write-Host "PASS: Vivado XSim smoke completed. Logs: $OutRoot"
