# Vivado Execution Guide

## Scope

本文档面向当前 MIPIALL 工程，说明如何把现有数字 RTL、testbench、Vivado Tcl/XDC 骨架迁移到 Vivado 中做仿真、综合、实现、报告检查和后续 FPGA 原型准备。它不是通用 Vivado 教程，也不声称当前已经完成真实综合、布局布线、Fmax、功耗、面积、bitstream 或板级 bring-up。

## Current Readiness

| Item | Current Status |
| --- | --- |
| RTL source tree | `rtl/` 下已有公共模块、parser、lane align、pixel repack、reliability、AXI writer、preprocess 和最小 top。 |
| Testbench source tree | `tb/tests/` 有模块级 TB，`tb/top/` 有 system smoke skeleton，`tb/models/`、`tb/refs/`、`tb/scoreboard/` 有可复用验证组件。 |
| Regression state | 当前 L0 compile-only、L1 module unit、L2 system smoke、L3 FPGA script syntax、顶层 compile check、smoke/regression scripts 均为 PASS。 |
| Source filelist seed | `sim/vcs/compile.f` 已给出一份 RTL 和共享 TB support file 的编译顺序参考。 |
| Vivado project Tcl | `fpga/vivado/create_project.tcl` 可创建工程并导入 `rtl/` 与 `fpga/xdc/`。 |
| Vivado synth/impl Tcl | `fpga/vivado/run_synth_impl.tcl` 可在已有工程上运行 synthesis/implementation 并导出报告。 |
| One-click PowerShell entry | `fpga/vivado/run_full_build.ps1` 可顺序执行建工程与综合/实现。 |
| XDC skeleton | `fpga/xdc/top_constraints.xdc` 有 clock、IOSTANDARD、pin、CDC/reset placeholder。 |
| ASIC handoff plan | `docs/spec/asic_assessment_plan.md` 已说明 Vivado 结果不能替代 ASIC PPA/signoff。 |

## Current Missing Inputs

| Missing Input | Why It Matters |
| --- | --- |
| FPGA part | 当前默认使用 `xczu9eg-ffvb1156-2-e`；如需切换板卡/器件可在 Tcl 参数中覆盖。 |
| Optional board part | 若使用 Vivado board flow，需要在选定板卡后补充。 |
| 实际时钟频率 | `clk_sys`、`clk_byte`、`clk_axi`、`clk_ddr` 当前只有 placeholder period。 |
| Pin assignment | 没有 package pin，无法生成可上板 bitstream。 |
| IO bank / IOSTANDARD / voltage | 当前 `DEFAULT_IOSTANDARD` 为空，不能直接用于真实 IO。 |
| 外部 PHY/桥接方式 | 当前顶层是数字 lane placeholder，真实 MIPI 或 bridge 输出格式未冻结。 |
| 最终 CDC / clock group 策略 | XDC 明确禁止盲目设置 clock group，必须结合真实 clocking/CDC 结构决定。 |
| DDR controller / memory bridge | 当前 AXI write interface 存在，但没有真实 DDR IP、scheduler 和板级 memory path。 |
| ILA/debug plan | 当前有 debug/status ports，但未生成 ILA IP 或 probe 连接。 |

## Table A: Vivado Migration Readiness Checklist

