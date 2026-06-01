# Regression Plan

## Scope

This plan defines the current RTL and testbench regression flow for the digital MIPI CSI-2 capture project. It covers module-level tests, system-level smoke tests, top-level compile checks, and script self-checks.

The plan complements:

- `docs/spec/system_spec.md`
- `docs/spec/clock_domains.md`
- `docs/spec/system_tb_notes.md`
- `docs/spec/top_integration_notes.md`
- `docs/spec/fpga_notes.md`

## Regression Artifacts

| File | Role |
| --- | --- |
| `sim/vcs/compile.f` | Shared source file list for RTL and reusable TB support files. |
| `sim/vcs/run_smoke.sh` | Fast smoke regression for key blocks, system variants, and top compile. |
| `sim/vcs/run_regression.sh` | Full available regression for all checked-in module tests plus system variants. |
| `docs/spec/regression_plan.md` | Regression layering, coverage map, and follow-up checks. |

The scripts live under `sim/vcs` because the long-term target simulator is VCS. For local accessibility they also support `iverilog` when VCS is unavailable.

## Simulator Selection

Both scripts use:

1. `SIM=vcs` to force VCS.
2. `SIM=iverilog` to force Icarus Verilog.
3. `SIM=auto` by default, preferring VCS and falling back to Icarus.

Examples:

```sh
./sim/vcs/run_smoke.sh
SIM=iverilog ./sim/vcs/run_regression.sh
SIM=vcs ./sim/vcs/run_regression.sh
```

Logs are written under:

- `sim/logs/smoke/`
- `sim/logs/regression/`

## Regression Layers

| Layer | Purpose | Entry |
| --- | --- | --- |
| L0 compile-only | Check file list, syntax, and top-level connection self-consistency. | `compile_only` steps in scripts |
| L1 module unit | Check each reusable RTL block with its dedicated TB. | `tb/tests/*.sv` |
| L2 system smoke | Check minimum CSI-2 flow and selected lane/data-type variants. | `tb/top/tb_mipi_csi2_capture_top.sv` |
| L3 FPGA script | Check Vivado Tcl/XDC syntax. Real synth/impl waits for FPGA part and final XDC. | `fpga/vivado/*.tcl`, `fpga/xdc/*.xdc` |

## Smoke Tests

Smoke is intended to be fast and representative. It should be run after normal edits and before handoff.

