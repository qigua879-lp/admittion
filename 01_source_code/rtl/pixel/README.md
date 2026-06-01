# rtl/pixel

本目录保存 pixel repack 和格式转换逻辑。

规划模块：
- `pixel_repack_core`

职责：
- 将 CSI-2 payload byte 转换为内部 pixel stream。
- 优先支持 RAW8 和 RGB888。
- 后续补充 RAW10 和 YUV422。
- 传递 frame 和 line marker。

骨架阶段尚未实现 pixel RTL。