| 项目项 | 当前状态 | 是否必须先完成 | 备注 |
| --- | --- | --- | --- |
| RTL compile-ready source list | 已具备 | 是 | 可参考 `sim/vcs/compile.f` 和 `rtl/` 自动导入结果。 |
| Module-level TB | 已具备 | 是，仿真迁移前 | 优先迁移已经 PASS 的 `tb/tests/*.sv`。 |
| System-level TB skeleton | 已具备 | 是，综合前建议跑 | 当前不是最终 top 实例化 TB，但可验证主数据链 smoke。 |
| Final top module | 部分具备 | 是，综合前 | `mipi_csi2_capture_top` 已 compile-only PASS，但仍含 placeholder。 |
| FPGA part | 已默认给出 | 是，创建真实 Vivado project 前 | 默认 part 为 `xczu9eg-ffvb1156-2-e`，也可用 `FPGA_PART` 或 Tcl 参数覆盖。 |
| Board part | 缺失 | 否，除非采用 board flow | 若不用 board flow，可只指定 part。 |
| Pin / IO constraints | 缺失 | 是，bitstream/上板前 | 综合可先用 clock-only/minimal XDC，真实实现需补齐。 |
| Clock periods | placeholder | 是，timing 有意义前 | 需要按系统目标或板卡 clock source 更新。 |
| CDC / clock group constraints | 未冻结 | 是，实现 signoff 前 | 不应盲目 false path 或 async group。 |
| Payload CRC top integration | 未闭合 | 否，早期综合可先保留 | 会影响最终可靠性闭环和资源/时序真实性。 |
| AXI scheduling | 未闭合 | 否，早期综合可先保留 | 若要验证 DDR 写入或带宽，必须先完成。 |
| External PHY/bridge definition | 未冻结 | 是，上板前 | 决定 lane inputs、IO standard、timing、debug 方法。 |
| ASIC SDC / PDK | 缺失 | 否，Vivado 不需要 | 但不能用 Vivado 结果替代 ASIC PPA。 |

## Phase 1: Simulation Migration In Vivado

### Create The Project

首选使用现有 Tcl 创建工程。当前默认器件已固定为 `xczu9eg-ffvb1156-2-e`，它与现有 XDC 设定和 AMD MIPI CSI-2 常用验证平台方向一致：

```sh
vivado -mode batch -source fpga/vivado/create_project.tcl
```

如果你想覆盖默认器件，也可以用环境变量：

```sh
export FPGA_PART=<fpga_part>
vivado -mode batch -source fpga/vivado/create_project.tcl
```

如果使用 GUI，可按同样规则创建 RTL project，然后把 `rtl/` 加到 Design Sources，把 `tb/tests/`、`tb/top/`、`tb/models/`、`tb/refs/`、`tb/scoreboard/` 加到 Simulation Sources，把 `fpga/xdc/top_constraints.xdc` 加到 Constraints。

### Import Sources

建议按以下分组导入：

| Source Group | Files |
| --- | --- |
| Design Sources | `rtl/**/*.sv` |
| Simulation Sources: tests | `tb/tests/*.sv`, `tb/top/tb_mipi_csi2_capture_top.sv` |
| Simulation Sources: models | `tb/models/sensor_model.sv` |
| Simulation Sources: refs | `tb/refs/csi2_reference_helpers.sv` |
| Simulation Sources: scoreboard | `tb/scoreboard/scoreboard.sv` |
| Constraints | `fpga/xdc/top_constraints.xdc` |

不要把 testbench 文件加入 synthesis Design Sources。Vivado 里可以保留多个 simulation top，但每次仿真应只指定一个 top。

### Compile Order And Simulation Top

`sim/vcs/compile.f` 是当前最可靠的顺序参考。迁移到 Vivado 时建议：

1. 先加入所有 `rtl/` 文件。
2. 再加入 `tb/refs/csi2_reference_helpers.sv`。
3. 再加入 `tb/models/sensor_model.sv`。
4. 再加入 `tb/scoreboard/scoreboard.sv`。
5. 最后加入当前要运行的 testbench top。

Vivado GUI 中执行 `Update Compile Order` 后，手动确认 selected simulation top。例如：

| Scenario | Simulation Top |
| --- | --- |
| FIFO unit | `tb_async_fifo` |
| Parser unit | `tb_short_packet_parser`, `tb_long_packet_parser`, `tb_frame_line_sync` |
| Lane unit | `tb_lane_deskew_buffer`, `tb_lane_reorder_merge` |
| Pixel unit | `tb_raw8_unpack`, `tb_rgb888_unpack`, `tb_raw10_unpack`, `tb_yuv422_unpack` |
| AXI unit | `tb_axi_write_master`, `tb_addr_gen_frame_based` |
| Preprocess unit | `tb_brightness_adjust`, `tb_contrast_adjust`, `tb_gray_balance` |
| System smoke | `tb_mipi_csi2_capture_top` |

