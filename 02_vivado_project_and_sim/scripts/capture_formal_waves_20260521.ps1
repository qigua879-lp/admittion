param(
    [string]$RepoRoot = "",
    [string]$OutRoot = "",
    [string]$WorkRoot = "C:\temp\admittion_formal_20260521\xsim_repo",
    [string]$VivadoBin = "D:\Xilinx\Vivado\2017.3\bin",
    [int]$WaitSeconds = 60,
    [string[]]$CaseId = @()
)

$ErrorActionPreference = "Stop"

if (-not $RepoRoot) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
}

if (-not $OutRoot) {
    $OutRoot = Join-Path $RepoRoot "05_simulation_results\结果验证\正式重验证_20260521"
}

$WaveRoot = Join-Path $OutRoot "waves"
$LogRoot = Join-Path $OutRoot "xsim_wave_logs"
$TableRoot = Join-Path $OutRoot "tables"
New-Item -ItemType Directory -Force -Path $WaveRoot, $LogRoot, $TableRoot | Out-Null

$TempRoot = "C:\temp\admittion_formal_20260521"
$AsciiCaptureRoot = Join-Path $TempRoot "wave_capture"
New-Item -ItemType Directory -Force -Path $AsciiCaptureRoot | Out-Null

function Assert-UnderTempFormalRoot {
    param([string]$Path)

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not $full.StartsWith($TempRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to modify path outside formal temp root: $full"
    }
}

