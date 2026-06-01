# rtl/csi2_rx

本目录保存 CSI-2 接收协议逻辑。

规划模块：
- `csi2_rx_core`
- `lane_align_merge`
- `csi2_packet_parser`
- `csi2_header_ecc`
- `csi2_crc16`
- `frame_line_sync`

职责：
- 对有效 lane 进行对齐与合并。
- 解析 CSI-2 short packet 和 long packet。
- 检查 packet header ECC 与 payload CRC。
- 生成 frame 和 line 同步事件。

骨架阶段结束后，P0 应优先从这里开始。
