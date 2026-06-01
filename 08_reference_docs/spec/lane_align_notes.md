# Lane Align Notes

## Scope
This phase adds lane alignment and merge building blocks only:
- `lane_deskew_buffer`
- `lane_reorder_merge`

Parser, AXI, preprocess, and top-level integration are intentionally not implemented in this phase.

## lane_deskew_buffer

### Interface
| Signal | Direction | Description |
|---|---:|---|
| `clk_byte` | input | Byte receive clock |
| `rst_n` | input | Active-low synchronous reset |
| `lane_valid_i[LANE_NUM-1:0]` | input | Per-lane byte valid |
| `lane_ready_o[LANE_NUM-1:0]` | output | Per-lane buffer can accept byte |
| `lane_data_i[LANE_NUM-1:0][7:0]` | input | Per-lane byte data |
| `deskew_valid_o` | output | All lanes have one aligned byte available |
| `deskew_ready_i` | input | Downstream accepts aligned lane group |
| `deskew_data_o[LANE_NUM-1:0][7:0]` | output | Aligned lane byte group |
| `err_overflow_o` | output | One-cycle pulse when a lane writes while full |

### Behavior
- `LANE_NUM` supports 1, 2, or 4 active lanes.
- Each lane has an independent FIFO of `DESKEW_DEPTH` bytes.
- The module outputs one group only when every lane has at least one byte.
- Output order inside the group is lane index order.
- `err_overflow_o` marks input data that could not be accepted.

## lane_reorder_merge

### Interface
| Signal | Direction | Description |
|---|---:|---|
| `clk_byte` | input | Byte receive clock |
| `rst_n` | input | Active-low synchronous reset |
| `lane_group_valid_i` | input | Aligned lane group valid |
| `lane_group_ready_o` | output | Merge block can accept a group |
| `lane_group_data_i[LANE_NUM-1:0][7:0]` | input | Aligned lane bytes |
| `byte_valid_o` | output | Merged byte stream valid |
| `byte_ready_i` | input | Downstream accepts merged byte |
| `byte_data_o[7:0]` | output | Merged byte data |
| `group_done_o` | output | Last byte of current lane group is accepted |

### Behavior
- A group is emitted in lane order: lane0, lane1, lane2, lane3.
- `byte_data_o` stays stable while `byte_valid_o && !byte_ready_i`.
- The block accepts the next group after the current group is fully emitted.

## Boundary Conditions
- Input lanes are assumed to belong to the same packet stream.
- Deskew depth must cover lane arrival skew; otherwise overflow is reported.
- These blocks do not detect SoT/EoT or packet type.
- These blocks do not implement lane polarity, byte sync, or physical D-PHY logic.

## Self-Check Method
- `tb_lane_deskew_buffer.sv` covers 1/2/4 lane operation, delayed lane arrivals, output backpressure, and overflow.
- `tb_lane_reorder_merge.sv` covers 1/2/4 lane merge order, group completion, continuous groups, and output backpressure.
