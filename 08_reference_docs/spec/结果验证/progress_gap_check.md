# 进度与差距检查

## 当前总体位置

按总路线图划分：

1. `Stage A：现状固化与论文骨架`
   - 已完成

2. `Stage B：高收益系统级验证增强`
   - 已基本完成主干工作
   - 多格式真实 wrapper 路径、异常注入、恢复链、背压链路都已建立

3. `Stage C：量化结果闭环与论文主体成形`
   - 已进入
   - 当前已经具备多格式主链路时延、AXI 背压指标、resync 恢复时延等基础数字
   - 第一批正式 `Vivado/xsim` 论文波形图已补齐

## 已经完成的关键块

- `RAW8`：
  - smoke
  - CRC/ECC/sync/lane/resync/AXI/repeated-error/overflow
  - metrics

- `RGB888`：
  - smoke
  - metrics

- `RAW10`：
  - full-frame smoke
  - metrics

- `YUV422`：
  - smoke
  - metrics

- 恢复与可靠性：
  - resync 信号链闭合
  - repeated error 场景
  - resync 基础时延数字
  - AXI 背压基础时延数字
  - lane skew 容忍窗口扫描表

- 正式论文留痕：
  - `Vivado/xsim` 正式波形图 6 张
  - 结果摘要图 3 张
  - 对应再生成脚本与 Tcl 配置已入库

## 距离整体目标还差什么

### P0：论文结果闭环仍需继续补的项

1. 当前无新增 P0 缺口
   - `Vivado` 资源与时序结果已补齐到论文可用层级
   - 已有 `LUT / FF / BRAM / DSP / routed WNS/TNS / worst path / 同域 Fmax 估算`
   - 但需要在论文中明确说明：当前结果基于 FPGA wrapper 与占位 XDC，global negative slack 主要来自未切断的 `clk_byte -> clk_sys` CDC 路径

### P1：多格式结果还可继续加强的项

1. 更强吞吐 / buffer 饱和扫描
   - 当前已补连续流背压强化扫描
   - 已证明在稳定通过区间内，AXI 背压会先传回 `lane_ready`，并给出 `AXI_FIFO_ADDR_WIDTH=2` 的失稳边界样例
   - 但仍未形成“最终像素侧 stall 阈值”或“完整饱和上限曲线”

2. lane / buffer 参数扫描扩展
   - 当前已补 `DESKEW_DEPTH / BYTE_FIFO / AXI writer FIFO` 的联合敏感性表
   - 已证明 lane skew 容忍窗口仍只由 `DESKEW_DEPTH` 主导
   - `lane1 / lane4` wrapper 级 smoke 也已补齐
   - 若后续还要继续扩展，优先级更高的是跨 `lane count` 的量化对比或多格式补证，而不是继续堆更多低收益组合

3. 连续流异常混合场景
   - 当前已补 `resync + backpressure + clean multiframe`
   - 仍可继续扩展到 `CRC error` 或 `repeated error during busy`

## 本轮新增闭环

### Lane skew 容忍窗口

- 已完成系统级窗口扫描：
  - `tb/tests/tb_fpga_wrapper_lane_skew_scan.sv`
- 已形成结果留痕：
  - `docs/spec/结果验证/lane_skew_scan_results.md`
- 当前结论：
  - 在 `LANE_NUM=2`、`RAW8`、`DESKEW_DEPTH=4` 下
  - 可容忍 `lead_bytes=0..4`
  - `lead_bytes=5` 时出现 overflow
- 论文可直接使用的归纳语句：
  - `tolerance window = DESKEW_DEPTH`
  - `overflow boundary = DESKEW_DEPTH + 1`

### Resync 后 Clean-Frame 恢复

- 已完成系统级恢复后输出证明：
  - `tb/tests/tb_fpga_wrapper_resync_clean_frame.sv`
- 已形成结果留痕：
  - `docs/spec/结果验证/resync_clean_frame_results.md`
- 当前结论：
  - 非法同步事件触发 `err_sync -> resync_req -> resync_busy -> clear_sys -> clear_byte -> resync_done`
  - 恢复完成后，新的 clean RAW8 frame 能重新输出完整 `frame/line/pixel`
  - scoreboard 结果为 `exp=4 act=4 mismatch=0`
- 本轮同时补强了恢复相关 RTL：
  - `lane_deskew_buffer.clear_i`
  - `lane_reorder_merge.clear_i`
  - 由 `resync_clear_pulse_byte` 驱动 byte 域 flush

## 建议的下一优先级

1. 先补更强吞吐 / buffer 饱和扫描
2. 再补 lane / buffer 参数扫描扩展
3. 若时间允许，再补连续流异常混合场景

## 本轮新增闭环

### 多格式横向比较表

