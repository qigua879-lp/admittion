# 2026-05-21 正式重验证目录说明

本目录保存本轮正式重验证的最终交付物与证据链。

## 目录结构

- `docs/`
  - `formal_reverification_plan_20260521.md`：本轮重验证实施计划
  - `formal_reverification_summary_20260521.md`：总报告
  - `verification_run_summary.md`：55 个 testbench 重跑汇总
  - `wave_capture_summary.md`：7 张正式波形截图汇总
- `tables/`
  - `testbench_results.md`
  - `topic_evidence_matrix.md`
  - `wave_capture_results.md`
- `waves/`：正式波形截图 PNG
- `logs/`：`iverilog/vvp` 编译与运行日志
- `xsim_wave_logs/`：XSim batch 与 Vivado 打开波形的日志
- `compile/`：批量重跑生成的编译产物

## 推荐阅读顺序

1. `docs/formal_reverification_summary_20260521.md`
2. `docs/verification_run_summary.md`
3. `docs/wave_capture_summary.md`
4. `tables/topic_evidence_matrix.md`
