# tb/refs

本目录保存 reference model。

## 当前文件

| 文件 | 作用 | 主要能力 |
| --- | --- | --- |
| `csi2_reference_helpers.sv` | CSI-2 参考 helper 包 | 提供数据类型常量、header 打包、packet byte 选取、payload byte count、payload CRC、期望像素生成等函数。 |

## 使用说明

参考模型可以是非综合代码，但应保持易审计。testbench 中构造 CSI-2 包、计算 CRC、生成期望像素时优先复用该 helper，避免每个 TB 重复写一套参考逻辑。