### Recommended Vivado Simulation Priority

1. 先跑 L1 中最小且基础的 `tb_async_fifo`、`tb_header_ecc`、`tb_payload_crc`。
2. 再跑 parser：`tb_short_packet_parser`、`tb_long_packet_parser`、`tb_frame_line_sync`。
3. 再跑 lane 和 pixel：`tb_lane_reorder_merge`、`tb_lane_deskew_buffer`、`tb_raw8_unpack`、`tb_rgb888_unpack`。
4. 再跑 AXI/preprocess：`tb_axi_write_master`、`tb_addr_gen_frame_based`、`tb_contrast_adjust`。
5. 最后跑 `tb_mipi_csi2_capture_top` 的 lane1/lane2/lane4 RAW8 和 lane2 RGB888 smoke。

当前 system-level TB 的目标是验证最小 CSI-2 style flow，不应误认为最终 top 的完整板级仿真。

## Phase 2: Logic Synthesis

### Set Top Module

综合 top 应设置为：

```text
mipi_csi2_capture_top
```

Tcl flow 会在 `create_project.tcl` 中尝试设置 top，在 `run_synth_impl.tcl` 中再次检查 top 是否存在。

### Separate Synthesizable Files And Testbench Files

Vivado Design Sources 应只包含 `rtl/**/*.sv`。以下文件不得进入 synthesis：

| Non-synthesis Files | Reason |
| --- | --- |
| `tb/tests/*.sv` | Testbench top 和仿真激励。 |
| `tb/top/*.sv` | System smoke testbench，不是硬件 top。 |
| `tb/models/*.sv` | Sensor model 是验证模型。 |
| `tb/refs/*.sv` | Reference helpers 用于 TB。 |
| `tb/scoreboard/*.sv` | Scoreboard 是验证组件。 |

### Minimal Constraints Before Synthesis

综合前至少应更新：

| Constraint Item | Current File | Required Action |
| --- | --- | --- |
| FPGA part | Tcl argument / `FPGA_PART` | 填写真实 Vivado part。 |
| Clock period | `fpga/xdc/top_constraints.xdc` | 根据目标频率更新 `CLK_*_PERIOD_NS`。 |
| Clock uncertainty | `fpga/xdc/top_constraints.xdc` | 根据目标板卡/clock source 粗略设置。 |
| IO standard | `fpga/xdc/top_constraints.xdc` | 早期可为空，真实实现前必须补。 |
| Pin assignment | `fpga/xdc/top_constraints.xdc` | 综合可暂缺，上板前必须补。 |

### Run Synthesis

先创建工程，再运行 synth/impl 脚本。若只想观察 synthesis，可在 Vivado GUI 中只启动 `synth_1`；现有批处理脚本会继续跑 implementation。

```sh
vivado -mode batch -source fpga/vivado/run_synth_impl.tcl \
  -tclargs mipi_csi2_capture mipi_csi2_capture_top 8
```

Windows PowerShell 下也可以一键执行：

```powershell
powershell -ExecutionPolicy Bypass -File fpga\vivado\run_full_build.ps1
```

### Reports To Review After Synthesis

| Report | What To Check |
| --- | --- |
| `synth_utilization.rpt` | LUT/FF/BRAM/DSP 使用量是否异常，是否推断出意外大资源。 |
| `synth_timing_summary.rpt` | 是否有 unconstrained paths、明显 setup violation、未识别 clock。 |
| `synth_cdc.rpt` | `clk_byte` to `clk_sys`、`clk_sys` to `clk_axi` 等 CDC 是否被识别并符合预期。 |
| Vivado messages | latch inference、multi-driver、undriven、width mismatch、ignored constraints。 |

综合成功后，脚本还会直接导出：

