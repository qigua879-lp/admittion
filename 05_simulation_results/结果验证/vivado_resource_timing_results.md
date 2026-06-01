# Vivado 资源与时序结果留痕

## 目的

本文件用于把 `Vivado 2017.3` 对当前分支 `HEAD` 的综合/实现关键结果固定成论文可直接引用的留痕，避免后续只剩原始 `.rpt` 难以快速复述。

## 报告来源

- 结果版本：`timing_cdc_v1`
- 目录：
  - `fpga/vivado/reports/mipi_csi2_capture_fpga_head_20260519/`
- 顶层：
  - `mipi_csi2_capture_fpga_wrapper`
- 器件：
  - `xczu9eg-ffvb1156-2-e`

## 约束边界

- 当前使用的是占位 XDC，而不是最终板级约束：
  - `clk_sys = 200 MHz`
  - `clk_axi = 200 MHz`
  - `clk_ddr = 200 MHz`
  - `clk_byte = 187.5 MHz`
- 尚未补最终：
  - `LOC`
  - `IOSTANDARD`
  - 板级输入输出 delay
  - 最终 CDC 例外约束策略

因此，本轮结果应定位为：

- `FPGA wrapper` 方案下的可综合/可实现性评估
- 不是最终板级 bitstream 收敛结果

## 资源结果

### 综合后

- `LUT = 541`
- `FF = 818`
- `BRAM Tile = 0`
- `DSP = 0`

来源：

- `synth_utilization.rpt`

### 实现后

- `LUT = 530`
- `FF = 819`
- `BRAM Tile = 0`
- `DSP = 0`
- `Bonded IOB = 59 / 328`

来源：

- `impl_utilization.rpt`

## 时序结果

### 版本保留

本节保留为 `timing_cdc_v1` 的问题基线：

- routed global `WNS = -2.725 ns`
- routed global `TNS = -327.762 ns`
- worst violated pair = `clk_byte -> clk_sys`
- worst violated path = `u_byte_to_sys_fifo.mem_reg_0_15_0_5/RAMD_D1 -> u_payload_crc_checker.crc_error_reg/D`

该问题已作为下一版 `timing_cdc_v2` 的修正输入：在 RTL 中补充 CDC 同步寄存器属性，并在 XDC 中基于现有 FIFO/同步器结构声明 `clk_byte` 与 `clk_sys` 为异步时钟组。

### 全局 routed timing

- `WNS = -2.725 ns`
- `TNS = -327.762 ns`

来源：

- `impl_timing_summary.rpt`

### 负 slack 主要来源

- worst violated clock pair：
  - `clk_byte -> clk_sys`
- worst violated path：
  - `u_byte_to_sys_fifo.mem_reg_0_15_0_5/RAMD_D1`
  - `->`
  - `u_payload_crc_checker.crc_error_reg/D`

这说明当前 global negative slack 主要来自 byte 域到 sys 域之间的跨时钟相关路径，而不是单一 sys 域主计算路径本身跑不动。

## 同域时序观察

从 routed report 的同域 WNS 可得：

- `clk_sys WNS = 1.715 ns`
- `clk_byte WNS = 2.610 ns`
- `clk_axi WNS = 2.835 ns`

对应估算可达频率：

- `clk_sys`: `5.000 - 1.715 = 3.285 ns`，约 `304.4 MHz`
- `clk_byte`: `5.333 - 2.610 = 2.723 ns`，约 `367.2 MHz`
- `clk_axi`: `5.000 - 2.835 = 2.165 ns`，约 `461.9 MHz`

## 论文建议口径

建议在论文中这样表述：

1. 当前 `FPGA wrapper` 方案已解决顶层 I/O 超限问题，`Bonded IOB` 收敛到 `59 / 328`。
2. 资源占用整体较低，当前实现后仅使用 `529 LUT / 819 FF`，未使用 `BRAM` 与 `DSP`。
3. 在占位时钟约束下，同域主路径可满足 `200 MHz / 187.5 MHz` 目标。
4. 全局 setup negative slack 仍存在，其主要来源是当前保守保留的 `clk_byte -> clk_sys` CDC 路径，因此本轮结果应表述为“可实现性验证”而不是“最终板级时序完全收敛”。
5. 若后续继续推进 FPGA 落板，需要补完整板级约束与 CDC 时序例外策略，再讨论 bitstream 与最终时序收敛。

## 与 2026-05-06 历史结果的关系

