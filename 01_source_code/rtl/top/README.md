# rtl/top

本目录保存顶层集成 wrapper。

主要模块：
- `mipi_csi2_capture_top`
- `mipi_csi2_capture_fpga_wrapper`

职责：
- 保持项目级 interface 风格。
- 连接主要子系统。
- 明确保留 clock-domain 边界。
- 在需要减少封装 I/O 时提供面向板级的 FPGA wrapper。

Wrapper 说明：
- `mipi_csi2_capture_top` 保留完整的系统侧 APB/AXI/debug interface。
- `mipi_csi2_capture_fpga_wrapper` 将 APB 和 AXI 隐藏在 FPGA 内部，只导出更小的板级 pin set。
