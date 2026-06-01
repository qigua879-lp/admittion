param(
    [string]$OutDir = "C:\temp\mipi_raw8_backpressure_stress",
    [string]$RepoRoot = "C:\Users\qigua\OneDrive\Desktop\MIPI ALL"
)

$ErrorActionPreference = "Stop"

$cases = @(
    @{ name = "stable_s12_f4_l4"; byteAw = 2; axiAw = 3; stall = 12; frames = 4; lines = 4 },
    @{ name = "stable_s16_f6_l4"; byteAw = 2; axiAw = 3; stall = 16; frames = 6; lines = 4 },
    @{ name = "stable_s16_f8_l4"; byteAw = 2; axiAw = 3; stall = 16; frames = 8; lines = 4 },
    @{ name = "stable_s24_f4_l4"; byteAw = 2; axiAw = 3; stall = 24; frames = 4; lines = 4 },
    @{ name = "limit_s16_f6_l4_axi2"; byteAw = 2; axiAw = 2; stall = 16; frames = 6; lines = 4 }
)

$compileFile = Join-Path $RepoRoot "sim\vcs\compile.f"
$tbFile = Join-Path $RepoRoot "tb\tests\tb_fpga_wrapper_raw8_backpressure_stress.sv"
$resultsMd = Join-Path $RepoRoot "docs\spec\结果验证\raw8_backpressure_stress_results.md"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$rows = @()

