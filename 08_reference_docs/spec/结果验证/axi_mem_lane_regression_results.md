# AXI Memory Lane Regression Results

## Purpose

This report captures wrapper-level AXI write closure plus readback-scoreboard evidence across `1 / 2 / 4 lane` configurations.

## Testbench

- Closure TB: `tb/tests/tb_fpga_wrapper_axi_mem_closure.sv`
- Batch script: `scripts/run_axi_mem_lane_regression.ps1`
- Method: feed expected RAW8 pixels into the scoreboard, wait for AXI writes to drain, then read back the wrapper's internal AXI sink memory and feed that stream into the same scoreboard as the actual path.

## Configuration

- Traffic: `RAW8`, single-frame, `LINE_COUNT=1`
- Lane sweep: `LANE_NUM in {1, 2, 4}`
- To keep lane4 frame grouping exact, lane4 uses a minimal `RAW8` 2-byte payload in this closure TB; lane1 and lane2 keep the normal 4-byte payload.
- The AXI sink interface is unchanged; it now stores write data so readback can be verified.

## Result Table

| lane num | lines | exp pixels | act pixels | aw bursts | w beats |
| --- | --- | --- | --- | --- | --- |
| 1 | 1 | 4 | 4 | 1 | 1 |
| 2 | 1 | 4 | 4 | 1 | 1 |
| 4 | 1 | 2 | 2 | 1 | 1 |

## Conclusions

- `1 / 2 / 4 lane` all now have wrapper-level `RAW8 -> AXI write -> memory readback -> scoreboard` closure evidence.
- This moves the proof point beyond live pixel-output closure and shows that the current AXI write path stores the expected pixels into the internal memory model.
- Because the current boot configuration reuses the frame base address across frames, this readback closure focuses on single-frame write correctness; long soak and throughput limits are covered by a separate stress test.
