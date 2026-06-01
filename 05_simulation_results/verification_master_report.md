# MIPI CSI-2 Front-End Verification Master Report

## 1. 目的与使用方式

本文档用于把当前仓库内已经完成的验证方法、验证结果、结果留痕和工程边界整合到一份总报告中，便于后续：

- 论文撰写时直接引用结果来源与结论口径
- 实习单位工程汇报时快速说明系统能力与风险边界
- 后续版本继续补实验时，保持结果入口统一

推荐与本文档配套阅读的主文件：

- [论文结果总表](thesis_result_tables.md)
- [当前缺口检查](结果验证/progress_gap_check.md)
- [阶段交接记录](thesis_progress_handoff_2026-05-19.md)
- [实验矩阵](thesis_experiment_matrix.md)
- [状态矩阵](thesis_status_matrix.md)
- [结果验证索引](结果验证/README.md)

## 2. 当前总体结论

截至 `2026-05-20`，本项目已经完成数字 RTL 主链路的主体实现与系统级验证闭环，能够支持下面这类结论：

- 数字前端主链路已完成：lane 对齐/重排、CSI-2 解析、ECC/CRC、frame/line sync、RAW8/RAW10/RGB888/YUV422 像素重组、基础错误恢复、FIFO/CDC、AXI 写通路、wrapper/top 集成。
- 论文级结果已基本闭环：不仅有功能通过结果，也已经补齐了多格式比较、lane skew 窗口、buffer 深度趋势、连续多帧稳定性、恢复后 clean-frame、混合异常场景和 Vivado 资源/时序留痕。
- 工程级判断已经有基础：当前设计可以作为“数字前端工程原型”进行汇报，但仍不能等价表述为“完整产品态”或“ASIC-ready”。

当前最稳妥的口径是：

> 已完成面向数字 RTL 的 MIPI CSI-2 图像采集前端主体设计与系统级验证，核心功能、基础恢复能力和主要边界条件均已得到可追溯验证；剩余工作主要集中在更强工程覆盖、长期稳定性与实现约束收敛。

### 2.1 总体结论对应证明表

为避免“总体结论”只停留在总结口径，下面把每条结论对应到直接证据。

