# System-Level Testbench Notes

## Scope

This stage builds a runnable system-level testbench skeleton. It does not add top integration RTL, AXI wiring, preprocess chaining, or Vivado scripts.

For regression execution and test grouping, see `docs/spec/regression_plan.md`.

The current minimum scenario verifies a single CSI-2 style capture flow:

1. Short packet FS.
2. Short packet LS.
3. One long packet carrying RAW8 payload bytes.
4. Short packet LE.
5. Short packet FE.
6. Frame-level pixel comparison in the scoreboard.

## Generated Files

| File | Role |
| --- | --- |
| `tb/models/sensor_model.sv` | Generates FS/FE/LS/LE short packets, one long packet payload, lane byte streams, expected pixels, and basic error injection hooks. |
| `tb/refs/csi2_reference_helpers.sv` | Provides shared CSI-2 constants, header ECC packing, packet byte extraction, payload bytes, and expected pixel conversion helpers. |
| `tb/scoreboard/scoreboard.sv` | Stores expected pixels and compares actual pixels in arrival order with SOF/SOL marker checks. |
| `tb/top/tb_mipi_csi2_capture_top.sv` | Instantiates the minimum system TB chain and runs the RAW8 smoke scenario. |

## Testbench Connection

```text
sensor_model short headers
  -> csi2_short_packet_parser
  -> frame_line_sync_fsm
  -> frame/line marker pulses

sensor_model lane byte stream
  -> lane_deskew_buffer
  -> lane_reorder_merge
  -> csi2_long_packet_parser
  -> raw8_unpack or rgb888_unpack
  -> scoreboard actual stream

sensor_model expected pixel stream
  -> scoreboard expected stream
```

All DUT-facing interfaces use the existing synchronous `clk_sys` or `clk_byte` style with active-low `rst_n`. The TB keeps DUT and verification model logic separate.

## Minimum Runnable Scenario

The checked smoke scenario uses:

| Item | Value |
| --- | --- |
| Lane count | 2 |
| Virtual channel | 0 |
| Data type | RAW8 |
| Frame count | 1 |
| Line count | 1 |
| Payload bytes | `11 22 33 44` |
| Expected pixels | `000011 000022 000033 000044` |

The TB waits for sensor completion, long-packet completion, and matching expected/actual pixel counts. It then pulses `finish_i` on the scoreboard and checks pass/fail plus sticky error flags.

## RAW8 / RGB888 Support

The model helper package defines both `CSI2_DT_RAW8` and `CSI2_DT_RGB888`. The top-level TB selects the unpacker path with the `DATA_TYPE` parameter. The default run selects RAW8; overriding `DATA_TYPE` to `6'h24` exercises the RGB888 payload pattern and expected pixel generation path.

The top TB exposes these scenario parameters:

| Parameter | Default | Notes |
| --- | --- | --- |
| `LANE_NUM` | 2 | Intended values are 1, 2, and 4. |
| `DESKEW_DEPTH` | 16 | Gives the smoke TB enough buffering for 1-lane and RGB888 long-packet variants. |
| `DATA_TYPE` | `CSI2_DT_RAW8` | Use `6'h2a` for RAW8 or `6'h24` for RGB888. |
| `VC_ID` | 0 | Virtual channel used in short and long packet headers. |

## Error Injection Hooks

`sensor_model` exposes:

| Signal | Effect |
| --- | --- |
| `inject_header_ecc_error_i` | Flips one ECC bit when packing short and long packet headers. |
| `inject_payload_error_i` | Flips one payload bit in the first long-packet payload byte. |

The current smoke test keeps both disabled. Future negative scenarios can enable these hooks and check that the parser, scoreboard, and reliability monitors report the expected failures.

## Scoreboard Strategy

The scoreboard is intentionally simple for this stage:

1. Accept expected pixels into a fixed-size memory.
2. Accept actual pixels from the selected unpacker.
3. Compare actual data, SOF, and SOL against the expected entry at the same sequence index.
4. Count actual SOF markers as received frames.
5. Report PASS only when finish is requested, expected and actual counts match, at least one pixel was checked, and no mismatches were recorded.

This provides a stable smoke-test base before adding randomized frame dimensions, multiple lines, backpressure variation, and negative error-injection cases.

## Boundary Conditions

- `MAX_PIXELS` must be sized larger than the expected frame payload in the scenario.
- The smoke scenario uses one line and one long packet; multi-line traffic should extend the model schedule rather than changing DUT interfaces.
- Lane count is parameterized for 1/2/4 lanes. The default executable scenario is 2-lane RAW8.
- The TB checks that no sync, deskew overflow, or long-header ECC error is observed during the positive smoke scenario.