| Netlist Artifact | Meaning |
| --- | --- |
| `post_synth.dcp` | 综合后 checkpoint。 |
| `mipi_csi2_capture_synth.edf` | EDIF 格式综合网表。 |
| `mipi_csi2_capture_synth_netlist.v` | Verilog 格式综合网表。 |
| `mipi_csi2_capture_synth.xdc` | 综合阶段约束导出副本。 |

### Current Placeholder/TODO Before Treating Synthesis As Meaningful

| Placeholder / TODO | Synthesis Impact |
| --- | --- |
| Payload CRC top path not connected | 可靠性逻辑面积和时序不完整。 |
| PHY adapter placeholder | lane 前端真实接口、输入 timing、IO 资源不真实。 |
| AXI writer command/data tied idle | DDR 写入主路径资源和时序不代表最终系统。 |
| Full `cfg_reg_if` missing | 配置/状态路径资源不完整。 |
| Final CDC constraints missing | timing report 可能有未约束或误约束路径。 |

## Phase 3: Implementation

### Standard Flow

Vivado implementation 的标准顺序是：

```text
opt_design -> place_design -> phys_opt_design -> route_design -> report/write_bitstream
```

当前 `run_synth_impl.tcl` 使用 Vivado run infrastructure 启动 `impl_1` 到 `write_bitstream`，并导出 utilization、timing、power、DRC、checkpoint 和 bit file。

### Minimum Implementation For This Project

在 part 已冻结但 pin 尚未完全冻结时，可以做一个最小实现检查：

1. 指定真实 FPGA part。
2. 保留当前 top。
3. 填写合理 clock period。
4. 暂不声称 pin/IO/board 可用。
5. 仅查看是否能完成 place/route、是否存在明显 timing/DRC/CDC 问题。

这个结果只能作为早期 FPGA 可实现性观察，不能作为最终上板或 ASIC PPA 依据。

### Clock, CDC, Clock Group, False Path Planning

| Domain Pair | Current Design Intent | Constraint Guidance |
| --- | --- | --- |
| `clk_byte` -> `clk_sys` | lane path 到 parser/pixel path，经 async FIFO crossing。 | 确认 FIFO CDC 被工具识别；必要时约束 FIFO 内部同步器路径。 |
| `clk_sys` -> `clk_axi` | 未来 pixel buffer 到 AXI writer，目前顶层 AXI tied idle。 | 等 sys-to-axi buffer 完成后再定 clock relationship 或 async group。 |
| `clk_axi` -> `clk_ddr` | DDR controller-facing boundary 未定义。 | 选择 DDR/IP 后再规划。 |
| `rst_n` | 项目规则为 active-low synchronous reset。 | 不添加 async reset false path，除非后续引入异步复位。 |

不要为了让 timing 变绿而随意 `set_false_path` 或 `set_clock_groups -asynchronous`。每条 exception 都需要对应 CDC 结构和文档解释。

### Reports To Review After Implementation

| Report | What To Check |
| --- | --- |
| `impl_timing_summary.rpt` | WNS/TNS、unconstrained paths、clock interaction、setup/hold、max transition/capacitance。 |
| `impl_utilization.rpt` | LUT/FF/BRAM/DSP/IO 使用率、层级资源热点。 |
| `impl_power.rpt` | 仅作 FPGA vectorless 或默认 activity 粗略参考，不能当 ASIC 功耗。 |
| `impl_drc.rpt` | IO、clock、routing、placement、bitstream blocker。 |
| `post_impl.dcp` | 后续 debug、增量实现或报告复查入口。 |

### If Implementation Does Not Close

优先按以下顺序排查：

1. 是否有 missing clock 或 unconstrained path。
2. 是否把 TB 文件误加入 synthesis。
3. XDC clock period 是否过激。
4. CDC 是否被误约束为同步路径。
5. 是否存在巨大 mux、过宽 counter、未预期 memory inference。
6. AXI/top placeholder 是否导致不真实的 dead logic 或 optimized-away path。
7. 是否需要在 RTL 中增加 pipeline，而不是靠约束掩盖。

## Phase 4: Bitstream And Board Debug Preparation

### Entry Conditions