| 总体结论 | 直接证明方式 | 主要 testbench / 脚本 | 对应结果留痕 |
| --- | --- | --- | --- |
| 数字前端主链路已完成 | 通过真实 wrapper 路径验证 `FS/LS/payload/LE/FE -> pixel -> AXI` 闭环 | `tb_fpga_wrapper_raw8_metrics`、`tb_fpga_wrapper_raw10_metrics`、`tb_fpga_wrapper_rgb888_metrics`、`tb_fpga_wrapper_yuv422_metrics`、`tb_fpga_wrapper_axi_backpressure_metrics` | [thesis_result_tables.md](thesis_result_tables.md)、[format_comparison_results.md](结果验证/format_comparison_results.md)、[reliability_metrics_overview.png](结果验证/reliability_metrics_overview.png) |
| `RAW8 / RAW10 / RGB888 / YUV422` 四类格式已经闭环 | 四条格式路径均已得到时延、像素数和 frame 收尾结果；`RAW10` 已补 full-frame closure | `tb_fpga_wrapper_raw8_metrics`、`tb_fpga_wrapper_raw10_smoke`、`tb_fpga_wrapper_raw10_metrics`、`tb_fpga_wrapper_rgb888_metrics`、`tb_fpga_wrapper_yuv422_metrics` | [format_comparison_results.md](结果验证/format_comparison_results.md)、[raw10_full_frame_results.md](结果验证/raw10_full_frame_results.md) |
| `1 / 2 / 4 lane` 配置能力已经实现 | `lane1` 与 `lane4` 已有 wrapper 级 smoke，`lane2` 是主验证路径 | `tb_fpga_wrapper_raw8_lane_config_smoke`、`scripts/run_raw8_lane_config_smokes.ps1`，配合既有 `lane2` RAW8 smoke/metrics | [raw8_lane_config_results.md](结果验证/raw8_lane_config_results.md)、[thesis_result_tables.md](thesis_result_tables.md) |
| ECC/CRC/sync/lane 异常检测与恢复链已经实现 | 错误注入后可观察到 `err_*`、恢复链状态和恢复后的 clean frame / multiframe 结果 | `tb_fpga_wrapper_crc_error`、`tb_fpga_wrapper_ecc_error`、`tb_fpga_wrapper_resync_metrics`、`tb_fpga_wrapper_resync_clean_frame`、`tb_fpga_wrapper_resync_backpressure_multiframe` | [resync_clean_frame_results.md](结果验证/resync_clean_frame_results.md)、[resync_backpressure_multiframe_results.md](结果验证/resync_backpressure_multiframe_results.md)、[正式波形 README](结果验证/正式波形/README.md) |
| lane skew 容忍窗口与 overflow 边界已经量化 | 对 `lead_bytes`、`DESKEW_DEPTH`、后级 FIFO 参数做系统扫描，得到稳定窗口规律 | `tb_fpga_wrapper_lane_skew_scan`、`scripts/run_lane_buffer_sensitivity_sweep.ps1` | [lane_skew_scan_results.md](结果验证/lane_skew_scan_results.md)、[lane_buffer_sensitivity_results.md](结果验证/lane_buffer_sensitivity_results.md) |
| buffer 深度与 AXI 背压传播规律已经形成基础结论 | 对 `BYTE FIFO / AXI FIFO / stall / multiframe` 做参数扫描，并观察 `lane_ready` 回压与失稳边界 | `tb_fpga_wrapper_buffer_depth_sweep`、`scripts/run_buffer_depth_sweep.ps1`、`tb_fpga_wrapper_raw8_backpressure_stress`、`scripts/run_raw8_backpressure_stress_sweep.ps1` | [buffer_depth_sweep_results.md](结果验证/buffer_depth_sweep_results.md)、[raw8_backpressure_stress_results.md](结果验证/raw8_backpressure_stress_results.md) |
| 系统已经不止能跑单帧样例，而具备基础连续工作能力 | 多帧多行和恢复后 multiframe 场景都已保持 scoreboard 闭合 | `tb_fpga_wrapper_raw8_multiframe_stability`、`tb_fpga_wrapper_resync_backpressure_multiframe` | [raw8_multiframe_stability_results.md](结果验证/raw8_multiframe_stability_results.md)、[resync_backpressure_multiframe_results.md](结果验证/resync_backpressure_multiframe_results.md) |
| 当前 RTL / wrapper 已具备 FPGA 实现评估基础 | 当前 `HEAD` 的综合、实现、资源和时序报告都已固定留痕 | `fpga/vivado/run_synth_impl.tcl`、`fpga/vivado/run_impl_route_only.tcl` | [vivado_resource_timing_results.md](结果验证/vivado_resource_timing_results.md)、`fpga/vivado/reports/mipi_csi2_capture_fpga_head_20260519/` |
| 当前结果足以支撑“数字前端工程原型”口径 | 功能闭环、恢复闭环、参数边界、连续流与实现评估都已具备证据，但边界限制也已明确列出 | 上述所有系统级 TB、参数脚本和 Vivado 报告的组合证据 | [verification_master_report.md](verification_master_report.md)、[progress_gap_check.md](结果验证/progress_gap_check.md)、[thesis_status_matrix.md](thesis_status_matrix.md) |

对应理解建议：

- “主链路完成” 的证明重点是多格式 wrapper 路径闭环，而不是单个模块通过。
- “恢复能力实现” 的证明重点是恢复后 clean frame / multiframe 继续正确输出，而不是只看 `resync_done` 脉冲。
- “工程原型成立” 的证明是多类证据叠加后的综合判断，不应只依赖某一条 smoke 或某一张波形图。

## 3. 验证方法总览

### 3.1 验证分层

当前验证按下面几层组织：

