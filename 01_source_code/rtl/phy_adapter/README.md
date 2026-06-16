# rtl/phy_adapter

本目录保存数字抽象层的 D-PHY 输入适配模块。

## 当前模块

- `phy_digital_adapter`
- `mipi_dphy_ppi_adapter`

## 当前职责

- 将 AMD MIPI D-PHY RX PPI 风格的 `rxbyteclkhs`、`dl*_rxdatahs`、
  `dl*_rxvalidhs`、`dl*_rxactivehs`、`dl*_rxsynchs` 和 stop/error 信号
  整形成现有数字 lane 输入。
- 在 `rxbyteclkhs` 域先寄存 PPI HS 输入，避免外部 PPI 端口直接驱动
  parser/deskew CE 这类内部高扇出控制路径。
- 对 `cl_stopstate/dl*_stopstate` 形成的 `lp_mode` 做两级同步；`lp_mode`
  作为状态观测使用，不再门控 HS 字节流。
- 消费已经桥接成数字字节流的 lane 输入
- 以 `hs_mode` 表示协议活动状态
- 根据 `LANE_CFG` 中的 `lane_num_minus1` 和 `lane_enable_mask` 输出有效 lane
- 将每个 lane 的 `31:0` 输入字裁剪成当前阶段使用的 `7:0` 字节输入

## 当前边界

- 只处理数字抽象层，不实现真实模拟 D-PHY 电气行为
- `mipi_dphy_ppi_adapter` 默认面向 2 lane bring-up；lane 数可通过参数扩到 1/3/4
- 当前仍假设每拍只消费每个 lane 输入字的低 8 bit
- SoT/EoT 级别的真实电气状态恢复仍不在本模块范围内
