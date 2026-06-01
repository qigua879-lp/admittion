# Genus 综合占位说明

本目录预留给未来面向 `mipi_csi2_capture_top` 的 Cadence Genus 综合配置。

当前阶段不提供综合脚本、technology library 或 PPA 结果。不要将本目录视为已经完成 ASIC 综合的证据。

## 后续输入

只有在目标 ASIC 工艺明确之后，才应补充 Genus 配置。必需输入包括：

| 输入 | 说明 |
| --- | --- |
| Standard-cell timing libraries | 所有选定 PVT corner 对应的 Liberty `.lib` 或已编译 `.db`。 |
| Physical abstracts | 如采用 physical-aware synthesis，需要 technology LEF 和 standard-cell LEF。 |
| RTL file list | 可从 `sim/vcs/compile.f` 起步，移除 TB-only 文件，仅保留可综合 RTL。 |
| Top module | `mipi_csi2_capture_top`。 |
| SDC constraints | ASIC 专用 clock、generated clock、IO delay、uncertainty、exception 和 path group。 |
| Operating conditions | Process、voltage 和 temperature corner 定义。 |
| Macro models | 如引入 SRAM、IO、PLL 或其他 hard macro，需要对应 timing/physical view。 |
| Power intent | 如加入多电源域或 power gating，需要 UPF/CPF。 |

## 后续脚本结构

真实 ASIC 目标明确后，建议采用以下文件结构：

```text
asic/genus/
  README.md
  scripts/
    setup.tcl
    read_rtl.tcl
    constraints.tcl
    synth.tcl
    reports.tcl
  filelists/
    rtl_synth.f
  constraints/
    top.sdc
  logs/
  out/
```

## Genus 检查清单

1. 读取 technology library 和 operating corner。
2. 只读取可综合 RTL。
3. 对 `mipi_csi2_capture_top` 执行 elaboration。
4. 应用 ASIC SDC constraints。
5. 检查 unresolved reference 以及 undriven/unconnected port。
6. 运行 synthesis。
7. 输出 timing、area、power、clock gating 和 QoR 报告。
8. 导出 mapped netlist、SDC 和报告，供 physical implementation 使用。

## 当前状态

- 仅为 placeholder。
- 尚不知道 library path。
- 尚无 ASIC SDC。
- 尚未生成 area、power 或 timing 数字。
