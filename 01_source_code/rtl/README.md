# RTL

本目录保存可综合 RTL，不放 testbench。

## 子目录说明

| 子目录 | 作用 |
| --- | --- |
| `top/` | 顶层集成与系统包装。 |
| `phy_adapter/` | D-PHY 数字抽象输入适配。 |
| `csi2_rx/` | lane 对齐、CSI-2 解析、ECC/CRC、帧行同步。 |
| `pixel/` | RAW8/RAW10/RGB888/YUV422 像素重组。 |
| `reliability/` | 错误分类、日志、重同步、降级恢复。 |
| `buffer/` | FIFO/CDC/缓存基础模块。 |
| `axi/` | AXI 写通路。 |
| `preprocess/` | 轻量预处理。 |
| `reg_if/` | 配置和状态寄存器接口。 |

## 当前现状

- 顶层为 `top/mipi_csi2_capture_top.sv`
- `phy_adapter/` 仍是未完全闭环区域
- `reg_if/` 现已提供 APB 版 `cfg_reg_if_apb.sv`，但更完整的软件可见策略语义仍可继续扩展
- 其余主要功能模块已具备可综合 RTL
