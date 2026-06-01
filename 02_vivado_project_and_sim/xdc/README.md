# XDC

本目录保存 FPGA 顶层约束。

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `top_constraints.xdc` | 当前顶层时钟、IO delay、输出驱动和 CDC 分组约束。 |
| `board_lab_placeholder_v1.xdc` | `xczu9eg-ffvb1156-2-e` 实验版 LOC/IOSTANDARD 约束，用于消除 `NSTD-1` 和 `UCIO-1`；真实上板前必须按原理图替换。 |
