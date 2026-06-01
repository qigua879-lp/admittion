param(
    [string]$RepoRoot = "",
    [string]$OutRoot = "",
    [string]$WorkRoot = "C:\temp\admittion_formal_20260521\repo",
    [switch]$SkipRun
)

$ErrorActionPreference = "Stop"

if (-not $RepoRoot) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
}

if (-not $OutRoot) {
    $OutRoot = Join-Path $RepoRoot "05_simulation_results\结果验证\正式重验证_20260521"
}

$LogRoot = Join-Path $OutRoot "logs"
$TableRoot = Join-Path $OutRoot "tables"
$CompileRoot = Join-Path $OutRoot "compile"
New-Item -ItemType Directory -Force -Path $OutRoot, $LogRoot, $TableRoot, $CompileRoot | Out-Null

function Assert-UnderTempFormalRoot {
    param([string]$Path)

    $full = [System.IO.Path]::GetFullPath($Path)
    if (-not $full.StartsWith("C:\temp\admittion_formal_20260521", [System.StringComparison]::OrdinalIgnoreCase)) {
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

New-CleanDirectory $WorkRoot
New-Junction (Join-Path $WorkRoot "rtl") (Join-Path $RepoRoot "01_source_code\rtl")
New-Junction (Join-Path $WorkRoot "tb") (Join-Path $RepoRoot "04_tb_tests\tb")
New-Junction (Join-Path $WorkRoot "sim") (Join-Path $RepoRoot "02_vivado_project_and_sim\sim")

$CompileFile = Join-Path $WorkRoot "sim\vcs\compile.f"
$TbFiles = @()
$TbFiles += Get-ChildItem -LiteralPath (Join-Path $RepoRoot "04_tb_tests\tb\tests") -Filter "*.sv" | Sort-Object Name
$TbFiles += Get-Item -LiteralPath (Join-Path $RepoRoot "04_tb_tests\tb\top\tb_mipi_csi2_capture_top.sv")

function Get-ModuleName {
    param([string]$File)

    $match = Select-String -LiteralPath $File -Pattern '^\s*module\s+([A-Za-z_][A-Za-z0-9_$]*)' | Select-Object -First 1
    if (-not $match) {
        throw "No module declaration found in $File"
    }
    return $match.Matches[0].Groups[1].Value
}

function Get-TestCategory {
    param([string]$Name)

    if ($Name -match 'metrics|sweep|scan|soak|stress') { return "指标/扫描" }
    if ($Name -match 'fpga_wrapper') { return "wrapper 系统级" }
    if ($Name -match 'mipi_csi2_capture_top') { return "顶层系统级" }
    return "模块级"
}

function Get-TestTopic {
    param([string]$Name)

    switch -Regex ($Name) {
        'cfg_reg' { return "寄存器接口" }
        'phy' { return "D-PHY 数字适配" }
        'packet|payload|header|crc|ecc|parser' { return "CSI-2 包解析与校验" }
        'frame_line|sync|resync' { return "同步/恢复" }
        'lane' { return "lane 对齐与 skew" }
        'raw8|raw10|rgb888|yuv422|pixel' { return "像素格式与主链路" }
        'axi|addr|buffer|fifo' { return "buffer/AXI 写通路" }
        'brightness|contrast|gray|adaptive|stats|preprocess' { return "预处理" }
        'err_' { return "错误分类与策略" }
        default { return "综合验证" }
    }
}

function Convert-PathForMarkdown {
    param([string]$Path)

    $relative = Resolve-Path -LiteralPath $Path -ErrorAction SilentlyContinue
    if ($relative) {
        return $relative.Path.Replace($RepoRoot + "\", "").Replace("\", "/")
    }
    return $Path.Replace($RepoRoot + "\", "").Replace("\", "/")
}

function Invoke-NativeToLog {
    param(
        [string]$Exe,
        [string[]]$CommandArgs,
        [string]$LogPath
    )

    $argList = @()
    foreach ($arg in $CommandArgs) {
        if ($arg -match '[\s()]') {
            $argList += '"' + ($arg -replace '"', '\"') + '"'
        } else {
            $argList += $arg
        }
    }

    $cmdLine = '"' + $Exe + '" ' + ($argList -join " ")
    cmd.exe /d /c "$cmdLine > `"$LogPath`" 2>&1"
    return $LASTEXITCODE
}

$Rows = @()

foreach ($Tb in $TbFiles) {
    $Module = Get-ModuleName $Tb.FullName
    $Name = $Module
    $CaseDir = Join-Path $LogRoot $Name
    New-Item -ItemType Directory -Force -Path $CaseDir | Out-Null

    $CompileLog = Join-Path $CaseDir "compile.log"
    $RunLog = Join-Path $CaseDir "run.log"
    $OutFile = Join-Path $CompileRoot ($Name + ".out")
    $TbRel = $Tb.FullName.Replace((Join-Path $RepoRoot "04_tb_tests\") , "").Replace("\", "/")

    $CompileExit = $null
    $RunExit = $null
    $Status = "NOT_RUN"
    $KeyLine = ""

    if (-not $SkipRun) {
        Push-Location $WorkRoot
        try {
            $CompileExit = Invoke-NativeToLog "iverilog" @("-g2012", "-Wall", "-s", $Module, "-o", $OutFile, "-f", $CompileFile, $TbRel) $CompileLog
            if ($CompileExit -eq 0) {
                $RunExit = Invoke-NativeToLog "vvp" @($OutFile) $RunLog
            }
        } finally {
            Pop-Location
        }
    }

    if ($SkipRun) {
        $Status = "SKIPPED"
    } elseif ($CompileExit -ne 0) {
        $Status = "COMPILE_FAIL"
    } elseif ($RunExit -ne 0) {
        $Status = "RUN_FAIL"
    } else {
        $pass = Select-String -LiteralPath $RunLog -Pattern '^PASS:' | Select-Object -Last 1
        $result = Select-String -LiteralPath $RunLog -Pattern '^RESULT:' | Select-Object -Last 1
        if ($pass) {
            $Status = "PASS"
            $KeyLine = $pass.Line
        } elseif ($result) {
            $Status = "RUN_OK_RESULT"
            $KeyLine = $result.Line
        } else {
            $Status = "RUN_OK_NO_PASS_LINE"
            $KeyLine = ""
        }
    }

    if (-not $KeyLine -and (Test-Path $RunLog)) {
        $fallback = Select-String -LiteralPath $RunLog -Pattern '(\$finish|PASS|RESULT|ERROR|FATAL)' | Select-Object -Last 1
        if ($fallback) {
            $KeyLine = $fallback.Line
        }
    }

    $Rows += [PSCustomObject]@{
        name = $Name
        category = Get-TestCategory $Name
        topic = Get-TestTopic $Name
        status = $Status
        compile_exit = if ($null -eq $CompileExit) { "" } else { $CompileExit }
        run_exit = if ($null -eq $RunExit) { "" } else { $RunExit }
        key_line = $KeyLine
        compile_log = Convert-PathForMarkdown $CompileLog
        run_log = Convert-PathForMarkdown $RunLog
    }
}

$Total = $Rows.Count
$PassCount = @($Rows | Where-Object { $_.status -eq "PASS" -or $_.status -eq "RUN_OK_RESULT" -or $_.status -eq "RUN_OK_NO_PASS_LINE" }).Count
$FailCount = @($Rows | Where-Object { $_.status -match "FAIL" }).Count

$SummaryLines = @()
$SummaryLines += "# 2026-05-21 仿真正式重验证运行汇总"
$SummaryLines += ""
$SummaryLines += "## 总览"
$SummaryLines += ""
$SummaryLines += "| 项目 | 数量 |"
$SummaryLines += "| --- | --- |"
$SummaryLines += "| testbench 总数 | $Total |"
$SummaryLines += "| 运行通过/完成 | $PassCount |"
$SummaryLines += "| 失败 | $FailCount |"
$SummaryLines += ""
$SummaryLines += "## Testbench 结果表"
$SummaryLines += ""
$SummaryLines += "| testbench | 分类 | 主题 | 状态 | compile exit | run exit | 关键输出 | 日志 |"
$SummaryLines += "| --- | --- | --- | --- | --- | --- | --- | --- |"

foreach ($row in $Rows) {
    $key = ($row.key_line -replace '\|', '\\|')
    $SummaryLines += "| $($row.name) | $($row.category) | $($row.topic) | $($row.status) | $($row.compile_exit) | $($row.run_exit) | $key | compile: $($row.compile_log)<br>run: $($row.run_log) |"
}

$SummaryPath = Join-Path $OutRoot "verification_run_summary.md"
$TestTablePath = Join-Path $TableRoot "testbench_results.md"
Set-Content -LiteralPath $SummaryPath -Value $SummaryLines -Encoding UTF8
Set-Content -LiteralPath $TestTablePath -Value $SummaryLines -Encoding UTF8

$TopicRows = $Rows | Group-Object topic | Sort-Object Name
$TopicLines = @()
$TopicLines += "# 2026-05-21 主题证据矩阵"
$TopicLines += ""
$TopicLines += "| 主题 | testbench 数量 | 完成数量 | 失败数量 | 覆盖 testbench |"
$TopicLines += "| --- | --- | --- | --- | --- |"
foreach ($group in $TopicRows) {
    $done = @($group.Group | Where-Object { $_.status -notmatch "FAIL" }).Count
    $fail = @($group.Group | Where-Object { $_.status -match "FAIL" }).Count
    $names = ($group.Group | ForEach-Object { $_.name }) -join "<br>"
    $TopicLines += "| $($group.Name) | $($group.Count) | $done | $fail | $names |"
}
$TopicMatrixPath = Join-Path $TableRoot "topic_evidence_matrix.md"
Set-Content -LiteralPath $TopicMatrixPath -Value $TopicLines -Encoding UTF8

$TopSummary = @()
$TopSummary += "# 2026-05-21 仿真正式重验证总报告"
$TopSummary += ""
$TopSummary += "## 证据位置"
$TopSummary += ""
$TopSummary += "- 批量运行汇总：05_simulation_results/结果验证/正式重验证_20260521/verification_run_summary.md"
$TopSummary += "- testbench 表格：05_simulation_results/结果验证/正式重验证_20260521/tables/testbench_results.md"
$TopSummary += "- 主题证据矩阵：05_simulation_results/结果验证/正式重验证_20260521/tables/topic_evidence_matrix.md"
$TopSummary += "- 编译与运行日志：05_simulation_results/结果验证/正式重验证_20260521/logs/"
$TopSummary += ""
$TopSummary += "## 本次运行统计"
$TopSummary += ""
$TopSummary += "| 项目 | 数量 |"
$TopSummary += "| --- | --- |"
$TopSummary += "| testbench 总数 | $Total |"
$TopSummary += "| 运行通过/完成 | $PassCount |"
$TopSummary += "| 失败 | $FailCount |"
$TopSummary += ""
$TopSummary += "## 说明"
$TopSummary += ""
$TopSummary += "- 本轮使用短路径工作区 $WorkRoot 运行，避免 OneDrive 路径空格影响仿真工具。"
$TopSummary += "- 每个 testbench 都保留独立 compile/run log。"
$TopSummary += "- 波形截图由后续 Vivado XSim 截图步骤补充到 waves/，并在 wave_capture_summary.md 中登记。"

$TopSummaryPath = Join-Path $RepoRoot "05_simulation_results\结果验证\formal_reverification_summary_20260521.md"
Set-Content -LiteralPath $TopSummaryPath -Value $TopSummary -Encoding UTF8

Write-Host "Wrote $SummaryPath"
Write-Host "Wrote $TopicMatrixPath"
Write-Host "Wrote $TopSummaryPath"
Write-Host "SUMMARY: total=$Total completed=$PassCount failed=$FailCount"