function New-CleanDirectory {
    param([string]$Path)

    Assert-UnderTempFormalRoot $Path
    if (Test-Path $Path) {
        Remove-Item -LiteralPath $Path -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function New-Junction {
    param(
        [string]$Path,
        [string]$Target
    )

    if (Test-Path $Path) {
        Remove-Item -LiteralPath $Path -Force
    }
    New-Item -ItemType Junction -Path $Path -Target $Target | Out-Null
}

function Convert-PathForMarkdown {
    param([string]$Path)

    $resolved = Resolve-Path -LiteralPath $Path -ErrorAction SilentlyContinue
    if ($resolved) {
        return $resolved.Path.Replace($RepoRoot + "\", "").Replace("\", "/")
    }
    return $Path.Replace($RepoRoot + "\", "").Replace("\", "/")
}

function Stop-VivadoSimProcesses {
    Get-Process vivado,xsim,xsimk -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 800
}

function Wait-ForMainWindow {
    param(
        [string]$ProcessName,
        [string]$TitlePattern = "*",
        [int]$TimeoutSeconds = 60
    )

    for ($idx = 0; $idx -lt ($TimeoutSeconds * 2); $idx = $idx + 1) {
        $proc = Get-Process $ProcessName -ErrorAction SilentlyContinue |
            Where-Object { $_.MainWindowHandle -ne 0 -and $_.MainWindowTitle -like $TitlePattern } |
            Select-Object -First 1
        if ($proc) {
            return $proc
        }
        Start-Sleep -Milliseconds 500
    }
    return $null
}

function Test-LogContains {
    param(
        [string]$Path,
        [string]$Pattern
    )

    return (Test-Path $Path) -and (Select-String -Path $Path -Pattern $Pattern -Quiet -ErrorAction SilentlyContinue)
}

function Wait-ForLogPattern {
    param(
        [string]$Path,
        [string]$Pattern,
        [int]$TimeoutSeconds = 30
    )

    for ($idx = 0; $idx -lt ($TimeoutSeconds * 2); $idx = $idx + 1) {
        if (Test-LogContains -Path $Path -Pattern $Pattern) {
            return $true
        }
        Start-Sleep -Milliseconds 500
    }
    return $false
}

function New-BatchCaptureTcl {
    param(
        [string]$SourceTcl,
        [string]$GeneratedTcl,
        [string]$WcfgPath
    )

    $lines = Get-Content -LiteralPath $SourceTcl
    $lines += "save_wave_config {" + ($WcfgPath -replace "\\", "/") + "}"
    $lines += "quit"
    $content = [string]::Join("`r`n", [string[]]$lines)
    [System.IO.File]::WriteAllText($GeneratedTcl, $content, [System.Text.Encoding]::ASCII)
}

function New-OpenWaveDatabaseTcl {
    param(
        [string]$GeneratedTcl,
        [string]$WdbPath,
        [string]$WcfgPath
    )

    $content = (
        "open_wave_database {" + ($WdbPath -replace "\\", "/") + "}`r`n" +
        "open_wave_config {" + ($WcfgPath -replace "\\", "/") + "}`r`n" +
        "current_fileset`r`n"
    )
    [System.IO.File]::WriteAllText($GeneratedTcl, $content, [System.Text.Encoding]::ASCII)
}

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class VivadoWindowCap {
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
  [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr hwnd, IntPtr hDC, uint nFlags);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int X, int Y);
  [DllImport("user32.dll")] public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, UIntPtr dwExtraInfo);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }
}
"@

function Invoke-WindowClick {
    param(
        [int]$X,
        [int]$Y
    )

    [VivadoWindowCap]::SetCursorPos($X, $Y) | Out-Null
    Start-Sleep -Milliseconds 150
    [VivadoWindowCap]::mouse_event(0x0002, 0, 0, 0, [UIntPtr]::Zero)
    Start-Sleep -Milliseconds 80
    [VivadoWindowCap]::mouse_event(0x0004, 0, 0, 0, [UIntPtr]::Zero)
    Start-Sleep -Milliseconds 250
}

function Save-VivadoWaveScreenshot {
    param(
        [string]$OutputPng,
        [int]$WaitSeconds
    )

    $windowProc = Wait-ForMainWindow -ProcessName "vivado" -TitlePattern "Vivado*" -TimeoutSeconds $WaitSeconds
    if (-not $windowProc) {
        throw "Vivado GUI window not found"
    }

    [VivadoWindowCap]::ShowWindow($windowProc.MainWindowHandle, 3) | Out-Null
    [VivadoWindowCap]::SetForegroundWindow($windowProc.MainWindowHandle) | Out-Null
    $rect = New-Object VivadoWindowCap+RECT
    [VivadoWindowCap]::GetWindowRect($windowProc.MainWindowHandle, [ref]$rect) | Out-Null
    $width = $rect.Right - $rect.Left
    $height = $rect.Bottom - $rect.Top

    $wavePaneHeaderX = $rect.Left + [int]($width * 0.69)
    $wavePaneHeaderY = $rect.Top + [int]($height * 0.18)
    $zoomFullX = $rect.Left + [int]($width * 0.60)
    $zoomFullY = $rect.Top + [int]($height * 0.23)
    $wavePaneBodyX = $rect.Left + [int]($width * 0.85)
    $wavePaneBodyY = $rect.Top + [int]($height * 0.42)

    function New-WindowBitmap {
        param(
            [IntPtr]$WindowHandle,
            [int]$BitmapWidth,
            [int]$BitmapHeight
        )

        $capturedBitmap = New-Object System.Drawing.Bitmap -ArgumentList $BitmapWidth, $BitmapHeight
        $capturedGraphics = [System.Drawing.Graphics]::FromImage($capturedBitmap)
        $capturedHdc = $capturedGraphics.GetHdc()
        [VivadoWindowCap]::PrintWindow($WindowHandle, $capturedHdc, 0) | Out-Null
        $capturedGraphics.ReleaseHdc($capturedHdc)
        $capturedGraphics.Dispose()
        return $capturedBitmap
    }

    function Test-WaveRegionReady {
        param([System.Drawing.Bitmap]$Bitmap)

        $startX = [int]([Math]::Round($Bitmap.Width * 0.67))
        $endX = [int]([Math]::Round($Bitmap.Width * 0.97))
        $startY = [int]([Math]::Round($Bitmap.Height * 0.25))
        $endY = [int]([Math]::Round($Bitmap.Height * 0.68))
        $darkSamples = 0
        $totalSamples = 0

        for ($y = $startY; $y -lt $endY; $y = $y + 12) {
            for ($x = $startX; $x -lt $endX; $x = $x + 12) {
                $pixel = $Bitmap.GetPixel($x, $y)
                $brightness = ($pixel.R + $pixel.G + $pixel.B) / 3
                if ($brightness -lt 40) {
                    $darkSamples = $darkSamples + 1
                }
                $totalSamples = $totalSamples + 1
            }
        }

        if ($totalSamples -eq 0) {
            return $false
        }
        return $darkSamples -ge [int]([Math]::Ceiling($totalSamples * 0.10))
    }

    $waveReady = $false
    for ($idx = 0; $idx -lt $WaitSeconds; $idx = $idx + 1) {
        $probeBitmap = New-WindowBitmap -WindowHandle $windowProc.MainWindowHandle -BitmapWidth $width -BitmapHeight $height
        try {
            if (Test-WaveRegionReady -Bitmap $probeBitmap) {
                $waveReady = $true
                break
            }
        } finally {
            $probeBitmap.Dispose()
        }
        Start-Sleep -Seconds 1
    }

    if (-not $waveReady) {
        throw "Wave region never rendered before screenshot"
    }

    Invoke-WindowClick -X $wavePaneHeaderX -Y $wavePaneHeaderY
    Invoke-WindowClick -X $zoomFullX -Y $zoomFullY
    Invoke-WindowClick -X $wavePaneBodyX -Y $wavePaneBodyY
    Start-Sleep -Seconds 2

    $bitmap = New-WindowBitmap -WindowHandle $windowProc.MainWindowHandle -BitmapWidth $width -BitmapHeight $height

    $cropLeft = [int]([Math]::Round($width * 0.48))
    $cropTop = [int]([Math]::Round($height * 0.17))
    $cropRight = [int]([Math]::Round($width * 0.99))
    $cropBottom = [int]([Math]::Round($height * 0.71))
    $cropRect = New-Object System.Drawing.Rectangle -ArgumentList $cropLeft, $cropTop, ($cropRight - $cropLeft), ($cropBottom - $cropTop)
    $croppedBitmap = $bitmap.Clone($cropRect, $bitmap.PixelFormat)

    New-Item -ItemType Directory -Force -Path (Split-Path $OutputPng) | Out-Null
    $croppedBitmap.Save($OutputPng, [System.Drawing.Imaging.ImageFormat]::Png)

    $croppedBitmap.Dispose()
    $bitmap.Dispose()
}

function Invoke-BatchWaveGeneration {
    param(
        [string]$Snapshot,
        [string]$BatchTcl,
        [string]$WdbPath,
        [string]$BatchLog,
        [string]$WorkingDirectory
    )

    $xsimBat = Join-Path $VivadoBin "xsim.bat"
    $proc = Start-Process -FilePath $xsimBat -WorkingDirectory $WorkingDirectory -ArgumentList @(
        $Snapshot,
        "-tclbatch", ($BatchTcl -replace "\\", "/"),
        "-wdb", ($WdbPath -replace "\\", "/"),
        "-log", ($BatchLog -replace "\\", "/")
    ) -PassThru -Wait

    if ($proc.ExitCode -ne 0) {
        throw "xsim batch generation failed with exit code $($proc.ExitCode)"
    }
}

function Invoke-VivadoWaveOpen {
    param(
        [string]$OpenTcl,
        [string]$VivadoLog,
        [string]$WorkingDirectory
    )

    $vivadoBat = Join-Path $VivadoBin "vivado.bat"
    return Start-Process -FilePath $vivadoBat -ArgumentList @(
        "-mode", "gui",
        "-source", ($OpenTcl -replace "\\", "/"),
        "-log", ($VivadoLog -replace "\\", "/"),
        "-journal", (($VivadoLog -replace "\.log$", ".jou") -replace "\\", "/")
    ) -WorkingDirectory $WorkingDirectory -PassThru
}

New-CleanDirectory $WorkRoot
New-Junction (Join-Path $WorkRoot "rtl") (Join-Path $RepoRoot "01_source_code\rtl")
New-Junction (Join-Path $WorkRoot "tb") (Join-Path $RepoRoot "04_tb_tests\tb")
New-Junction (Join-Path $WorkRoot "sim") (Join-Path $RepoRoot "02_vivado_project_and_sim\sim")

$BuildScript = Join-Path $RepoRoot "02_vivado_project_and_sim\vivado\build_one_xsim_snapshot.ps1"
$TclRoot = Join-Path $RepoRoot "02_vivado_project_and_sim\vivado\formal_wave_tcl"

$Cases = @(
    @{
        id = "01_raw8_main_path_xsim"
        title = "RAW8 主链路 frame/line/pixel 闭合"
        top = "tb_fpga_wrapper_raw8_smoke"
        test = "tb\tests\tb_fpga_wrapper_raw8_smoke.sv"
        snapshot = "snap_formal_raw8_main_20260521"
        tcl = "tb_fpga_wrapper_raw8_formal.tcl"
        run_window = "0-650 ns"
        key_events = "保留 500 ns 后 frame_start/line_start/pixel_valid/line_end/frame_end 单帧闭合跳变"
    },
    @{
        id = "02_crc_error_xsim"
        title = "CRC 错误注入"
        top = "tb_fpga_wrapper_crc_error"
        test = "tb\tests\tb_fpga_wrapper_crc_error.sv"
        snapshot = "snap_formal_crc_error_20260521"
        tcl = "tb_fpga_wrapper_crc_formal.tcl"
        run_window = "0-750 ns"
        key_events = "保留 err_crc_o 脉冲和 err_cnt_crc_o 从 0 到 1 的计数跳变"
    },
    @{
        id = "03_ecc_error_xsim"
        title = "Header ECC 错误注入"
        top = "tb_fpga_wrapper_ecc_error"
        test = "tb\tests\tb_fpga_wrapper_ecc_error.sv"
        snapshot = "snap_formal_ecc_error_20260521"
        tcl = "tb_fpga_wrapper_ecc_formal.tcl"
        run_window = "0-500 ns"
        key_events = "保留 err_ecc_o 脉冲和 err_cnt_ecc_o 计数跳变"
    },
    @{
        id = "04_resync_recovery_xsim"
        title = "resync 恢复链"
        top = "tb_fpga_wrapper_resync_metrics"
        test = "tb\tests\tb_fpga_wrapper_resync_metrics.sv"
        snapshot = "snap_formal_resync_recovery_20260521"
        tcl = "tb_fpga_wrapper_resync_formal.tcl"
        run_window = "0-650 ns"
        key_events = "保留 err_sync_o、resync_req、resync_busy、clear、done 的连续恢复跳变"
    },
    @{
        id = "05_lane_skew_overflow_xsim"
        title = "lane skew overflow"
        top = "tb_fpga_wrapper_lane_skew_overflow"
        test = "tb\tests\tb_fpga_wrapper_lane_skew_overflow.sv"
        snapshot = "snap_formal_lane_skew_20260521"
        tcl = "tb_fpga_wrapper_lane_skew_formal.tcl"
        run_window = "0-330 ns"
        key_events = "保留 sensor_lane_ready 回压和 err_overflow_o 触发跳变"
    },
    @{
        id = "06_axi_backpressure_xsim"
        title = "AXI AW/W 背压"
        top = "tb_fpga_wrapper_axi_backpressure"
        test = "tb\tests\tb_fpga_wrapper_axi_backpressure.sv"
        snapshot = "snap_formal_axi_backpressure_20260521"
        tcl = "tb_fpga_wrapper_axi_backpressure_formal.tcl"
        run_window = "0-900 ns"
        key_events = "保留 AW/W ready 阻塞、valid 保持、背压释放和 axi_busy 变化"
    },
    @{
        id = "07_resync_clean_frame_xsim"
        title = "resync 后 clean frame 恢复输出"
        top = "tb_fpga_wrapper_resync_clean_frame"
        test = "tb\tests\tb_fpga_wrapper_resync_clean_frame.sv"
        snapshot = "snap_formal_resync_clean_frame_20260521"
        tcl = "tb_fpga_wrapper_resync_clean_frame_formal.tcl"
        run_window = "0-1550 ns"
        key_events = "保留 900 ns 后 clean frame 重新输出 frame/line/pixel 的闭合跳变"
    }
)

if ($CaseId.Count -gt 0) {
    $Cases = @($Cases | Where-Object { $CaseId -contains $_.id })
    if ($Cases.Count -eq 0) {
        throw "No waveform case matched CaseId: $($CaseId -join ', ')"
    }
}

$Rows = @()

foreach ($case in $Cases) {
    Stop-VivadoSimProcesses

    $caseLogRoot = Join-Path $LogRoot $case.id
    New-Item -ItemType Directory -Force -Path $caseLogRoot | Out-Null
    $caseTempRoot = Join-Path $AsciiCaptureRoot $case.id
    New-CleanDirectory $caseTempRoot

    $png = Join-Path $WaveRoot ($case.id + ".png")
    $batchLog = Join-Path $caseTempRoot "xsim_batch.log"
    $vivadoLog = Join-Path $caseTempRoot "vivado_open.log"
    $wdbPath = Join-Path $caseTempRoot ($case.id + ".wdb")
    $wcfgPath = Join-Path $caseTempRoot ($case.id + ".wcfg")
    $batchTcl = Join-Path $caseTempRoot "capture_batch.tcl"
    $openTcl = Join-Path $caseTempRoot "open_wave_db.tcl"
    $tclPath = Join-Path $TclRoot $case.tcl

    $status = "PASS"
    $note = ""

    try {
        Push-Location $WorkRoot
        try {
            powershell -NoProfile -ExecutionPolicy Bypass -File $BuildScript `
                -Name $case.id `
                -Top $case.top `
                -TestFile $case.test `
                -Snapshot $case.snapshot `
                -VivadoBin $VivadoBin `
                -RepoRoot $WorkRoot `
                -OutTag "formal_reverification_20260521" | Tee-Object -FilePath (Join-Path $caseLogRoot "build_stdout.log") | Out-Null

            New-BatchCaptureTcl -SourceTcl $tclPath -GeneratedTcl $batchTcl -WcfgPath $wcfgPath
            Invoke-BatchWaveGeneration -Snapshot $case.snapshot -BatchTcl $batchTcl -WdbPath $wdbPath -BatchLog $batchLog -WorkingDirectory $WorkRoot

            if (-not (Test-Path $wdbPath)) {
                throw "WDB was not created"
            }
            if (-not (Test-Path $wcfgPath)) {
                throw "WCFG was not created"
            }
            if (-not (Test-LogContains -Path $batchLog -Pattern "## run ")) {
                throw "xsim batch log did not reach the run command"
            }

            New-OpenWaveDatabaseTcl -GeneratedTcl $openTcl -WdbPath $wdbPath -WcfgPath $wcfgPath
            $vivadoProc = Invoke-VivadoWaveOpen -OpenTcl $openTcl -VivadoLog $vivadoLog -WorkingDirectory $WorkRoot

            if (-not (Wait-ForLogPattern -Path $vivadoLog -Pattern "open_wave_database" -TimeoutSeconds $WaitSeconds)) {
                throw "Vivado log did not open the wave database"
            }

            Start-Sleep -Seconds 5

            Save-VivadoWaveScreenshot -OutputPng $png -WaitSeconds $WaitSeconds
            if (-not (Test-Path $png)) {
                throw "PNG was not created"
            }

            Stop-VivadoSimProcesses
        } finally {
            Pop-Location
        }

        Copy-Item -LiteralPath $batchLog -Destination (Join-Path $caseLogRoot "xsim_batch.log") -Force
        Copy-Item -LiteralPath $vivadoLog -Destination (Join-Path $caseLogRoot "vivado_open.log") -Force
        Copy-Item -LiteralPath $batchTcl -Destination (Join-Path $caseLogRoot "capture_batch.tcl") -Force
        Copy-Item -LiteralPath $openTcl -Destination (Join-Path $caseLogRoot "open_wave_db.tcl") -Force
    } catch {
        $status = "FAIL"
        $note = $_.Exception.Message
        Stop-VivadoSimProcesses
    }

    $Rows += [PSCustomObject]@{
        id = $case.id
        title = $case.title
        top = $case.top
        run_window = $case.run_window
        key_events = $case.key_events
        status = $status
        png = Convert-PathForMarkdown $png
        tcl = Convert-PathForMarkdown $tclPath
        batch_log = Convert-PathForMarkdown (Join-Path $caseLogRoot "xsim_batch.log")
        vivado_log = Convert-PathForMarkdown (Join-Path $caseLogRoot "vivado_open.log")
        note = $note
    }
}

$Lines = @()
$Lines += "# 2026-05-21 正式波形截图汇总"
$Lines += ""
$Lines += "## 截图原则"
$Lines += ""
$Lines += "- 所有截图均先由 XSim batch 生成 WDB/WCFG，再由 Vivado 2017.3 GUI 打开静态波形库截图。"
$Lines += "- 截图前聚焦 Wave pane，并裁切到单独的波形子窗口区域。"
$Lines += "- 每个 Tcl 只运行到指定时间窗，截图必须保留对应关键跳变。"
$Lines += "- 波形 GUI 不并行抓取，避免窗口焦点和布局互相干扰。"
$Lines += ""
$Lines += "## 波形截图表"
$Lines += ""
$Lines += "| 编号 | 主题 | top | 时间窗 | 必须保留的关键跳变 | 状态 | 截图 | Tcl | XSim batch 日志 | Vivado 打开日志 | 备注 |"
$Lines += "| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |"

foreach ($row in $Rows) {
    $note = ($row.note -replace '\|', '\\|')
    $Lines += "| $($row.id) | $($row.title) | $($row.top) | $($row.run_window) | $($row.key_events) | $($row.status) | $($row.png) | $($row.tcl) | $($row.batch_log) | $($row.vivado_log) | $note |"
}

$SummaryPath = Join-Path $OutRoot "wave_capture_summary.md"
$TablePath = Join-Path $TableRoot "wave_capture_results.md"
Set-Content -LiteralPath $SummaryPath -Value $Lines -Encoding UTF8
Set-Content -LiteralPath $TablePath -Value $Lines -Encoding UTF8

Write-Host "Wrote $SummaryPath"
Write-Host "Wrote $TablePath"
$failCount = @($Rows | Where-Object { $_.status -ne "PASS" }).Count
Write-Host "SUMMARY: waves=$($Rows.Count) failed=$failCount"
