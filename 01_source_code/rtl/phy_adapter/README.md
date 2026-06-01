# rtl/phy_adapter

本目录保存数字抽象层的 D-PHY 输入适配模块。

## 当前模块

- `phy_digital_adapter`

## 当前职责

- 消费已经桥接成数字字节流的 lane 输入
- 结合 `hs_mode/lp_mode` 做协议活动门控
- 根据 `LANE_CFG` 中的 `lane_num_minus1` 和 `lane_enable_mask` 输出有效 lane
- 将每个 lane 的 `31:0` 输入字裁剪成当前阶段使用的 `7:0` 字节输入

## 当前边界

- 只处理数字抽象层，不实现真实模拟 D-PHY 电气行为
- 当前仍假设每拍只消费每个 lane 输入字的低 8 bit
- SoT/EoT 级别的真实电气状态恢复仍不在本模块范围内
