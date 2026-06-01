# AXI Writer Notes

## Scope
This phase implements AXI write-path building blocks only:
- `axi_write_master`
- `axi_burst_gen`
- `addr_gen_frame_based`
- `mem_map_ctrl`
- `pixel_to_axi_writer`

AXI read path, preprocessing, system testbench, and top-level integration are intentionally not implemented in this phase.

## Pixel-To-AXI Writer

`pixel_to_axi_writer` is the current minimum bridge that closes the top-level
pixel-to-DDR write path without introducing a full frame buffer subsystem yet.

Behavior:

- Accepts the final 24-bit pixel stream in `clk_sys`.
- Packs each pixel into one padded 32-bit slot: `{8'h00, pixel_data[23:0]}`.
- When `DATA_WIDTH > 32`, multiple padded pixel slots are packed into one wider
  AXI beat before crossing into `clk_axi`.
- Buffers pixel beats through an async FIFO from `clk_sys` to `clk_axi`.
- Uses `line_end_i` to emit one line write command after a full line has been buffered.
- Computes the line address with `addr_gen_frame_based`.
- Streams buffered data through `axi_write_master`.
- Supports `clear_i` so recovery logic can flush pending sys-side packing state,
  queued line commands, and queued data after any in-flight AXI burst completes.

Current assumptions and limits:

- One pixel still maps to one padded 32-bit slot, so payload packing efficiency
  is tied to `DATA_WIDTH / 32`.
- Write command length is based on actual accepted pixels in the line.
- Line index resets on `frame_start_i`.
- Configuration is sampled into the AXI domain as a stable control bus and
  should only be changed while capture is idle.
- `discard_line_i` can mark the current line as a drop command, causing the
  buffered line beats to be drained without issuing AXI AW/W/B traffic.
- `clear_i` blocks new sys-side pixels, waits for AXI to go safe, then clears
  both async FIFOs so recovery does not leak stale packed beats into the next frame.
- This is a minimum closure path, not the final optimized frame-buffer design.

## AXI Write Master

### Command Interface
| Signal | Direction | Description |
|---|---:|---|
| `cmd_valid_i` | input | Write command valid |
| `cmd_ready_o` | output | Command accepted |
| `cmd_addr_i` | input | Start byte address |
| `cmd_byte_len_i` | input | Transfer size in bytes |
| `cfg_max_burst_len_i` | input | Maximum beats per burst; zero selects module default |

### Data Stream Interface
| Signal | Direction | Description |
|---|---:|---|
| `wr_valid_i` | input | Write data beat valid |
| `wr_ready_o` | output | Write data beat accepted |
| `wr_data_i` | input | Write data beat |
| `wr_strb_i` | input | Write byte strobes |

### AXI Interface
Only AXI write channels are implemented:
- AW: address, length, size, burst, valid, ready
- W: data, strobe, last, valid, ready
- B: response, valid, ready

## State Machine
| State | Description |
|---|---|
| `ST_IDLE` | Wait for the next generated burst |
| `ST_AW` | Issue AXI write address |
| `ST_W` | Stream data beats and assert `WLAST` on the final beat |
| `ST_B` | Wait for write response and emit `done_o` after final burst |

## Burst Generation
`axi_burst_gen` splits a total beat count into bursts no larger than `cfg_max_burst_len_i` or `MAX_BURST_LEN`.

For a 32-bit data bus:
- 4 bytes per beat
- A 24-byte command is 6 beats
- With max burst length 4, bursts are 4 beats then 2 beats

For a 128-bit data bus:
- 16 bytes per beat
- 4 padded pixels fit in one beat
- A 24-byte command becomes 2 beats with the final beat partially strobed

## Frame-Based Address Generation
`addr_gen_frame_based` computes:

```text
addr = frame_base_addr + line_id * line_stride + byte_offset
```

This supports frame base address plus line stride without tying the module to a top-level frame scheduler.

## Memory Map Control
`mem_map_ctrl` stores AXI writer configuration fields:
- frame base address
- line stride
- line byte count
- frame height
- max burst length

It is a lightweight configuration holder, not an APB or AXI-Lite slave.

## Boundary Conditions
- `cmd_byte_len_i` is rounded up to full data beats.
- The data producer must provide enough beats for the accepted command.
- Partial final beats are represented through `wr_strb_i`.
- Counters and addresses naturally wrap at their signal width.
- Outstanding write depth is one burst; the next burst waits until the current B response.

## Self-Check Method
- `tb_axi_write_master.sv` verifies burst splitting, AW/W backpressure, `WLAST`, B response completion, and memory contents.
- `tb_addr_gen_frame_based.sv` verifies config storage, line stride address calculation, and output backpressure.
- `tb_pixel_to_axi_writer.sv` now verifies:
  - normal line write
  - discard-line drain behavior
  - 128-bit packed-beat write behavior
  - `clear_i` recovery flush behavior
