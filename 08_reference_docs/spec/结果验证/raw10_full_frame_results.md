# RAW10 Full-Frame Closure Results

## Purpose

本文件用于留痕 `RAW10` 在真实 `mipi_csi2_capture_fpga_wrapper` 路径下的 `FS/LS/payload/LE/FE` 完整闭环结果，补齐此前“只有 pixel-path、缺少 `LE/FE` 收尾闭环”的论文缺口。

## Tests

- `tb/tests/tb_fpga_wrapper_raw10_smoke.sv`
- `tb/tests/tb_fpga_wrapper_raw10_metrics.sv`

## Final PASS Results

`tb_fpga_wrapper_raw10_smoke`

```text
PASS: tb_fpga_wrapper_raw10_smoke exp=4 act=4 frames=1 full_frame=1
```

`tb_fpga_wrapper_raw10_metrics`

```text
PASS: tb_fpga_wrapper_raw10_metrics init_to_frame=16 frame_to_first_pixel=20 frame_to_end=38 first_to_last_pixel=3 pixel_valid_cycles=4 exp=4 act=4
```

## Key Conclusion

- `RAW10` 当前已不再只是 pixel-path only。
- 在真实 wrapper 路径下，`FS -> LS -> payload -> LE -> FE` 已完成完整闭环。
- 当前论文可将 `RAW10` 表述为 system-level full-frame closure。

## Testbench Note

- 当前 `LANE_NUM=2` wrapper 适配路径对尾部单字节存在残留现象。
- 为将 `FE` short packet 的最后一个 ECC 字节稳定推出，testbench 在 `FE` 后追加了一个 flush byte。
- 该处理只位于 testbench 激励层，不改变 DUT RTL，不改变 RAW10 像素值、frame/line 计数或错误处理逻辑。

## Thesis Wording Suggestion

- 可表述为：“RAW10 格式在真实 FPGA wrapper 集成路径下已完成系统级单帧闭环验证，能够正确输出像素数据，并正常产生 `LE/FE` 收尾事件。”