只有满足以下条件后，才建议进入真实 bitstream 和板级 bring-up：

| Condition | Required Status |
| --- | --- |
| FPGA part / board | 已冻结。 |
| Package pinout | 已根据 schematic 完成。 |
| IO bank voltage / IOSTANDARD | 已与板卡电源和外设匹配。 |
| Clock source | `clk_sys`、`clk_byte`、`clk_axi`、`clk_ddr` 来源和频率明确。 |
| External PHY/bridge | 数字 lane 输入格式、valid 语义、HS/LP 语义明确。 |
| CDC constraints | 已审查，不存在盲目 exception。 |
| Debug plan | ILA/probe 信号和触发条件已定义。 |

### Board / Pin / IO / Clock / Bridge Inputs To Complete

| Input | Required Detail |
| --- | --- |
| FPGA part | 完整 Vivado part name。 |
| Board part | 如采用 board flow，填写 board part。 |
| Pin assignment | clocks、reset、lane_data、lane_valid、APB、AXI/bridge/debug ports。 |
| IO standard | 每个 IO bank 的电压和标准。 |
| Clocking | oscillator/PLL/MMCM 来源、频率、phase relationship。 |
| External PHY/bridge | MIPI D-PHY 到 FPGA 数字接口的供应商 IP 或板外桥接方式。 |
| DDR / AXI endpoint | 使用片上 memory、外部 DDR controller、还是 dummy bridge。 |

### Suggested ILA Probe Signals

| Probe Group | Signals |
| --- | --- |
| Lane intake | `lane_valid_*`, selected `lane_data_*[7:0]`, deskew overflow。 |
| Packet parser | header valid, VC, DT, word_count, payload_start, payload_end, payload_valid。 |
| Frame/line sync | `frame_start_o`, `frame_end_o`, `line_start_o`, `line_end_o`, frame/line counters。 |
| Error monitor | `err_ecc_o`, `err_crc_o`, `err_sync_o`, lane error, resync busy, degrade active。 |
| Pixel output | `pixel_valid_o`, `pixel_data_o`, `pixel_sof_o`, `pixel_sol_o`。 |
| AXI future path | AW/W/B handshake, burst counters, command valid/ready, done/error。 |

### Bring-Up Checklist Before First Board Run

1. Confirm reset polarity and reset release sequence.
2. Confirm all input clocks are present and constrained.
3. Confirm IO bank voltage and IOSTANDARD.
4. Confirm external PHY/bridge outputs match top-level lane input expectation.
5. Start with RAW8 single-frame or repeated-line pattern.
6. Enable ILA triggers on FS, LS, first payload byte, LE, FE, and error pulses.
7. Compare ILA pixel stream against known sensor/bridge test pattern.

## Phase 5: Link To Later ASIC Assessment

### Problems Vivado Can Expose Early

| Problem Type | Vivado Value |
| --- | --- |
| RTL syntax and elaboration | Catches source-order, top binding, unsupported construct issues. |
| Basic timing pressure | Highlights long combinational paths and missing pipeline candidates. |
| CDC structure | `report_cdc` can reveal obvious missing synchronization or wrong constraints. |
| Resource hotspots | Utilization hierarchy can identify unexpectedly large blocks. |
| Constraint quality | Missing clocks, invalid ports, unconstrained paths show up early. |

### Items That Can Migrate Toward ASIC Flow

| Vivado Artifact | ASIC Use |
| --- | --- |
| Clean RTL file partition | Starting point for `asic/genus/filelists/rtl_synth.f`. |
| Clock definitions | Starting point for ASIC SDC clocks, but periods/uncertainty must be redefined. |
| CDC review notes | Useful for ASIC CDC/lint and STA exception planning. |
| Regression evidence | Supports RTL maturity before Genus. |
| Timing hotspot list | Helps decide pipeline fixes before ASIC synthesis. |

### Items Vivado Cannot Prove For ASIC