- 当前结果来自 `2026-05-19` 对当前 `HEAD` 的 fresh run。
- 相比 `2026-05-06` 历史留痕，资源与时序数字仅有小幅漂移：
  - LUT `529 -> 530`
  - FF `819 -> 819`
  - WNS `-2.410 ns -> -2.725 ns`
  - TNS `-326.251 ns -> -327.762 ns`
- 因此，论文定性结论未变，但后续必须统一引用当前 `HEAD` 结果，不再混用 `2026-05-06` 历史报告。

## timing_cdc_v2 结果

### 报告来源

- 结果版本：`timing_cdc_v2`
- 目录：
  - `fpga/vivado/reports/mipi_csi2_capture_fpga_timing_cdc_v2/`
- 顶层：
  - `mipi_csi2_capture_fpga_wrapper`
- 器件：
  - `xczu9eg-ffvb1156-2-e`
- 执行日期：
  - `2026-05-20`

### 资源结果

综合后：

- `LUT = 634`
- `FF = 1165`
- `BRAM Tile = 0`
- `DSP = 0`
- `Bonded IOB = 77 / 328`

实现后：

- `LUT = 618`
- `FF = 1135`
- `BRAM Tile = 0`
- `DSP = 0`
- `Bonded IOB = 77 / 328`

说明：

- 这里的实现资源来自 direct route-only 流程下的 placed/routed 留痕。
- 与 `timing_cdc_v1` 相比，当前 wrapper 使用的是完整 `77` 个逻辑端口，因此 `Bonded IOB` 不再是 `59 / 328`。

### 时序结果

全局 routed timing：

- `WNS = 1.884 ns`
- `TNS = 0.000 ns`
- 报告结论：
  - `All user specified timing constraints are met.`

同域时序：

- `clk_byte WNS = 2.476 ns`
- `clk_sys WNS = 1.884 ns`

跨域观察：

- `clk_byte -> clk_sys` 不再作为全局 setup violation 出现在 routed timing 总表中。
- `clk_sys -> clk_axi` 与 `clk_axi -> clk_sys` 均为正裕量：
  - `clk_sys -> clk_axi WNS = 3.167 ns`
  - `clk_axi -> clk_sys WNS = 3.222 ns`

### DRC 状态

`timing_cdc_v2` routed DRC 当时仍保留两条板级约束相关告警：

- `NSTD-1`
- `UCIO-1`

其含义是：

- `77 / 77` 逻辑端口尚未指定最终 `IOSTANDARD`
- `77 / 77` 逻辑端口尚未指定最终 `LOC`

因此：

- `timing_cdc_v2` 可以支撑“RTL + CDC 约束后 routed timing 已满足占位时钟约束”的结论。
- 但这一轮本身不能表述为“最终板级 bitstream 已完成”。

## board_io_v1 bitstream DRC 更新

### 报告来源

- 结果版本：`board_io_v1`
- 工程名：`mipi_csi2_capture_board_io_v1_clkfix5`
- 目录：
  - `C:\vivado_admittion\reports\mipi_csi2_capture_board_io_v1_clkfix5`
- 顶层：
  - `mipi_csi2_capture_fpga_wrapper`
- 器件：
  - `xczu9eg-ffvb1156-2-e`
- 执行日期：
  - `2026-06-01`

### 约束变化

- 新增实验版 `LOC/IOSTANDARD`：
  - `02_vivado_project_and_sim/xdc/board_lab_placeholder_v1.xdc`
- 新增/完善 IO delay、输出驱动、CDC 分组：
  - `02_vivado_project_and_sim/xdc/top_constraints.xdc`
- `clk_sys` 和 `clk_byte` 已移到 P-side global clock pin，避开 `Place 30-876`。

### DRC 与 bitstream 结果

- `place_design` completed successfully
- `route_design` completed successfully
- `write_bitstream` 前 DRC：
  - `0 Errors`
- `impl_drc.rpt`：
  - `Violations found: 0`
- 已生成 bitstream：
  - `mipi_csi2_capture_board_io_v1_clkfix5.bit`
- `NSTD-1` / `UCIO-1`：
  - final bitgen DRC 中已清零

### 边界说明

`board_io_v1` 解决的是 bitstream 阻塞级 DRC，不等于真实板卡签核：

- 当前 `board_lab_placeholder_v1.xdc` 是实验版 pinout，不是原理图核对后的真实 pinout。
- 真实上板前仍需确认 schematic、bank VCCO、外部 PHY/bridge 连接和 clock source。
- 当前 `impl_timing_summary.rpt` 仍显示 timing 未收敛，`WNS=-3.398 ns`，需要后续 timing closure。
