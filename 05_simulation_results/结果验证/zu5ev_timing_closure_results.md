# XCZU5EV 目标器件时序收敛（T6）

## 结论

在 **Genesys ZU-5EV 的实际器件型号 `xczu5ev-sfvc784-1-e`**（Zynq UltraScale+，速度级 -1）上，
`mipi_csi2_capture_dphy_wrapper`（含完整采集系统 top）完成综合 + 布局布线后**时序收敛**：

```text
All user specified timing constraints are met.
WNS = +0.194 ns    TNS = 0.000 ns   (0 failing / 6015 endpoints)
WHS = +0.012 ns    THS = 0.000 ns   (hold 亦满足)
routing errors = 0
```

时钟目标（与 `02_vivado_project_and_sim/xdc/dphy_wrapper_constraints.xdc` 一致）：
`clk_sys / clk_axi / clk_ddr = 200 MHz`，`rxbyteclkhs = 187.5 MHz`（对应 1.5 Gbps/lane HS）。

资源占用（ZU5EV）：CLB LUT **2199（1.88%）**、CLB FF **2378（1.02%）**、BRAM 0、极小占用。

## 收敛过程（三次迭代，问题→修法）

| 轮次 | WNS | 关键路径 | 处置 |
|---|---|---|---|
| core1 | −12.261 ns | `adaptive_preprocess_ctrl_v1`：帧间系数**单周期组合计算**（4 个 24/16 位除法 + DSP 乘法，70 级逻辑）| 重构为**共享迭代除法器 FSM**（每周期 1 位，~150 周期出系数）|
| core2 | −40.050 ns | ctrl 修复后暴露 `pixel_frame_stats_v1`：帧末均值 `sum/pixel_cnt` **三个 48/32 位组合除法**（279 级、231 CARRY8）| 帧末快照累加器 → **三路并行迭代除法器**（48 周期出均值，统计集一致性发布）|
| core3 | **+0.194 ns** | — | **收敛** |

两处修复的合法性：系数/均值均为**帧级数据**（第 N 帧统计 → 第 N+1 帧使用），几十~几百周期的
计算延迟相对帧间隔可忽略；top 中 `coeff_valid` 本无消费者，`stats_valid` 消费者（adaptive ctrl、
APB 观测寄存器）均与延迟无关。模块 TB 改为等待 `stats_valid/coeff_valid`（延迟从不是接口规格）。

## 复现

```powershell
$env:VIVADO_REPORT_ROOT="C:/vivado_admittion/reports"
vivado -mode batch -source 02_vivado_project_and_sim/vivado/run_dphy_wrapper_timing_direct.tcl `
       -tclargs xczu5ev-sfvc784-1-e dphy_zu5ev_core3 mipi_csi2_capture_dphy_wrapper 4 1
```
报告：`C:/vivado_admittion/reports/dphy_zu5ev_core3/`（Vivado 2017.3）。

## 回归（RTL 重构后零回归）

xsim 通过：adaptive_ctrl / pixel_frame_stats（模块级，TB 改等 valid）；
raw8/rgb888/yuv422/raw10 metrics、axi_mem_closure、resync_recovery、dphy_raw8_smoke、
boot_cfg_apb、recapture 闭环/多帧/窗口边界/策略A、DDR 延迟闭环——全部 PASS。

## 边界声明（诚实口径）

- 本结果为 **core timing-only**（`DPHY_CORE_TIMING_ONLY=1`）：`rst_n` 与状态/调试输出等
  **占位 wrapper 边界**被 false-path（它们不是最终板级时序契约）；四个时钟组间已按异步声明。
  **内部所有时钟域的核内时序全部按 200/187.5 MHz 判定并满足。**
- 论文可写口径：**"面向目标器件 XCZU5EV 完成综合、实现与核内时序收敛评估（200 MHz，WNS +0.194 ns）"**。
- 仍不可写"已上板"：最终板级收敛尚需真实 D-PHY RX IP/BD、真实引脚/IOSTANDARD、生成时钟与
  板级 XDC、bitstream 全流程（见项目说明书 §7.2）。
- 历史口径修正：交接文档中的"WNS=−3.398"为更早期占位跑批数据，现以本文为准。
