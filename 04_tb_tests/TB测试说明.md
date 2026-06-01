# TB 测试说明

## 1. TB 目录结构

| 目录 | 内容 |
| --- | --- |
| `tb/top/` | 顶层 testbench |
| `tb/models/` | sensor 输入模型 |
| `tb/refs/` | CSI-2 参考函数和辅助任务 |
| `tb/scoreboard/` | scoreboard 自检逻辑 |
| `tb/seq/` | 激励序列说明 |
| `tb/tests/` | 模块级和 wrapper 级测试用例 |
| `compile.f` | 仿真编译文件 |

## 2. 已覆盖的测试类型

| 测试类别 | 典型 testbench | 验证重点 |
| --- | --- | --- |
| PHY 数字适配 | `tb_phy_digital_adapter.sv` | lane valid、HS/LP 模式、输入适配 |
| CSI-2 parser | `tb_short_packet_parser.sv`、`tb_long_packet_parser.sv` | short/long packet 解析 |
| ECC/CRC | `tb_header_ecc.sv`、`tb_payload_crc.sv` | Header ECC、Payload CRC 检测 |
| lane 对齐 | `tb_lane_deskew_buffer.sv`、`tb_lane_reorder_merge.sv` | 多 lane deskew、重排、overflow |
| 帧行同步 | `tb_frame_line_sync.sv` | FS/FE/LS/LE 顺序与计数 |
| 像素格式 | `tb_raw8_unpack.sv`、`tb_raw10_unpack.sv`、`tb_rgb888_unpack.sv`、`tb_yuv422_unpack.sv` | 多格式像素重组 |
| 可靠性 | `tb_resync_ctrl.sv`、`tb_packet_error_policy.sv`、`tb_err_classifier.sv` | 错误分类、重同步、策略控制 |
| FIFO/AXI | `tb_async_fifo.sv`、`tb_axi_write_master.sv`、`tb_pixel_to_axi_writer.sv` | CDC FIFO、AXI 写通路 |
| 系统 wrapper | `tb_fpga_wrapper_*` | 顶层路径、错误注入、背压、多帧稳定性 |

## 3. 重点系统级用例

| 用例 | 说明 |
| --- | --- |
| `tb_fpga_wrapper_raw8_metrics.sv` | RAW8 主链路时延与像素结果 |
| `tb_fpga_wrapper_raw10_metrics.sv` | RAW10 full-frame closure |
| `tb_fpga_wrapper_rgb888_metrics.sv` | RGB888 主链路验证 |
| `tb_fpga_wrapper_yuv422_metrics.sv` | YUV422 主链路验证 |
| `tb_fpga_wrapper_crc_error.sv` | CRC 错误注入 |
| `tb_fpga_wrapper_ecc_error.sv` | ECC 错误注入 |
| `tb_fpga_wrapper_resync_clean_frame.sv` | 同步错误后 clean frame 恢复 |
| `tb_fpga_wrapper_resync_backpressure_multiframe.sv` | resync 后叠加 AXI 背压和多帧输入 |
| `tb_fpga_wrapper_lane_skew_scan.sv` | lane skew 容忍窗口扫描 |
| `tb_fpga_wrapper_raw8_backpressure_stress.sv` | RAW8 连续流背压强化测试 |
| `tb_fpga_wrapper_raw8_soak_metrics.sv` | RAW8 多 lane 多帧多行 soak 与吞吐指标 |
| `tb_fpga_wrapper_axi_mem_closure.sv` | RAW8 经 AXI 写入内部 memory 后再读回 scoreboard |

## 4. 自检方法

testbench 中使用 scoreboard 比较期望像素数、实际像素数和 mismatch 数量。错误注入类测试会检查 `err_ecc_o`、`err_crc_o`、`err_sync_o`、`resync_req`、`resync_busy`、`resync_done` 等状态链路。

在我当前的理解中，这些 TB 不只是 happy path，还包含 CRC/ECC 错误、非法同步顺序、lane skew overflow、AXI 背压、恢复后继续输出等场景，因此能比较完整地说明系统可靠性。

## 5. 本次新增测试

| 测试 | 脚本 | 结果文档 | 说明 |
| --- | --- | --- | --- |
| `tb_fpga_wrapper_raw8_soak_metrics.sv` | `scripts/run_raw8_soak_throughput_sweep.ps1` | `docs/spec/结果验证/raw8_soak_throughput_results.md` | 验证 `1 / 2 / 4 lane` 在 RAW8 多帧多行连续流下 scoreboard clean，并采集吞吐指标 |
| `tb_fpga_wrapper_axi_mem_closure.sv` | `scripts/run_axi_mem_lane_regression.ps1` | `docs/spec/结果验证/axi_mem_lane_regression_results.md` | 验证 `RAW8 -> AXI write -> internal memory -> readback -> scoreboard` 闭环 |

## 6. 已知限制

| 限制 | 说明 |
| --- | --- |
| 长时间 soak | 已新增 32/48 帧 RAW8 soak，但还不是小时级或板级长稳测试 |
| lane1/lane4 深度 | 已有 smoke、soak 和 AXI memory closure 证据，但错误注入覆盖仍不如 lane2 完整 |
| 吞吐上限 | 当前更多是功能和边界测试，最终吞吐极限还需要继续扫参 |
| 真实 D-PHY | TB 使用数字抽象输入，没有模拟真实 D-PHY 电气噪声 |
