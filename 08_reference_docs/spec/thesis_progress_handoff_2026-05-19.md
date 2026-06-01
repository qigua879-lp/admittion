# Thesis Progress Handoff 2026-05-19

## Purpose

这份文档用于在新聊天中快速接上当前毕业论文推进状态，避免重复梳理上下文。

## Current Workspace State

- Repository:
  - `C:\Users\qigua\OneDrive\Desktop\MIPI ALL`
- Active branch:
  - `codex/thesis-stage-a`
- Local HEAD:
  - `42ccd28` `docs: detail formal waveform readme`
- Important local-only commit not yet pushed:
  - `63fc087` `docs: add formal vivado waveform evidence`
  - `42ccd28` `docs: detail formal waveform readme`
- Remote branch currently confirmed at:
  - `5b300b0` `docs: add result-validation artifacts and resync metrics`
- Working tree:
  - clean

## Push Note

最近两次 `git push origin codex/thesis-stage-a` 因 GitHub 443 网络中断失败，不是仓库内容问题。

若网络恢复，先执行：

```powershell
git push origin codex/thesis-stage-a
```

## Overall Stage Status

### Stage A: Baseline Freeze And Mapping

- Status:
  - completed
- Evidence:
  - `docs/spec/thesis_status_matrix.md`
  - `docs/spec/thesis_experiment_matrix.md`
  - `docs/spec/thesis_result_tables.md`

### Stage B: High-Value Engineering Refinement

- Status:
  - mostly completed
- Evidence:
  - 系统级 wrapper/top 验证主干已建立
  - 错误注入、恢复、背压、lane skew 关键 case 已具备
  - 多格式真实路径已补齐到当前论文所需深度

### Stage C: Quantitative Closure And Thesis Body

- Status:
  - in progress
- Evidence:
  - 多格式 metrics 已有基础数字
  - `resync` 与 `AXI backpressure` 已有量化结果
  - 第一批正式 `Vivado/xsim` 波形图已补齐

### Stage D: Final Polish And Defense Prep

- Status:
  - not started

## Master Task Table

| Area | Overall expectation in master plan | Current status | Evidence / files | Remaining gap |
| --- | --- | --- | --- | --- |
| Baseline inventory | 明确“做完了什么、验证到哪里” | Completed | `docs/spec/thesis_status_matrix.md` | 后续只需随结果同步微调 |
| Experiment matrix | 建立系统实验矩阵与优先级 | Completed | `docs/spec/thesis_experiment_matrix.md` | 后续补新结果时同步更新 |
| Result table skeleton | 建立论文结果表框架 | Completed | `docs/spec/thesis_result_tables.md` | 后续只需随新结果同步微调 |
| RAW8 system path | 主链路 + 异常 + 恢复 + metrics | Completed at thesis-useful level | RAW8 smoke/error/metrics tests, result tables, `tb_fpga_wrapper_raw8_multiframe_stability.sv`, `tb_fpga_wrapper_raw8_lane_config_smoke.sv`, `docs/spec/结果验证/raw8_lane_config_results.md` | 已补 `lane1/lane4` wrapper 级 smoke，仍可继续补 lane 量化对比 |
| RGB888 system path | 至少 smoke + metrics | Completed | `tb_fpga_wrapper_rgb888_smoke.sv`, `tb_fpga_wrapper_rgb888_metrics.sv` | 已进入统一横向比较表 |
| RAW10 system path | 至少真实路径证明 | Completed at thesis-useful level | `tb_fpga_wrapper_raw10_smoke.sv`, `tb_fpga_wrapper_raw10_metrics.sv`, `docs/spec/结果验证/raw10_full_frame_results.md` | 已进入统一横向比较表 |
| YUV422 system path | 至少 smoke + metrics | Completed | `tb_fpga_wrapper_yuv422_smoke.sv`, `tb_fpga_wrapper_yuv422_metrics.sv` | 已进入统一横向比较表 |
| CRC error injection | 系统级异常注入 | Completed | `tb_fpga_wrapper_crc_error.sv` | 无关键缺口 |
| ECC error injection | 系统级异常注入 | Completed at single-error level | `tb_fpga_wrapper_ecc_error.sv` | 多错场景仍可继续补 |
| Illegal sync / resync | 系统级恢复链 | Completed at thesis-useful level | `tb_fpga_wrapper_sync_illegal_order.sv`, `tb_fpga_wrapper_resync_recovery.sv`, `tb_fpga_wrapper_resync_metrics.sv`, `tb_fpga_wrapper_resync_clean_frame.sv`, `tb_fpga_wrapper_resync_backpressure_multiframe.sv`, `docs/spec/结果验证/resync_backpressure_multiframe_results.md` | repeated-error 分布与 CRC 叠加仍可继续量化 |
| Repeated error during resync | 论文型负场景 | Completed | `tb_fpga_wrapper_resync_repeated_error.sv` | 可进入论文异常恢复讨论 |
| Lane skew | tolerance + overflow + 边界扫描 | Completed at thesis-useful level | `tb_fpga_wrapper_lane_skew_tolerance.sv`, `tb_fpga_wrapper_lane_skew_overflow.sv`, `tb_fpga_wrapper_lane_skew_scan.sv`, `scripts/run_lane_buffer_sensitivity_sweep.ps1`, `docs/spec/结果验证/lane_buffer_sensitivity_results.md` | 已补 deskew/buffer 联合敏感性，后续更适合转向 lane1/lane4 或多格式补证 |
| AXI backpressure | 系统级背压与指标 | Completed | `tb_fpga_wrapper_axi_backpressure.sv`, `tb_fpga_wrapper_axi_backpressure_metrics.sv` | 可继续扩 burst/throughput 对比 |
| FIFO / buffer depth analysis | 性能和缓存需求 | Partially completed | `tb/tests/tb_fpga_wrapper_buffer_depth_sweep.sv`, `tb/tests/tb_fpga_wrapper_raw8_backpressure_stress.sv`, `scripts/run_buffer_depth_sweep.ps1`, `scripts/run_raw8_backpressure_stress_sweep.ps1`, `docs/spec/结果验证/buffer_depth_sweep_results.md`, `docs/spec/结果验证/raw8_backpressure_stress_results.md` | 已有基础占用趋势扫描和连续流背压强化扫描，仍缺完整像素侧 stall 阈值曲线 |
| Reliability methodology | 形成论文方法论 | Partially completed | 现有结果已能支撑叙述 | 还需写成正式章节语言 |
| Formal waveform evidence | 论文正式仿真图 | Completed for first batch | `docs/spec/结果验证/正式波形/` | 当前批次已够第一轮论文配图 |
| Vivado resource/timing closure | LUT/FF/BRAM/Fmax/worst path | Completed at thesis-useful level | `docs/spec/结果验证/vivado_resource_timing_results.md`, `fpga/vivado/reports/mipi_csi2_capture_fpga_head_20260519/` | 板级约束与 CDC 时序例外仍可继续完善 |
| Thesis body drafting | 第 2-6 章主体 | Not started in this branch as full draft | 只有结构化矩阵和素材 | 需要开始把结果转换成章节文字 |

