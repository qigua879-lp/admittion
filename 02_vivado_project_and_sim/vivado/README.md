# Vivado

本目录保存 Vivado 相关脚本和输出。

## 文件/目录说明

| 文件/目录 | 作用 |
| --- | --- |
| `create_project.tcl` | 创建工程并导入 RTL/XDC。 |
| `run_synth_only.tcl` | 只运行综合并导出 synth 级报告/DCP，适合早期 wrapper/top 验证。 |
| `run_synth_impl.tcl` | 运行综合和实现。 |
| `run_dphy_wrapper_synth.ps1` | 使用 `dphy_minimal` XDC profile 跑 `mipi_csi2_capture_dphy_wrapper` synthesis-only。 |
| `run_dphy_wrapper_timing.ps1` | 使用 `dphy_minimal` XDC profile 跑 `mipi_csi2_capture_dphy_wrapper` 的 synth + route timing-only 流程，不写 bitstream。 |
| `run_dphy_wrapper_timing_direct.ps1` | 非 project direct flow，直接 `read_verilog/synth_design/opt/place/route/report`，用于绕开 Windows/OneDrive 下的 project/run 卡顿。 |
| `run_synth_route_direct.tcl` | 运行综合，并在当前 batch 会话内直接执行 `opt/place/route/report/write_bitstream`，绕过 `impl_1` WSH 包装链。 |
| `run_synth_route_timing_only.tcl` | 运行综合和 direct route，只导出 routed timing/DRC/CDC/资源报告，不写 bitstream。 |
| `run_dphy_wrapper_timing_direct.tcl` | D-PHY wrapper 专用 direct timing-only Tcl，不创建 Vivado project，不写 bitstream。 |
| `check_dphy_wrapper_synth_entry.ps1` | 静态检查 D-PHY wrapper synthesis 入口脚本和 XDC profile 是否齐全。 |
| `check_board_io_drc_v1.ps1` | 检查 board IO v1 bitstream、DRC 报告和 `NSTD-1/UCIO-1` 清零结果。 |
| `query_package_pins_v1.tcl` | 查询目标器件封装管脚、bank、GC 时钟属性和差分对信息。 |
| `run_full_build.ps1` | Windows 一键构建入口。 |
| `run_timing_cdc_v2_build.ps1` | 使用独立工程名重跑 `timing_cdc_v2`，并采用 direct route-only 流程导出时序/资源报告。 |
| `run_xsim_smoke.tcl` | XSim smoke 仿真入口。 |
| `run_xsim_smoke.ps1` | Windows XSim smoke 入口。 |
| `diagnose_gui_project.tcl` | GUI 工程诊断。 |
| `fix_gui_sim_sources.tcl` | 修复 GUI 仿真源分组。 |
| `reports/` | 保留的综合/实现报告。 |
| `runtime_logs/` | 保留从根目录运行工具时产生的历史日志归档。 |
| `work/` | Vivado 工程工作区，可重建。 |

## Windows batch 注意

在 Windows/Codex 环境下，建议先 `call D:\Xilinx\Vivado\2017.3\settings64.bat`，并对 Tcl 脚本使用绝对路径；直接用相对 `-source 02_vivado_project_and_sim\...` 可能卡在 Vivado 启动阶段。

推荐把工程和报告放到本地短路径，避免 OneDrive 目录的只读/同步属性影响 Vivado：

```bat
set VIVADO_WORK_ROOT=C:\vivado_admittion\work
set VIVADO_REPORT_ROOT=C:\vivado_admittion\reports
```

## 最近板级 IO 验证

工程名：`mipi_csi2_capture_board_io_v1_clkfix5`

结果目录：`C:\vivado_admittion\reports\mipi_csi2_capture_board_io_v1_clkfix5`

验证结论：

- `write_bitstream` 前 DRC：`0 Errors`
- `impl_drc.rpt`：`Violations found: 0`
- 已生成 bitstream：`mipi_csi2_capture_board_io_v1_clkfix5.bit`
- 时序仍未收敛：`impl_timing_summary.rpt` 中 `WNS=-3.398 ns`，这属于后续 timing closure 工作，不是 `NSTD-1/UCIO-1` 问题。

复查命令：

```powershell
powershell -ExecutionPolicy Bypass -File 02_vivado_project_and_sim/vivado/check_board_io_drc_v1.ps1
```

## D-PHY wrapper synthesis-only 入口

工程名示例：`mipi_csi2_capture_dphy_wrapper_synth_check`

用途：

- 以 `mipi_csi2_capture_dphy_wrapper` 作为 Vivado top。
- 只导入 `dphy_wrapper_constraints.xdc`，避免旧 board placeholder pinout 约束旧 `lane_data_*` 端口。
- 只跑 synthesis，不做 implementation/bitstream。

复查命令：

```powershell
powershell -ExecutionPolicy Bypass -File 02_vivado_project_and_sim/vivado/check_dphy_wrapper_synth_entry.ps1
powershell -ExecutionPolicy Bypass -File 02_vivado_project_and_sim/vivado/run_dphy_wrapper_synth.ps1 -ProjectName mipi_csi2_capture_dphy_wrapper_synth_check
```

在还没有最终 D-PHY wrapper 板级 pinout 和 IOSTANDARD 前，建议用 timing-only 流程检查 route 后时序，不写 bitstream：

```powershell
powershell -ExecutionPolicy Bypass -File 02_vivado_project_and_sim/vivado/run_dphy_wrapper_timing.ps1 `
  -ProjectName mipi_csi2_capture_dphy_wrapper_timing `
  -WorkRoot C:\vivado_admittion\work `
  -ReportRoot C:\vivado_admittion\reports
```

如果 project/run 入口在 Windows 或 OneDrive 环境中卡住，使用非 project direct 入口：

```powershell
powershell -ExecutionPolicy Bypass -File 02_vivado_project_and_sim/vivado/run_dphy_wrapper_timing_direct.ps1 `
  -ProjectName mipi_csi2_capture_dphy_wrapper_timing_direct `
  -ReportRoot C:\vivado_admittion\reports
```

direct 入口默认设置 `DPHY_CORE_TIMING_ONLY=1`，用于在 D-PHY/BD/pinout 尚未固定前只检查内部 core timing；它会忽略人工 wrapper 顶层的 `rst_n` 和 status/debug 输出边界。需要检查这些外部 IO 边界时，可传 `-CoreTimingOnly $false`。

最新 core timing-only 收敛基线：

```text
Project/report: C:\vivado_admittion\reports\dphy_core5
WNS = 0.825 ns
WHS = 0.009 ns
TNS/THS/TPWS = 0.000 ns
Route errors = 0
```

这说明当前 D-PHY wrapper 内部逻辑已经 route 后收敛；最终上板仍需要在真实 AMD D-PHY RX IP/BD、pinout、IOSTANDARD 和 board clock 约束固定后重跑板级 DRC/timing/bitstream。
