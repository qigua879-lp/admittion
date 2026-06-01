# Innovus 物理实现占位说明

本目录预留给未来 Cadence Innovus 物理实现配置。在真实 ASIC process、floorplan 和 library package 选定前，本目录应保持 technology-neutral。

当前阶段不提供 placement、routing、timing、area、power、DRC、LVS、DEF 或 GDS 结果。

## 后续输入

物理实现需要综合结果和工艺交付物：

| 输入 | 说明 |
| --- | --- |
| Gate-level netlist | Genus mapped synthesis 后导出的网表。 |
| MMMC setup | Timing corner、RC corner 和 analysis view。 |
| Technology LEF | Foundry/process routing layer 和 design rule。 |
| Cell LEF | Standard cell 和 macro 的 physical abstract。 |
| Liberty timing libraries | 与综合相同的 corner set；如 signoff view 不同，也需补充。 |
| SDC | 顶层 clock、IO、generated clock 和 exception constraints。 |
| Floorplan | Die/core size、utilization target、macro placement、pin placement。 |
| Power plan | Power/ground net、ring、strap、rail 和 voltage domain。 |
| RC extraction setup | QRC tech file 或等效 extraction deck。 |
| Signoff decks | Foundry 或 PDK owner 提供的 DRC/LVS/antenna deck。 |

## 后续脚本结构

物理实现启动后，建议采用以下文件结构：

```text
asic/innovus/
  README.md
  scripts/
    setup_mmmc.tcl
    init_design.tcl
    floorplan.tcl
    power_plan.tcl
    place.tcl
    cts.tcl
    route.tcl
    signoff_exports.tcl
    reports.tcl
  constraints/
  logs/
  out/
```

## 实现检查清单

1. 导入 Genus netlist 和 constraints。
2. 创建 MMMC timing view。
3. 初始化 floorplan 和 pin placement。
4. 构建 power grid，并执行早期 connectivity check。
5. 放置 standard cell，并运行 pre-CTS timing。
6. 构建 clock tree，并检查 skew/latency 目标。
7. 对 signal net 和 power net 进行 route。
8. 提取 parasitics。
9. 生成 timing、congestion、utilization、power、DRC 和 antenna 报告。
10. 按 signoff flow 需求导出 netlist、DEF、SPEF、SDF 和 GDS/OASIS。

## 当前状态

- 仅为 placeholder。
- 尚未选择 floorplan 或 utilization target。
- 尚无 macro、IO 或 power-grid plan。
- 尚未生成 physical implementation 结果。
