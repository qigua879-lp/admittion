# rtl/reg_if

本目录保存配置和状态寄存器模块。

规划模块：
- `cfg_reg_if`

职责：
- 解码 `docs/regmap/register_map.md` 中定义的控制和状态寄存器。
- 向 datapath 提供配置输出。
- 收集状态和错误计数器。

骨架阶段尚未实现 register RTL。
