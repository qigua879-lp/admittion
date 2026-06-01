# 结果验证

本目录用于保存可直接引用到论文、周报或答辩材料中的“结果留痕”产物。

总入口报告：

- `../verification_master_report.md`
  - 汇总当前验证方法、核心结果、工程口径和交付整理方式

## 当前图片

- `format_latency_overview.png`
  - 汇总 `RAW8 / RGB888 / RAW10 / YUV422` 的真实 wrapper 路径基础时延结果
  - 数据来源：
    - `tb_fpga_wrapper_raw8_metrics`
    - `tb_fpga_wrapper_rgb888_metrics`
    - `tb_fpga_wrapper_raw10_metrics`
    - `tb_fpga_wrapper_yuv422_metrics`

- `system_coverage_overview.png`
  - 汇总系统级覆盖进度和当前阶段定位
  - 数据来源：
    - `docs/spec/thesis_status_matrix.md`
    - `docs/spec/thesis_experiment_matrix.md`

- `reliability_metrics_overview.png`
  - 汇总 AXI 背压与 resync 恢复的量化结果
  - 数据来源：
    - `tb_fpga_wrapper_axi_backpressure_metrics`
    - `tb_fpga_wrapper_resync_metrics`

- `lane_skew_scan_results.md`
  - 固化系统级 `lane skew` 容忍窗口扫描结果
  - 数据来源：
    - `tb_fpga_wrapper_lane_skew_scan`
    - `tb_fpga_wrapper_lane_skew_tolerance`
    - `tb_fpga_wrapper_lane_skew_overflow`

- `lane_buffer_sensitivity_results.md`
  - 固化 `DESKEW_DEPTH / BYTE_FIFO / AXI FIFO` 的联合敏感性扫描结果
  - 数据来源：
    - `tb_fpga_wrapper_lane_skew_scan`
    - `scripts/run_lane_buffer_sensitivity_sweep.ps1`

- `resync_clean_frame_results.md`
  - 固化 `resync` 后重新回到 clean frame 输出路径的系统级证明
  - 数据来源：
    - `tb_fpga_wrapper_resync_clean_frame`
    - `tb_fpga_wrapper_resync_recovery`
    - `tb_fpga_wrapper_resync_metrics`

- `resync_backpressure_multiframe_results.md`
  - 固化 `resync + AXI backpressure + clean multiframe` 的混合工况结果
  - 数据来源：
    - `tb_fpga_wrapper_resync_backpressure_multiframe`

- `buffer_depth_sweep_results.md`
  - 固化 `BYTE FIFO / AXI writer FIFO / AXI stall cycles` 的基础参数扫描结果
  - 数据来源：
    - `tb_fpga_wrapper_buffer_depth_sweep`
    - `scripts/run_buffer_depth_sweep.ps1`

- `raw8_multiframe_stability_results.md`
  - 固化真实 wrapper 路径下 `RAW8` 连续多帧 / 多行稳定性证明
  - 数据来源：
    - `tb_fpga_wrapper_raw8_multiframe_stability`

- `raw8_lane_config_results.md`
  - 固化 `lane1 / lane4` 的真实 wrapper 级 `RAW8` smoke 结果
  - 数据来源：
    - `tb_fpga_wrapper_raw8_lane_config_smoke`
    - `scripts/run_raw8_lane_config_smokes.ps1`

- `raw8_backpressure_stress_results.md`
  - 固化真实 wrapper 路径下 `RAW8` 连续流背压强化扫描与浅 FIFO 失稳边界
  - 数据来源：
    - `tb_fpga_wrapper_raw8_backpressure_stress`
    - `scripts/run_raw8_backpressure_stress_sweep.ps1`

- `正式波形/`
  - 保存使用 `Vivado 2017.3 xsim` 正式导出的波形窗口截图
  - 当前包含 RAW8、CRC、ECC、resync、lane skew、AXI backpressure 六张论文候选图
  - 当前这一批已经校正到关键事件时间窗，不再是“停在结束帧”的尾图

## 生成方式

使用脚本：

`python scripts/generate_result_validation_assets.py`

## 使用说明

- 图片内容只记录已经 fresh run 验证通过的数字。
- 若后续指标更新，应先更新论文结果表，再重新运行图片脚本。
- `RAW10` 现已补齐真实 wrapper 下的 full-frame closure，但尾部 `FE` 字节冲刷方式仍应按结果说明文件中的边界条件引用。
