# 板级测试器件清单（BOM）

> 用于 MIPI CSI-2 采集系统板级测试与重采集硬件演示。平台限定 **Xilinx（Zynq / UltraScale+）**，
> 因 `mipi_dphy_ppi_adapter` 按 AMD MIPI D-PHY RX IP 的 PPI 实现。预算 ¥5 万内，实花约 ¥2.5–3 万。
> 配套说明见 [项目说明书 第 8 章](项目说明书_MIPI_CSI2采集系统.md)。

## 主清单

| # | 名称 | 型号 / 订货号 | 厂商 | 关键规格 / 接口 | 数量 | 单价(约) | 小计(约) | 用途 |
|---|---|---|---|---|---|---|---|---|
| 1 | RX 主板（本设计载体）| **Genesys ZU-5EV** ／ 410-383-5EV | Digilent | Zynq UltraScale+ **XCZU5EV**；DDR4；2×Pcam(2-lane MIPI) 口；**FMC**；HDMI/10G | 1 | ¥16,000–18,000 | ¥16,000–18,000 | 跑 RTL（CSI-2 RX + 重采集），PS DDR4 帧缓冲 |
| 2 | 可控 MIPI 发送端 | **Zybo Z7-20** ／ 410-351-20 | Digilent | Zynq-7020 **XC7Z020-1CLG400C**；Pcam 口 | 1 | ¥2,800–3,200 | ¥2,800–3,200 | 配成可控 MIPI TX，演示重采集闭环 |
| 3 | **2-lane 相机** | **Pcam 5C** ／ 410-358 | Digilent | OV5640 5MP；**2-lane MIPI CSI-2**；15-pin Pcam 口直插 | 1 | ¥500–700 | ¥500–700 | 接 Genesys Pcam 口，验 2-lane 真实采集 |
| 4 | **4-lane 相机** | **LI-IMX274MIPI-FMC** | Leopard Imaging | Sony IMX274 8.5MP；**4-lane MIPI CSI-2**；**FMC** 接口 | 1 | ¥2,500–4,000（询价）| ¥2,500–4,000 | 接 Genesys FMC 口，验 4-lane 真实采集 |
| 5 | 电源（主板）| Genesys ZU 原配 12V 适配器 | Digilent | 12V（随板）| 1 | 随板 | — | Genesys 供电 |
| 6 | 电源（Zybo）| 5V/2.5A、5.5×2.1mm、中心正 | 通用 | 桶形插头 | 1 | ¥30–50 | ¥30–50 | Zybo 供电（跑视频建议外接）|
| 7 | micro-USB 线 | USB-A ↔ micro-USB | 通用 | JTAG/UART 编程 | 2 | ¥20 | ¥40 | 两块板各一根 |
| 8 | microSD 卡 | 16GB Class10 | 通用 | — | 2 | ¥30 | ¥60 | PS 端启动镜像 |
| 9 | 反向通道连线 | 杜邦线（母-母）若干 | 通用 | GPIO/I²C | 1 套 | ¥15 | ¥15 | 两板间传"重发请求"（T5 反向通道）|
| 10 | （可选）第 2 个 2-lane 相机 | Pcam 5C ／ 410-358 | Digilent | 同 #3 | (1) | ¥500–700 | (+¥500–700) | 多相机/VC 演示（Genesys 有 2 个 Pcam 口）|

**合计（不含可选 #10）≈ ¥22,000–26,000**　｜　¥5 万预算内，余量 ¥2.4–2.8 万。

## 连接关系

```
Genesys ZU-5EV (RX，你的电路 + PS DDR4)
   ├─ Pcam 口  ← Pcam 5C            (2-lane 真实采集)
   └─ FMC 口   ← LI-IMX274MIPI-FMC  (4-lane 真实采集)

Zybo Z7-20 (可控 MIPI 发送端) ──MIPI 数据──▶ Genesys
        ▲                                      │ 检出坏行→定位→重发请求
        └────── 反向通道(杜邦线 GPIO/I²C) ──────┘   → 写回覆盖 → 读 DDR 核对
```

- 两个相机都接 **RX 主板（Genesys）**；**Zybo 不接相机**（它本身就是数据源）。
- 重采集闭环演示用 **Zybo 可控源**，与两个相机是相互独立的两类验证。

## 采购要点 / 注意

1. **认准订货号**：410-383-5EV（主板）、410-351-20（Zybo，**务必 -20 不是 -10**）、410-358（Pcam 5C）。
2. **4-lane 相机需询价**：LI-IMX274MIPI-FMC 为 Leopard Imaging B2B 产品，邮件 support@leopardimaging.com
   或经 Future Electronics 询价；备选厂商 **e-con Systems**（亦提供 FPGA 用 4-lane MIPI 模组）。
3. **4-lane 集成有工作量（诚实提示）**：该 FMC 相机官方主要在 **ZCU102/104** 验证；接 Genesys ZU 的
   FMC 电气可行但**非官方验证组合**，需按 Genesys FMC 引脚自写约束 + 配 4-lane D-PHY IP，非即插即用。
4. **不采购**：MIPI 协议分析仪等高价实验室设备（远超本项目需求）。

## 来源

- Genesys ZU-5EV（410-383-5EV）— Digilent / Jameco
- Zybo Z7-20（410-351-20）— Digilent / DigiKey
- Pcam 5C（410-358）— Digilent
- LI-IMX274MIPI-FMC（IMX274，4-lane MIPI，FMC）— Leopard Imaging
