param(
    [string]$OutDir = "C:\temp\mipi_axi_mem_lane_regression",
    [string]$RepoRoot = "C:\Users\qigua\OneDrive\Desktop\MIPI ALL"
)

$ErrorActionPreference = "Stop"

$laneCases = @(1, 2, 4)
$compileFile = Join-Path $RepoRoot "sim\vcs\compile.f"
$tbFile = Join-Path $RepoRoot "tb\tests\tb_fpga_wrapper_axi_mem_closure.sv"
$resultsDir = (Get-ChildItem (Join-Path $RepoRoot "docs\spec") -Directory | Select-Object -First 1 -ExpandProperty FullName)
$resultsMd = Join-Path $resultsDir "axi_mem_lane_regression_results.md"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$rows = @()

foreach ($laneNum in $laneCases) {
    $name = "lane${laneNum}"
    $outFile = Join-Path $OutDir "${name}.out"
    $compileLog = Join-Path $OutDir "${name}_compile.log"
    $runLog = Join-Path $OutDir "${name}.log"

    $compileCmd = "iverilog -g2012 -Wall -P tb_fpga_wrapper_axi_mem_closure.LANE_NUM=$laneNum -s tb_fpga_wrapper_axi_mem_closure -o `"$outFile`" -f `"$compileFile`" `"$tbFile`" > `"$compileLog`" 2>&1"
    cmd /c $compileCmd | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "iverilog failed for $name"
    }

    $runCmd = "vvp `"$outFile`" > `"$runLog`" 2>&1"
    cmd /c $runCmd | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "vvp failed for $name"
    }

    $passLine = Select-String -Path $runLog -Pattern "^PASS: tb_fpga_wrapper_axi_mem_closure" | Select-Object -Last 1
    if (-not $passLine) {
        throw "No PASS line found for $name"
    }

    $kv = @{}
    foreach ($token in $passLine.Line.Replace("PASS: tb_fpga_wrapper_axi_mem_closure ", "").Split(" ")) {
        if ($token -match "=") {
            $parts = $token.Split("=")
            $kv[$parts[0]] = $parts[1]
        }
    }

    $rows += [PSCustomObject]@{
        lane_num  = $kv["lane"]
        lines     = $kv["lines"]
        exp       = $kv["exp"]
        act       = $kv["act"]
        aw_bursts = $kv["aw_bursts"]
        w_beats   = $kv["w_beats"]
    }
}

$lines = @()
$lines += '# AXI Memory Lane Regression Results'
$lines += ""
$lines += '## Purpose'
$lines += ""
$lines += 'This report captures wrapper-level AXI write closure plus readback-scoreboard evidence across `1 / 2 / 4 lane` configurations.'
$lines += ""
$lines += '## Testbench'
$lines += ""
$lines += '- Closure TB: `tb/tests/tb_fpga_wrapper_axi_mem_closure.sv`'
$lines += '- Batch script: `scripts/run_axi_mem_lane_regression.ps1`'
$lines += '- Method: feed expected RAW8 pixels into the scoreboard, wait for AXI writes to drain, then read back the wrapper''s internal AXI sink memory and feed that stream into the same scoreboard as the actual path.'
$lines += ""
$lines += '## Configuration'
$lines += ""
$lines += '- Traffic: `RAW8`, single-frame, `LINE_COUNT=1`'
$lines += '- Lane sweep: `LANE_NUM in {1, 2, 4}`'
$lines += '- To keep lane4 frame grouping exact, lane4 uses a minimal `RAW8` 2-byte payload in this closure TB; lane1 and lane2 keep the normal 4-byte payload.'
$lines += '- The AXI sink interface is unchanged; it now stores write data so readback can be verified.'
$lines += ""
$lines += '## Result Table'
$lines += ""
$lines += '| lane num | lines | exp pixels | act pixels | aw bursts | w beats |'
$lines += '| --- | --- | --- | --- | --- | --- |'

foreach ($row in $rows) {
    $lines += "| $($row.lane_num) | $($row.lines) | $($row.exp) | $($row.act) | $($row.aw_bursts) | $($row.w_beats) |"
}

$lines += ""
$lines += '## Conclusions'
$lines += ""
$lines += '- `1 / 2 / 4 lane` all now have wrapper-level `RAW8 -> AXI write -> memory readback -> scoreboard` closure evidence.'
$lines += '- This moves the proof point beyond live pixel-output closure and shows that the current AXI write path stores the expected pixels into the internal memory model.'
$lines += '- Because the current boot configuration reuses the frame base address across frames, this readback closure focuses on single-frame write correctness; long soak and throughput limits are covered by a separate stress test.'

Set-Content -Path $resultsMd -Value $lines -Encoding UTF8

Write-Output "Wrote $resultsMd"
