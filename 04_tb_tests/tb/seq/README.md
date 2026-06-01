# tb/seq

本目录保存可复用 stimulus sequence。

## 当前状态

| 项目 | 状态 | 说明 |
| --- | --- | --- |
| 复用 sequence 文件 | 暂未落正式文件 | 当前大部分 short/long packet、ECC/CRC、sync error、lane skew 激励仍直接写在各 `tb/tests/*.sv` 内。 |
| 后续建议 | 可继续抽象 | 若后续 testbench 继续增长，可把通用 packet 发送、错误注入和多帧序列抽到本目录，减少 wrapper TB 重复代码。 |

## 使用原则

sequence 应能同时服务模块级和系统级测试，且每个 sequence 要明确输入参数、错误注入点和预期结果。
