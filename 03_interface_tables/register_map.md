# register_map.md

## Register Map

当前顶层由 `rtl/reg_if/cfg_reg_if_apb.sv` 实现 APB 配置与状态读回。
该映射兼顾现阶段主链路闭环与后续扩展，因此在基础控制寄存器之外，
额外保留了 AXI 与 adaptive 观测寄存器。

| Name | Addr | RW | Reset | Description |
|---|---:|---|---:|---|
| CTRL | 0x0000 | RW | 0x0000_0000 | 总控制寄存器 |
| STATUS | 0x0004 | RO | 0x0001_0201 | 当前状态和链路模式 |
| IMG_WIDTH | 0x0008 | RW | 0x0000_0780 | 图像宽度，默认 1920 |
| IMG_HEIGHT | 0x000C | RW | 0x0000_0438 | 图像高度，默认 1080 |
| LANE_CFG | 0x0010 | RW | 0x0000_0021 | lane 数和 lane 使能 mask |
| DT_CFG | 0x0014 | RW | 0x0000_002A | 数据类型和 VC 配置 |
| FRAME_BASE_ADDR | 0x0018 | RW | 0x0000_0000 | DDR 帧基地址 |
| LINE_STRIDE | 0x001C | RW | 0x0000_0000 | 每行 stride |
| ERR_CNT_ECC | 0x0020 | RO | 0x0000_0000 | ECC 错误计数 |
| ERR_CNT_CRC | 0x0024 | RO | 0x0000_0000 | CRC 错误计数 |
| ERR_CNT_SYNC | 0x0028 | RO | 0x0000_0000 | 同步错误计数 |
| FRAME_CNT | 0x002C | RO | 0x0000_0000 | 帧计数 |
| LINE_CNT | 0x0030 | RO | 0x0000_0000 | 行计数 |
| ERR_POLICY | 0x0034 | RW | 0x0000_0039 | 错误策略配置 |
| PREPROC_CFG | 0x0038 | RW | 0x0000_0001 | 预处理与自适应开关 |
| DBG_SEL | 0x003C | RW | 0x0000_0000 | 调试信号选择 |
| AXI_CFG | 0x0040 | RW | `AXI_MAX_BURST_LEN` | AXI 写通路配置 |
| LAST_ERR | 0x0044 | RO | 0x0000_0000 | 最近一次错误摘要 |
| ADAPT_GAIN | 0x0048 | RO | 0x0000_0000 | adaptive gain 观测 |
| ADAPT_STAT0 | 0x004C | RO | 0x0000_0000 | 均值统计观测 0 |
| ADAPT_STAT1 | 0x0050 | RO | 0x0000_0000 | 均值统计观测 1 |
| LAST_ERR_FRAME | 0x0054 | RO | 0x0000_0000 | 最近一次错误所在帧号 |
| LAST_ERR_LINE | 0x0058 | RO | 0x0000_0000 | 最近一次错误所在行号 |
| RETRY_STATUS | 0x005C | RO | 0x0000_0000 | 自动重采集请求摘要 |
| RETRY_FRAME | 0x0060 | RO | 0x0000_0000 | 自动重采集请求帧号 |
| RETRY_LINE | 0x0064 | RO | 0x0000_0000 | 自动重采集请求行号 |

## CTRL bitfields

- [0] `enable`
- [1] `soft_reset_pulse`
- [2] `start_capture_pulse`
- [3] `retry_ack_pulse`
- [31:4] reserved

说明：

- `soft_reset_pulse` 和 `start_capture_pulse` 是写 `1` 产生单周期脉冲。
- `retry_ack_pulse` 是写 `1` 产生单周期脉冲，用于清除 retry pending。
- 当前顶层主要使用 `enable` 控制 AXI 写通路使能。

## STATUS bitfields

- [0] `idle`
- [1] `receiving`
- [2] `frame_active`
- [3] `line_active`
- [4] `overflow_sticky`
- [5] `axi_busy`
- [6] `err_pending`
- [10:8] `active_lane_num`
- [16] `hs_mode`
- [17] `lp_mode`
- [31:18] reserved

说明：

- `overflow_sticky` 当前由 lane/deskew 侧的溢出事件置位。
- 写 `CTRL[1] = 1` 可清除该 sticky 位。

## LANE_CFG bitfields

- [1:0] `lane_num_minus1`
- [7:4] `lane_enable_mask`
- [31:8] reserved

## DT_CFG bitfields

- [7:0] `dt_code`
- [15:8] `vc_id`
- [31:16] reserved

## ERR_POLICY bitfields

- [0] `enable_err_log`
- [1] `mark_ecc_error`
- [2] `drop_on_crc_error`
- [3] `resync_on_sync_error`
- [4] `degrade_on_lane_error`
- [5] `enable_retry_request`
- [6] `retry_line_mode`
- [31:7] reserved

说明：

- 当前 RTL 已正式使用 [0]、[1]、[2]、[3]、[4]、[5]、[6]。
- [1] 控制 bad-ECC long packet 是否送入像素链路。
- [2] 控制 CRC 错误行是否在 `line_end` 时被整行丢弃。
- [5] 控制错误上下文是否产生自动重采集请求。
- [6] 控制重采集粒度，`0` 为帧级请求，`1` 为行级请求。

## PREPROC_CFG bitfields

- [0] `bypass_preprocess`
- [1] `adaptive_enable`
- [2] `adaptive_awb_enable`
- [3] `adaptive_stretch_enable`
- [31:4] reserved

## AXI_CFG bitfields

- [8:0] `max_burst_len`
- [31:9] reserved

## LAST_ERR bitfields

- [2:0] `last_err_type`
- [5:4] `last_err_priority`
- [15:8] `last_err_dt`
- [17:16] `last_err_vc`
- [31:18] reserved

## LAST_ERR_FRAME / LAST_ERR_LINE

- `LAST_ERR_FRAME`：最近一次错误绑定的 `frame_id`
- `LAST_ERR_LINE`：最近一次错误绑定的 `line_id`

## RETRY_STATUS bitfields

- [0] `retry_pending`
- [1] `retry_mode`，`0` 表示帧级重采集请求，`1` 表示行级重采集请求
- [4:2] `retry_err_type`
- [15:8] `retry_dt`
- [17:16] `retry_vc`
- [31:18] reserved

## RETRY_FRAME / RETRY_LINE

- `RETRY_FRAME`：最近一次自动重采集请求绑定的帧号
- `RETRY_LINE`：最近一次自动重采集请求绑定的行号

## Known Limits

- `LANE_CFG` 和 `DT_CFG` 已反馈到顶层动态行为；`DBG_SEL` 仍主要作为调试留口。
- `AXI_CFG` 目前仅控制 `max_burst_len`，尚未扩展到更完整的 DDR 调度参数。
- `DT_CFG` 当前是单一 `VC/DT` 严格过滤，不支持多类型 allow-list。
