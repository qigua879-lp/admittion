# 正式波形

本目录保存使用 `Vivado 2017.3 xsim` 正式导出的论文波形图。

## 当前波形图

1. `01_raw8_main_path_xsim.png`
   - 对应：`tb_fpga_wrapper_raw8_smoke`
   - 作用：展示 RAW8 主链路下 `frame/line/pixel` 的基本闭合
   - 关键观察信号：
     - `frame_start_o`
     - `line_start_o`
     - `pixel_valid_o`
     - `pixel_sof_o`
     - `pixel_sol_o`
     - `line_end_o`
     - `frame_end_o`
   - 当前截图时间窗：
     - 运行到 `650 ns`
     - 重点观察 `500 ns` 之后的单帧闭合区域

2. `02_crc_error_xsim.png`
   - 对应：`tb_fpga_wrapper_crc_error`
   - 作用：展示 CRC 错误注入后 `err_crc_o` 与错误计数行为
   - 关键观察信号：
     - `pixel_valid_o`
     - `err_crc_o`
     - `err_cnt_crc_o`
     - `line_end_o`
   - 当前截图时间窗：
     - 运行到 `750 ns`
     - 重点观察后段 `err_cnt_crc_o` 从 `0 -> 1` 的变化

3. `03_ecc_error_xsim.png`
   - 对应：`tb_fpga_wrapper_ecc_error`
   - 作用：展示 header ECC 错误注入后 `err_ecc_o` 与错误计数行为
   - 关键观察信号：
     - `err_ecc_o`
     - `err_cnt_ecc_o`
     - `pixel_valid_o`
     - `line_end_o`
   - 当前截图时间窗：
     - 运行到 `500 ns`
     - 重点观察 ECC 错误脉冲和计数增量

4. `04_resync_recovery_xsim.png`
   - 对应：`tb_fpga_wrapper_resync_metrics`
   - 作用：展示 `err_sync -> resync_req -> resync_busy -> clear -> done` 恢复链
   - 关键观察信号：
     - `err_sync_o`
     - `resync_req`
     - `resync_busy`
     - `resync_clear_pulse_sys`
     - `resync_done_o`
   - 当前截图时间窗：
     - 运行到 `650 ns`
     - 重点观察恢复链在后段的连续触发关系

5. `05_lane_skew_overflow_xsim.png`
   - 对应：`tb_fpga_wrapper_lane_skew_overflow`
   - 作用：展示超界 lane skew 下的 backpressure 与 overflow
   - 关键观察信号：
     - `sensor_lane_valid[1:0]`
     - `sensor_lane_ready[1:0]`
     - `u_lane_deskew_buffer.err_overflow_o`
   - 当前截图时间窗：
     - 运行到 `330 ns`
     - 重点观察 `ready` 回压后出现 `overflow` 的区域

6. `06_axi_backpressure_xsim.png`
   - 对应：`tb_fpga_wrapper_axi_backpressure`
   - 作用：展示 AXI `AW/W` 背压时的握手与 `axi_busy` 行为
   - 关键观察信号：
     - `pixel_valid_o`
     - `axi_busy`
     - `m_axi_awvalid_o`
     - `m_axi_awready_i`
     - `m_axi_wvalid_o`
     - `m_axi_wready_i`
   - 当前截图时间窗：
     - 运行到 `900 ns`
     - 重点观察背压释放前后的握手变化

7. `07_resync_clean_frame_xsim.png`
   - 对应：`tb_fpga_wrapper_resync_clean_frame`
   - 作用：展示 `resync` 完成后，系统重新回到 clean frame 的 `frame/line/pixel` 输出路径
   - 关键观察信号：
     - `err_sync_o`
     - `resync_req`
     - `resync_busy`
     - `resync_clear_pulse_sys`
     - `resync_clear_pulse_byte`
     - `resync_done_o`
     - `frame_start_o`
     - `line_start_o`
     - `pixel_valid_o`
     - `line_end_o`
     - `frame_end_o`
   - 建议截图时间窗：
     - 运行到 `1550 ns`
     - 重点观察 `900 ns` 之后 clean frame 重新输出的区域

## 导出方式

当前使用两步法：

1. `fpga\vivado\build_one_xsim_snapshot.ps1`
2. `fpga\vivado\capture_one_xsim_wave.ps1`
3. `fpga\vivado\formal_wave_tcl\*.tcl`

说明：

- 使用 `Vivado 2017.3 xsim`
- 先 `xvlog/xelab` 建立 snapshot
- 再打开 `xsim GUI`
- 通过每张图单独的 Tcl 控制信号选择与关键时间窗
- 最后使用窗口级截图保存为 PNG
- `capture_one_xsim_wave.ps1` 现支持先将 `Wave` 面板单独最大化，再输出 PNG；正式波形优先使用该模式，避免源码编辑区占据截图主体
- GUI 波形截图必须串行执行，不能并行抓取

## 对应 Tcl

- `01_raw8_main_path_xsim.png`
  - `fpga/vivado/formal_wave_tcl/tb_fpga_wrapper_raw8_formal.tcl`
- `02_crc_error_xsim.png`
  - `fpga/vivado/formal_wave_tcl/tb_fpga_wrapper_crc_formal.tcl`
- `03_ecc_error_xsim.png`
  - `fpga/vivado/formal_wave_tcl/tb_fpga_wrapper_ecc_formal.tcl`
- `04_resync_recovery_xsim.png`
  - `fpga/vivado/formal_wave_tcl/tb_fpga_wrapper_resync_formal.tcl`
- `05_lane_skew_overflow_xsim.png`
  - `fpga/vivado/formal_wave_tcl/tb_fpga_wrapper_lane_skew_formal.tcl`
- `06_axi_backpressure_xsim.png`
  - `fpga/vivado/formal_wave_tcl/tb_fpga_wrapper_axi_backpressure_formal.tcl`
- `07_resync_clean_frame_xsim.png`
  - `fpga/vivado/formal_wave_tcl/tb_fpga_wrapper_resync_clean_frame_formal.tcl`

## 注意

- 这些图片是正式仿真软件窗口截图，不是后处理绘图。
- 为避免仓库路径中的空格影响 `xsim -tclbatch`，脚本会通过 `C:\mipi_all` junction 执行。
- 如果后续要重抓图片，优先复用本目录对应编号的 Tcl 配置，不要直接跑到测试结束帧再截图。