- 已完成统一对比表：
  - `docs/spec/thesis_result_tables.md`
  - `docs/spec/结果验证/format_comparison_results.md`
- 当前已统一整理：
  - `RAW8 / RAW10 / RGB888 / YUV422`
  - `init_to_frame / frame_to_first_pixel / frame_to_end / first_to_last_pixel / pixel_valid_cycles / full-frame closure`
- 当前结论：
  - `RAW8` 为最短 baseline 主链路
  - `RAW10` 与 `RAW8` 像素输出跨度一致，但前端整理时延更高
  - `RGB888` 的整帧跨度最长
  - `YUV422` 整体位于 `RAW10` 与 `RGB888` 之间

## 本轮新增闭环

### Buffer 深度与背压关系基础扫描

- 已完成基础参数扫描：
  - `tb/tests/tb_fpga_wrapper_buffer_depth_sweep.sv`
  - `scripts/run_buffer_depth_sweep.ps1`
  - `docs/spec/结果验证/buffer_depth_sweep_results.md`
- 当前已完成矩阵：
  - `BYTE_FIFO_ADDR_WIDTH ∈ {2,3,4}`
  - `AXI_FIFO_ADDR_WIDTH ∈ {3,4,6}`
  - `AXI_STALL_CYCLES ∈ {6,16}`
  - `RAW8`, `LANE_NUM=2`, `PIXEL_COUNT=16`, `AXI_DATA_WIDTH=128`
- 当前结论：
  - `max_byte_fifo_level` 随 byte FIFO 深度增加而上升：`3 -> 7 -> 10`
  - `max_axi_fifo_level` 在本样例下固定为 `4`
  - `lane_bp_cycles` 与 `pixel_stall_cycles` 均为 `0`
  - 当前结果适合作为“占用趋势扫描”，暂不应表述为最终吞吐上限或饱和边界

## 本轮新增闭环

### 连续多帧 / 多行稳定性

- 已完成系统级连续流稳定性证明：
  - `tb/tests/tb_fpga_wrapper_raw8_multiframe_stability.sv`
- 已形成结果留痕：
  - `docs/spec/结果验证/raw8_multiframe_stability_results.md`
- 当前结论：
  - 在真实 wrapper 路径下，`RAW8` 已完成 `3` 帧、`9` 行、`36` 像素的连续闭环
  - `frame_start / frame_end / line_start / line_end / pixel_sof / pixel_sol` 计数均与预期一致
  - scoreboard 结果为 `scoreboard_frames=3, mismatch=0`

## 本轮新增闭环

### RAW8 连续流背压强化扫描

- 已完成系统级连续流压力扫描：
  - `tb/tests/tb_fpga_wrapper_raw8_backpressure_stress.sv`
  - `scripts/run_raw8_backpressure_stress_sweep.ps1`
- 已形成结果留痕：
  - `docs/spec/结果验证/raw8_backpressure_stress_results.md`
- 当前结论：
  - 在 `BYTE_FIFO_ADDR_WIDTH=2`、`AXI_FIFO_ADDR_WIDTH=3`、`AXI_DATA_WIDTH=128` 下
  - `stall=12, 4x4`、`stall=16, 6x4`、`stall=16, 8x4`、`stall=24, 4x4` 均可稳定通过
  - 上述稳定工作点都已观测到 `lane_bp_seen=1`
  - `pixel_stall_seen` 在稳定通过区间内仍为 `0`
  - 当 `AXI_FIFO_ADDR_WIDTH=2` 且 `stall=16, 6x4` 时进入失稳边界，出现 scoreboard 失配和 timeout
- 当前论文/工程可用口径：
  - 当前实现已具备“先 lane 节流、后像素停顿”的吸压特征
  - `AXI_FIFO_ADDR_WIDTH=3` 可作为当前更稳妥的最小工程建议值
  - `AXI_FIFO_ADDR_WIDTH=2` 仍需专项排查后再作为工程配置使用

## 本轮新增闭环

### Lane / Buffer 联合敏感性扫描

- 已完成联合参数扫描：
  - `tb/tests/tb_fpga_wrapper_lane_skew_scan.sv`
  - `scripts/run_lane_buffer_sensitivity_sweep.ps1`
- 已形成结果留痕：
  - `docs/spec/结果验证/lane_buffer_sensitivity_results.md`
- 当前矩阵：
  - `DESKEW_DEPTH ∈ {2, 4, 6}`
  - `BYTE_FIFO_ADDR_WIDTH ∈ {2, 4}`
  - `AXI_FIFO_ADDR_WIDTH ∈ {3, 6}`
- 当前结论：
  - 所有组合都满足 `tolerant window = DESKEW_DEPTH`
  - 所有组合都满足 `overflow boundary = DESKEW_DEPTH + 1`
  - `BYTE FIFO / AXI writer FIFO` 不会改变当前 lane skew 容忍边界
