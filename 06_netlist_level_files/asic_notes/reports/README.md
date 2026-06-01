# ASIC 报告占位说明

本目录预留给未来 ASIC 评估报告。只有在真实 ASIC flow 可用后，才应放入工具生成结果或明确标注的分析产物。

当前阶段不提供 area、timing、power、Fmax、DRC、LVS 或 signoff 结果。

## 推荐报告结构

```text
asic/reports/
  README.md
  genus/
    timing/
    area/
    power/
    qor/
  innovus/
    timing/
    utilization/
    congestion/
    power/
    drc/
    antenna/
  tempus/
    setup/
    hold/
    noise/
    constraints/
  summary/
    ppa_summary.md
    risk_register.md
```

## 报告规则

1. 报告文件名应尽量包含 stage、corner、mode 和 date。
2. 汇总文件必须注明每个数字对应的源工具报告。
3. 没有源报告链接时，不要手工填写 area、power 或 timing 数字。
4. Estimate 必须标注为 estimate，并与工具结果分开。
5. 在 risk register 中跟踪 unresolved violation、waiver 和 assumption。

## 后续需要采集的指标

| 指标 | 来源 |
| --- | --- |
| Cell area | Genus 或 Innovus area report。 |
| Macro area | 引入 macro 后的 floorplan/macro report。 |
| Total die/core utilization | Innovus utilization report。 |
| Fmax estimate | 从指定 corner/mode 下的 worst setup timing 推导。 |
| Dynamic power | 带 switching activity 的 Genus/Innovus/PrimePower-equivalent report。 |
| Leakage power | 与 library/corner 相关的 power report。 |
| Setup/hold slack | Tempus timing report。 |
| Clock tree quality | Innovus 输出的 CTS report。 |
| DRC/LVS/antenna | Signoff deck 或工具报告。 |

## 当前状态

- 仅为 placeholder。
- 尚未生成 ASIC report。
- 暂无 PPA 数值。
