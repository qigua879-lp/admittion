# rtl/preprocess/adaptive_v1

自适应预处理版本 `v1` 在现有轻量 preprocess 链路上扩展了基于 frame 的图像统计和自动系数生成功能。

本目录模块：

- `pixel_frame_stats_v1`
- `adaptive_preprocess_ctrl_v1`

版本说明：

- `v1` 是增量扩展，不替换原有 `brightness_adjust`、`contrast_adjust`、`gray_balance` 或 `preprocess_bypass_mux` 模块。
- `v1` 设计为复用现有 pixel-stream interface，并在 adaptive path 使能前保持顶层默认行为不变。

当前范围：

- 基于 frame 的 RGB/mono 统计。
- 自动 gray-world 风格 white balance 系数生成。
- 自动 linear range stretch 系数生成。
- 上一帧统计结果应用到下一帧。

当前限制：

- 自动 white balance 仅对 `RGB888` 有实际意义。
- 自动 stretch 面向 `RGB888` 和 `RAW8` debug-style stream。
- `RAW10` 和 `YUV422` 在 adaptive mode 下仍保持 pass-through，因为当前 debug pixel stream 还不是完整的 ISP-domain 表示。
