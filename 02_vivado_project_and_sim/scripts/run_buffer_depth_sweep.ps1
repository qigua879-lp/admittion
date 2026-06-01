param(
    [string]$OutDir = "C:\temp\mipi_buffer_sweep",
    [string]$RepoRoot = "C:\Users\qigua\OneDrive\Desktop\MIPI ALL"
)

$ErrorActionPreference = "Stop"

$byteFifoWidths = @(2, 3, 4)
$axiFifoWidths  = @(3, 4, 6)
$stallCycles    = @(6, 16)
$axiDataWidth   = 128
$pixelCount     = 16

$compileFile = Join-Path $RepoRoot "sim\vcs\compile.f"
$tbFile = Join-Path $RepoRoot "tb\tests\tb_fpga_wrapper_buffer_depth_sweep.sv"
$resultsMd = Join-Path $RepoRoot "docs\spec\结果验证\buffer_depth_sweep_results.md"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$rows = @()

foreach ($byteAw in $byteFifoWidths) {
    foreach ($axiAw in $axiFifoWidths) {
        foreach ($stall in $stallCycles) {
            $name = "bf${byteAw}_af${axiAw}_st${stall}"
            $outFile = Join-Path $OutDir "${name}.out"
            $compileLog = Join-Path $OutDir "${name}_compile.log"
            $runLog = Join-Path $OutDir "${name}.log"

            & iverilog -g2012 -Wall `
                -P tb_fpga_wrapper_buffer_depth_sweep.BYTE_FIFO_ADDR_WIDTH=$byteAw `
                -P tb_fpga_wrapper_buffer_depth_sweep.AXI_FIFO_ADDR_WIDTH=$axiAw `
                -P tb_fpga_wrapper_buffer_depth_sweep.AXI_STALL_CYCLES=$stall `
                -P tb_fpga_wrapper_buffer_depth_sweep.AXI_DATA_WIDTH=$axiDataWidth `
                -P tb_fpga_wrapper_buffer_depth_sweep.PIXEL_COUNT=$pixelCount `
                -s tb_fpga_wrapper_buffer_depth_sweep `
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

            $resultLine = Select-String -Path $runLog -Pattern "^RESULT:" | Select-Object -Last 1
            if (-not $resultLine) {
                throw "No RESULT line found for $name"
            }

            $kv = @{}
            $tokens = $resultLine.Line.Replace("RESULT: ", "").Split(" ")
            foreach ($token in $tokens) {
                if ($token -match "=") {
                    $parts = $token.Split("=")
                    $kv[$parts[0]] = $parts[1]
                }
            }

            $rows += [PSCustomObject]@{
                byte_fifo_aw      = $kv["byte_fifo_aw"]
                axi_fifo_aw       = $kv["axi_fifo_aw"]
                stall             = $kv["stall"]
                exp               = $kv["exp"]
                act               = $kv["act"]
                max_byte_fifo     = $kv["max_byte_fifo"]
                max_axi_fifo      = $kv["max_axi_fifo"]
                lane_bp_cycles    = $kv["lane_bp_cycles"]
                pixel_stall_cycles= $kv["pixel_stall_cycles"]
                aw_stall_cycles   = $kv["aw_stall_cycles"]
                w_stall_cycles    = $kv["w_stall_cycles"]
                axi_busy_duration = $kv["axi_busy_duration"]
            }
        }
    }
}

$lines = @()
$lines += '# Buffer Depth Sweep Results'
$lines += ""
$lines += '## Purpose'
$lines += ""
$lines += '本文件用于留痕 `BYTE FIFO` 深度、`AXI writer FIFO` 深度与 AXI 背压释放延迟之间的系统级关系，服务论文中的缓存需求分析与工程中的深度选型判断。'
$lines += ""
$lines += '## Sweep Matrix'
$lines += ""
$lines += '- `BYTE_FIFO_ADDR_WIDTH ∈ {2, 3, 4}`'
$lines += '- `AXI_FIFO_ADDR_WIDTH ∈ {3, 4, 6}`'
$lines += '- `AXI_STALL_CYCLES ∈ {6, 16}`'
$lines += '- `AXI_DATA_WIDTH = 128`'
$lines += '- Traffic: `RAW8`, `LANE_NUM=2`, `PIXEL_COUNT=16`'
$lines += ""
$lines += '## Result Table'
$lines += ""
$lines += '| byte fifo aw | axi fifo aw | stall cycles | exp | act | max byte fifo | max axi fifo | lane bp cycles | pixel stall cycles | aw stall cycles | w stall cycles | axi busy duration |'
$lines += '| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |'

foreach ($row in $rows) {
    $lines += "| $($row.byte_fifo_aw) | $($row.axi_fifo_aw) | $($row.stall) | $($row.exp) | $($row.act) | $($row.max_byte_fifo) | $($row.max_axi_fifo) | $($row.lane_bp_cycles) | $($row.pixel_stall_cycles) | $($row.aw_stall_cycles) | $($row.w_stall_cycles) | $($row.axi_busy_duration) |"
}

$lines += ""
$lines += '## Notes'
$lines += ""
$lines += '- `byte fifo aw` 表示 `BYTE_FIFO_ADDR_WIDTH`，对应 byte-to-sys async FIFO 深度 `2^aw`。'
$lines += '- `axi fifo aw` 表示 `AXI writer` 内部 data FIFO 深度 `2^aw`。'
$lines += '- `lane bp cycles` 表示 sensor 侧观测到 `lane_ready` 被拉低的周期数。'
$lines += '- `pixel stall cycles` 表示像素输出侧因 writer 背压导致 `pixel_valid && !pixel_ready` 的周期数。'
$lines += '- `axi busy duration` 表示 `axi_busy` 从拉高到释放的 AXI 域持续周期数。'
$lines += '- 当前 sweep 先固定在稳定可复现的 `16-pixel` 单行样例，用于比较 buffer 占用与背压传播基础趋势，而不是最终吞吐上限。'

Set-Content -Path $resultsMd -Value $lines -Encoding UTF8

Write-Output "Wrote $resultsMd"
