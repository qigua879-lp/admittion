# Parser Notes

## Scope
This phase adds CSI-2 packet parser building blocks:
- `csi2_short_packet_parser`
- `csi2_long_packet_parser`
- `frame_line_sync_fsm`

Lane alignment, AXI writing, and preprocessing are intentionally not implemented in this phase.

## CSI-2 Header Packing
The local parser header packing is:

| Bits | Field |
|---:|---|
| `[5:0]` | Data Type |
| `[7:6]` | Virtual Channel |
| `[15:8]` | Word Count or short packet data byte 0 |
| `[23:16]` | Word Count or short packet data byte 1 |
| `[29:24]` | Header ECC |
| `[31:30]` | Reserved |

For byte-stream inputs, bytes arrive as Data ID, WC low byte, WC high byte, ECC byte.

## Short Packet Parser

### Responsibilities
- Accept one packed 32-bit short packet header.
- Parse VC, DT, and the 16-bit word count or short packet data field.
- Reuse `csi2_header_ecc_checker`.
- Report `ecc_ok`, `ecc_correctable`, and `ecc_syndrome`.

### State Machine
| State | Description |
|---|---|
| `ST_IDLE` | Accept a packed header |
| `ST_ECC_REQ` | Send header into ECC checker |
| `ST_WAIT_ECC` | Wait for ECC result |
| `ST_HOLD` | Hold parsed packet until accepted |

## Long Packet Parser

### Responsibilities
- Accept a CSI-2 byte stream.
- Collect and parse the four header bytes.
- Reuse `csi2_header_ecc_checker`.
- Output parsed header fields through `hdr_valid/hdr_ready`.
- Stream exactly `word_count` payload bytes.
- Assert `payload_start` on the first payload byte and `payload_end` on the last payload byte.

### State Machine
| State | Description |
|---|---|
| `ST_HDR0` | Accept Data ID byte |
| `ST_HDR1` | Accept WC low byte |
| `ST_HDR2` | Accept WC high byte |
| `ST_HDR3` | Accept ECC byte |
| `ST_ECC_REQ` | Send header into ECC checker |
| `ST_WAIT_ECC` | Wait for ECC result |
| `ST_HDR_OUT` | Hold parsed header until accepted |
| `ST_PAYLOAD` | Stream payload bytes |

## Frame/Line Sync FSM

### Recognized Short Packet Data Types
| Data Type | Meaning |
|---:|---|
| `6'h00` | Frame Start |
| `6'h01` | Frame End |
| `6'h02` | Line Start |
| `6'h03` | Line End |

### Policy
- FS opens a frame and emits `frame_start`.
- FE closes a frame and emits `frame_end` when a frame is active.
- LS opens a line only inside an active frame.
- LE closes a line only when both frame and line are active.
- Invalid ordering emits a one-cycle `sync_error`.

## Boundary Conditions
- Short parser does not correct header data; it only reports ECC status.
- Long parser handles `word_count == 0` by producing no payload and asserting `packet_done`.
- Long parser stalls byte input while header ECC and header output handshakes complete.
- `payload_start` and `payload_end` are valid-qualified sideband signals.
- Frame/line counters saturating behavior is not implemented yet; counters naturally wrap.

## Self-Check Method
- `tb_short_packet_parser.sv` checks VC, DT, word count, ECC pass/fail, and output backpressure.
- `tb_long_packet_parser.sv` checks header parsing, payload boundaries, zero-length payloads, ECC failure marking, and payload backpressure.
- `tb_frame_line_sync.sv` checks normal FS/LS/LE/FE sequencing and abnormal event ordering.

## Known Limitations
- Parsers assume input is already lane-aligned and byte-ordered.
- Long parser does not consume or check payload CRC in this phase.
- Long parser has no timeout for missing payload bytes.
- Frame/line sync currently tracks one active VC context.
