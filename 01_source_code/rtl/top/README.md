# rtl/top

本目录保存顶层集成 wrapper。

主要模块：
- `mipi_csi2_capture_top`
- `mipi_csi2_capture_fpga_wrapper`
- `mipi_csi2_capture_dphy_wrapper`

职责：
- 保持项目级 interface 风格。
- 连接主要子系统。
- 明确保留 clock-domain 边界。
- 在需要减少封装 I/O 时提供面向板级的 FPGA wrapper。

Wrapper 说明：
- `mipi_csi2_capture_top` 保留完整的系统侧 APB/AXI/debug interface。
- `mipi_csi2_capture_fpga_wrapper` 将 APB 和 AXI 隐藏在 FPGA 内部，只导出更小的板级 pin set。
- `mipi_csi2_capture_dphy_wrapper` 在 FPGA wrapper 前增加 AMD MIPI D-PHY RX PPI 适配入口，默认用于 2 lane bring-up，并启用 no-backpressure drop guard。

D-PHY no-backpressure guard:
- `mipi_csi2_capture_top` 默认不启用该保护，保持原仿真 sensor 可等待 `lane_ready` 的语义。
- `mipi_csi2_capture_dphy_wrapper` 显式启用该保护，因为 AMD D-PHY RX PPI 侧没有 `rxreadyhs`，真实 byte stream 不能被 RTL 反压。
- 保护触发后会清 byte/sys 侧残留，丢弃当前受损帧，直到 parser 重新看到下一个 FS 再恢复像素输出。
- D-PHY wrapper 默认将 `BYTE_FIFO_ADDR_WIDTH` 和 `AXI_FIFO_ADDR_WIDTH` 提到 `8`，避免小 FIFO 在正常 clean frame 下误触发保护。