- 当前论文/工程可用口径：
  - 若目标是提升 lane skew 容忍窗口，应优先调整 `DESKEW_DEPTH`
  - 后级 FIFO 深度更适合用于吞吐/吸压优化，而不是替代 deskew 能力本身

## 本轮新增闭环

### Resync + Backpressure + Clean Multiframe

- 已完成系统级混合场景验证：
  - `tb/tests/tb_fpga_wrapper_resync_backpressure_multiframe.sv`
- 已形成结果留痕：
  - `docs/spec/结果验证/resync_backpressure_multiframe_results.md`
- 当前结论：
  - 先触发一次 `illegal sync -> resync`
  - 再在恢复后的 `2` 帧、`4` 行 clean `RAW8` 流上施加真实 AXI 背压
  - 最终得到 `exp=16 act=16 mismatch=0`
  - 同时观测到 `aw_stall_cycles=52`、`w_stall_cycles=52`
- 当前论文/工程可用口径：
  - 恢复策略在背压存在时仍能支持恢复后的连续 clean 输出
  - 当前系统已不再只是“单一异常/单一恢复”的孤立证明，而是具备基础混合工况下的系统级闭环

## 本轮新增闭环

### RAW8 Lane1 / Lane4 Wrapper Smoke

- 已完成系统级 wrapper 补证：
  - `tb/tests/tb_fpga_wrapper_raw8_lane_config_smoke.sv`
  - `scripts/run_raw8_lane_config_smokes.ps1`
- 已形成结果留痕：
  - `docs/spec/结果验证/raw8_lane_config_results.md`
- 当前结论：
  - `lane1` 得到 `exp=2 act=2 frames=1`
  - `lane4` 得到 `exp=2 act=2 frames=1`
  - 配合既有 `lane2 RAW8 smoke`，`1 / 2 / 4 lane` 现在都已具备至少一条 wrapper 级闭环证据
- 当前论文/工程可用口径：
  - 可以说“`1 / 2 / 4 lane` 可配置能力已经实现，并完成基础系统级补证”
  - 但不能说三种 lane 配置都已拥有与 `lane2` 同等强度的异常、恢复和吞吐量化覆盖

## 本轮新增闭环

### Vivado 资源与时序结果

- 已对当前 `HEAD` fresh run 并整理报告：
  - `fpga/vivado/reports/mipi_csi2_capture_fpga_head_20260519/`
- 当前论文可直接引用的资源数字：
  - synth `LUT=541 FF=818 BRAM=0 DSP=0`
  - impl `LUT=530 FF=819 BRAM=0 DSP=0`
  - `Bonded IOB = 59 / 328`
- 当前论文可直接引用的时序数字：
  - routed global `WNS=-2.725 ns`
  - routed global `TNS=-327.762 ns`
  - worst violated pair = `clk_byte -> clk_sys`
  - worst violated path = `u_byte_to_sys_fifo.mem_reg_0_15_0_5/RAMD_D1 -> u_payload_crc_checker.crc_error_reg/D`
- 同域估算 Fmax：
  - `clk_sys ≈ 304.4 MHz`
  - `clk_byte ≈ 367.2 MHz`
  - `clk_axi ≈ 461.9 MHz`
- 论文结论口径：
  - 当前结果足以支持“RTL 可综合、wrapper 可实现、资源占用较低”
  - 但不能表述为“最终板级时序完全收敛”，因为当前 negative slack 主要来自占位 XDC 下保守保留的 CDC 路径

### RAW10 Full-Frame Closure

- 已完成 `RAW10` 系统级 `LE/FE` 收尾闭环：
  - `tb/tests/tb_fpga_wrapper_raw10_smoke.sv`
  - `tb/tests/tb_fpga_wrapper_raw10_metrics.sv`
- 已形成结果留痕：
  - `docs/spec/结果验证/raw10_full_frame_results.md`
- 当前结论：
  - `smoke` 已得到 `PASS: ... exp=4 act=4 frames=1 full_frame=1`
  - `metrics` 已得到 `init_to_frame=16 frame_to_first_pixel=20 frame_to_end=38 first_to_last_pixel=3 pixel_valid_cycles=4`
  - `RAW10` 现已可按真实 wrapper 路径的 full-frame closure 表述，而不再只是 pixel-path only
- testbench 说明：
  - 在当前 `LANE_NUM=2` wrapper 适配路径下，`FE` 尾部最后一个 ECC 字节需要一个额外 flush byte 才会从链路尾部稳定推出
  - 该处理只存在于 testbench 激励层，用于完成末尾单字节冲刷，不改变 DUT RTL
