# Thesis Experiment Matrix

## Purpose

本表用于把毕业论文后续实验固定成可执行矩阵，避免实验范围无限扩张。每个实验都要明确：

- 类别
- 输入场景
- 观测信号
- 预期行为
- 成功判据
- 优先级
- 对应的论文章节或图表

## Priority Definition

- `P0`：答辩必须有，直接支撑核心结论
- `P1`：强烈建议有，明显增强论文说服力
- `P2`：时间允许时补充，用于提高完整度

## Matrix

| 实验名称 | 类别 | 输入场景 | 观测信号 | 预期行为 | 成功判据 | 优先级 | 对应论文章节/图表 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| RAW8 single-frame smoke | 功能正确性 | lane2 RAW8 单帧、FS/LS/payload/LE/FE 最小合法链路 | `frame_start_o` `line_start_o` `pixel_valid_o` `pixel_data_o` `line_end_o` `frame_end_o` | 主链路可从 packet 流进入 top 并输出像素 | 至少 1 帧、1 行、像素有效输出且无意外 fatal sync 行为 | P0 | 第 6 章系统级验证入口波形 |
| RAW8 lane1 single-frame smoke | 功能正确性 | 单 lane RAW8 最小合法链路 | `lane_valid_*` `pixel_valid_o` `frame_cnt_o` | 单 lane 模式下系统主链路仍能闭合 | 单 lane 下 frame/line 流程正确完成 | P1 | 第 6 章 lane 配置对比 |
| RAW8 lane4 single-frame smoke | 功能正确性 | 四 lane RAW8 合法链路 | `pixel_valid_o` `frame_cnt_o` `line_cnt_o` | 多 lane 路径可扩展至四 lane 配置 | 四 lane 模式完成主链路输出 | P1 | 第 6 章 lane 配置对比 |
| RAW10 system path | 功能正确性 | RAW10 payload + 合法 `FS/LS/LE/FE` 事件 | `pixel_valid_o` `pixel_data_o` `payload_dt` `line_end_o` `frame_end_o` | RAW10 解包可接入系统路径并完成完整帧收尾 | 至少完成 1 次正确 RAW10 像素重组输出，且 `line_end_o/frame_end_o` 正常出现 | P1 | 第 4 章像素重组结果表 |
| RGB888 system path | 功能正确性 | RGB888 payload + 合法 frame/line 事件 | `pixel_valid_o` `pixel_data_o[23:0]` | RGB888 可在系统链路中输出完整 24-bit 像素 | 颜色分量顺序正确、frame/line marker 正常 | P1 | 第 4 章像素重组结果图 |
| YUV422 system path | 功能正确性 | YUV422 payload + 合法 frame/line 事件 | `pixel_valid_o` `pixel_data_o[23:0]` `payload_dt` | YUV422 两像素分组可接入系统路径 | 至少完成 1 次正确 YUV422 像素分组输出 | P1 | 第 4 章像素重组结果表 |
| ECC single error | 异常注入 | header 注入单 bit 错误 | `err_ecc_o` `err_cnt_ecc_o` `last_err` | ECC 单错被检测并进入错误链路 | `err_ecc_o` 有效，计数增加，错误上下文可见 | P1 | 第 6 章 ECC 异常实验 |
| ECC multi error | 异常注入 | header 注入多 bit 错误 | `err_ecc_o` `frame_cnt_o` `line_cnt_o` | 多错不可纠正并触发错误处理路径 | 错误事件被记录且不误判为正常 header | P1 | 第 6 章 ECC 异常实验 |
| CRC error | 异常注入 | long packet payload 后附错误 CRC | `err_crc_o` `err_cnt_crc_o` `drop_line` or discard behavior | CRC mismatch 被系统检测并进入错误/丢弃路径 | `err_crc_o` 有效、错误计数变化、后续行为符合策略 | P0 | 第 6 章 CRC 负向系统实验 |
| lane skew tolerance | 恢复行为 | 多 lane 数据延迟错位接近 deskew 边界 | deskew buffer 内部 ready/valid、`pixel_valid_o` | 在容忍范围内可恢复正确合并，超界时出现明确错误 | 给出可容忍 skew 范围及超界表现 | P1 | 第 4 章 lane 对齐实验表 |
| lane/buffer sensitivity sweep | 参数敏感性 | 扫描 `DESKEW_DEPTH / BYTE_FIFO / AXI FIFO` 并重复 lane skew lead-byte 边界测试 | `err_overflow_o` `lane_ready` `pixel_valid_o` | 容忍窗口应跟随 `DESKEW_DEPTH` 变化，并验证后级 FIFO 不改变 deskew 边界 | 每组都形成 `tolerant window / overflow at` 表项 | P1 | 第 4/6 章参数敏感性与工程选型 |
| illegal FS/LS/LE/FE order | 异常注入 | 事件顺序非法，如缺少 LS 或 FE 提前 | `err_sync_o` `line_cnt_o` `frame_cnt_o` | sync FSM 检出非法时序并输出 sync error | `err_sync_o` 有效，状态机不进入 silent corruption | P0 | 第 6 章同步异常实验 |
| FIFO backpressure | 吞吐/背压 | 下游 ready 拉低、FIFO 接近满/空边界 | FIFO full/empty、`pixel_valid/ready` | FIFO 在背压下保持数据顺序和状态一致 | 无数据乱序，full/empty 行为符合预期 | P1 | 第 5/6 章缓存稳定性实验 |
| AXI backpressure | 吞吐/背压 | AXI `awready/wready` 拉低或响应延迟 | AXI AW/W/B 握手、writer busy/clear 状态 | 写通路在背压下保持有序、无死锁 | 行写入最终完成，状态机能恢复 idle | P1 | 第 5/6 章 AXI 写通路实验 |
| RAW8 continuous backpressure stress | 吞吐/背压 | `RAW8` 多帧多行连续流 + 缩小 FIFO + 固定 AXI stall | `lane_ready` `pixel_valid/final_pixel_ready` FIFO level `m_axi_awvalid/wvalid` | 背压应先传播到 lane 侧，稳定区内主链路仍闭合，极浅 FIFO 下可观察到失稳边界 | 稳定点 scoreboard 通过且 `lane_bp_seen=1`；边界点留痕记录 mismatch/timeout | P1 | 第 5/6 章缓存需求与工程边界分析 |
| resync during repeated error | 恢复行为 | resync 期间再次注入 sync 或 CRC 错误 | `resync_req_o` `resync_busy_o` `resync_done_o` 及 error outputs | 系统能维持恢复流程，不因重复错误直接失控 | resync 行为可观测，错误链路仍然一致 | P1 | 第 5/6 章恢复机制实验 |
| resync to clean frame | 恢复行为 | 先注入非法同步事件触发 resync，再发送一帧 clean RAW8 | `err_sync_o` `resync_req_o` `resync_busy_o` `resync_done_o` `frame_start_o` `pixel_valid_o` `frame_end_o` | 恢复后能重新回到干净帧输出路径 | 恢复链闭合，且 clean frame 的像素与 marker 重新出现 | P0 | 第 6 章恢复后重新输出证明 |
| resync + backpressure + clean multiframe | 混合场景 | 先触发 `illegal sync -> resync`，再在恢复后的连续 clean `RAW8` 帧上施加 AXI 背压 | `resync_*` `frame/line marker` `pixel_valid_o` `m_axi_awvalid/wvalid` | 恢复与背压应能共存，恢复后 clean multiframe 仍闭合 | `resync` 链闭合，且 clean multiframe 在背压下 `exp=act, mismatch=0` | P1 | 第 6 章混合工况验证 |
| degrade/recover lane policy | 恢复行为 | lane error 触发 degraded mode，再输入若干 good frames | `active_lane_num_o` `good_frame_i` | 系统进入降级并在满足门限后恢复 full lane | degraded/recover 状态转移符合门限设计 | P2 | 第 5 章降级恢复状态图 |
| preprocess bypass vs processed path | 功能正确性 | 同一帧分别走 bypass 和 processed path | `pixel_data_o` `cfg_preprocess_bypass` | bypass 输出与处理链输出可区分且行为稳定 | 两种路径可控切换，默认配置符合文档 | P2 | 第 5 章预处理对比图 |
| Vivado synth/resource collection | 资源/时序 | 使用当前顶层/FPGA wrapper 执行综合 | utilization、timing、warnings | 得到可用于论文的资源与时序结果 | 生成资源表、时序表和限制说明 | P0 | 第 6 章综合实现分析 |

