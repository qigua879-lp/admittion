# rtl/reliability

本目录保存可靠性与恢复策略逻辑。

规划模块：
- `reliability_monitor`

职责：
- 对 ECC、CRC、sync、lane、FIFO 和 AXI 错误进行分类。
- 将错误绑定到 frame、line、virtual channel 和 data type 上下文。
- 驱动 mark、drop、resync 和 degrade 策略决策。

详细恢复 RTL 延后到 parser 和 pixel path 验证完成后实现。
