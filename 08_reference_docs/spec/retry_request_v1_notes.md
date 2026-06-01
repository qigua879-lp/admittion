# Retry Request V1 Notes

## Purpose

`retry_request_v1` 把现有错误定位能力向“自动重采集控制”推进一步：

- 硬件内部继续完成 ECC/CRC/sync/lane 错误识别；
- logger 保留最近错误的 `frame_id / line_id / VC / DT`；
- retry 控制块在错误出现时产生一拍 `retry_req`；
- APB 状态寄存器提供最近错误位置和最近 retry 请求位置。

## Scope

本版本实现的是接收端的请求和定位能力，不声称普通 CSI-2 sensor 一定支持标准重传。

- `retry_mode=0`：帧级重采集请求。适合视频流中丢弃坏帧、等待下一帧，或通知上游重新采一帧。
- `retry_mode=1`：行级重采集请求。需要上游图像源、缓存源或仿真 camera model 支持按行重发。

## RTL Changes

- 新增 `rtl/reliability/retry_request_ctrl.sv`
- `cfg_reg_if_apb.sv` 新增：
  - `ERR_POLICY[5] enable_retry_request`
  - `ERR_POLICY[6] retry_line_mode`
  - `LAST_ERR_FRAME / LAST_ERR_LINE`
  - `RETRY_STATUS / RETRY_FRAME / RETRY_LINE`
  - `CTRL[3] retry_ack_pulse`
- `mipi_csi2_capture_top.sv` 和 FPGA wrapper 新增 retry 输出：
  - `retry_req_o`
  - `retry_pending_o`
  - `retry_mode_o`
  - `retry_frame_id_o`
  - `retry_line_id_o`

## Verification

- `tb_retry_request_ctrl.sv`：模块级验证 frame/line 两种请求模式。
- `tb_cfg_reg_if_apb.sv`：验证新增 APB 状态寄存器和 ack pulse。
- `tb_fpga_wrapper_crc_error.sv`：CRC 错误后观测到 `retry_req`，上下文为 `frame=1, line=1`。

## Thesis Wording

建议论文表述为：

> 系统实现了错误帧/行上下文绑定和自动重采集请求输出。对于普通连续视频源，可使用帧级请求丢弃错误帧并等待后续干净帧；对于支持缓存或可控发送端的图像源，可进一步根据 `frame_id / line_id` 执行行级重采集。