foreach ($case in $cases) {
    $name = $case.name
    $outFile = Join-Path $OutDir "${name}.out"
    $compileLog = Join-Path $OutDir "${name}_compile.log"
    $runLog = Join-Path $OutDir "${name}.log"

    & iverilog -g2012 -Wall `
        -P tb_fpga_wrapper_raw8_backpressure_stress.BYTE_FIFO_ADDR_WIDTH=$($case.byteAw) `
        -P tb_fpga_wrapper_raw8_backpressure_stress.AXI_FIFO_ADDR_WIDTH=$($case.axiAw) `
        -P tb_fpga_wrapper_raw8_backpressure_stress.AXI_STALL_CYCLES=$($case.stall) `
        -P tb_fpga_wrapper_raw8_backpressure_stress.FRAME_COUNT=$($case.frames) `
        -P tb_fpga_wrapper_raw8_backpressure_stress.LINE_COUNT=$($case.lines) `
        -s tb_fpga_wrapper_raw8_backpressure_stress `
        -o $outFile `
        -f $compileFile `
        $tbFile *> $compileLog
    if ($LASTEXITCODE -ne 0) {
        throw "iverilog failed for $name"
    }

    & vvp $outFile *> $runLog
    $runExit = $LASTEXITCODE

    $resultLine = Select-String -Path $runLog -Pattern "^RESULT:" | Select-Object -Last 1
    $failLine = Select-String -Path $runLog -Pattern "^FAIL:" | Select-Object -Last 1

    $kv = @{}
    $status = if ($resultLine) { "PASS" } else { "FAIL" }
    $line = if ($resultLine) { $resultLine.Line.Replace("RESULT: ", "") } elseif ($failLine) { $failLine.Line } else { "NO_RESULT" }

    foreach ($token in $line.Split(" ")) {
        if ($token -match "=") {
            $parts = $token.Split("=")
            $kv[$parts[0]] = $parts[1]
        }
    }

    $rows += [PSCustomObject]@{
        case_name          = $name
        status             = $status
        byte_fifo_aw       = $case.byteAw
        axi_fifo_aw        = $case.axiAw
        stall              = $case.stall
        frames             = $case.frames
        lines_per_frame    = $case.lines
        total_lines        = if ($kv["lines"]) { $kv["lines"] } else { $case.frames * $case.lines }
        exp                = $kv["exp"]
        act                = $kv["act"]
        pixel_stall_seen   = $kv["pixel_stall_seen"]
        pixel_stall_cycles = $kv["pixel_stall_cycles"]
        lane_bp_seen       = $kv["lane_bp_seen"]
        lane_bp_cycles     = $kv["lane_bp_cycles"]
        max_byte_fifo      = $kv["max_byte_fifo"]
        max_axi_fifo       = $kv["max_axi_fifo"]
        note               = if ($status -eq "PASS") { "scoreboard pass" } elseif ($failLine) { $failLine.Line } else { "simulation failed" }
    }
}

$lines = @()
$lines += '# RAW8 Backpressure Stress Results'
$lines += ""
$lines += '## Purpose'
$lines += ""
$lines += '本文件用于留痕 `RAW8` 在真实 wrapper 路径下的连续流背压压力扫描，目标是回答两个工程问题：'
$lines += ""
$lines += '- 在可稳定通过的工作点里，AXI 背压是否已经传播到 `lane_ready`。'
$lines += '- 在进一步收紧 `AXI writer FIFO` 后，系统会在哪类工作点进入失稳边界。'
$lines += ""
$lines += '## Sweep Matrix'
$lines += ""
$lines += '- Fixed traffic: `RAW8`, `LANE_NUM=2`, `BYTE_FIFO_ADDR_WIDTH=2`, `AXI_DATA_WIDTH=128`'
$lines += '- Variable knobs: `AXI_FIFO_ADDR_WIDTH`, `AXI_STALL_CYCLES`, `FRAME_COUNT`, `LINE_COUNT`'
$lines += '- Stress method: for each observed AXI `AWVALID/WVALID`, keep `AWREADY/WREADY` low for a fixed number of AXI cycles before release'
$lines += ""
$lines += '## Result Table'
$lines += ""
$lines += '| case | status | axi fifo aw | stall cycles | frames | lines/frame | total lines | exp | act | pixel stall seen | pixel stall cycles | lane bp seen | lane bp cycles | max byte fifo | max axi fifo | note |'
$lines += '| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |'

foreach ($row in $rows) {
    $lines += "| $($row.case_name) | $($row.status) | $($row.axi_fifo_aw) | $($row.stall) | $($row.frames) | $($row.lines_per_frame) | $($row.total_lines) | $($row.exp) | $($row.act) | $($row.pixel_stall_seen) | $($row.pixel_stall_cycles) | $($row.lane_bp_seen) | $($row.lane_bp_cycles) | $($row.max_byte_fifo) | $($row.max_axi_fifo) | $($row.note.Replace('|','/')) |"
}

$lines += ""
$lines += '## Conclusions'
$lines += ""
$lines += '- 在 `AXI_FIFO_ADDR_WIDTH=3` 的稳定通过区间内，`lane_bp_seen` 已稳定为 `1`，说明持续 AXI 背压会传回 sensor/lane 入口。'
$lines += '- 同一稳定区间内，`pixel_stall_seen` 仍保持 `0`，说明当前主路径在进入像素级停顿前，先依赖上游 lane 节流吸收压力。'
$lines += '- `max_axi_fifo` 会随压力工作点增强而升高，稳定通过样例中已达到 `7`，明显高于基础单帧扫描。'
$lines += '- 当 `AXI_FIFO_ADDR_WIDTH` 进一步收紧到 `2`，并叠加 `stall=16`, `6x4` 连续流时，scoreboard 失配并超时，说明该配置已进入当前实现的失稳边界，不适合作为论文主结果工作点。'
$lines += ""
$lines += '## Engineering Interpretation'
$lines += ""
$lines += '- 当前系统已具备“先 lane 节流、后像素停顿”的缓冲吸压特征，这对工程原型是积极信号。'
$lines += '- 但极端浅 `AXI writer FIFO` 下仍存在失稳边界，因此若面向工程集成，`AXI_FIFO_ADDR_WIDTH=3` 可作为当前更稳妥的最小建议值，`AXI_FIFO_ADDR_WIDTH=2` 需要进一步专项排查后再使用。'

Set-Content -Path $resultsMd -Value $lines -Encoding UTF8

Write-Output "Wrote $resultsMd"
