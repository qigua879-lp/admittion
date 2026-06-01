# Common Blocks Notes

## Scope
This phase adds reusable common blocks only:
- `async_fifo`
- `csi2_header_ecc_checker`
- `csi2_payload_crc_checker`

Parser, lane alignment, AXI writing, and preprocessing are intentionally not implemented in this phase.

## async_fifo

### Interface
| Signal | Direction | Description |
|---|---:|---|
| `clk_wr` | input | Write clock domain |
| `clk_rd` | input | Read clock domain |
| `rst_n` | input | Active-low synchronous reset sampled in both domains |
| `wr_valid` | input | Write request valid |
| `wr_ready` | output | FIFO can accept a write |
| `wr_data` | input | Write payload |
| `rd_valid` | output | Read payload valid |
| `rd_ready` | input | Read side accepts payload |
| `rd_data` | output | Read payload |
| `full` | output | Write-domain full indicator |
| `empty` | output | Read-domain empty indicator |
| `wr_level` | output | Write-domain approximate fill level |
| `rd_level` | output | Read-domain approximate fill level |

### Boundary Conditions
- FIFO depth is `2**ADDR_WIDTH`.
- `ADDR_WIDTH` must be at least 1.
- Writes are ignored when `wr_ready` is low.
- Reads occur only when `rd_valid && rd_ready`.
- `wr_level` and `rd_level` are clock-domain local estimates after pointer synchronization latency.

### Self-Check
`tb_async_fifo.sv` covers reset-empty, single write/read, order preservation, full behavior, empty behavior, and backpressure with unrelated clocks.

## csi2_header_ecc_checker

### Interface
| Signal | Direction | Description |
|---|---:|---|
| `clk_sys` | input | System clock |
| `rst_n` | input | Active-low synchronous reset |
| `hdr_valid` | input | Header input valid |
| `hdr_ready` | output | Checker can accept a header |
| `hdr_data[23:0]` | input | CSI-2 packet header bytes packed into 24 bits |
| `hdr_ecc[5:0]` | input | Received CSI-2 header ECC |
| `ecc_valid` | output | Result valid |
| `ecc_ready` | input | Result accepted |
| `ecc_calc[5:0]` | output | Calculated ECC |
| `ecc_syndrome[5:0]` | output | `ecc_calc ^ hdr_ecc` |
| `ecc_error` | output | Non-zero syndrome |
| `ecc_correctable` | output | Syndrome matches a single-bit header/ECC error pattern |

### Boundary Conditions
- This module detects and classifies ECC syndrome only.
- It does not modify or correct `hdr_data`.
- Output fields remain stable while `ecc_valid && !ecc_ready`.

### Self-Check
`tb_header_ecc.sv` covers zero header, known single-bit header patterns, deterministic headers, single-bit ECC injection, single-bit header injection, and output backpressure.

## csi2_payload_crc_checker

### Interface
| Signal | Direction | Description |
|---|---:|---|
| `clk_sys` | input | System clock |
| `rst_n` | input | Active-low synchronous reset |
| `crc_start` | input | Start a new payload CRC calculation |
| `crc_clear` | input | Clear checker state |
| `crc_finish` | input | Finish a zero-length or externally terminated payload |
| `payload_valid` | input | Payload byte valid |
| `payload_ready` | output | Checker can accept a payload byte |
| `payload_data[7:0]` | input | Payload byte |
| `payload_last` | input | Last byte of payload, included in CRC |
| `expected_crc_valid` | input | Expected CRC valid |
| `expected_crc_ready` | output | Checker can accept expected CRC |
| `expected_crc[15:0]` | input | Expected final CRC value |
| `crc_valid` | output | CRC compare result valid |
| `crc_ready` | input | CRC compare result accepted |
| `crc_calc[15:0]` | output | Calculated CRC |
| `crc_error` | output | Calculated CRC differs from expected CRC |

### CRC Convention
- Initial value is `16'hffff`.
- Polynomial is `x^16 + x^12 + x^5 + 1`.
- The byte update is LSB-first, using the reflected polynomial `16'h8408`.
- `expected_crc[15:0]` is compared against the internal final CRC state.

### Boundary Conditions
- `payload_last` finalizes the CRC after accepting that byte.
- `crc_finish` finalizes without accepting a byte and supports zero-length payloads.
- Expected CRC may arrive before or after payload completion.
- `crc_start` starts a new calculation and clears any previous result.

### Self-Check
`tb_payload_crc.sv` covers empty payload, the known `"123456789"` vector, CRC error injection, expected-CRC-before-payload ordering, and clear/restart behavior.
