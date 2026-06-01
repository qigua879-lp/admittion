# Format Comparison Results

## Purpose

本文件用于把当前四种已完成系统级验证的数据格式结果整理成统一横向比较表，便于后续直接插入论文第 4 章像素重组分析或第 6 章系统验证总结。

## Data Sources

- `tb_fpga_wrapper_raw8_metrics`
- `tb_fpga_wrapper_raw10_metrics`
- `tb_fpga_wrapper_rgb888_metrics`
- `tb_fpga_wrapper_yuv422_metrics`

## Comparison Table

| Format | `init_to_frame` | `frame_to_first_pixel` | `frame_to_end` | `first_to_last_pixel` | `pixel_valid_cycles` | Full-frame closure |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| `RAW8` | `14` | `16` | `34` | `3` | `4` | Yes |
| `RAW10` | `16` | `20` | `38` | `3` | `4` | Yes |
| `RGB888` | `14` | `18` | `42` | `9` | `4` | Yes |
| `YUV422` | `14` | `19` | `40` | `7` | `4` | Yes |

## Engineering Reading

- `RAW8` 是当前最短的 baseline 主链路。
- `RAW10` 与 `RAW8` 的像素输出跨度一致，但首像素与整帧收尾时延更高，反映出额外解包整理开销。
- `RGB888` 的整帧跨度最大，符合 24-bit 像素路径在当前最小样例下的数据组织特征。
- `YUV422` 的整体复杂度和时延介于 `RAW10` 与 `RGB888` 之间。

## Thesis Wording Suggestion

- 可表述为：“在统一 wrapper 启动框架与最小单帧样例下，四种格式均已完成系统级闭环验证。其中 `RAW8` 具有最短主链路时延，`RAW10` 在保持与 `RAW8` 相同像素输出跨度的同时表现出更高的前端整理时延，`RGB888` 和 `YUV422` 则体现出更宽像素组织路径带来的整帧跨度增长。”

## Boundary Notes

- 本比较表用于说明格式间相对差异，不等价于最终吞吐上限测试。
- `RAW10` full-frame closure 在 testbench 中通过 `FE` 后追加一个 flush byte 完成尾部单字节冲刷；该处理只位于激励层，不改变 DUT RTL。
