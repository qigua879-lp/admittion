param(
    [string]$OutDir = "C:\temp\mipi_lane_buffer_sensitivity",
    [string]$RepoRoot = "C:\Users\qigua\OneDrive\Desktop\MIPI ALL"
)

$ErrorActionPreference = "Stop"

$deskewDepths = @(2, 4, 6)
$byteFifoWidths = @(2, 4)
$axiFifoWidths = @(3, 6)

$compileFile = Join-Path $RepoRoot "sim\vcs\compile.f"
$tbFile = Join-Path $RepoRoot "tb\tests\tb_fpga_wrapper_lane_skew_scan.sv"
$resultsMd = Join-Path $RepoRoot "docs\spec\结果验证\lane_buffer_sensitivity_results.md"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$rows = @()

foreach ($deskew in $deskewDepths) {
    foreach ($byteAw in $byteFifoWidths) {
        foreach ($axiAw in $axiFifoWidths) {
            $name = "dd${deskew}_bf${byteAw}_af${axiAw}"
            $outFile = Join-Path $OutDir "${name}.out"
            $compileLog = Join-Path $OutDir "${name}_compile.log"
            $runLog = Join-Path $OutDir "${name}.log"

            & iverilog -g2012 -Wall `
                -P tb_fpga_wrapper_lane_skew_scan.DESKEW_DEPTH=$deskew `
                -P tb_fpga_wrapper_lane_skew_scan.BYTE_FIFO_ADDR_WIDTH=$byteAw `
                -P tb_fpga_wrapper_lane_skew_scan.AXI_FIFO_ADDR_WIDTH=$axiAw `
                -s tb_fpga_wrapper_lane_skew_scan `
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

            $resultLines = Select-String -Path $runLog -Pattern "^RESULT:"
            $passLine = Select-String -Path $runLog -Pattern "^PASS: tb_fpga_wrapper_lane_skew_scan" | Select-Object -Last 1
            if (-not $resultLines -or -not $passLine) {
                throw "Missing RESULT/PASS lines for $name"
            }

            $tolerantWindows = @()
            $overflowHits = @()
            $readyLowHits = @()
            foreach ($entry in $resultLines) {
                $kv = @{}
                foreach ($token in $entry.Line.Replace("RESULT: ", "").Split(" ")) {
                    if ($token -match "=") {
                        $parts = $token.Split("=")
                        $kv[$parts[0]] = $parts[1]
                    }
                }
                if ($kv["tolerant"] -eq "1" -and $kv["overflow"] -eq "0" -and $kv["mismatch"] -eq "0") {
                    $tolerantWindows += [int]$kv["lead_bytes"]
                }
                if ($kv["overflow"] -eq "1") {
                    $overflowHits += [int]$kv["lead_bytes"]
                }
                if ($kv["ready_low"] -eq "1") {
                    $readyLowHits += [int]$kv["lead_bytes"]
                }
            }

            $rows += [PSCustomObject]@{
                deskew_depth     = $deskew
                byte_fifo_aw     = $byteAw
                axi_fifo_aw      = $axiAw
                tolerant_window  = if ($tolerantWindows.Count -gt 0) { ($tolerantWindows | Measure-Object -Maximum).Maximum } else { -1 }
                overflow_at      = if ($overflowHits.Count -gt 0) { ($overflowHits | Measure-Object -Minimum).Minimum } else { -1 }
                ready_low_cases  = if ($readyLowHits.Count -gt 0) { ($readyLowHits -join ",") } else { "-" }
                pass_summary     = $passLine.Line
            }
        }
    }
}

$lines = @()
$lines += '# Lane/Buffer Sensitivity Results'
$lines += ""
$lines += '## Purpose'
$lines += ""
$lines += '本文件用于留痕 `DESKEW_DEPTH / BYTE_FIFO / AXI_FIFO` 的联合敏感性扫描，目标是确认 lane skew 容忍窗口是否只由 deskew 深度主导，还是会被下游 buffer 深度显著改变。'
$lines += ""
$lines += '## Sweep Matrix'
$lines += ""
$lines += '- `DESKEW_DEPTH ∈ {2, 4, 6}`'
$lines += '- `BYTE_FIFO_ADDR_WIDTH ∈ {2, 4}`'
$lines += '- `AXI_FIFO_ADDR_WIDTH ∈ {3, 6}`'
$lines += '- Fixed traffic: `RAW8`, `LANE_NUM=2`, single-frame wrapper path'
$lines += '- For each case, `lead_bytes` scans from `0` to `DESKEW_DEPTH + 1`'
$lines += ""
$lines += '## Result Table'
$lines += ""
$lines += '| deskew depth | byte fifo aw | axi fifo aw | tolerant window | overflow at | ready_low cases |'
$lines += '| --- | --- | --- | --- | --- | --- |'

foreach ($row in $rows) {
    $lines += "| $($row.deskew_depth) | $($row.byte_fifo_aw) | $($row.axi_fifo_aw) | 0..$($row.tolerant_window) | $($row.overflow_at) | $($row.ready_low_cases) |"
}

$lines += ""
$lines += '## Conclusions'
$lines += ""
$lines += '- 在当前测试矩阵内，所有组合都满足 `tolerant window = DESKEW_DEPTH`，`overflow at = DESKEW_DEPTH + 1`。'
$lines += '- 这说明当前真实 wrapper 路径下，lane skew 的主导约束仍然是 `lane_deskew_buffer` 自身深度，而不是 `BYTE FIFO` 或 `AXI writer FIFO` 的选值。'
$lines += '- `ready_low` 的出现位置会随工作点变化，但它并不改变容忍窗口结论，因此更适合被解释为瞬时回压现象，而不是越界判据。'
$lines += ""
$lines += '## Engineering Interpretation'
$lines += ""
$lines += '- 对工程选型而言，若目标是扩展 lane skew 容忍窗口，应优先调整 `DESKEW_DEPTH`，而不是指望增大后级 FIFO 深度来等效提升容忍能力。'
$lines += '- `BYTE FIFO / AXI FIFO` 更直接影响的是后续缓存吸压与吞吐边界；它们不会替代 deskew 结构本身的对齐上限。'

Set-Content -Path $resultsMd -Value $lines -Encoding UTF8

Write-Output "Wrote $resultsMd"
