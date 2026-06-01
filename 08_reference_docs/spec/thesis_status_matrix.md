# Thesis Status Matrix

## Purpose

本表用于把毕业论文当前工程状态收敛成统一口径，明确每个模块：

- 当前实现到了什么程度
- 当前验证覆盖到了什么程度
- 论文里应该如何真实表述
- 下一步最值得补的动作是什么
- 当前主要风险在哪里

## Status Labels

本表统一使用以下状态描述：

- `已实现并有模块级验证`
- `已实现并有系统级基础验证`
- `已实现但需补系统级验证`
- `已实现但需补量化结果`

## Matrix

| 模块 | 当前实现状态 | 当前验证状态 | 论文表述方式 | 下一步优化动作 | 风险 |
| --- | --- | --- | --- | --- | --- |
| `phy_digital_adapter` | 已实现并有模块级验证 | `tb_phy_digital_adapter.sv` 已覆盖 HS/LP gating、lane mask 和字节抽取 | 已完成数字抽象输入适配，建立了面向数字 RTL 的 D-PHY 边界 | 补数字输入假设、异常输入行为和论文边界说明 | 当前仅验证数字抽象，不覆盖真实模拟 D-PHY 电气行为 |
| `lane_deskew_buffer` | 已实现并有系统级基础验证 | `tb_lane_deskew_buffer.sv` 已覆盖模块级多 lane valid skew 和 deskew 行为，`tb_fpga_wrapper_lane_skew_tolerance.sv` 已覆盖真实 top 容忍范围内的 skew 合并路径，`tb_fpga_wrapper_lane_skew_overflow.sv` 已覆盖超界 overflow 事件 | 已完成多 lane 对齐缓存基础设计，并具备系统级基础验证 | 补 skew 极限、overflow 边界和恢复时延量化 | 尚缺容忍窗口的系统统计结果 |
| `lane_reorder_merge` | 已实现并有系统级基础验证 | `tb_lane_reorder_merge.sv` 已覆盖模块级 1/2/4 lane merge 顺序，`tb_fpga_wrapper_lane_skew_tolerance.sv` 已覆盖真实 top 的 skew 后合并路径，`tb_fpga_wrapper_lane_skew_overflow.sv` 已覆盖超界前的 backpressure/overflow 观测 | 已完成多 lane 重排序与合并逻辑，并具备系统级基础验证 | 补不同 skew 大小下的端到端量化 | 尚缺容忍边界统计结果 |
| `csi2_short_packet_parser` | 已实现并有模块级验证 | `tb_short_packet_parser.sv` 已覆盖 VC/DT/WC/ECC 字段提取 | 已完成 short packet 字段解析基础功能 | 补与 frame/line sync 的联动实验说明 | 系统级对 short packet 的真实顶层路径展示仍不足 |
| `csi2_long_packet_parser` | 已实现但需补系统级验证 | `tb_long_packet_parser.sv` 已覆盖 header 解析、payload valid/start/end、clear 行为 | 已完成长包解析核心逻辑并接入顶层主链路 | 补真实 top 下 RAW8 与 CRC 异常路径 | 尚缺顶层 end-to-end mixed packet 负场景 |
| `csi2_header_ecc_checker` | 已实现并有系统级基础验证 | `tb_header_ecc.sv` 已覆盖模块级 good/error/correctable 行为，`tb_fpga_wrapper_ecc_error.sv` 已覆盖真实 top ECC error pulse 与计数可见性 | 已完成 Header ECC 检测与错误状态输出，并具备系统级基础验证 | 补多错分类、恢复策略和对比结果 | 当前仍缺更完整的 ECC 策略对比实验 |
| `csi2_payload_crc_checker` | 已实现并有系统级基础验证 | `tb_payload_crc.sv` 已覆盖模块级 CRC 检测，`tb_fpga_wrapper_crc_error.sv` 已覆盖系统级 CRC error pulse 与计数可见性 | 已完成 Payload CRC 检测并已接入顶层错误链路，具备系统级基础验证 | 补恢复时延、丢弃粒度和策略对比 | 当前系统级覆盖仍以单一负向样例为主 |
| `frame_line_sync_fsm` | 已实现并有系统级基础验证 | `tb_frame_line_sync.sv` 已覆盖模块级合法/非法顺序和 clear 行为，`tb_fpga_wrapper_sync_illegal_order.sv` 已覆盖真实 top 非法顺序 sync error | 已完成帧/行同步状态机设计，并具备系统级异常基础验证 | 补更多非法序列和恢复相关实验 | 尚缺与 resync/recovery 联动的系统级结果 |
| `raw8_unpack` | 已实现并有模块级验证 | `tb_raw8_unpack.sv` 已覆盖 RAW8 字节到像素输出 | 已完成 RAW8 像素重组模块 | 补真实 top RAW8 smoke 作为系统级入口 | 当前系统级可见性仍待补强 |
| `raw10_unpack` | 已实现并有系统级基础验证 | `tb_raw10_unpack.sv` 已覆盖 5-byte to 4-pixel packing，`tb_fpga_wrapper_raw10_smoke.sv` 与 `tb_fpga_wrapper_raw10_metrics.sv` 已覆盖真实 top / wrapper 的像素路径 | 已完成 RAW10 像素重组模块，并具备系统级像素路径验证 | 补 RAW10 收尾标记闭环与 RAW8/RGB888 对比表 | 当前真实 top 下已验证到像素路径，但 `LE/FE` 收尾标记仍需继续分析 |
| `rgb888_unpack` | 已实现并有系统级基础验证 | `tb_rgb888_unpack.sv` 已覆盖像素分组和 marker 传播，`tb_fpga_wrapper_rgb888_smoke.sv` 与 `tb_fpga_wrapper_rgb888_metrics.sv` 已覆盖真实 top / wrapper 系统路径 | 已完成 RGB888 像素重组模块，并具备系统级基础验证 | 补 RGB888 与 RAW8/RAW10 的对比结果表 | 尚缺多格式横向对比结果 |
| `yuv422_unpack` | 已实现并有系统级基础验证 | `tb_yuv422_unpack.sv` 已覆盖两像素分组输出，`tb_fpga_wrapper_yuv422_smoke.sv` 与 `tb_fpga_wrapper_yuv422_metrics.sv` 已覆盖真实 top / wrapper 系统路径 | 已完成 YUV422 像素重组模块，并具备系统级基础验证 | 补 YUV422 与 RAW8/RAW10/RGB888 的对比结果表 | 尚缺多格式横向对比结果 |
| `err_classifier` | 已实现并有模块级验证 | `tb_err_classifier.sv` 已覆盖 ecc/crc/sync/lane 优先级和计数器 | 已完成错误分类和上下文绑定基础逻辑 | 补系统级错误矩阵和 counters 量化表 | 当前主要是单元级结论，尚未升格为系统级方法论证据 |
| `err_frame_line_logger` | 已实现并有模块级验证 | `tb_err_logger.sv` 已覆盖最近错误上下文记录和计数 | 已完成错误记录与状态保存基础逻辑 | 补日志可观测性与论文状态读取叙事 | 当前不是深 FIFO，只是 last-event logger，需要边界说明 |
| `resync_ctrl_fsm` | 已实现并有系统级基础验证 | `tb_resync_ctrl.sv` 已覆盖 request/ack/done 和恢复流程，`tb_fpga_wrapper_resync_recovery.sv` 已覆盖真实 top 的 `resync_req/busy/done/clear` 信号链，`tb_fpga_wrapper_resync_repeated_error.sv` 已覆盖恢复期间再次报错，`tb_fpga_wrapper_resync_metrics.sv` 已补恢复时延数字 | 已完成重同步控制基础逻辑并接入 top clear 路径，具备系统级基础验证和初版量化结果 | 补恢复后 clean-frame 闭环和 repeated-error 统计量化 | 仍缺对 sensor-side idleness 与恢复后 clean-frame 闭环的完整证明 |
| `degrade_recover_fsm` | 已实现并有模块级验证 | `tb_resync_ctrl.sv` 已覆盖 degrade/recover 基本行为 | 已完成降级恢复状态机并联动有效 lane 数 | 补 lane 异常后的恢复统计和 good-frame 门限实验 | 目前更像基础机制，缺少量化恢复效果 |
| `async_fifo` | 已实现并有模块级验证 | `tb_async_fifo.sv` 已覆盖 full/empty/backpressure/dual-domain clear，`tb_fpga_wrapper_buffer_depth_sweep.sv` 已补系统级基础占用趋势扫描 | 已完成 FIFO/CDC 基础模块，并具备基础深度趋势留痕 | 补更强饱和扫描与更长流量工作点 | 当前系统级结果仍偏基础趋势，不是最终容量边界 |
| `axi_write_master` | 已实现并有模块级验证 | `tb_axi_write_master.sv` 已覆盖 burst write 握手和 B response，`tb_fpga_wrapper_buffer_depth_sweep.sv` 已补固定背压下的 writer FIFO 占用观测 | 已完成 AXI 写事务核心状态机，并具备基础背压占用留痕 | 补更长行、多帧和更窄数据宽度下的饱和分析 | 仍缺系统级写入瓶颈边界 |
| `pixel_to_axi_writer` | 已实现并有系统级基础验证 | `tb_pixel_to_axi_writer.sv` 已覆盖跨 `clk_sys/clk_axi` 的 line write closure、clear/flush，`tb_fpga_wrapper_axi_backpressure.sv` 已覆盖真实 top 下 AXI 背压恢复，`tb_fpga_wrapper_buffer_depth_sweep.sv` 已补深度与占用趋势扫描 | 已完成最小可综合像素到 AXI 写入通路，并具备系统级基础验证与基础占用趋势数据 | 补更强饱和工作点和吞吐边界量化 | 当前仍是 minimum closure path，不是最终高效率 frame buffer 架构 |
| `preprocess_core` 相关模块 | 已实现并有模块级验证 | `tb_brightness_adjust.sv`、`tb_contrast_adjust.sv`、`tb_gray_balance.sv`、adaptive v1 TB 已覆盖 | 已完成轻量预处理与 bypass 基础链路 | 补系统级配置叙事和资源开销表 | 不宜过度宣称为完整 ISP，仅能定位为轻量预处理 |
| `cfg_reg_if_apb` | 已实现并有模块级验证 | `tb_cfg_reg_if_apb.sv` 已覆盖默认值、RW 字段、sticky clear 和 status readback | 已完成论文当前阶段可用的 APB 配置/状态接口 | 补寄存器到实验观测的映射表 | 若未在系统级实验中使用，论文体现会偏弱 |
| `mipi_csi2_capture_top` | 已实现并有系统级基础验证 | 当前已有 compile-level closure，`tb_fpga_wrapper_raw8_smoke.sv`、`tb_fpga_wrapper_crc_error.sv`、`tb_fpga_wrapper_ecc_error.sv`、`tb_fpga_wrapper_sync_illegal_order.sv`、`tb_fpga_wrapper_lane_skew_tolerance.sv`、`tb_fpga_wrapper_resync_recovery.sv`、`tb_fpga_wrapper_resync_metrics.sv`、`tb_fpga_wrapper_axi_backpressure.sv`、`tb_fpga_wrapper_resync_repeated_error.sv`、`tb_fpga_wrapper_lane_skew_overflow.sv`、`tb_fpga_wrapper_rgb888_smoke.sv`、`tb_fpga_wrapper_rgb888_metrics.sv`、`tb_fpga_wrapper_raw10_smoke.sv`、`tb_fpga_wrapper_raw10_metrics.sv`、`tb_fpga_wrapper_yuv422_smoke.sv`、`tb_fpga_wrapper_yuv422_metrics.sv`、`tb_fpga_wrapper_buffer_depth_sweep.sv` 已直接覆盖真实 top / wrapper 路径 | 已完成面向论文阶段的最小主链路顶层集成，并具备真实 top 基础系统验证与基础 buffer 占用趋势数据 | 补连续多帧、强饱和吞吐和更广参数边界 | 目前仍是 minimum main-path integration，不是最终产品级顶层 |
| `system testbench` | 已实现并有系统级基础验证 | `tb_mipi_csi2_capture_top` 已覆盖骨架链路 smoke，`tb_fpga_wrapper_raw8_smoke.sv`、`tb_fpga_wrapper_crc_error.sv`、`tb_fpga_wrapper_ecc_error.sv`、`tb_fpga_wrapper_sync_illegal_order.sv`、`tb_fpga_wrapper_lane_skew_tolerance.sv`、`tb_fpga_wrapper_resync_recovery.sv`、`tb_fpga_wrapper_resync_metrics.sv`、`tb_fpga_wrapper_axi_backpressure.sv`、`tb_fpga_wrapper_resync_repeated_error.sv`、`tb_fpga_wrapper_lane_skew_overflow.sv`、`tb_fpga_wrapper_rgb888_smoke.sv`、`tb_fpga_wrapper_rgb888_metrics.sv`、`tb_fpga_wrapper_raw10_smoke.sv`、`tb_fpga_wrapper_raw10_metrics.sv`、`tb_fpga_wrapper_yuv422_smoke.sv`、`tb_fpga_wrapper_yuv422_metrics.sv`、`tb_fpga_wrapper_buffer_depth_sweep.sv` 已补真实 top 样例 | 已建立模块骨架 + 真实 top 并行的系统级验证基础，并新增 buffer 深度趋势扫描入口 | 补连续帧稳定性矩阵和更强吞吐工作点 | 当前系统级覆盖仍偏定向样例，缺少更完整论文级矩阵 |
| `vivado flow` | 已实现并有系统级基础验证 | 已有 Tcl/PowerShell 脚本、干净重跑报告以及资源/时序结果整理 | 已完成综合/原型化基础流程搭建，并已有论文可引用的 util/timing 结果 | 后续可继续补板级约束与 CDC 约束策略 | 当前仍需区分“综合可行性验证”与“完整板级实现” |

## Current Thesis Reading

基于当前状态，论文可稳定声称：

1. 已完成 MIPI CSI-2 数字接收前端的主体 RTL 架构搭建。
2. 已完成关键基础模块的模块级实现与验证。
3. 已建立系统级验证的基础骨架，但系统级负场景和量化实验仍需补强。
4. 已具备 FPGA 综合与原型化验证基础，但仍需系统整理资源和时序结果。

## Stage A Focus

Stage A 需要优先把以下条目从“已实现但需补系统级验证/量化结果”往前推进：

1. `mipi_csi2_capture_top`
2. `csi2_payload_crc_checker`
3. `raw8_unpack` 的系统级路径
4. `system testbench`
5. `vivado flow` 的论文结果表框架
