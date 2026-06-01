# RAW8 Backpressure Stress Results

## Purpose

本文件用于留痕 `RAW8` 在真实 wrapper 路径下的连续流背压压力扫描，目标是回答两个工程问题：

- 在可稳定通过的工作点里，AXI 背压是否已经传播到 `lane_ready`。
- 在进一步收紧 `AXI writer FIFO` 后，系统会在哪类工作点进入失稳边界。

## Sweep Matrix

- Fixed traffic: `RAW8`, `LANE_NUM=2`, `BYTE_FIFO_ADDR_WIDTH=2`, `AXI_DATA_WIDTH=128`
- Variable knobs: `AXI_FIFO_ADDR_WIDTH`, `AXI_STALL_CYCLES`, `FRAME_COUNT`, `LINE_COUNT`
- Stress method: for each observed AXI `AWVALID/WVALID`, keep `AWREADY/WREADY` low for a fixed number of AXI cycles before release

## Result Table

| case | status | axi fifo aw | stall cycles | frames | lines/frame | total lines | exp | act | pixel stall seen | pixel stall cycles | lane bp seen | lane bp cycles | max byte fifo | max axi fifo | note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| stable_s12_f4_l4 | PASS | 3 | 12 | 4 | 4 | 16 | 64 | 64 | 0 | 0 | 1 | 256 | 3 | 2 | scoreboard pass |
| stable_s16_f6_l4 | PASS | 3 | 16 | 6 | 4 | 24 | 96 | 96 | 0 | 0 | 1 | 416 | 3 | 6 | scoreboard pass |
| stable_s16_f8_l4 | PASS | 3 | 16 | 8 | 4 | 32 | 128 | 128 | 0 | 0 | 1 | 576 | 3 | 7 | scoreboard pass |
| stable_s24_f4_l4 | PASS | 3 | 24 | 4 | 4 | 16 | 64 | 64 | 0 | 0 | 1 | 256 | 3 | 7 | scoreboard pass |
| limit_s16_f6_l4_axi2 | FAIL | 2 | 16 | 6 | 4 | 24 | 96 | 29336 |  |  |  |  |  |  | FAIL: raw8 backpressure stress timeout cfg=1 fs=1 fe=1 awstall=1 wstall=1 pixel_stall=1 lane_bp=1 exp=96 act=29336 mismatch=29246 |

## Conclusions

- 在 `AXI_FIFO_ADDR_WIDTH=3` 的稳定通过区间内，`lane_bp_seen` 已稳定为 `1`，说明持续 AXI 背压会传回 sensor/lane 入口。
- 同一稳定区间内，`pixel_stall_seen` 仍保持 `0`，说明当前主路径在进入像素级停顿前，先依赖上游 lane 节流吸收压力。
- `max_axi_fifo` 会随压力工作点增强而升高，稳定通过样例中已达到 `7`，明显高于基础单帧扫描。
- 当 `AXI_FIFO_ADDR_WIDTH` 进一步收紧到 `2`，并叠加 `stall=16`, `6x4` 连续流时，scoreboard 失配并超时，说明该配置已进入当前实现的失稳边界，不适合作为论文主结果工作点。

## Engineering Interpretation

- 当前系统已具备“先 lane 节流、后像素停顿”的缓冲吸压特征，这对工程原型是积极信号。
- 但极端浅 `AXI writer FIFO` 下仍存在失稳边界，因此若面向工程集成，`AXI_FIFO_ADDR_WIDTH=3` 可作为当前更稳妥的最小建议值，`AXI_FIFO_ADDR_WIDTH=2` 需要进一步专项排查后再使用。
