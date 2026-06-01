# Buffer Depth Sweep Results

## Purpose

本文件用于留痕 `BYTE FIFO` 深度、`AXI writer FIFO` 深度与 AXI 背压释放延迟之间的系统级关系，服务论文中的缓存需求分析与工程中的深度选型判断。

## Sweep Matrix

- `BYTE_FIFO_ADDR_WIDTH ∈ {2, 3, 4}`
- `AXI_FIFO_ADDR_WIDTH ∈ {3, 4, 6}`
- `AXI_STALL_CYCLES ∈ {6, 16}`
- `AXI_DATA_WIDTH = 128`
- Traffic: `RAW8`, `LANE_NUM=2`, `PIXEL_COUNT=16`

## Result Table

| byte fifo aw | axi fifo aw | stall cycles | exp | act | max byte fifo | max axi fifo | lane bp cycles | pixel stall cycles | aw stall cycles | w stall cycles | axi busy duration |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2 | 3 | 6 | 16 | 16 | 3 | 4 | 0 | 0 | 6 | 6 | 4 |
| 2 | 3 | 16 | 16 | 16 | 3 | 4 | 0 | 0 | 16 | 16 | 4 |
| 2 | 4 | 6 | 16 | 16 | 3 | 4 | 0 | 0 | 6 | 6 | 4 |
| 2 | 4 | 16 | 16 | 16 | 3 | 4 | 0 | 0 | 16 | 16 | 4 |
| 2 | 6 | 6 | 16 | 16 | 3 | 4 | 0 | 0 | 6 | 6 | 4 |
| 2 | 6 | 16 | 16 | 16 | 3 | 4 | 0 | 0 | 16 | 16 | 4 |
| 3 | 3 | 6 | 16 | 16 | 7 | 4 | 0 | 0 | 6 | 6 | 4 |
| 3 | 3 | 16 | 16 | 16 | 7 | 4 | 0 | 0 | 16 | 16 | 4 |
| 3 | 4 | 6 | 16 | 16 | 7 | 4 | 0 | 0 | 6 | 6 | 4 |
| 3 | 4 | 16 | 16 | 16 | 7 | 4 | 0 | 0 | 16 | 16 | 4 |
| 3 | 6 | 6 | 16 | 16 | 7 | 4 | 0 | 0 | 6 | 6 | 4 |
| 3 | 6 | 16 | 16 | 16 | 7 | 4 | 0 | 0 | 16 | 16 | 4 |
| 4 | 3 | 6 | 16 | 16 | 10 | 4 | 0 | 0 | 6 | 6 | 4 |
| 4 | 3 | 16 | 16 | 16 | 10 | 4 | 0 | 0 | 16 | 16 | 4 |
| 4 | 4 | 6 | 16 | 16 | 10 | 4 | 0 | 0 | 6 | 6 | 4 |
| 4 | 4 | 16 | 16 | 16 | 10 | 4 | 0 | 0 | 16 | 16 | 4 |
| 4 | 6 | 6 | 16 | 16 | 10 | 4 | 0 | 0 | 6 | 6 | 4 |
| 4 | 6 | 16 | 16 | 16 | 10 | 4 | 0 | 0 | 16 | 16 | 4 |

## Notes

- `byte fifo aw` 表示 `BYTE_FIFO_ADDR_WIDTH`，对应 byte-to-sys async FIFO 深度 `2^aw`。
- `axi fifo aw` 表示 `AXI writer` 内部 data FIFO 深度 `2^aw`。
- `lane bp cycles` 表示 sensor 侧观测到 `lane_ready` 被拉低的周期数。
- `pixel stall cycles` 表示像素输出侧因 writer 背压导致 `pixel_valid && !pixel_ready` 的周期数。
- `axi busy duration` 表示 `axi_busy` 从拉高到释放的 AXI 域持续周期数。
- 当前 sweep 先固定在稳定可复现的 `16-pixel` 单行样例，用于比较 buffer 占用与背压传播基础趋势，而不是最终吞吐上限。