| 层级 | 目标 | 典型入口 |
| --- | --- | --- |
| 模块级 | 校验子模块功能正确性和边界行为 | `tb/tests/` 下各 parser / FIFO / CRC / deskew / writer 用例 |
| wrapper 级系统验证 | 在真实顶层路径下验证 frame/line/pixel/AXI 行为闭环 | `tb_fpga_wrapper_*` 系列 |
| 错误注入与恢复 | 验证 CRC/ECC/sync/lane skew/backpressure/repeated error | `tb_fpga_wrapper_crc_*`、`tb_fpga_wrapper_ecc_*`、`tb_fpga_wrapper_resync_*`、`tb_fpga_wrapper_lane_skew_*` |
| 参数扫描 | 验证可调参数对系统边界的影响 | `run_buffer_depth_sweep.ps1`、`run_lane_buffer_sensitivity_sweep.ps1`、`run_raw8_backpressure_stress_sweep.ps1` |
| FPGA 实现评估 | 形成资源/时序结果与波形留痕 | `fpga/vivado/` 下 TCL/PowerShell 与 `reports/` |

### 3.2 结果留痕规则

当前仓库采用下面的留痕方式：

1. 用 `tb/tests/*.sv` 固化 testbench 行为与自检逻辑。
2. 用 `scripts/*.ps1` 或 `fpga/vivado/*.ps1` 固化批量执行入口。
3. 用 `docs/spec/结果验证/*.md` 记录每类实验的参数、原始结果摘要、建议引用口径和边界条件。
4. 用 `docs/spec/结果验证/正式波形/*.png` 保存适合论文截图引用的关键波形窗口。
5. 用 [论文结果总表](thesis_result_tables.md) 汇总可直接入论文表格的数字。

### 3.3 当前主验证入口

| 类别 | 主要 testbench / 脚本 | 主要结果留痕 |
| --- | --- | --- |
| 基础格式路径 | `tb_fpga_wrapper_raw8_metrics`、`tb_fpga_wrapper_raw10_metrics`、`tb_fpga_wrapper_rgb888_metrics`、`tb_fpga_wrapper_yuv422_metrics` | [format_comparison_results.md](结果验证/format_comparison_results.md) |
| RAW10 full-frame 收尾 | `tb_fpga_wrapper_raw10_smoke`、`tb_fpga_wrapper_raw10_metrics` | [raw10_full_frame_results.md](结果验证/raw10_full_frame_results.md) |
| AXI 背压 | `tb_fpga_wrapper_axi_backpressure_metrics` | [reliability_metrics_overview.png](结果验证/reliability_metrics_overview.png) |
| Buffer 深度趋势 | `tb_fpga_wrapper_buffer_depth_sweep`、`scripts/run_buffer_depth_sweep.ps1` | [buffer_depth_sweep_results.md](结果验证/buffer_depth_sweep_results.md) |
| 连续流背压强化 | `tb_fpga_wrapper_raw8_backpressure_stress`、`scripts/run_raw8_backpressure_stress_sweep.ps1` | [raw8_backpressure_stress_results.md](结果验证/raw8_backpressure_stress_results.md) |
| Lane skew 窗口 | `tb_fpga_wrapper_lane_skew_scan` | [lane_skew_scan_results.md](结果验证/lane_skew_scan_results.md) |
| Lane / buffer 联合敏感性 | `tb_fpga_wrapper_lane_skew_scan`、`scripts/run_lane_buffer_sensitivity_sweep.ps1` | [lane_buffer_sensitivity_results.md](结果验证/lane_buffer_sensitivity_results.md) |
| Resync 恢复 | `tb_fpga_wrapper_resync_metrics`、`tb_fpga_wrapper_resync_clean_frame`、`tb_fpga_wrapper_resync_backpressure_multiframe` | [resync_clean_frame_results.md](结果验证/resync_clean_frame_results.md)、[resync_backpressure_multiframe_results.md](结果验证/resync_backpressure_multiframe_results.md) |
| 连续多帧稳定性 | `tb_fpga_wrapper_raw8_multiframe_stability` | [raw8_multiframe_stability_results.md](结果验证/raw8_multiframe_stability_results.md) |
| 1/2/4 lane 配置 | `tb_fpga_wrapper_raw8_lane_config_smoke`、`scripts/run_raw8_lane_config_smokes.ps1` | [raw8_lane_config_results.md](结果验证/raw8_lane_config_results.md) |
| Vivado 资源/时序 | `fpga/vivado/run_synth_impl.tcl`、`fpga/vivado/run_impl_route_only.tcl` | [vivado_resource_timing_results.md](结果验证/vivado_resource_timing_results.md) |
| 正式波形截图 | `fpga/vivado/build_one_xsim_snapshot.ps1`、`fpga/vivado/capture_one_xsim_wave.ps1` | [正式波形 README](结果验证/正式波形/README.md) |

