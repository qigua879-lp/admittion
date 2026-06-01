# tb/scoreboard

本目录保存 scoreboard 和 checker 代码。

## 当前文件

| 文件 | 作用 | 主要能力 |
| --- | --- | --- |
| `scoreboard.sv` | 像素流 scoreboard | 比对 expected/actual pixel data、SOF/SOL marker，统计 expected/actual pixel count、frame count、mismatch count，并输出 pass/fail。 |

## 判据原则

scoreboard 应用于系统级 wrapper 测试时，通常以 `mismatch_cnt==0`、`exp_pixel_cnt==act_pixel_cnt` 和必要 marker 计数闭合为通过条件。协议错误类 TB 还应额外检查 `err_ecc_o`、`err_crc_o`、`err_sync_o` 或内部恢复信号。
