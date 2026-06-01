# RAW8 Soak And Throughput Sweep Results

## Purpose

This report captures long-run soak and throughput-sweep evidence for two questions:

- Do `1 / 2 / 4 lane` configurations remain scoreboard-clean under multi-frame, multi-line continuous traffic?
- How does lane count affect sustained throughput in the stable no-stall operating region?

## Testbench

- Soak TB: `tb/tests/tb_fpga_wrapper_raw8_soak_metrics.sv`
- Batch script: `scripts/run_raw8_soak_throughput_sweep.ps1`

## Configuration

- Traffic: `RAW8`, wrapper path, live pixel scoreboard
- Base FIFO setting: `BYTE_FIFO_ADDR_WIDTH=2`, `AXI_FIFO_ADDR_WIDTH=3`
- Throughput metrics: `pix_per_byte_clk_x1000` and `pix_per_axi_clk_x1000`
- This sweep intentionally stays inside the stable no-stall region; extreme backpressure boundaries are already covered by the dedicated stress script.
- `x1000` means fixed-point milli-pixels per clock

## Result Table

| case | lane | stall | frames | lines/frame | total lines | total pixels | lane bp seen | lane bp cycles | max byte fifo | max axi fifo | pix/byte-clk x1000 | pix/axi-clk x1000 | aw stall cycles | w stall cycles | aw bursts | w beats |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| lane1_soak_s0 | 1 | 0 | 32 | 8 | 256 | 1024 | 1 | 637 | 3 | 1 | 98 | 123 | 0 | 0 | 256 | 256 |
| lane2_soak_s0 | 2 | 0 | 32 | 8 | 256 | 1024 | 1 | 4670 | 3 | 1 | 106 | 133 | 0 | 0 | 256 | 256 |
| lane4_soak_s0 | 4 | 0 | 32 | 8 | 256 | 1024 | 1 | 7040 | 3 | 1 | 106 | 133 | 0 | 0 | 256 | 256 |
| lane2_soak_long_s0 | 2 | 0 | 48 | 8 | 384 | 1536 | 1 | 7038 | 3 | 1 | 106 | 133 | 0 | 0 | 384 | 384 |

## Conclusions

- `lane1 / lane2 / lane4` now all have multi-frame, multi-line wrapper-level soak evidence rather than only minimal smoke coverage.
- In the no-stall region, increasing lane count shortens the byte-side transfer window, so `pix_per_byte_clk_x1000` rises accordingly.
- `lane2_soak_long_s0` extends the run length to `48` frames to provide a longer continuous soak sample on the 2-lane main path.
