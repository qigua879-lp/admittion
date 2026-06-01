# Error Policy

## Purpose
This document defines the initial error handling policy for the digital MIPI CSI-2 capture system. It aligns with the register map and keeps error behavior testable.

## Error Classes
| Error | Source | Required Context | Default P0 Behavior |
|---|---|---|---|
| ECC error | CSI-2 packet header | frame_id, line_id, vc, dt | Count and mark packet |
| CRC error | Long packet payload | frame_id, line_id, vc, dt | Count and optionally drop line |
| Sync error | SoT/EoT or frame/line sequence | frame_id, line_id, vc, dt | Count and request resync |
| Lane align error | Lane deskew or merge | frame_id, line_id, lane_id | Count and mark lane event |
| FIFO overflow | Buffer subsystem | frame_id, line_id | Count and mark frame unreliable |
| AXI error | AXI write response | frame_id, line_id, address | Count and stop or retry by policy |

## Register Policy Mapping
`ERR_POLICY` controls the default action:

| Bit | Name | Meaning |
|---:|---|---|
| 0 | enable_err_log | 允许错误写入 logger/sticky 状态 |
| 1 | mark_ecc_error | 当前实现为“bad-ECC long packet 不进入像素路径” |
| 2 | drop_on_crc_error | 当前实现先产生 `crc_drop_req` 观察脉冲 |
| 3 | resync_on_sync_error | Enter resync flow on sync sequence error |
| 4 | degrade_on_lane_error | Allow reduced-lane or recovery behavior on lane errors |
| 5 | enable_retry_request | Allow error context to generate a retry request |
| 6 | retry_line_mode | 0: request frame reacquire, 1: request line reacquire |

## P0 Behavior
- ECC errors increment `ERR_CNT_ECC`.
- CRC errors increment `ERR_CNT_CRC`.
- Sync errors increment `ERR_CNT_SYNC`.
- Error pulses are observable through debug/status outputs.
- When `enable_retry_request=1`, the latest error context is exported as a
  retry request with frame/line/VC/DT information.
- Error injection is required in testbench.
- Packet parsing must continue only when the configured policy allows it.
- 当 `mark_ecc_error=1` 时，header ECC 错误的 long packet 会被 parser 消耗，
  但不会送入像素重组链路。
- 当 `drop_on_crc_error=1` 时，当前版本会在顶层锁存“当前行待丢弃”，并在
  `line_end` 时通过 `pixel_to_axi_writer` flush 掉这一整行的已缓存像素。

## Recovery Rules
- ECC error: keep receiving by default, but when `mark_ecc_error` is set,
  bad-ECC long packet is withheld from the pixel path.
- CRC error: keep receiving by default; when `drop_on_crc_error` is set,
  the current line is discarded at line end through the existing AXI-side line buffer.
- Sync error: request resync when `resync_on_sync_error` is set.
- Lane align error: record event; when `degrade_on_lane_error` is set,
  `degrade_recover_fsm` now reduces the effective lane count seen by
  `phy_digital_adapter`.
- Retry request: latch the latest error frame/line context and raise a one-cycle
  `retry_req` pulse. In frame mode, software or an upstream controller should
  reacquire the whole frame. In line mode, the upstream source must support
  line-level resend; the RX side only provides the request and context.

## Boundary Conditions
- Counter saturation behavior must be defined before RTL implementation.
- Error context must not cross clock domains without explicit synchronization.
- A bad packet length must be treated as a parser or sync error.
- An unsupported data type must be visible to verification even if payload is skipped.
