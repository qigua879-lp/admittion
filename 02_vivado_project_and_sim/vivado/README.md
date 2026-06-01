# Vivado

本目录保存 Vivado 相关脚本和输出。

## 文件/目录说明

| 文件/目录 | 作用 |
| --- | --- |
| `create_project.tcl` | 创建工程并导入 RTL/XDC。 |
| `run_synth_impl.tcl` | 运行综合和实现。 |
| `run_synth_route_direct.tcl` | 运行综合，并在当前 batch 会话内直接执行 `opt/place/route/report`，绕过 `impl_1` WSH 包装链。 |
| `run_full_build.ps1` | Windows 一键构建入口。 |
| `run_timing_cdc_v2_build.ps1` | 使用独立工程名重跑 `timing_cdc_v2`，并采用 direct route-only 流程导出时序/资源报告。 |
| `run_xsim_smoke.tcl` | XSim smoke 仿真入口。 |
| `run_xsim_smoke.ps1` | Windows XSim smoke 入口。 |
| `diagnose_gui_project.tcl` | GUI 工程诊断。 |
| `fix_gui_sim_sources.tcl` | 修复 GUI 仿真源分组。 |
| `reports/` | 保留的综合/实现报告。 |
| `runtime_logs/` | 保留从根目录运行工具时产生的历史日志归档。 |
| `work/` | Vivado 工程工作区，可重建。 |
