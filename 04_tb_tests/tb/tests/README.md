# tb/tests

本目录保存模块级、wrapper 级和参数扫描类 SystemVerilog testbench。所有文件均为非综合验证代码，DUT 与 testbench 严格分离。

## 测试分类

| 分类 | 作用 | 典型判据 |
| --- | --- | --- |
| 模块级单元测试 | 验证单个 RTL 模块的接口、复位、握手、边界条件和错误响应。 | 关键输出、计数器、ready/valid、错误脉冲与期望一致，否则 `$fatal`。 |
| wrapper 系统测试 | 通过 `mipi_csi2_capture_fpga_wrapper` 验证真实顶层路径。 | frame/line/pixel/AXI/error 信号链闭合，scoreboard `mismatch=0`。 |
| 指标/扫描测试 | 采集时延、恢复、背压、FIFO 深度、lane skew 等量化指标。 | 打印 `RESULT:` 或 `PASS:` 行，结果归档到 `docs/spec/结果验证/`。 |

## Testbench 明细说明

| 文件 | 层级 | 主要测试对象 | 测试内容 | 通过/自检判据 |
| --- | --- | --- | --- | --- |
| `tb_cfg_reg_if_apb.sv` | 模块级 | `cfg_reg_if_apb` | APB 默认值、RW 字段、sticky clear、状态寄存器读回。 | APB readback 与期望一致，非法/清除行为符合寄存器定义。 |
| `tb_phy_digital_adapter.sv` | 模块级 | `phy_digital_adapter` | HS/LP gating、lane mask、1/2/4 lane 有效数据抽取。 | lane enable、lane valid、lane data 与配置和输入一致。 |
| `tb_mipi_dphy_ppi_adapter.sv` | 模块级 | `mipi_dphy_ppi_adapter` | AMD D-PHY RX PPI 字节、active/valid、stopstate、SoT error 到现有数字 lane 接口的整形。 | lane data/valid、HS/LP debug、sync/error mask 与 2 lane 配置一致。 |
| `tb_short_packet_parser.sv` | 模块级 | `csi2_short_packet_parser` | short packet 的 VC、DT、WC、ECC 字段解析。 | 输出字段与构造 header 一致。 |
| `tb_long_packet_parser.sv` | 模块级 | `csi2_long_packet_parser` | long packet header、payload valid/start/end、CRC trailer、clear 行为。 | payload 边界、word count、expected CRC 输出正确。 |
| `tb_header_ecc.sv` | 模块级 | `csi2_header_ecc_checker` | Header ECC good、error、correctable/syndrome 行为。 | ECC ok/error/correctable 标志与参考输入一致。 |
| `tb_payload_crc.sv` | 模块级 | `csi2_payload_crc_checker` | Payload CRC 累加、expected CRC 比较、CRC mismatch 注入。 | good packet 不报错，错误 CRC 产生 `crc_error`。 |
| `tb_frame_line_sync.sv` | 模块级 | `frame_line_sync_fsm` | FS/FE/LS/LE 合法顺序、非法顺序、clear。 | frame/line marker、计数器、sync error 与事件序列一致。 |
| `tb_lane_deskew_buffer.sv` | 模块级 | `lane_deskew_buffer` | 多 lane valid skew、deskew 对齐、overflow 边界。 | 容忍窗口内输出对齐，超界时 overflow。 |
| `tb_lane_reorder_merge.sv` | 模块级 | `lane_reorder_merge` | 1/2/4 lane byte merge 顺序和 group handshaking。 | 输出 byte 顺序符合 CSI-2 lane interleave 规则。 |
| `tb_raw8_unpack.sv` | 模块级 | `raw8_unpack` | RAW8 payload byte 到 24-bit pixel 输出。 | 像素值、sof/sol marker、ready/valid 传播正确。 |
| `tb_raw10_unpack.sv` | 模块级 | `raw10_unpack` | RAW10 5-byte 到 4-pixel 解包。 | 4 个像素的 10-bit 数据展开与参考一致。 |
| `tb_rgb888_unpack.sv` | 模块级 | `rgb888_unpack` | RGB888 3-byte 像素组装和 marker 传播。 | RGB 24-bit 像素、sof/sol、backpressure 行为正确。 |
| `tb_yuv422_unpack.sv` | 模块级 | `yuv422_unpack` | YUV422 字节分组到像素输出。 | 两像素分组、输出顺序和 marker 与期望一致。 |
| `tb_err_classifier.sv` | 模块级 | `err_classifier` | ECC/CRC/sync/lane 错误优先级、上下文绑定、计数器。 | 错误类型、优先级、frame/line/VC/DT、计数器正确。 |
| `tb_err_logger.sv` | 模块级 | `err_frame_line_logger` | 最近错误记录、pending、错误计数。 | last error 字段和累计计数符合输入事件。 |
| `tb_retry_request_ctrl.sv` | 模块级 | `retry_request_ctrl` | 错误上下文转自动重采集请求。 | frame/line 两种模式均能产生一拍请求并锁存上下文。 |
| `tb_packet_error_policy.sv` | 模块级 | `packet_error_policy` | ECC 标记、CRC 丢弃、unsupported DT、resync drop 策略。 | `payload_drop`、`crc_drop_req` 等策略输出符合配置。 |
| `tb_resync_ctrl.sv` | 模块级 | `resync_ctrl_fsm`、`degrade_recover_fsm` | resync request/ack/done 流程和降级恢复基础行为。 | request/busy/done/degraded/recovering 状态转换正确。 |
| `tb_async_fifo.sv` | 模块级 | `async_fifo` | 双时钟 FIFO full/empty、backpressure、clear_wr/clear_rd。 | 写读顺序不乱，满空标志和 clear 后状态正确。 |
| `tb_axi_write_master.sv` | 模块级 | `axi_write_master` | AXI AW/W/B 写握手、burst、B response。 | AW/W/B 通道事务数量、last、busy/done/err 正确。 |
| `tb_addr_gen_frame_based.sv` | 模块级 | `addr_gen_frame_based` | frame base、line stride、line index 到 AXI 地址生成。 | 不同行地址与期望 frame/line 映射一致。 |
| `tb_pixel_to_axi_writer.sv` | 模块级/子系统 | `pixel_to_axi_writer` | `clk_sys` 到 `clk_axi` 跨域、line write、clear/flush、discard line。 | 像素被正确打包成 AXI beat，背压和 clear 不导致死锁。 |
| `tb_brightness_adjust.sv` | 模块级 | `brightness_adjust` | 亮度 gain/bias、饱和裁剪、bypass。 | 输出像素与线性变换/旁路参考一致。 |
| `tb_contrast_adjust.sv` | 模块级 | `contrast_adjust` | 对比度 gain/bias、饱和裁剪、bypass。 | 输出像素与期望调整结果一致。 |
| `tb_gray_balance.sv` | 模块级 | `gray_balance` | RGB 通道独立 gain/bias、灰度平衡、bypass。 | R/G/B 输出与参考计算一致。 |
| `tb_pixel_frame_stats_v1.sv` | 模块级 | `pixel_frame_stats_v1` | 帧内像素计数、RGB 均值、luma min/max、暗/亮像素统计。 | frame end 后统计值与输入像素集合一致。 |
| `tb_adaptive_preprocess_ctrl_v1.sv` | 模块级 | `adaptive_preprocess_ctrl_v1` | 基于统计值生成 AWB gain、stretch gain/bias。 | 输出系数在 enable/disable、边界输入下符合策略。 |
| `tb_fpga_wrapper_boot.sv` | wrapper 系统级 | `mipi_csi2_capture_fpga_wrapper`、`fpga_apb_boot_cfg` | FPGA wrapper 复位启动和片上 APB boot 配置。 | `cfg_init_done_o` 出现，配置使能进入可采集状态。 |
| `tb_mipi_csi2_capture_dphy_wrapper_compile.sv` | wrapper 系统级 | `mipi_csi2_capture_dphy_wrapper` | D-PHY PPI wrapper 复位启动、片上 APB boot 和 LP/HS debug 口连接。 | `cfg_init_done_o` 出现，PPI debug 输出能从 LP 切到 HS 再回 LP。 |
| `tb_mipi_csi2_capture_dphy_debug_probe.sv` | wrapper 系统级 | `mipi_csi2_capture_dphy_wrapper` | ILA probe bus bit map、LP/HS/lane/error/drop debug 打包。 | `ila_probe_o[63:0]` 对应 bit 与独立 debug 输出一致，高位保留位为 0。 |
| `tb_mipi_csi2_capture_dphy_wrapper_raw8_smoke.sv` | wrapper 系统级 | D-PHY PPI 入口 RAW8 主路径 | 通过 `rxbyteclkhs` 和 `dl0/1_*` PPI 信号发送 FS/LS/RAW8/LE/FE 小帧。 | frame/line/pixel marker 出现，scoreboard `exp=act` 且无 ECC/CRC/sync/SoT 错误。 |
| `tb_mipi_csi2_capture_dphy_no_backpressure_guard.sv` | wrapper 系统级 | D-PHY PPI 入口 no-backpressure guard | 在 `fifo_rd_ready` 受阻时持续灌入 PPI byte stream，验证受损帧被丢弃且下一个 clean RAW8 frame 恢复。 | stale frame 不漏出，clean frame scoreboard `exp=act`，`lane_ready_low` 和 FIFO 压力被观测。 |
| `tb_fpga_wrapper_raw8_smoke.sv` | wrapper 系统级 | RAW8 顶层主路径 | FS/LS/RAW8 payload/LE/FE 到 pixel 输出的最小闭环。 | frame/line/pixel marker 出现，scoreboard 像素匹配。 |
| `tb_fpga_wrapper_raw8_metrics.sv` | 指标测试 | RAW8 顶层主路径 | 采集 `init_to_frame`、`frame_to_first_pixel`、`frame_to_end` 等时延。 | 打印 RAW8 metrics，像素 `exp=act`。 |
| `tb_fpga_wrapper_raw8_multiframe_stability.sv` | wrapper 系统级 | RAW8 连续多帧多行 | 3 帧 9 行 36 像素连续输出稳定性。 | `scoreboard_frames=3`，`mismatch=0`。 |
| `tb_fpga_wrapper_raw8_backpressure_stress.sv` | 压力/扫描测试 | RAW8 + AXI 背压 | 多帧多行下对 AXI AW/W 施加固定 stall，观察 lane 回压、FIFO 峰值和 scoreboard。 | 稳定配置打印 `RESULT:` 且 scoreboard pass；极浅 FIFO 配置可暴露失稳边界。 |
| `tb_fpga_wrapper_raw8_lane_config_smoke.sv` | wrapper 系统级 | RAW8 1/4 lane 配置 | 扫描 `LANE_NUM=1` 和 `LANE_NUM=4` 的最小 RAW8 wrapper 路径。 | lane1/lane4 `exp=act`，frame 完整闭合。 |
| `tb_fpga_wrapper_raw10_smoke.sv` | wrapper 系统级 | RAW10 顶层主路径 | RAW10 payload 解包、line/frame 收尾闭合。 | `exp=4 act=4 frames=1 full_frame=1`。 |
| `tb_fpga_wrapper_raw10_metrics.sv` | 指标测试 | RAW10 顶层主路径 | RAW10 主链路时延和 full-frame closure 指标。 | 打印 RAW10 metrics，`exp=act`。 |
| `tb_fpga_wrapper_rgb888_smoke.sv` | wrapper 系统级 | RGB888 顶层主路径 | RGB888 payload 解包和 frame/line/pixel 输出。 | 像素输出与参考一致，frame 完整闭合。 |
| `tb_fpga_wrapper_rgb888_metrics.sv` | 指标测试 | RGB888 顶层主路径 | RGB888 主链路时延指标。 | 打印 RGB888 metrics，`exp=act`。 |
| `tb_fpga_wrapper_yuv422_smoke.sv` | wrapper 系统级 | YUV422 顶层主路径 | YUV422 payload 解包和 frame/line/pixel 输出。 | 像素输出与参考一致，frame 完整闭合。 |
| `tb_fpga_wrapper_yuv422_metrics.sv` | 指标测试 | YUV422 顶层主路径 | YUV422 主链路时延指标。 | 打印 YUV422 metrics，`exp=act`。 |
| `tb_fpga_wrapper_crc_error.sv` | wrapper 错误注入 | Payload CRC 链路 | 注入 CRC mismatch，观察 `err_crc_o`、计数、系统响应和 retry 请求。 | CRC error pulse/计数可见，frame-level retry 上下文正确，非目标错误不误报。 |
| `tb_fpga_wrapper_ecc_error.sv` | wrapper 错误注入 | Header ECC 链路 | 注入 header ECC 错误，观察 `err_ecc_o`、计数和错误分类。 | ECC error pulse/计数可见，链路按策略处理。 |
| `tb_fpga_wrapper_sync_illegal_order.sv` | wrapper 错误注入 | 帧行同步 FSM | 发送非法 FS/LS/LE/FE 顺序。 | `err_sync_o` 被触发，错误路径可观测。 |
| `tb_fpga_wrapper_resync_recovery.sv` | wrapper 恢复测试 | resync 信号链 | sync error 后观察 `resync_req/busy/done/clear` 链路。 | resync 信号链完整闭合。 |
| `tb_fpga_wrapper_resync_metrics.sv` | 指标测试 | resync 时延 | 测量 `sync_to_req`、`clear_to_done`、`sync_to_done` 等周期数。 | 打印恢复阶段时延，恢复流程闭合。 |
| `tb_fpga_wrapper_resync_repeated_error.sv` | wrapper 错误注入 | resync busy 期间重复错误 | 恢复期间再次注入错误，验证状态一致性。 | repeated error 不破坏 resync 状态机闭合。 |
| `tb_fpga_wrapper_resync_clean_frame.sv` | wrapper 恢复测试 | resync 后 clean frame | 先触发非法同步，再发送干净 RAW8 帧。 | `clear_sys/clear_byte` 后 clean frame `exp=act`。 |
| `tb_fpga_wrapper_resync_backpressure_multiframe.sv` | 混合压力测试 | resync + AXI 背压 + 多帧 | resync 后在 AXI 背压下连续发送 clean multiframe。 | `frames=2 lines=4 exp=16 act=16 mismatch=0`，记录 AW/W stall。 |
| `tb_fpga_wrapper_axi_backpressure.sv` | wrapper 系统级 | AXI 背压 | 对 AXI AW/W ready 施加阻塞，验证释放后不死锁。 | frame/pixel 正确，AW/W stall 被观测。 |
| `tb_fpga_wrapper_axi_backpressure_metrics.sv` | 指标测试 | AXI 背压时延 | 统计 `aw_stall_cycles`、`w_stall_cycles`、`aw_release_to_fire`、`axi_busy_duration`。 | 打印背压指标，像素 `exp=act`。 |
| `tb_fpga_wrapper_buffer_depth_sweep.sv` | 参数扫描 | BYTE FIFO / AXI FIFO | 扫描 FIFO 深度和 AXI stall，观察 FIFO level、lane/pixel stall。 | 打印 `RESULT:`，稳定样例无 mismatch。 |
| `tb_fpga_wrapper_lane_skew_tolerance.sv` | wrapper 系统级 | lane deskew 容忍路径 | 在容忍范围内注入 lane skew，验证顶层像素仍正确。 | 容忍 skew 下 frame/pixel 正确，无 overflow。 |
| `tb_fpga_wrapper_lane_skew_overflow.sv` | wrapper 错误注入 | lane deskew overflow | 注入超出 deskew 深度的 lane skew。 | overflow/ready low 可观测，错误路径被触发。 |
| `tb_fpga_wrapper_lane_skew_scan.sv` | 参数扫描 | lane skew window | 扫描 `lead_bytes=0..DESKEW_DEPTH+1`，量化容忍窗口和 overflow 边界。 | `0..DESKEW_DEPTH` 通过，`DESKEW_DEPTH+1` overflow。 |

