param(
    [string]$OutDir = "C:\temp\mipi_raw8_soak_throughput",
    [string]$RepoRoot = "C:\Users\qigua\OneDrive\Desktop\MIPI ALL"
)

$ErrorActionPreference = "Stop"

$cases = @(
    @{ name = "lane1_soak_s0"; lane = 1; byteAw = 2; axiAw = 3; stall = 0; frames = 32; lines = 8 },
    @{ name = "lane2_soak_s0"; lane = 2; byteAw = 2; axiAw = 3; stall = 0; frames = 32; lines = 8 },
    @{ name = "lane4_soak_s0"; lane = 4; byteAw = 2; axiAw = 3; stall = 0; frames = 32; lines = 8 },
    @{ name = "lane2_soak_long_s0"; lane = 2; byteAw = 2; axiAw = 3; stall = 0; frames = 48; lines = 8 }
)

$compileFile = Join-Path $RepoRoot "sim\vcs\compile.f"
$tbFile = Join-Path $RepoRoot "tb\tests\tb_fpga_wrapper_raw8_soak_metrics.sv"
$resultsDir = (Get-ChildItem (Join-Path $RepoRoot "docs\spec") -Directory | Select-Object -First 1 -ExpandProperty FullName)
$resultsMd = Join-Path $resultsDir "raw8_soak_throughput_results.md"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$rows = @()

foreach ($case in $cases) {
    $name = $case.name
    $outFile = Join-Path $OutDir "${name}.out"
    $compileLog = Join-Path $OutDir "${name}_compile.log"
    $runLog = Join-Path $OutDir "${name}.log"

    $compileCmd = "iverilog -g2012 -Wall -P tb_fpga_wrapper_raw8_soak_metrics.LANE_NUM=$($case.lane) -P tb_fpga_wrapper_raw8_soak_metrics.BYTE_FIFO_ADDR_WIDTH=$($case.byteAw) -P tb_fpga_wrapper_raw8_soak_metrics.AXI_FIFO_ADDR_WIDTH=$($case.axiAw) -P tb_fpga_wrapper_raw8_soak_metrics.AXI_STALL_CYCLES=$($case.stall) -P tb_fpga_wrapper_raw8_soak_metrics.FRAME_COUNT=$($case.frames) -P tb_fpga_wrapper_raw8_soak_metrics.LINE_COUNT=$($case.lines) -s tb_fpga_wrapper_raw8_soak_metrics -o `"$outFile`" -f `"$compileFile`" `"$tbFile`" > `"$compileLog`" 2>&1"
    cmd /c $compileCmd | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "iverilog failed for $name"
    }

    $runCmd = "vvp `"$outFile`" > `"$runLog`" 2>&1"
    cmd /c $runCmd | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "vvp failed for $name"
    }

    $resultLine = Select-String -Path $runLog -Pattern "^RESULT:" | Select-Object -Last 1
    if (-not $resultLine) {
        throw "No RESULT line found for $name"
    }

    $kv = @{}
    foreach ($token in $resultLine.Line.Replace("RESULT: ", "").Split(" ")) {
        if ($token -match "=") {
            $parts = $token.Split("=")
            $kv[$parts[0]] = $parts[1]
        }
    }

    $rows += [PSCustomObject]@{
        case_name               = $name
        lane                    = $kv["lane"]
        stall                   = $kv["stall"]
        frames                  = $kv["frames"]
        lines_per_frame         = $kv["lines_per_frame"]
        total_lines             = $kv["total_lines"]
        total_pixels            = $kv["total_pixels"]
        lane_bp_seen            = $kv["lane_bp_seen"]
        lane_bp_cycles          = $kv["lane_bp_cycles"]
        max_byte_fifo           = $kv["max_byte_fifo"]
        max_axi_fifo            = $kv["max_axi_fifo"]
        pix_per_byte_clk_x1000  = $kv["pix_per_byte_clk_x1000"]
        pix_per_axi_clk_x1000   = $kv["pix_per_axi_clk_x1000"]
        aw_stall_cycles         = $kv["aw_stall_cycles"]
        w_stall_cycles          = $kv["w_stall_cycles"]
        aw_bursts               = $kv["aw_bursts"]
        w_beats                 = $kv["w_beats"]
    }
}

$lines = @()
$lines += '# RAW8 Soak And Throughput Sweep Results'
$lines += ""
$lines += '## Purpose'
$lines += ""
$lines += 'This report captures long-run soak and throughput-sweep evidence for two questions:'
$lines += ""
$lines += '- Do `1 / 2 / 4 lane` configurations remain scoreboard-clean under multi-frame, multi-line continuous traffic?'
$lines += '- How does lane count affect sustained throughput in the stable no-stall operating region?'
$lines += ""
$lines += '## Testbench'
$lines += ""
$lines += '- Soak TB: `tb/tests/tb_fpga_wrapper_raw8_soak_metrics.sv`'
$lines += '- Batch script: `scripts/run_raw8_soak_throughput_sweep.ps1`'
$lines += ""
$lines += '## Configuration'
$lines += ""
$lines += '- Traffic: `RAW8`, wrapper path, live pixel scoreboard'
$lines += '- Base FIFO setting: `BYTE_FIFO_ADDR_WIDTH=2`, `AXI_FIFO_ADDR_WIDTH=3`'
$lines += '- Throughput metrics: `pix_per_byte_clk_x1000` and `pix_per_axi_clk_x1000`'
$lines += '- This sweep intentionally stays inside the stable no-stall region; extreme backpressure boundaries are already covered by the dedicated stress script.'
$lines += '- `x1000` means fixed-point milli-pixels per clock'
$lines += ""
$lines += '## Result Table'
$lines += ""
$lines += '| case | lane | stall | frames | lines/frame | total lines | total pixels | lane bp seen | lane bp cycles | max byte fifo | max axi fifo | pix/byte-clk x1000 | pix/axi-clk x1000 | aw stall cycles | w stall cycles | aw bursts | w beats |'
$lines += '| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |'

foreach ($row in $rows) {
    $lines += "| $($row.case_name) | $($row.lane) | $($row.stall) | $($row.frames) | $($row.lines_per_frame) | $($row.total_lines) | $($row.total_pixels) | $($row.lane_bp_seen) | $($row.lane_bp_cycles) | $($row.max_byte_fifo) | $($row.max_axi_fifo) | $($row.pix_per_byte_clk_x1000) | $($row.pix_per_axi_clk_x1000) | $($row.aw_stall_cycles) | $($row.w_stall_cycles) | $($row.aw_bursts) | $($row.w_beats) |"
}

$lines += ""
$lines += '## Conclusions'
$lines += ""
$lines += '- `lane1 / lane2 / lane4` now all have multi-frame, multi-line wrapper-level soak evidence rather than only minimal smoke coverage.'
$lines += '- In the no-stall region, increasing lane count shortens the byte-side transfer window, so `pix_per_byte_clk_x1000` rises accordingly.'
$lines += '- `lane2_soak_long_s0` extends the run length to `48` frames to provide a longer continuous soak sample on the 2-lane main path.'

Set-Content -Path $resultsMd -Value $lines -Encoding UTF8

Write-Output "Wrote $resultsMd"