## 4. 结果总览

### 4.1 功能覆盖结论

当前可以确认已经具备系统级证据的功能包括：

- `1 / 2 / 4 lane` 可配置接收路径
- CSI-2 short packet / long packet 基本解析
- lane deskew 与 lane reorder
- Header ECC / Payload CRC 检错
- frame / line marker 输出
- RAW8 / RAW10 / RGB888 / YUV422 像素路径
- AXI 写通路与背压传播
- sync error 触发 resync、恢复后 clean frame、恢复后 multiframe 持续工作

### 4.2 多格式结果汇总

数据来源：

- `tb_fpga_wrapper_raw8_metrics`
- `tb_fpga_wrapper_raw10_metrics`
- `tb_fpga_wrapper_rgb888_metrics`
- `tb_fpga_wrapper_yuv422_metrics`

| Format | `init_to_frame` | `frame_to_first_pixel` | `frame_to_end` | `first_to_last_pixel` | `pixel_valid_cycles` | Full-frame closure | 说明 |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| `RAW8` | `14` | `16` | `34` | `3` | `4` | Yes | baseline 最短主链路 |
| `RAW10` | `16` | `20` | `38` | `3` | `4` | Yes | 前端整理时延高于 `RAW8` |
| `RGB888` | `14` | `18` | `42` | `9` | `4` | Yes | 当前最小样例下整帧跨度最长 |
| `YUV422` | `14` | `19` | `40` | `7` | `4` | Yes | 介于 `RAW10` 与 `RGB888` 之间 |

结论：

- `RAW8` 是当前最短 baseline 路径。
- `RAW10` 的输出跨度与 `RAW8` 一致，但前端整理时延更高。
- `RGB888` 和 `YUV422` 已经形成对照组，可支撑论文中的格式横向比较。

边界说明：

- `RAW10` 当前已完成 wrapper 路径 full-frame closure。
- 为了把尾部 `FE` short packet 的最后一个 ECC 字节稳定推出，testbench 在 `FE` 后追加了一个 flush byte；该处理仅作用于激励层，不修改 DUT RTL。

### 4.3 连续流与稳定性结果

| 场景 | 结果摘要 | 说明 |
| --- | --- | --- |
| `RAW8` 多帧多行稳定性 | `frames=3`, `lines=9`, `total_pixels=36`, `mismatch=0` | 已证明不是只会跑最小单帧样例 |
| `RAW8` 背压强化稳定区 | 在 `AXI_FIFO_ADDR_WIDTH=3` 下，多组连续流压力保持 `PASS` | 当前实现先在 lane 入口节流吸收背压 |
| `RAW8` 浅 FIFO 失稳边界 | `AXI_FIFO_ADDR_WIDTH=2`, `stall=16`, `6x4` 出现 timeout + mismatch | 当前不建议把该配置作为工程默认值 |
| `resync + backpressure + multiframe` | `frames=2`, `lines=4`, `exp=16 act=16`, `mismatch=0` | 恢复后可以继续在背压下连续工作 |

结论：

