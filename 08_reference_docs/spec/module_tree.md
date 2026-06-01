# Module Tree

## Purpose
This document defines the planned RTL hierarchy for the MIPI CSI-2 digital capture front end. It is a development guide, not a complete implementation promise for the current phase.

## Top Level
```text
mipi_csi2_capture_top
|-- cfg_reg_if
|-- phy_digital_adapter
|-- csi2_rx_core
|   |-- lane_align_merge
|   |-- csi2_packet_parser
|   |-- csi2_header_ecc
|   |-- csi2_crc16
|   `-- frame_line_sync
|-- pixel_repack_core
|-- reliability_monitor
|-- buffer_cdc_subsys
|-- axi_ddr_writer
`-- preprocess_core
```

## Module Responsibilities

### mipi_csi2_capture_top
System integration wrapper. It keeps the external clock, reset, lane input, configuration, AXI write, debug, status, and pixel debug interface style stable.

### cfg_reg_if
Configuration and status register block. Early development uses a simple APB-style slave interface unless the top-level integration plan changes.

### phy_digital_adapter
Digital abstraction of the D-PHY-facing input. It consumes already-digital lane words, tracks HS/LP mode, detects sync conditions, and forwards byte-domain lane data.

### csi2_rx_core
CSI-2 protocol receive core. It owns lane alignment, packet parsing, ECC/CRC checking, and frame/line synchronization.

### pixel_repack_core
Pixel formatter. It converts CSI-2 payload bytes into a unified internal pixel stream and propagates frame/line markers.

### reliability_monitor
Error classification and recovery policy block. It records ECC, CRC, sync, and lane errors with frame/line context.

### buffer_cdc_subsys
Buffering and clock-domain crossing subsystem. It contains async FIFO and optional line-buffer logic.

### axi_ddr_writer
AXI write-path engine. It generates burst writes from buffered pixel data into DDR address regions.

### preprocess_core
Lightweight optional image preprocessing block. It must support bypass and stay behind the core receive path in priority.

## Development Order

### P0
- Documentation and skeleton
- Reusable testbench skeleton
- ECC/CRC reference logic
- CSI-2 short and long packet parser
- Frame and line sync
- Basic error counters and injection tests

### P1
- Lane deskew and merge
- RAW8 and RGB888 pixel repack
- Async FIFO and CDC
- Scoreboard coverage for pixel stream output

### P2
- RAW10 and YUV422 pixel repack
- Reliability monitor policies
- AXI DDR write path
- Error-driven drop, mark, resync, and degrade behavior

## Boundary Rules
- One module has one primary responsibility.
- Complex RTL must not be added during skeleton-only phases.
- Testbench code must stay outside `rtl/`.
- Top-level signal naming and clock-domain boundaries follow `AGENTS.md`.
