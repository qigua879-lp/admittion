# Lane/Buffer Sensitivity Results

## Purpose

本文件用于留痕 `DESKEW_DEPTH / BYTE_FIFO / AXI_FIFO` 的联合敏感性扫描，目标是确认 lane skew 容忍窗口是否只由 deskew 深度主导，还是会被下游 buffer 深度显著改变。

## Sweep Matrix

- `DESKEW_DEPTH ∈ {2, 4, 6}`
- `BYTE_FIFO_ADDR_WIDTH ∈ {2, 4}`
- `AXI_FIFO_ADDR_WIDTH ∈ {3, 6}`
- Fixed traffic: `RAW8`, `LANE_NUM=2`, single-frame wrapper path
- For each case, `lead_bytes` scans from `0` to `DESKEW_DEPTH + 1`

## Result Table

| deskew depth | byte fifo aw | axi fifo aw | tolerant window | overflow at | ready_low cases |
| --- | --- | --- | --- | --- | --- |
| 2 | 2 | 3 | 0..2 | 3 | 0,2,3 |
| 2 | 2 | 6 | 0..2 | 3 | 0,2,3 |
| 2 | 4 | 3 | 0..2 | 3 | 0,2,3 |
| 2 | 4 | 6 | 0..2 | 3 | 0,2,3 |
| 4 | 2 | 3 | 0..4 | 5 | 0,4,5 |
| 4 | 2 | 6 | 0..4 | 5 | 0,4,5 |
| 4 | 4 | 3 | 0..4 | 5 | 0,4,5 |
| 4 | 4 | 6 | 0..4 | 5 | 0,4,5 |
| 6 | 2 | 3 | 0..6 | 7 | 0,6,7 |
| 6 | 2 | 6 | 0..6 | 7 | 0,6,7 |
| 6 | 4 | 3 | 0..6 | 7 | 6,7 |
| 6 | 4 | 6 | 0..6 | 7 | 6,7 |

## Conclusions

- 在当前测试矩阵内，所有组合都满足 `tolerant window = DESKEW_DEPTH`，`overflow at = DESKEW_DEPTH + 1`。
- 这说明当前真实 wrapper 路径下，lane skew 的主导约束仍然是 `lane_deskew_buffer` 自身深度，而不是 `BYTE FIFO` 或 `AXI writer FIFO` 的选值。
- `ready_low` 的出现位置会随工作点变化，但它并不改变容忍窗口结论，因此更适合被解释为瞬时回压现象，而不是越界判据。

## Engineering Interpretation

- 对工程选型而言，若目标是扩展 lane skew 容忍窗口，应优先调整 `DESKEW_DEPTH`，而不是指望增大后级 FIFO 深度来等效提升容忍能力。
- `BYTE FIFO / AXI FIFO` 更直接影响的是后续缓存吸压与吞吐边界；它们不会替代 deskew 结构本身的对齐上限。