- 当前系统已经具备“恢复后继续连续工作”的证据。
- `AXI_FIFO_ADDR_WIDTH=3` 是当前更稳妥的最小工程建议值。

### 4.4 Lane skew 与参数边界结果

#### 基线窗口扫描

配置：`LANE_NUM=2`, `DATA_TYPE=RAW8`, `DESKEW_DEPTH=4`

| `lead_bytes` | 结果 | 结论 |
| --- | --- | --- |
| `0..4` | `act=4, mismatch=0, overflow=0` | 容忍窗口内通过 |
| `5` | `act=0, overflow=1` | 超界 overflow |

结论：

- `tolerance window = DESKEW_DEPTH`
- `overflow boundary = DESKEW_DEPTH + 1`

#### 联合敏感性扫描

配置矩阵：

- `DESKEW_DEPTH ∈ {2, 4, 6}`
- `BYTE_FIFO_ADDR_WIDTH ∈ {2, 4}`
- `AXI_FIFO_ADDR_WIDTH ∈ {3, 6}`

观察结论：

- 所有组合都满足 `lane skew tolerance window = DESKEW_DEPTH`
- 后级 `BYTE FIFO / AXI FIFO` 只改变瞬时回压现象，不改变容忍窗口边界

工程含义：

- 如果工程目标是扩大 lane skew 容忍范围，优先调 `DESKEW_DEPTH`
- 单纯加深后级 FIFO 不能等效替代 deskew 深度

### 4.5 恢复能力结果

#### Resync 时延

来源：`tb_fpga_wrapper_resync_metrics`

| 指标 | 数值 |
| --- | ---: |
| `sync_to_req` | `1` |
| `req_to_busy` | `0` |
| `busy_to_clear` | `0` |
| `clear_to_done` | `1` |
| `sync_to_done` | `2` |

#### Resync 后 clean frame 恢复

结果摘要：

- `err_sync_o` 已触发
- `resync_req / busy / done` 全部观测到
- `clear_sys / clear_byte` 全部观测到
- 恢复后 clean `RAW8` frame 像素结果 `exp=4 act=4 mismatch=0`

#### Resync + AXI 背压 + clean multiframe

结果摘要：

- 恢复后 `2` 帧、`4` 行 clean `RAW8` 连续输出闭合
- `aw_stall_cycles=52`, `w_stall_cycles=52`
- `exp=16 act=16 mismatch=0`

结论：

- 当前恢复策略不是“只发一个恢复脉冲”，而是已经证明能在恢复后继续工作。

### 4.6 Lane 配置结果

来源：`tb_fpga_wrapper_raw8_lane_config_smoke`

| `LANE_NUM` | exp pixels | act pixels | frames | 说明 |
| --- | ---: | ---: | ---: | --- |
| `1` | `2` | `2` | `1` | 单 lane wrapper 路径闭合 |
| `2` | 已有既有 smoke/metrics 支撑 | 已闭合 | 已闭合 | 当前主验证路径 |
| `4` | `2` | `2` | `1` | 四 lane wrapper 路径闭合 |

结论：

- `1 / 2 / 4 lane` 配置能力已经实现。
- 但 `1 lane` 与 `4 lane` 目前仍是 smoke 级补证，验证深度不等价于 `2 lane` 主路径。

### 4.7 Vivado 资源与时序结果

对象：`mipi_csi2_capture_fpga_wrapper`  
器件：`xczu9eg-ffvb1156-2-e`  
报告目录：`fpga/vivado/reports/mipi_csi2_capture_fpga_head_20260519/`

| 指标 | 综合后 | 实现后 |
| --- | ---: | ---: |
| LUT | `541` | `530` |
| FF | `818` | `819` |
| BRAM Tile | `0` | `0` |
| DSP | `0` | `0` |
| Bonded IOB | `59 / 328` | `59 / 328` |

