# Reliability Notes

## Scope
This note now covers both the original reliability monitor blocks and the
current top-level recovery closure wiring:
- `err_classifier`
- `err_frame_line_logger`
- `resync_ctrl_fsm`
- `degrade_recover_fsm`
- top-level `resync` clear/flush wiring
- `packet_error_policy`-driven payload drop / line drop behavior

## Error Types
| Code | Name |
|---:|---|
| `3'd0` | none |
| `3'd1` | ecc |
| `3'd2` | crc |
| `3'd3` | sync |
| `3'd4` | lane |

## Error Priority
When multiple error inputs arrive in the same cycle, `err_classifier` emits one event using this priority:

1. sync
2. lane
3. crc
4. ecc

All asserted per-type counters increment even when only the highest-priority event is emitted.

## err_classifier
### Interface Summary
- Inputs: ECC/CRC/sync/lane error pulses and frame/line/VC/DT context.
- Output: one valid/ready error event with `err_type`, `err_priority`, frame ID, line ID, VC, and DT.
- Counters: per-type 32-bit counters.

### Boundary Conditions
- If output is held by backpressure, the current event is preserved.
- New event storage while backpressured is intentionally minimal in this phase.
- Counter saturation is not implemented; counters wrap naturally.

## err_frame_line_logger
### Interface Summary
- Consumes classified error events.
- Records the most recent error context.
- Maintains total and per-type counters.
- `clear_i` clears `err_pending_o` but does not clear counters.

### Boundary Conditions
- This is a last-event logger, not a deep event FIFO.
- It is intended to feed register/status logic in a later phase.

## resync_ctrl_fsm
### Strategy
- If `enable_resync_i` and `sync_error_i` are asserted, request resync.
- Hold `resync_req_o`, `drop_packet_o`, and `resync_busy_o` until `resync_ack_i`.
- Emit one-cycle `resync_done_o` after acknowledgement.

### Current Top-Level Closure
- `resync_req_o` rising edge is converted into one clear pulse in `clk_sys`.
- That pulse clears parser state, frame/line sync state, unpacker partial state,
  adaptive statistic state, and the byte-domain CDC FIFO read side.
- The same request is toggle-synchronized into `clk_byte` to clear the write
  side of the byte FIFO.
- `pixel_to_axi_writer` performs an ordered flush: it blocks new sys-side input,
  waits for any in-flight AXI burst to finish, clears its CDC FIFOs in both
  domains, and then returns `clear_busy_o = 0`.
- The top uses `!axi_clear_busy && resync_clear_pulse_sys` as the current
  acknowledgement condition, so resync now waits for the writer clear path
  instead of simply waiting for the next `frame_start`.

## degrade_recover_fsm
### Strategy
- If `enable_degrade_i` and `lane_error_i` are asserted, switch to degraded lane count.
- Count consecutive `good_frame_i` pulses while degraded.
- Restore full lane count after `RECOVER_GOOD_FRAME_TH` good frames.
- A new lane error restarts degraded recovery.

## Self-Check Method
- `tb_err_classifier.sv` covers ECC, CRC, sync, lane, priority, context binding, and counters.
- `tb_err_logger.sv` covers recent-context logging, per-type counters, total counter, and pending clear.
- `tb_resync_ctrl.sv` covers resync disabled/enabled behavior, acknowledgement completion, lane degradation, and recovery.
- `tb_long_packet_parser.sv` now includes `clear_i` flush behavior.
- `tb_frame_line_sync.sv` now includes `clear_i` state flush behavior.
- `tb_async_fifo.sv` now includes dual-domain clear behavior.

## Current Limits
- Resync currently waits only for the AXI writer clear path to become safe; it
  does not yet prove end-to-end sensor-side idleness.
- Parser/FIFO flush is line-oriented and sufficient for the current minimum
  pipeline, but not yet coupled to a deeper multi-packet frame buffer policy.
