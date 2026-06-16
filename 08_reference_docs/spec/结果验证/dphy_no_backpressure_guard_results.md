# D-PHY No-Backpressure Guard Results

## Purpose

固化 D-PHY PPI 入口在真实 `rxreadyhs` 不存在时的保护策略：当 byte/sys 路径无法继续接收连续 PPI byte stream，当前受损帧应被丢弃，后续 clean frame 能重新同步并输出像素。

## Testbench

- `tb/tests/tb_mipi_csi2_capture_dphy_no_backpressure_guard.sv`

## Scenario

1. 使用 `mipi_csi2_capture_dphy_wrapper`，`LANE_NUM=2`、`RAW8`。
2. 强制 `fifo_rd_ready=0`，同时通过 `rxbyteclkhs` 和 `dl0/1_*` 连续灌入一个超长 HS burst。
3. 释放读端后确认 stale frame 不产生 frame/pixel 输出。
4. 再发送一帧 clean RAW8：`FS -> LS -> RAW8 -> LE -> FE`。

## Fresh Run Result

关键输出：

```text
PASS: tb_mipi_csi2_capture_dphy_no_backpressure_guard exp=4 act=4 frames=1 max_fifo=63 lane_ready_low=1
```

## Conclusion

- D-PHY wrapper 的 no-backpressure guard 能阻止已损坏帧继续进入像素闭环。
- clean RAW8 frame 可在后续 FS 后恢复，scoreboard `exp=4 act=4 mismatch=0`。
- D-PHY guard 路径不会把 downstream byte backpressure 衍生的 lane overflow 送入 lane degradation。

## Notes

- 该保护只在 `mipi_csi2_capture_dphy_wrapper` 默认启用；普通 FPGA wrapper 默认保持 ready/valid 可回压语义。
- 测试使用较大的 byte FIFO 工作点，避免把正常 clean frame 的 parser 延迟误判为工程拥塞。
