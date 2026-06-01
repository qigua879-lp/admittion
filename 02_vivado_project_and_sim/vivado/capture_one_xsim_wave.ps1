param(
    [Parameter(Mandatory = $true)][string]$Snapshot,
    [Parameter(Mandatory = $true)][string]$TclPath,
    [Parameter(Mandatory = $true)][string]$LogPath,
    [Parameter(Mandatory = $true)][string]$OutputPng,
    [string]$VivadoBin = "D:\Xilinx\Vivado\2017.3\bin",
    [string]$RepoRoot = "C:\mipi_all",
    [int]$WaitSeconds = 40,
    [switch]$MaximizeWavePane,
    [double]$CropLeftRatio = 0.00,
    [double]$CropTopRatio = 0.00,
    [double]$CropRightRatio = 1.00,
    [double]$CropBottomRatio = 1.00
)

$ErrorActionPreference = "Stop"

Get-Process xsim,xsimk -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 800

$XsimBat = Join-Path $VivadoBin "xsim.bat"
Start-Process -FilePath $XsimBat -WorkingDirectory $RepoRoot -ArgumentList @(
    $Snapshot,
    "-gui",
    "-onfinish", "stop",
    "-tclbatch", ($TclPath -replace "\\", "/"),
    "-log", ($LogPath -replace "\\", "/")
) -PassThru | Out-Null

Start-Sleep -Seconds $WaitSeconds

$LogReady = $false
for ($idx = 0; $idx -lt 60; $idx = $idx + 1) {
    if ((Test-Path $LogPath) -and (Select-String -Path $LogPath -Pattern "## run " -Quiet -ErrorAction SilentlyContinue)) {
        $LogReady = $true
        break
    }
    Start-Sleep -Milliseconds 500
}

if (-not $LogReady) {
    throw "Vivado XSim tcl batch did not reach the run command"
}

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class XSimWindowCap {
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
  [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr hwnd, IntPtr hDC, uint nFlags);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int X, int Y);
  [DllImport("user32.dll")] public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, UIntPtr dwExtraInfo);
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }
}
"@

$WindowProc = $null
for ($idx = 0; $idx -lt 60; $idx = $idx + 1) {
    $WindowProc = Get-Process xsim -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowHandle -ne 0 } |
        Select-Object -First 1
    if ($WindowProc) {
        break
    }
    Start-Sleep -Milliseconds 500
}

if (-not $WindowProc) {
    throw "Vivado XSim simulation window not found"
}

[XSimWindowCap]::ShowWindow($WindowProc.MainWindowHandle, 3) | Out-Null
[XSimWindowCap]::SetForegroundWindow($WindowProc.MainWindowHandle) | Out-Null
Start-Sleep -Seconds 1

$Rect = New-Object XSimWindowCap+RECT
[XSimWindowCap]::GetWindowRect($WindowProc.MainWindowHandle, [ref]$Rect) | Out-Null
$Width = $Rect.Right - $Rect.Left
$Height = $Rect.Bottom - $Rect.Top

function Invoke-WindowClick {
    param(
        [int]$X,
        [int]$Y
    )

    [XSimWindowCap]::SetCursorPos($X, $Y) | Out-Null
    Start-Sleep -Milliseconds 150
    [XSimWindowCap]::mouse_event(0x0002, 0, 0, 0, [UIntPtr]::Zero)
    Start-Sleep -Milliseconds 80
    [XSimWindowCap]::mouse_event(0x0004, 0, 0, 0, [UIntPtr]::Zero)
    Start-Sleep -Milliseconds 250
}

$WaveTabX = $Rect.Left + [int]($Width * 0.52)
$WaveTabY = $Rect.Top + [int]($Height * 0.19)
$ZoomFullX = $Rect.Left + [int]($Width * 0.60)
$ZoomFullY = $Rect.Top + [int]($Height * 0.23)
$WavePaneBodyX = $Rect.Left + [int]($Width * 0.78)
$WavePaneBodyY = $Rect.Top + [int]($Height * 0.34)
$WavePaneMaxX = $Rect.Left + [int]($Width * 0.955)
$WavePaneMaxY = $Rect.Top + [int]($Height * 0.19)

Invoke-WindowClick -X $WaveTabX -Y $WaveTabY
Invoke-WindowClick -X $ZoomFullX -Y $ZoomFullY

if ($MaximizeWavePane) {
    Invoke-WindowClick -X $WavePaneBodyX -Y $WavePaneBodyY
    Invoke-WindowClick -X $WavePaneMaxX -Y $WavePaneMaxY
}

Start-Sleep -Seconds 2

$Bitmap = New-Object System.Drawing.Bitmap $Width, $Height
$Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)
$Hdc = $Graphics.GetHdc()
[XSimWindowCap]::PrintWindow($WindowProc.MainWindowHandle, $Hdc, 0) | Out-Null
$Graphics.ReleaseHdc($Hdc)

New-Item -ItemType Directory -Force -Path (Split-Path $OutputPng) | Out-Null
$CropLeft = [Math]::Max(0, [Math]::Min($Width - 1, [int]([Math]::Round($Width * $CropLeftRatio))))
$CropTop = [Math]::Max(0, [Math]::Min($Height - 1, [int]([Math]::Round($Height * $CropTopRatio))))
$CropRight = [Math]::Max($CropLeft + 1, [Math]::Min($Width, [int]([Math]::Round($Width * $CropRightRatio))))
$CropBottom = [Math]::Max($CropTop + 1, [Math]::Min($Height, [int]([Math]::Round($Height * $CropBottomRatio))))
$CropWidth = $CropRight - $CropLeft
$CropHeight = $CropBottom - $CropTop

if (($CropWidth -lt $Width) -or ($CropHeight -lt $Height)) {
    $CropRect = New-Object System.Drawing.Rectangle($CropLeft, $CropTop, $CropWidth, $CropHeight)
    $CroppedBitmap = $Bitmap.Clone($CropRect, $Bitmap.PixelFormat)
    $CroppedBitmap.Save($OutputPng, [System.Drawing.Imaging.ImageFormat]::Png)
    $CroppedBitmap.Dispose()
} else {
    $Bitmap.Save($OutputPng, [System.Drawing.Imaging.ImageFormat]::Png)
}

$Graphics.Dispose()
$Bitmap.Dispose()

Get-Process xsim,xsimk -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host "Captured $OutputPng"
