# Testbench 验证

本目录保存非综合验证代码。

## 子目录说明

| 子目录 | 作用 |
| --- | --- |
| `top/` | 系统级 smoke testbench。 |
| `models/` | 传感器与环境模型。 |
| `refs/` | 参考 helper、协议常量和打包函数。 |
| `scoreboard/` | 输出比对与统计。 |
| `seq/` | 预留复用激励序列。 |
| `tests/` | 模块级单元测试。 |

## 当前现状

- `tests/` 目前包含模块级、wrapper 系统级、错误注入和参数扫描类 testbench。
- 每个 `tb/tests/*.sv` 的测试目的、主要对象和自检判据见 `tb/tests/README.md`。
- `top/`、`models/`、`refs/`、`scoreboard/` 提供系统级 wrapper、传感器模型、协议 helper 和结果比对能力。
- 真实顶层全链路验证已经覆盖多格式、ECC/CRC/sync/lane 异常、resync、AXI 背压和 buffer/lane 参数扫描，但仍可继续扩展长期 soak、真实 DDR 和更完整 lane 配置矩阵。

## 快速索引

| 需求 | 阅读位置 |
| --- | --- |
| 想知道每个 testbench 测什么 | `tb/tests/README.md` |
| 想看系统级 top wrapper | `tb/top/README.md` |
| 想看传感器/激励模型 | `tb/models/README.md` |
| 想看参考函数和 CSI-2 打包 helper | `tb/refs/README.md` |
| 想看 scoreboard 判据 | `tb/scoreboard/README.md` |
| 想看复用序列状态 | `tb/seq/README.md` |