| Not Derivable From Vivado | Reason |
| --- | --- |
| ASIC area | FPGA LUT/FF/BRAM resources do not map to standard-cell area. |
| ASIC power | FPGA activity/power model is unrelated to ASIC Liberty/PDK power. |
| ASIC Fmax | FPGA routing/timing is not ASIC post-synthesis or post-route timing. |
| ASIC DRC/LVS | Requires foundry decks and physical implementation. |
| ASIC signoff | Requires Genus/Innovus/Tempus-equivalent flow with real technology data. |

## Table B: Vivado Implementation Checklist

| 检查项 | 查看位置/命令 | 判定标准 | 当前备注 |
| --- | --- | --- | --- |
| Top module set correctly | Vivado project settings or `get_property top [current_fileset]` | Top is `mipi_csi2_capture_top`。 | 当前 Tcl 会尝试设置并检查。 |
| RTL only in synthesis | Sources view / fileset contents | `tb/` 不在 `sources_1`。 | `create_project.tcl` 只导入 `rtl/` 到 Design Sources。 |
| Clock constraints applied | `report_clocks` | `clk_sys`, `clk_byte`, `clk_axi`, `clk_ddr` 存在且 period 正确。 | XDC 当前为 placeholder period。 |
| No unconstrained paths | `report_timing_summary -report_unconstrained` | 无未解释 unconstrained path。 | 需 part/XDC 后检查。 |
| CDC is intentional | `report_cdc` | FIFO/synchronizer crossing 被识别，非预期 CDC 为 0 或已解释。 | 最终 clock group 未冻结。 |
| IO constraints complete | `report_io`, DRC | 所有外部端口有合法 pin/IOSTANDARD。 | 当前缺失，不能上板。 |
| Utilization acceptable | `report_utilization` | 不超过目标 FPGA 资源预算。 | 需选定 part 后才有意义。 |
| Timing closure | `report_timing_summary` | WNS/TNS 满足项目目标，无 hold blocker。 | 当前无真实实现结果。 |
| DRC clean | `report_drc` | 无 bitstream blocker。 | 当前未跑真实 impl。 |
| Power reviewed | `report_power` | 只作为 FPGA 粗估，activity 来源明确。 | 不能用于 ASIC 功耗。 |
| Bitstream generated | Vivado run output / reports dir | `.bit` 生成且 DRC/timing 可接受。 | 当前不应声称已完成。 |
| ILA probes inserted | Debug core view / netlist | probes 与 bring-up checklist 对齐。 | 当前未生成 ILA IP。 |

## Recommended Execution Order

1. 在现有脚本环境继续跑 `./sim/vcs/run_smoke.sh`，确认仓库基线干净。
2. 在 Vivado 中迁移并跑模块级仿真，从 FIFO/ECC/CRC/parser 开始。
3. 迁移 lane、pixel、AXI、preprocess 模块级仿真。
4. 迁移 `tb/top/tb_mipi_csi2_capture_top.sv`，先跑默认 RAW8，再跑 lane1/lane4 RAW8 和 lane2 RGB888。
5. 指定真实 FPGA part，创建 Vivado project。
6. 只用 `rtl/` 作为 synthesis sources，设置 top 为 `mipi_csi2_capture_top`。
7. 更新 clock period 和最小 XDC，先跑 synthesis，审查 utilization、timing、CDC。
8. 在 part/clock 可信后跑最小 implementation，审查 timing/utilization/DRC。
9. 等 board、pin、IO bank、external PHY/bridge、DDR/AXI endpoint 冻结后补齐 XDC。
10. 添加 ILA/debug plan，生成 bitstream 并进入最小 RAW8 bring-up。
11. Vivado 阶段问题修完后，再把干净 RTL filelist、clock/CDC 约束经验迁移到 ASIC Genus/STA 准备。

## No-Fabrication Rule

在真实 Vivado synthesis/implementation 和板级测试完成前，不得填写或口头声称以下结果：

- FPGA Fmax
- FPGA utilization 结论
- FPGA power 结论
- bitstream 已可上板
- 板级 bring-up PASS
- ASIC 面积、功耗、Fmax、STA、DRC、LVS 或 signoff 结论