## Stage A Required Set

Stage A 最初先交付下面两个起步实验：

1. `RAW8 single-frame smoke`
2. `CRC error`

这两个实验分别作为：

- 系统主链路正确性入口
- 高可靠错误注入入口

## Recommended Run Order

1. 先跑 `RAW8 single-frame smoke`
2. 再跑 `CRC error`
3. 再跑 `illegal FS/LS/LE/FE order`
4. 再跑 `ECC single error`
5. 再补 `lane skew tolerance`
6. 最后扩展 `AXI/FIFO/resync` 等量化型实验

## Current Implemented Real-Top Cases

当前已经完成并可直接复现实验的真实 top / wrapper 样例包括：

1. `tb_fpga_wrapper_raw8_smoke`
2. `tb_fpga_wrapper_crc_error`
3. `tb_fpga_wrapper_ecc_error`
4. `tb_fpga_wrapper_sync_illegal_order`
5. `tb_fpga_wrapper_lane_skew_tolerance`
6. `tb_fpga_wrapper_resync_recovery`
7. `tb_fpga_wrapper_axi_backpressure`
8. `tb_fpga_wrapper_resync_repeated_error`
9. `tb_fpga_wrapper_lane_skew_overflow`
10. `tb_fpga_wrapper_raw8_metrics`
11. `tb_fpga_wrapper_axi_backpressure_metrics`
12. `tb_fpga_wrapper_rgb888_smoke`
13. `tb_fpga_wrapper_rgb888_metrics`
14. `tb_fpga_wrapper_raw10_smoke`
15. `tb_fpga_wrapper_raw10_metrics`
16. `tb_fpga_wrapper_yuv422_smoke`
17. `tb_fpga_wrapper_yuv422_metrics`
18. `tb_fpga_wrapper_resync_metrics`
19. `tb_fpga_wrapper_lane_skew_scan`
20. `tb_fpga_wrapper_resync_clean_frame`
21. `tb_fpga_wrapper_buffer_depth_sweep`
22. `tb_fpga_wrapper_raw8_backpressure_stress`
23. `tb_fpga_wrapper_lane_skew_scan` with `run_lane_buffer_sensitivity_sweep.ps1`
24. `tb_fpga_wrapper_resync_backpressure_multiframe`
25. `tb_fpga_wrapper_raw8_lane_config_smoke`

