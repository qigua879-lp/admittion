# tb/models

本目录保存可复用 testbench model。

## 当前文件

| 文件 | 作用 | 主要能力 |
| --- | --- | --- |
| `sensor_model.sv` | 可复用 CSI-2 传感器/输入模型 | 生成确定性的 CSI-2 short/long packet、lane byte stream 和像素参考流，用于 wrapper/system testbench。 |

## 建模原则

模型可以是非综合代码，但必须保持确定性、可复现、易调试。错误注入类场景优先在 testbench 中显式构造，避免模型隐藏测试意图。
