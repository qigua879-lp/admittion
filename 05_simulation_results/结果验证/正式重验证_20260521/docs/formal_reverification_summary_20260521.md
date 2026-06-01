# 2026-05-21 仿真正式重验证总报告

## 证据位置

- 批量运行汇总：`docs/verification_run_summary.md`
- 波形截图汇总：`docs/wave_capture_summary.md`
- testbench 表格：`tables/testbench_results.md`
- 主题证据矩阵：`tables/topic_evidence_matrix.md`
- 编译与运行日志：`logs/`
- 波形日志：`xsim_wave_logs/`

## 本次运行统计

| 项目 | 数量 |
| --- | --- |
| testbench 总数 | 55 |
| 运行通过/完成 | 55 |
| 失败 | 0 |

## 说明

- 本轮使用短路径工作区 C:\temp\admittion_formal_20260521\repo 运行，避免 OneDrive 路径空格影响仿真工具。
- 每个 testbench 都保留独立 compile/run log。
- 波形截图由后续 Vivado XSim 截图步骤补充到 waves/，并在 wave_capture_summary.md 中登记。