## 结果文档映射

| 结果主题 | 对应 testbench / 脚本 | 结果文档 |
| --- | --- | --- |
| 多格式主链路时延 | `tb_fpga_wrapper_*_metrics.sv` | `docs/spec/结果验证/format_comparison_results.md` |
| RAW10 full-frame closure | `tb_fpga_wrapper_raw10_smoke.sv`、`tb_fpga_wrapper_raw10_metrics.sv` | `docs/spec/结果验证/raw10_full_frame_results.md` |
| RAW8 连续多帧 | `tb_fpga_wrapper_raw8_multiframe_stability.sv` | `docs/spec/结果验证/raw8_multiframe_stability_results.md` |
| RAW8 背压压力扫描 | `tb_fpga_wrapper_raw8_backpressure_stress.sv`、`scripts/run_raw8_backpressure_stress_sweep.ps1` | `docs/spec/结果验证/raw8_backpressure_stress_results.md` |
| lane 配置 smoke | `tb_fpga_wrapper_raw8_lane_config_smoke.sv`、`scripts/run_raw8_lane_config_smokes.ps1` | `docs/spec/结果验证/raw8_lane_config_results.md` |
| D-PHY ILA probe map | `tb_mipi_csi2_capture_dphy_debug_probe.sv` | `docs/spec/dphy_ila_probe_map.md` |
| D-PHY PPI RAW8 smoke | `tb_mipi_csi2_capture_dphy_wrapper_raw8_smoke.sv` | `docs/spec/结果验证/dphy_ppi_raw8_smoke_results.md` |
| D-PHY no-backpressure guard | `tb_mipi_csi2_capture_dphy_no_backpressure_guard.sv` | `docs/spec/结果验证/dphy_no_backpressure_guard_results.md` |
| lane skew 扫描 | `tb_fpga_wrapper_lane_skew_scan.sv`、`scripts/run_lane_buffer_sensitivity_sweep.ps1` | `docs/spec/结果验证/lane_skew_scan_results.md`、`docs/spec/结果验证/lane_buffer_sensitivity_results.md` |
| buffer 深度扫描 | `tb_fpga_wrapper_buffer_depth_sweep.sv`、`scripts/run_buffer_depth_sweep.ps1` | `docs/spec/结果验证/buffer_depth_sweep_results.md` |
| resync clean frame | `tb_fpga_wrapper_resync_clean_frame.sv` | `docs/spec/结果验证/resync_clean_frame_results.md` |
| resync + backpressure + multiframe | `tb_fpga_wrapper_resync_backpressure_multiframe.sv` | `docs/spec/结果验证/resync_backpressure_multiframe_results.md` |