## Verification Assets Already Prepared

### Result summary assets

- `docs/spec/结果验证/format_latency_overview.png`
- `docs/spec/结果验证/system_coverage_overview.png`
- `docs/spec/结果验证/reliability_metrics_overview.png`

### Formal Vivado/xsim waveforms

- `docs/spec/结果验证/正式波形/01_raw8_main_path_xsim.png`
- `docs/spec/结果验证/正式波形/02_crc_error_xsim.png`
- `docs/spec/结果验证/正式波形/03_ecc_error_xsim.png`
- `docs/spec/结果验证/正式波形/04_resync_recovery_xsim.png`
- `docs/spec/结果验证/正式波形/05_lane_skew_overflow_xsim.png`
- `docs/spec/结果验证/正式波形/06_axi_backpressure_xsim.png`
- `docs/spec/结果验证/正式波形/07_resync_clean_frame_xsim.png`

### Formal waveform regeneration path

- `fpga/vivado/build_one_xsim_snapshot.ps1`
- `fpga/vivado/capture_one_xsim_wave.ps1`
- `fpga/vivado/formal_wave_tcl/`
- `docs/spec/结果验证/正式波形/README.md`

Important note:

- GUI waveform capture must run serially, not in parallel.
- These PNGs are real `Vivado/xsim` window captures, not post-generated graphics.

## Highest-Priority Remaining Gaps

### P1

1. 工程适用性评估成文
2. 若时间允许，再补 CRC/repeated-error 叠加
3. 再往后可补 lane1/lane4 量化对比

## Recommended Next-Chat Starting Prompt

如果要在新聊天中无缝接上，建议直接说明：

```text
请读取 docs/spec/thesis_progress_handoff_2026-05-19.md，
当前分支是 codex/thesis-stage-a。
先从 P0 缺口继续，优先做 lane skew 容忍窗口扫描表，
并把结果同步写回 thesis_result_tables.md 和 progress_gap_check.md。
```

## Practical Next Step Recommendation

建议下一步严格按这个顺序继续：

1. 先整理工程适用性评估成文
2. 再补 CRC/repeated-error 叠加
3. 然后视时间补 lane1/lane4 量化对比

原因：

- `Vivado` 资源与时序结果已经具备论文可用口径
- `RAW10` 真实 wrapper 路径的 `LE/FE` 收尾已经闭合
- 多格式横向比较表已经成文，可直接进入论文结果章节
- buffer 深度关系已经有基础趋势表，连续流背压强化扫描已证明 lane 侧回压与浅 FIFO 失稳边界
- lane / buffer 联合敏感性已经证明 skew 容忍窗口仍只由 `DESKEW_DEPTH` 主导
- 连续流异常混合场景已经有 `resync + backpressure + clean multiframe` 的系统级闭环
- `lane1 / lane4` wrapper 级 smoke 已补齐，`1 / 2 / 4 lane` 现在都具备至少一条系统级闭环证据
- `RAW8` 连续多帧 / 多行稳定性已经补齐，不再只停留在最小单帧样例
- 剩余工作都更偏 P1 说服力增强，而不是核心闭环阻塞
