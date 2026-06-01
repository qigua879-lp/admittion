# MIPI CSI-2 图像采集系统交付说明

本文件夹是我按照毕业设计/课程项目交付口径整理出来的版本，目录名按要求命名为 `admittion`。原始整理日期为 `2026-05-20`，本次根据代码层面的新改动更新于 `2026-05-21`。

本交付包的目标不是重新开发工程，而是把当前仓库中已经完成的源码、Vivado 工程、仿真文件、接口表、TB 测试、仿真结果、网表级文件和总体结果分析集中放在一起，方便老师或评审直接查看。

## 目录说明

| 目录 | 内容 |
| --- | --- |
| `01_source_code/` | RTL 源码、顶层说明和原始工程规则文件 |
| `02_vivado_project_and_sim/` | Vivado 工程、TCL/PowerShell 脚本、XDC、仿真入口 |
| `03_interface_tables/` | 顶层接口表、寄存器表和我整理的接口说明 |
| `04_tb_tests/` | SystemVerilog testbench、模型、scoreboard、编译文件 |
| `05_simulation_results/` | 仿真结果文档、正式波形截图、验证总报告 |
| `06_netlist_level_files/` | 综合后 Verilog/EDF/DCP、实现报告和 ASIC 评估说明 |
| `07_project_result_analysis/` | 当前工程预期目标、完成情况、未完成情况和改进策略 |
| `08_reference_docs/` | 原工程中的规格、寄存器、时序和结果参考文档 |

## 推荐阅读顺序

1. `总体说明_接口_仿真_验证总览.md`
2. `07_project_result_analysis/当前工程结果分析.md`
3. `07_project_result_analysis/本次代码改动分析.md`
4. `01_source_code/源码介绍.md`
5. `03_interface_tables/接口表格及说明.md`
6. `04_tb_tests/TB测试说明.md`
7. `05_simulation_results/仿真结果分析.md`
8. `02_vivado_project_and_sim/工程介绍.md`
9. `06_netlist_level_files/网表级文件说明.md`

## 我的总体说明

我目前完成的是一个面向数字 RTL 的 MIPI CSI-2 图像采集前端原型。工程重点放在 CSI-2 包解析、多 lane 对齐、ECC/CRC 校验、帧行同步、像素重组、可靠性恢复、FIFO/CDC、AXI 写入和轻量预处理这些数字逻辑上。真实模拟 D-PHY 电气部分没有实现，只保留数字抽象输入。

当前结果可以支撑“数字前端 RTL 主体功能完成，并具备系统级仿真和 FPGA 可实现性评估”的结论，但还不能直接说是完整产品级或 ASIC signoff 级设计。

## 本次更新摘要

本次代码更新主要补强了三件事：

1. CDC 与 Vivado 时序：给 FIFO 和顶层跨域同步寄存器补充 FPGA 属性，并在 XDC 中把 `clk_byte` 与 `clk_sys` 声明为异步时钟组。`timing_cdc_v2` routed timing 已达到 `WNS=1.884 ns`、`TNS=0.000 ns`。
2. AXI 写入闭环：`axi_write_null_slave` 从单纯握手 sink 扩展为带内部存储的 AXI 写入模型，新增 `RAW8 -> AXI write -> memory readback -> scoreboard` 验证。
3. 长时间与多 lane 覆盖：新增 RAW8 soak/throughput 测试，`1 / 2 / 4 lane` 都有多帧多行 wrapper 级 soak 证据。