其中：

- `tb_fpga_wrapper_resync_recovery` 当前用于证明真实 top 下 `err_sync -> resync_req -> resync_busy -> resync_done -> resync_clear` 的恢复信号链闭合。
- `tb_fpga_wrapper_resync_metrics` 当前用于提供真实 top 下 `sync_to_req / req_to_busy / busy_to_clear / clear_to_done / sync_to_done` 的恢复时延数字。
- `tb_fpga_wrapper_axi_backpressure` 当前用于证明真实 top 下 AXI `awready/wready` 背压时写通路最终可恢复完成。
- `tb_fpga_wrapper_resync_repeated_error` 当前用于证明真实 top 在 `resync_busy` 期间再次出现 sync error 时，恢复流程仍可闭合。
- `tb_fpga_wrapper_resync_clean_frame` 当前用于证明真实 top 在恢复链完成后，能够重新回到 clean RAW8 frame 的像素输出路径。
- `tb_fpga_wrapper_lane_skew_overflow` 当前用于证明超出 deskew 容忍范围时，真实 top 能观测到 lane backpressure 与 overflow 事件。
- `tb_fpga_wrapper_lane_skew_scan` 当前用于把真实 top 下的 `lane skew tolerance / overflow` 两端样例收敛成系统级边界扫描表，当前已得到 `DESKEW_DEPTH=4 -> tolerance 0..4, overflow at 5`。
- `tb_fpga_wrapper_raw8_metrics` 当前用于提供 `init/frame/first-pixel/frame-end` 的主链路时延数字。
- `tb_fpga_wrapper_axi_backpressure_metrics` 当前用于提供 AXI `AW/W stall cycles` 与释放后握手指标。
- `tb_fpga_wrapper_rgb888_smoke` 当前用于补齐真实 top / wrapper 下的 RGB888 系统级主链路样例。
- `tb_fpga_wrapper_rgb888_metrics` 当前用于提供 RGB888 主链路的 `init/frame/first-pixel/frame-end` 时延数字。
- `tb_fpga_wrapper_raw10_smoke` 当前用于补齐真实 top / wrapper 下的 RAW10 系统级 full-frame 样例。
- `tb_fpga_wrapper_raw10_metrics` 当前用于提供 RAW10 主链路的 `init/frame/first-pixel/frame-end` 与像素输出跨度数字。
- `tb_fpga_wrapper_yuv422_smoke` 当前用于补齐真实 top / wrapper 下的 YUV422 系统级主链路样例。
- `tb_fpga_wrapper_yuv422_metrics` 当前用于提供 YUV422 主链路的 `init/frame/first-pixel/frame-end` 时延数字。
- `tb_fpga_wrapper_buffer_depth_sweep` 当前用于扫描 `BYTE_FIFO_ADDR_WIDTH / AXI writer FIFO / AXI stall cycles` 与 buffer 占用趋势之间的关系。
- `tb_fpga_wrapper_raw8_backpressure_stress` 当前用于补连续流背压强化扫描，验证 lane 侧回压是否出现，并记录浅 `AXI writer FIFO` 下的失稳边界。
- `tb_fpga_wrapper_lane_skew_scan` 当前还承担 `DESKEW_DEPTH / BYTE_FIFO / AXI FIFO` 联合敏感性扫描入口；批量脚本为 `scripts/run_lane_buffer_sensitivity_sweep.ps1`。
- `tb_fpga_wrapper_resync_backpressure_multiframe` 当前用于补“恢复后连续工作”这一类混合工况证据，验证 `resync` 与 AXI 背压能够同时成立。
- `tb_fpga_wrapper_raw8_lane_config_smoke` 当前用于补 `lane1 / lane4` 的真实 wrapper 级 smoke 证据；批量脚本为 `scripts/run_raw8_lane_config_smokes.ps1`。
- 由于当前 wrapper boot 序列默认未拉起 `cfg_capture_enable`，AXI backpressure case 在 testbench 中显式 force 该使能，只用于打开写通路覆盖，不改变 DUT RTL。
- `tb_fpga_wrapper_resync_repeated_error` 在第二次错误注入时显式 force `sync_error`，目的是把“恢复期间再次出错”的条件稳定收敛成可复现实验，不改变 DUT RTL。
- `tb_fpga_wrapper_rgb888_smoke` 和 `tb_fpga_wrapper_rgb888_metrics` 在 testbench 中显式 force `cfg_dt_code=0x24`，用于匹配 wrapper 默认 RAW8 启动配置，不改变 DUT RTL。
- `tb_fpga_wrapper_raw10_smoke` 和 `tb_fpga_wrapper_raw10_metrics` 在 testbench 中显式 force `cfg_dt_code=0x2b`；为冲出当前 2-lane wrapper 路径尾部残留的单字节，`FE` short packet 后追加了一个 flush byte，但不改变 DUT RTL。
- `tb_fpga_wrapper_yuv422_smoke` 和 `tb_fpga_wrapper_yuv422_metrics` 在 testbench 中显式 force `cfg_dt_code=0x1e`，用于匹配 wrapper 默认 RAW8 启动配置，不改变 DUT RTL。