| Test | Area | Purpose |
| --- | --- | --- |
| `tb_async_fifo` | Buffer/CDC | Basic async FIFO reset, ordering, full/empty, backpressure. |
| `tb_header_ecc` | CSI-2 common | Header ECC good/error/correctable behavior. |
| `tb_payload_crc` | CSI-2 common | Payload CRC accumulation and mismatch detection. |
| `tb_short_packet_parser` | Parser | VC/DT/WC/ECC extraction for short packets. |
| `tb_long_packet_parser` | Parser | Header parse plus payload start/end/valid flow. |
| `tb_lane_reorder_merge` | Lane path | 1/2/4 lane merge order. |
| `tb_phy_digital_adapter` | PHY adapter | HS/LP gating, lane count mask, and byte extraction. |
| `tb_cfg_reg_if_apb` | Reg-if | APB register defaults, RW fields, status reflection, and sticky clear behavior. |
| `tb_raw8_unpack` | Pixel | RAW8 byte-to-pixel path. |
| `tb_rgb888_unpack` | Pixel | RGB888 grouping and marker propagation. |
| `tb_axi_write_master` | AXI | Burst write handshake and B response closure. |
| `tb_pixel_to_axi_writer` | AXI | Pixel-stream to line-write closure across `clk_sys` and `clk_axi`. |
| `tb_contrast_adjust` | Preprocess | Signed datapath and bypass-sensitive contrast behavior. |
| `tb_pixel_frame_stats_v1` | Adaptive preprocess | Frame statistics accumulation and latch behavior. |
| `tb_adaptive_preprocess_ctrl_v1` | Adaptive preprocess | Frame-to-frame coefficient generation behavior. |
| `tb_mipi_csi2_capture_top` lane2 RAW8 | System TB | Default minimum frame. |
| `tb_mipi_csi2_capture_top` lane1 RAW8 | System TB | Single-lane smoke. |
| `tb_mipi_csi2_capture_top` lane4 RAW8 | System TB | Four-lane smoke. |
| `tb_mipi_csi2_capture_top` lane2 RGB888 | System TB | RGB888 smoke. |
| `tb_fpga_wrapper_raw8_smoke` | Real-top system TB | Direct RAW8 smoke through `mipi_csi2_capture_fpga_wrapper` and the real integrated top path. |
| `tb_fpga_wrapper_crc_error` | Real-top system TB | Direct CRC error injection through `mipi_csi2_capture_fpga_wrapper` with system-level error observation. |
| `tb_fpga_wrapper_ecc_error` | Real-top system TB | Direct header ECC error injection through `mipi_csi2_capture_fpga_wrapper` with system-level error observation. |
| `tb_fpga_wrapper_sync_illegal_order` | Real-top system TB | Direct illegal short-packet ordering through `mipi_csi2_capture_fpga_wrapper` to observe sync error behavior. |
| `tb_fpga_wrapper_lane_skew_tolerance` | Real-top system TB | Direct in-range lane-skew injection through `mipi_csi2_capture_fpga_wrapper` to observe successful deskew and merge. |
| `tb_fpga_wrapper_resync_recovery` | Real-top system TB | Direct illegal sync sequence through `mipi_csi2_capture_fpga_wrapper` to observe `resync_req/busy/done/clear` signal-chain closure. |
| `tb_fpga_wrapper_resync_metrics` | Real-top system TB | Direct illegal sync sequence through `mipi_csi2_capture_fpga_wrapper` with cycle-count collection for `sync_to_req`, `req_to_busy`, `busy_to_clear`, `clear_to_done`, and `sync_to_done`. |
| `tb_fpga_wrapper_axi_backpressure` | Real-top system TB | Direct RAW8 frame through `mipi_csi2_capture_fpga_wrapper` while forcing AXI `awready/wready` low to observe write-path backpressure closure. |
| `tb_fpga_wrapper_resync_repeated_error` | Real-top system TB | Direct sync error plus repeated error injection during `resync_busy` to observe that the recovery chain still closes. |
| `tb_fpga_wrapper_lane_skew_overflow` | Real-top system TB | Direct out-of-range lane skew through `mipi_csi2_capture_fpga_wrapper` to observe lane backpressure and deskew overflow. |
| `tb_fpga_wrapper_raw8_metrics` | Real-top system TB | Direct RAW8 wrapper path with cycle-count collection for init, first-frame, first-pixel, and frame-end latency. |
| `tb_fpga_wrapper_axi_backpressure_metrics` | Real-top system TB | Direct RAW8 wrapper path with AXI backpressure plus cycle-count collection for AW/W stall and release behavior. |
| `tb_fpga_wrapper_rgb888_smoke` | Real-top system TB | Direct RGB888 wrapper path with explicit DT configuration to observe full 24-bit pixel output on the integrated top. |
| `tb_fpga_wrapper_rgb888_metrics` | Real-top system TB | Direct RGB888 wrapper path with cycle-count collection for init, first-frame, first-pixel, and frame-end latency. |
| `tb_fpga_wrapper_raw10_smoke` | Real-top system TB | Direct RAW10 wrapper path with explicit DT configuration to observe correct 5-byte to 4-pixel unpacking on the integrated top. |
| `tb_fpga_wrapper_raw10_metrics` | Real-top system TB | Direct RAW10 wrapper path with cycle-count collection for init, first-frame, first-pixel, and pixel-output span. |
| `tb_fpga_wrapper_yuv422_smoke` | Real-top system TB | Direct YUV422 wrapper path with explicit DT configuration to observe correct two-pixel grouping on the integrated top. |
| `tb_fpga_wrapper_yuv422_metrics` | Real-top system TB | Direct YUV422 wrapper path with cycle-count collection for init, first-frame, first-pixel, and frame-end latency. |
| `mipi_csi2_capture_top` compile-only | Top | Minimum top integration syntax and port binding. |

## Full Regression Tests

Full regression adds lower-level corner coverage around the smoke set.

| Test | Area | Purpose |
| --- | --- | --- |
| `tb_frame_line_sync` | Parser/sync | FS/FE/LS/LE legal and illegal order behavior. |
| `tb_lane_deskew_buffer` | Lane path | Delay mismatch, valid skew, multi-lane deskew. |
| `tb_raw10_unpack` | Pixel | RAW10 5-byte to 4-pixel packing. |
| `tb_yuv422_unpack` | Pixel | YUV422 grouping and two-pixel output. |
| `tb_err_classifier` | Reliability | ECC/CRC/sync/lane priority and counters. |
| `tb_err_logger` | Reliability | Frame/line/VC/DT error logging. |
| `tb_resync_ctrl` | Reliability | Resync request/ack and degrade/recover flow coverage. |
| `tb_cfg_reg_if_apb` | Reg-if | Register-map decode, sticky overflow state, and control pulse behavior. |
| `tb_addr_gen_frame_based` | AXI | Frame base + line stride address calculation. |
| `tb_brightness_adjust` | Preprocess | Gain/bias, saturation, bypass, backpressure. |
| `tb_gray_balance` | Preprocess | Per-channel gain/bias and marker propagation. |
| `tb_pixel_frame_stats_v1` | Adaptive preprocess | RGB/RAW8 frame statistics and clear behavior. |
| `tb_adaptive_preprocess_ctrl_v1` | Adaptive preprocess | AWB/stretch coefficient generation and disables. |
| `preprocess_bypass_mux` compile-only | Preprocess | Bypass mux syntax and port binding. |

The full script also runs all smoke tests.

## Compile File Policy

`compile.f` includes:

1. All synthesizable RTL under the implemented module areas.
2. Shared TB support packages/models/scoreboards.
3. No individual test top by default.

Each script appends the selected testbench file and sets the desired top. This prevents multiple TB top modules from running in one compile.

