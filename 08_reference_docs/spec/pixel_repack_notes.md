# Pixel Repack Notes

## Scope
This phase adds payload-byte to pixel-stream unpackers:
- `raw8_unpack`
- `rgb888_unpack`
- `raw10_unpack`
- `yuv422_unpack`

AXI writing, preprocessing, and top-level integration are intentionally not implemented in this phase.

## Common Interface
| Signal | Direction | Description |
|---|---:|---|
| `clk_sys` | input | System clock |
| `rst_n` | input | Active-low synchronous reset |
| `payload_valid_i` | input | Payload byte valid |
| `payload_ready_o` | output | Unpacker can accept payload byte |
| `payload_data_i[7:0]` | input | Payload byte |
| `payload_sof_i` | input | Start-of-frame marker on the byte that starts a pixel group |
| `payload_sol_i` | input | Start-of-line marker on the byte that starts a pixel group |
| `pixel_valid_o` | output | Output pixel valid |
| `pixel_ready_i` | input | Downstream accepts pixel |
| `pixel_data_o[23:0]` | output | Unified pixel data |
| `pixel_sof_o` | output | Start-of-frame marker on output pixel |
| `pixel_sol_o` | output | Start-of-line marker on output pixel |

## RAW8
- One payload byte produces one pixel.
- Output format is `{16'd0, raw8[7:0]}`.
- SOF/SOL markers pass through with the same byte.

## RGB888
- Three payload bytes produce one pixel.
- Byte order is R, G, B.
- Output format is `{R[7:0], G[7:0], B[7:0]}`.
- SOF/SOL markers are captured from the R byte.

## RAW10
- Five payload bytes produce four 10-bit pixels.
- Byte order follows the common CSI-2 RAW10 packing:
  - `byte0 = P0[9:2]`
  - `byte1 = P1[9:2]`
  - `byte2 = P2[9:2]`
  - `byte3 = P3[9:2]`
  - `byte4[1:0] = P0[1:0]`
  - `byte4[3:2] = P1[1:0]`
  - `byte4[5:4] = P2[1:0]`
  - `byte4[7:6] = P3[1:0]`
- Output format is `{14'd0, raw10[9:0]}` for each pixel.
- SOF/SOL markers are attached to P0 only.

## YUV422
- Four payload bytes produce two pixels.
- Byte order is U0, Y0, V0, Y1.
- Output pixel 0 is `{Y0, U0, V0}`.
- Output pixel 1 is `{Y1, U0, V0}`.
- SOF/SOL markers are attached to pixel 0 only.

## Boundary Conditions
- Incomplete pixel groups are held internally until enough bytes arrive.
- Unpackers stall payload input while buffered output pixels are waiting.
- Backpressure preserves `pixel_data_o`, `pixel_sof_o`, and `pixel_sol_o`.
- Counter or frame-size validation is not implemented in these unpackers.

## Self-Check Method
- `tb_raw8_unpack.sv` covers byte-to-pixel mapping, marker pass-through, and backpressure.
- `tb_rgb888_unpack.sv` covers 3-byte assembly, marker capture from first byte, continuous pixels, and backpressure.
- `tb_raw10_unpack.sv` covers 5-byte to 4-pixel unpacking, low-bit stitching, marker behavior, and backpressure.
- `tb_yuv422_unpack.sv` covers UYVY to two YUV pixels, marker behavior, continuous groups, and backpressure.
