# MIPI ALL 工程总览

基于 MIPI CSI-2 协议的高速高可靠图像采集系统设计与仿真验证工程。

## 1. 先看哪些文件

建议按下面顺序阅读：

1. `AGENTS.md`
2. `docs/spec/system_spec.md`
3. `docs/spec/top_io.md`
4. `docs/spec/top_integration_notes.md`
5. `docs/spec/regression_plan.md`
6. `docs/spec/verification_master_report.md`
7. `rtl/top/mipi_csi2_capture_top.sv`
8. `sim/vcs/compile.f`

## 2. 根目录文件说明

| 文件/目录 | 作用 |
| --- | --- |
| `AGENTS.md` | 项目约束、命名、交付格式和开发边界。 |
| `docs/project_inputs/mipi_csi2_thesis_proposal_source.docx` | 课题开题报告原文。 |
| `docs/` | 项目规格、架构、状态、Vivado/ASIC 说明和寄存器草案。 |
| `rtl/` | 可综合 RTL。 |
| `tb/` | 非综合 testbench、模型、参考代码和 scoreboard。 |
| `sim/` | 仿真 filelist、运行脚本和日志目录。 |
| `fpga/` | Vivado 脚本、约束和原型相关文件。 |
| `asic/` | ASIC 评估占位目录。 |
| `prompts/` | 分阶段开发提示词留档。 |
| `scripts/` | 参数扫描、结果整理和交付打包脚本。 |
| `deliverables/` | 可交付版本导出说明。 |
| `MIPI update/` | 本轮重构和分析留痕，不覆盖原工程。 |

## 3. 当前工程状态

- 这是一个数字 RTL 原型，不包含真实模拟 D-PHY。
- 主链路已经覆盖 lane 对齐、CSI-2 包解析、帧行同步、像素重组、错误恢复、FIFO/CDC、AXI 写通路和基础预处理。
- 论文级验证与 Vivado 实现评估已形成基础闭环，但更强工程覆盖、完整 `cfg_reg_if`、最终板级时序收敛和 ASIC 流程仍未闭环。

## 4. 目录导航

| 目录 | 说明文件 |
| --- | --- |
| `docs/` | `docs/README.md` |
| `rtl/` | `rtl/README.md` |
| `tb/` | `tb/README.md` |
| `sim/` | `sim/README.md` |
| `fpga/` | `fpga/README.md` |
| `asic/` | `asic/README.md` |
| `prompts/` | `prompts/README.md` |
| `scripts/` | `scripts/README.md` |
| `deliverables/` | `deliverables/README.md` |
| `MIPI update/` | `MIPI update/README.md` |

## 5. 当前保留原则

- 保留源码、规格、脚本、报告和必要交付记录。
- 删除工具自动生成的临时目录和根目录无价值日志。
- 将总览类重复文档收敛到 `README` 体系中。
- 根目录只保留工程入口文件，波形快照与工具日志分别归档到 `sim/waves/` 和 `fpga/vivado/runtime_logs/`。