## Naming And Reset Check

Current lightweight checks:

- Clocks use `clk_sys`, `clk_byte`, `clk_axi`, `clk_ddr`, `clk_wr`, or `clk_rd`.
- Resets use `rst_n`.
- Sequential RTL uses `always_ff @(posedge clk_*)` with active-low `if (!rst_n)` reset handling.
- Data movement interfaces use valid/ready naming except fixed external draft ports such as APB and AXI.
- Testbench-only modules remain outside `rtl/`.

## Boundary Conditions Covered

| Area | Boundary Conditions |
| --- | --- |
| FIFO | Empty, full, reset, ordering, backpressure. |
| Header ECC | Good header, error header, syndrome reporting. |
| Payload CRC | Start/finish, expected CRC arrival, mismatch. |
| Parser | Short packet fields, long packet payload start/end, ECC status. |
| Frame/line sync | Legal and illegal FS/FE/LS/LE sequences. |
| Lane path | Lane count 1/2/4, skewed valid/data timing. |
| Pixel repack | RAW8, RAW10, RGB888, YUV422 grouping and marker propagation. |
| Reliability | Error priority, context logging, resync/degrade state behavior. |
| PHY adapter | HS/LP gating, lane enable mask, and byte-lane extraction behavior. |
| Reg-if | APB control defaults, register decode, sticky status, and readback behavior. |
| AXI writer | Burst generation, WLAST, B response, done/error closure, line discard, wide-beat packing, and clear/flush recovery. |
| Preprocess | Saturation, signed contrast, bypass, output backpressure, adaptive frame stats, and coefficient generation. |
| System TB | FS/LS/long payload/LE/FE with 1/2/4 lane and RAW8/RGB888 smoke, plus dedicated real-top RAW8, RGB888, RAW10-pixel-path, YUV422, CRC, ECC, illegal-order, resync signal-chain, resync metrics, in-range/out-of-range lane-skew, repeated-error resync, AXI-backpressure, and metrics-oriented wrapper tests. |
| Top | Compile-level connectivity and clock-domain partition. |

## Current Gaps

- The real top now has dedicated wrapper-level RAW8, CRC, ECC, illegal-order sync, in-range/out-of-range lane-skew, resync signal-chain, repeated-error resync, and AXI backpressure tests, but still lacks throughput/result summarization coverage.
- Top-level AXI write path is minimally closed, but still lacks the final
  bandwidth-efficient line/frame buffer architecture.
- Payload CRC is integrated into the top-level packet flow and now has a dedicated wrapper-level negative test, but mixed packet and recovery scenarios are still not covered.
- The wrapper boot sequencer currently leaves `cfg_capture_enable` low for debug-only bring-up, so write-path wrapper tests explicitly force capture enable before observing AXI-side behavior.
- The repeated-error resync case uses a testbench force on `sync_error` during `resync_busy` so the recovery-period fault condition is stable and reproducible without changing DUT RTL.
- The wrapper boot sequencer also defaults `cfg_dt_code` to RAW8, so RGB888 wrapper tests explicitly force `cfg_dt_code=0x24` to exercise the real-top RGB888 path without changing DUT RTL.
- The wrapper boot sequencer defaults `cfg_dt_code` away from RAW10 as well, so RAW10 wrapper tests explicitly force `cfg_dt_code=0x2b` to exercise the real-top RAW10 path without changing DUT RTL.
- The wrapper boot sequencer defaults `cfg_dt_code` away from YUV422 as well, so YUV422 wrapper tests explicitly force `cfg_dt_code=0x1e` to exercise the real-top YUV422 path without changing DUT RTL.
- Current RAW10 wrapper coverage proves pixel-path correctness and timing, but `LE/FE` closure after the odd-byte long-packet trailer still needs follow-up investigation.
- Metrics-oriented wrapper tests currently provide fixed-scenario cycle counts; they are suitable for thesis tables but not yet a full parameter sweep.
- Vivado synth/impl is not part of regression until FPGA part and real XDC pin constraints are selected.
- No randomized constrained regression is included yet.

## Recommended Run Order

1. Run smoke after local edits:

```sh
./sim/vcs/run_smoke.sh
```

2. Run full regression before milestone handoff:

```sh
./sim/vcs/run_regression.sh
```

3. Run Vivado Tcl/XDC syntax checks before FPGA handoff:

```sh
tclsh <<'EOF'
foreach f {fpga/vivado/create_project.tcl fpga/vivado/run_synth_impl.tcl fpga/xdc/top_constraints.xdc} {
    set fp [open $f r]
    set data [read $fp]
    close $fp
    if {![info complete $data]} {
        puts "FAIL: $f"
        exit 1
    }
    puts "PASS: $f"
}
EOF
```

## Follow-Up Polish

- Add a dedicated `tb/top/tb_mipi_csi2_capture_top_real.sv` that instantiates `rtl/top/mipi_csi2_capture_top.sv`.
- Add recovery-after-resync clean-frame and throughput/result summarization tests.
- Add regression result summarization in machine-readable form.
- Add formal or lint-specific checks once tool choice is finalized.