| 时序项 | 数值 | 说明 |
| --- | ---: | --- |
| Global WNS | `-2.725 ns` | 全局 setup 未收敛 |
| Global TNS | `-327.762 ns` | 全局负裕量 |
| Worst clock pair | `clk_byte -> clk_sys` | 主负 slack 来自跨时钟路径 |

结论：

- 当前 RTL 与 wrapper 已经可综合、可实现。
- 资源占用较低，说明架构没有失控。
- 但当前时序结果仍是“保守实现评估”，不能直接表述为最终板级 timing clean。

## 5. 正式波形与截图留痕

当前论文候选波形截图位于：

- [正式波形目录](结果验证/正式波形/README.md)

当前已固化的关键截图包括：

- `01_raw8_main_path_xsim.png`
- `02_crc_error_xsim.png`
- `03_ecc_error_xsim.png`
- `04_resync_recovery_xsim.png`
- `05_lane_skew_overflow_xsim.png`
- `06_axi_backpressure_xsim.png`
- `07_resync_clean_frame_xsim.png`

这些图片的共同特点是：

- 已经裁成波形窗口，不再把源码编辑区带进去
- 已经对齐到关键事件时窗，而不是停留在结束帧尾部
- 可直接作为论文插图候选或工程汇报附件

## 6. 当前工程适用性判断

从工程角度看，当前系统已经可以支撑下面的结论：

- 可以作为“数字前端 RTL 工程原型”交付
- 可以支持论文级核心结论与主要实验表格
- 可以用于说明主链路、错误恢复和关键边界条件已经实现

但当前还不宜直接表述为：

- 完整产品态可量产模块
- 完整 ASIC-ready 前端
- 所有 lane/格式/异常组合都已等强度验证

原因主要有四类：

1. 当前阶段只实现数字逻辑，不包含真实模拟 D-PHY。
2. `2 lane` 是最强主验证路径，`1 lane / 4 lane` 仍偏 smoke 级。
3. 吞吐极限、长时 soak、更多 corner 覆盖还未做满。
4. Vivado 时序目前仍属于保守实现评估，不是最终板级收敛状态。

## 7. 当前已知边界与引用注意事项

论文或工程汇报里，建议保留下面这些边界说明：

1. `RAW10` full-frame closure 已经成立，但依赖 testbench 侧 `flush byte` 推出尾部单字节；该处理不修改 DUT。
2. `AXI_FIFO_ADDR_WIDTH=2` 已观测到连续流失稳边界，不建议作为当前工程最小默认值。
3. `lane skew` 容忍窗口由 `DESKEW_DEPTH` 主导，后级 FIFO 不能等效替代。
4. Vivado 结果应表述为“当前 HEAD 的实现评估结果”，不是最终板级 timing signoff。
5. 正式波形截图是展示关键机制的辅助证据，最终结论仍以 markdown 结果文件与 testbench 自检结果为准。

## 8. 可交付版本说明

为便于对外整理，当前仓库已增加交付导出脚本：

- [交付目录说明](../../deliverables/README.md)
- `scripts/package_delivery_release.ps1`

该脚本会生成一个独立的可交付目录，包含：

- 最终 RTL
- testbench 与回归入口
- 论文/工程可引用的验证结果文档
- Vivado 脚本、XDC 与当前 HEAD 资源/时序报告
- 结果截图与正式波形留痕

同时会明确排除：

- `.Xil`、`xsim.dir`
- 顶层临时 `wdb/jou/log/str/pb`
- `fpga/vivado/work/`
- 大量原始运行缓存

## 9. 后续建议

如果后续继续增强工程说服力，建议按下面顺序推进：

1. 增加更长时间连续流 / soak 级验证
2. 补 `1 lane / 4 lane` 的异常注入和恢复级覆盖
3. 增加更强吞吐上限与 AXI 饱和边界扫描
4. 补 ASIC 前端视角的 lint / CDC / DFT / 约束整理

---

本报告是当前验证方法和验证结果的统一总入口；数字细节以 [论文结果总表](thesis_result_tables.md) 和 [结果验证目录](结果验证/README.md) 为准。
