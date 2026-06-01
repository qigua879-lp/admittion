# rtl/preprocess

本目录保存可选的轻量预处理逻辑。

规划模块：
- `preprocess_core`
- `adaptive_v1/*`

职责：
- 支持 bypass。
- 后续补充简单 brightness、contrast、gray balance 或 3x3 filter 逻辑。
- 在增量版本中加入基于 frame 的自适应统计和系数生成，不替换稳定的基础模块。
- 保持位于已验证的接收链路和 pixel repack 逻辑之后。

当前已纳入版本管理的自适应扩展：

- `adaptive_v1/pixel_frame_stats_v1.sv`
- `adaptive_v1/adaptive_preprocess_ctrl_v1.sv`

preprocess RTL 有意保持轻量且可综合。
