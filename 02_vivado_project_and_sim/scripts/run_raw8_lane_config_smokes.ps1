param(
    [string]$OutDir = "C:\temp\mipi_raw8_lane_config",
    [string]$RepoRoot = "C:\Users\qigua\OneDrive\Desktop\MIPI ALL"
)

$ErrorActionPreference = "Stop"

$laneCases = @(1, 4)
$compileFile = Join-Path $RepoRoot "sim\vcs\compile.f"
$tbFile = Join-Path $RepoRoot "tb\tests\tb_fpga_wrapper_raw8_lane_config_smoke.sv"
$resultsMd = Join-Path $RepoRoot "docs\spec\结果验证\raw8_lane_config_results.md"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$rows = @()

foreach ($laneNum in $laneCases) {
    $name = "lane${laneNum}"
    $outFile = Join-Path $OutDir "${name}.out"
    $compileLog = Join-Path $OutDir "${name}_compile.log"
    $runLog = Join-Path $OutDir "${name}.log"

    & iverilog -g2012 -Wall `
        -P tb_fpga_wrapper_raw8_lane_config_smoke.LANE_NUM=$laneNum `
        -s tb_fpga_wrapper_raw8_lane_config_smoke `
        -o $outFile `
        -f $compileFile `
        $tbFile *> $compileLog
    if ($LASTEXITCODE -ne 0) {
        throw "iverilog failed for $name"
    }

    & vvp $outFile *> $runLog
    if ($LASTEXITCODE -ne 0) {
        throw "vvp failed for $name"
    }

    $passLine = Select-String -Path $runLog -Pattern "^PASS: tb_fpga_wrapper_raw8_lane_config_smoke" | Select-Object -Last 1
    if (-not $passLine) {
        throw "No PASS line found for $name"
    }

    $kv = @{}
    foreach ($token in $passLine.Line.Replace("PASS: tb_fpga_wrapper_raw8_lane_config_smoke ", "").Split(" ")) {
        if ($token -match "=") {
            $parts = $token.Split("=")
            $kv[$parts[0]] = $parts[1]
        }
    }

    $rows += [PSCustomObject]@{
        lane_num = $kv["lane"]
        exp      = $kv["exp"]
        act      = $kv["act"]
        frames   = $kv["frames"]
    }
}

$lines = @()
$lines += '# RAW8 Lane Configuration Results'
$lines += ""
$lines += '## Purpose'
$lines += ""
$lines += '本文件用于补 `lane1 / lane4 wrapper` 级系统证据，回答“1 / 2 / 4 lane 可配置”目前是否已经具有真实 wrapper 路径下的 smoke 闭环。'
$lines += ""
$lines += '## Testbench'
$lines += ""
$lines += '- 系统级 TB：'
$lines += '  - `tb/tests/tb_fpga_wrapper_raw8_lane_config_smoke.sv`'
$lines += '- 批量脚本：'
$lines += '  - `scripts/run_raw8_lane_config_smokes.ps1`'
$lines += ""
$lines += '## Configuration'
$lines += ""
$lines += '- Fixed traffic: `RAW8` single-frame wrapper path'
$lines += '- `LANE_NUM ∈ {1, 4}`'
$lines += '- Testbench forces boot cfg lane selection only in the stimulus layer:'
$lines += '  - lane1 uses `cfg_lane_num_minus1=0`, `lane_enable_mask=0001`'
$lines += '  - lane4 uses `cfg_lane_num_minus1=3`, `lane_enable_mask=1111`'
$lines += '- To make lane4 grouping exact, this smoke uses a minimal `RAW8` long-packet payload of `2` bytes'
$lines += ""
$lines += '## Result Table'
$lines += ""
$lines += '| lane num | exp pixels | act pixels | frames |'
$lines += '| --- | --- | --- | --- |'

foreach ($row in $rows) {
    $lines += "| $($row.lane_num) | $($row.exp) | $($row.act) | $($row.frames) |"
}

$lines += ""
$lines += '## Conclusions'
$lines += ""
$lines += '- `lane1` 与 `lane4` 现在都已经补到真实 wrapper 路径下的 `RAW8` smoke 证据。'
$lines += '- 配合既有 `lane2 RAW8 smoke`，当前论文和工程都可以更稳妥地表述为：`1 / 2 / 4 lane` 配置能力已实现，并且三种配置都已具备至少一条 wrapper 级系统闭环证据。'
$lines += '- 这批结果仍属于最小 smoke 闭环，不等价于三种 lane 配置都已经完成等强度的异常注入、恢复和吞吐量化。'

Set-Content -Path $resultsMd -Value $lines -Encoding UTF8

Write-Output "Wrote $resultsMd"
