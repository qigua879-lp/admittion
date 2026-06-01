# 毕业课题执行流程表（2026-04-29 到 2026-05-31）

## 1. 目标定位

课题名称：基于 MIPI CSI-2 协议的高速高可靠图像采集系统设计与仿真验证

本计划面向 2026 年 6 月前完成毕业课题，目标不是把项目做成完整商品级板卡系统，而是在论文周期内形成一套可自洽、可答辩、可验证的数字 RTL 课题成果，覆盖：

1. 完整的系统规格与架构说明
2. 可综合 RTL
3. 模块级和系统级仿真验证
4. 错误注入与高可靠机制验证
5. Vivado 综合结果与可实现性分析
6. ASIC 方向的评估思路与后续工作说明

## 2. 与开题内容的对应关系

| 开题报告目标 | 论文/工程中应体现的成果 | 当前状态 | 5 月底前目标 |
| --- | --- | --- | --- |
| D-PHY 数字抽象输入适配 | `phy_digital_adapter` 边界定义、数字输入假设、顶层接口说明 | 部分完成 | 冻结数字输入假设，明确外部 bridge/PHY 占位边界 |
| CSI-2 包解析 | short/long packet parser、帧行同步、header ECC、payload CRC | 大部分完成 | 完成顶层 CRC 闭环和系统级负向验证 |
| 多 lane 对齐与重排序 | lane deskew + reorder/merge 模块与仿真 | 已完成 | 在论文中形成时序/状态流程图和验证结果 |
| Header ECC 与 Payload CRC 校验 | checker RTL、错误注入、计数与状态输出 | ECC 完成，CRC 顶层未闭合 | 完成 CRC 顶层接入和错误传播 |
| 帧/行同步 | FS/LS/LE/FE 事件、frame/line 计数、异常序列处理 | 已完成 | 补系统级多帧/多行波形结果 |
| 像素重组 | RAW8/RAW10/RGB888/YUV422 解包 | 模块级完成 | 系统级补 RAW10/YUV422 结果或明确其模块级验证范围 |
| 高可靠错误统计、重同步、降级恢复 | error classify/logger/resync/degrade | 基础完成 | 完成与顶层主数据通路的论文级闭环说明 |
| FIFO / CDC / 缓存 | async FIFO、byte-to-sys crossing、后续 sys-to-axi 缓存 | 部分完成 | 明确已实现部分与未实现部分边界 |
| AXI DDR 写入 | burst/address/write master、frame-based address | 模块级完成 | 若顶层无法全部闭合，则至少形成模块级验证 + 集成方案说明 |
| 轻量预处理 | brightness/contrast/gray balance/bypass | 已完成 | 完成配置说明、波形和结果展示 |
| TB / 错误注入 / scoreboard | 模块级 TB、system smoke、negative cases | 部分完成 | 补关键负向 case 和验证矩阵 |
| Vivado 工程脚本与可综合 RTL | 工程创建、综合、综合网表、约束 | 已完成基础版 | 完成综合结果整理，说明实现阶段 IO 限制 |

## 3. 总体策略

6 月前最重要的是“收敛”，不是无限扩展功能。建议采用以下原则：

1. 优先闭合已有架构，不新增大模块分支。
2. 优先补齐“顶层闭环缺口”，尤其是 CRC、寄存器接口、系统级 TB、论文结果整理。
3. FPGA 以“可综合、有资源/时序报告”为目标，不强求完整上板。
4. ASIC 以“RTL 可迁移、流程规划清晰”为目标，不声称已完成真实 PPA/signoff。

## 4. 时间流程表

当前时间基准：2026 年 4 月 29 日  
目标完成时间：2026 年 5 月 31 日前形成论文定稿所需核心材料

### 阶段 A：闭合关键功能缺口

| 时间 | 任务主题 | 对应模块 | 对应开题内容 | 需要完成的功能 | 验证/输出物 |
| --- | --- | --- | --- | --- | --- |
| 2026-04-29 ~ 2026-05-02 | 约束与综合环境收敛 | `fpga/xdc`, `fpga/vivado`, `rtl/top` | Vivado 工程脚本与可综合 RTL | 修复 Vivado 2017.3 XDC 兼容性，保留综合网表导出流程，整理综合结果 | XDC 修复、综合日志、综合网表、util/timing/cdc 报告 |
| 2026-05-01 ~ 2026-05-05 | Payload CRC 顶层闭环 | `csi2_payload_crc_checker`, `csi2_long_packet_parser`, `mipi_csi2_capture_top`, `err_classifier` | Payload CRC 校验、高可靠错误统计 | 在顶层主路径接入 payload CRC，完成 expected CRC 与错误输出闭环 | 顶层波形、CRC pass/fail case、错误计数结果 |
| 2026-05-03 ~ 2026-05-07 | 顶层真实 system TB | `tb/top`, `tb/models`, `tb/scoreboard` | TB、错误注入、scoreboard | 直接实例化真实 top，跑 RAW8 单帧、多行、基本错误注入 | 真实顶层 smoke/negative test |
| 2026-05-05 ~ 2026-05-09 | 配置寄存器闭环 | `cfg_reg_if` 或 top 内 APB-lite 扩展 | 配置与状态寄存器 | 至少补全论文演示所需的 CTRL/STATUS/ERR_CNT/PREPROC/DBG 配置读取与控制 | 寄存器表、RTL、简单寄存器 TB |

### 阶段 B：系统功能收敛与验证增强

| 时间 | 任务主题 | 对应模块 | 对应开题内容 | 需要完成的功能 | 验证/输出物 |
| --- | --- | --- | --- | --- | --- |
| 2026-05-08 ~ 2026-05-12 | 像素格式收敛 | `raw10_unpack`, `yuv422_unpack`, `rgb888_unpack`, `raw8_unpack` | 像素重组 | 保证四种格式模块级结论完整，补系统级 RAW10/YUV422 场景，若时间不足则形成“模块级已验证、系统级未全覆盖”的边界说明 | 波形、像素重组表、格式对照图 |
| 2026-05-10 ~ 2026-05-14 | 可靠性策略闭环 | `err_classifier`, `err_frame_line_logger`, `resync_ctrl_fsm`, `degrade_recover_fsm` | 高可靠错误统计、重同步、降级恢复 | 补完从 parser/CRC/sync/lane error 到状态输出的论文级闭环；明确恢复策略边界 | 错误注入矩阵、策略流程图、计数结果 |
| 2026-05-12 ~ 2026-05-16 | CDC/Buffer/AXI 边界说明 | `async_fifo`, `axi_write_master`, `axi_burst_gen`, `addr_gen_frame_based`, `mem_map_ctrl` | FIFO/CDC/缓存、AXI DDR 写入 | 明确哪些功能已模块完成、哪些仍属集成待补；若顶层 AXI 无法闭合，至少形成“模块级完整验证 + 顶层接口方案” | AXI 模块结果、地址生成波形、CDC 说明 |
| 2026-05-14 ~ 2026-05-18 | 轻量预处理结果整理 | `brightness_adjust`, `contrast_adjust`, `gray_balance`, `preprocess_bypass_mux` | 轻量预处理 | 完成预处理参数、效果说明、bypass 策略和验证结果整理 | 波形、示意图、参数说明表 |

### 阶段 C：论文材料形成

| 时间 | 任务主题 | 对应模块/材料 | 对应开题内容 | 需要完成的功能 | 输出物 |
| --- | --- | --- | --- | --- | --- |
| 2026-05-17 ~ 2026-05-21 | 总体架构与模块图 | `docs/spec`, `rtl`, `tb` | 全部 | 整理系统框图、时钟域图、主数据流图、错误处理流图、验证架构图 | 论文图 1~图 6 草稿 |
| 2026-05-19 ~ 2026-05-24 | 仿真结果章节材料 | 模块级 TB、顶层 TB、错误注入 | TB、错误注入、scoreboard | 选出 6~10 组典型波形与表格，覆盖 parser、lane、pixel、CRC、error、preprocess、system smoke | 论文实验章节素材 |
| 2026-05-22 ~ 2026-05-26 | FPGA 综合章节材料 | Vivado 工程、综合网表、util/timing/cdc 报告 | Vivado 工程脚本与可综合 RTL | 总结综合资源、时钟约束、实现受限原因、工程可迁移性 | 资源表、时序表、问题说明 |
| 2026-05-24 ~ 2026-05-28 | ASIC 可实现性评估章节 | `asic_assessment_plan.md`, `clock_domains.md`, `top_io.md` | ASIC 方向评估 | 明确为什么不能直接用 FPGA 网表去 Cadence 实现，以及正确 ASIC 流程 | ASIC 评估章节草稿 |

### 阶段 D：论文定稿与答辩准备

| 时间 | 任务主题 | 对应内容 | 需要完成的功能 | 输出物 |
| --- | --- | --- | --- | --- |
| 2026-05-27 ~ 2026-05-29 | 论文初稿收敛 | 全文 | 补齐摘要、引言、结论、参考文献、附录 | 论文完整初稿 |
| 2026-05-29 ~ 2026-05-30 | 自检与导师版修订 | 全文 + 结果表 | 检查“已完成/未完成”表述真实一致，避免过度声称 | 修改稿 |
| 2026-05-30 ~ 2026-05-31 | 答辩材料准备 | PPT、流程图、波形、结果表 | 形成 10~15 页答辩提纲，突出架构、验证、综合、可靠性 | 答辩 PPT 提纲 |

## 5. 功能模块检查表

| 功能模块 | 代码位置 | 论文中必须体现的内容 | 5 月底前最低交付标准 |
| --- | --- | --- | --- |
| D-PHY 数字抽象输入 | `rtl/phy_adapter/` + `rtl/top` | 数字接口假设、lane 输入定义、HS/LP 占位说明 | 文档边界冻结，说明为何当前只做数字抽象 |
| lane deskew / merge | `rtl/csi2_rx/lane_deskew_buffer.sv`, `lane_reorder_merge.sv` | 原理、状态/缓存机制、验证波形 | 模块级波形 + system 路径说明 |
| short/long parser | `rtl/csi2_rx/*parser*.sv` | header 解析、VC/DT/word count、payload 边界 | 模块级结果 + 顶层接入说明 |
| Header ECC | `csi2_header_ecc_checker.sv` | syndrome、可纠正分类、错误传播 | TB 波形和错误注入结果 |
| Payload CRC | `csi2_payload_crc_checker.sv` | CRC 计算、expected CRC 比较、错误输出 | 顶层闭环 + 负向测试 |
| Frame/Line Sync | `frame_line_sync_fsm.sv` | FS/LS/LE/FE 状态流 | 单帧/多行波形 |
| RAW8/RAW10/RGB888/YUV422 | `rtl/pixel/` | 组包与像素映射规则 | 模块级结果完整；系统级至少 RAW8 + 另 1~2 种 |
| Reliability Monitor | `rtl/reliability/` | 错误分类、计数、重同步、降级恢复 | 错误矩阵与策略说明 |
| FIFO / CDC | `rtl/buffer/async_fifo.sv` | 异步 FIFO、跨时钟规则 | CDC 说明 + 模块级验证 |
| AXI DDR Write | `rtl/axi/` | burst、地址生成、写状态机 | 模块级完整验证 + 顶层方案说明 |
| Preprocess | `rtl/preprocess/` | gain/bias/bypass 处理 | 参数说明 + 验证波形 |
| 顶层集成 | `rtl/top/mipi_csi2_capture_top.sv` | 主链路集成与接口定义 | 真实 top 编译/综合通过 |
| Testbench | `tb/` | module TB、system TB、scoreboard、错误注入 | 验证矩阵完整 |

## 6. 论文章节建议架构

建议按 7 章或 8 章组织，适合你这个项目的逻辑。

### 方案 A：7 章结构

| 章节 | 题目建议 | 主要内容 |
| --- | --- | --- |
| 第 1 章 | 绪论 | 研究背景、MIPI CSI-2 应用场景、高速图像采集需求、国内外研究现状、本文工作内容 |
| 第 2 章 | MIPI CSI-2 图像采集系统需求与总体方案 | 协议背景、系统需求、时钟域、总体架构、数据流、错误处理思路 |
| 第 3 章 | MIPI CSI-2 接收与像素重组模块设计 | lane 对齐与重排序、short/long parser、ECC/CRC、frame/line sync、RAW8/RAW10/RGB888/YUV422 |
| 第 4 章 | 高可靠性与数据缓存写入模块设计 | 错误分类、日志、重同步、降级恢复、FIFO/CDC、AXI DDR 写入方案 |
| 第 5 章 | 轻量预处理与顶层集成设计 | brightness/contrast/gray balance、bypass、顶层接口与系统集成 |
| 第 6 章 | 仿真验证与综合实现分析 | 模块级 TB、系统级 TB、错误注入、scoreboard、Vivado 综合结果、资源与时序分析 |
| 第 7 章 | 总结与展望 | 本文成果、未完成项、ASIC/板级后续工作 |

### 方案 B：8 章结构

如果你想把“验证”和“综合实现”拆开，可以用 8 章：

| 章节 | 题目建议 | 主要内容 |
| --- | --- | --- |
| 第 1 章 | 绪论 | 同上 |
| 第 2 章 | 协议分析与系统需求 | CSI-2 协议与课题需求 |
| 第 3 章 | 系统总体架构设计 | 顶层模块划分、时钟域、接口 |
| 第 4 章 | 接收与像素重组模块设计 | parser、lane、ECC/CRC、pixel repack |
| 第 5 章 | 高可靠与数据搬运模块设计 | reliability、FIFO/CDC、AXI |
| 第 6 章 | 预处理与顶层集成设计 | preprocess、cfg/top integration |
| 第 7 章 | 仿真验证与综合分析 | TB、错误注入、综合报告 |
| 第 8 章 | 总结与展望 | 同上 |

## 7. 每章建议插图/表格

| 章节 | 建议图表 |
| --- | --- |
| 第 2 章 | 系统总体框图、时钟域划分图、顶层接口表 |
| 第 3 章 | lane 对齐时序图、packet 解析状态图、ECC/CRC 数据流图、pixel repack 映射表 |
| 第 4 章 | 错误处理流程图、resync/degrade 状态图、FIFO/CDC 结构图、AXI burst 写时序图 |
| 第 5 章 | preprocess 数据通路图、参数说明表、顶层集成连接图 |
| 第 6 章 | 验证矩阵表、关键波形图、错误注入对比表、综合资源表、时序结果表 |

## 8. 建议的论文结果组织方式

### 8.1 必须展示的验证结果

1. lane deskew/reorder 的字节对齐波形
2. short/long packet parser 的 header/payload 提取波形
3. Header ECC 正常/单 bit 错误注入结果
4. Payload CRC 正常/错误注入结果
5. frame/line sync 的 FS/LS/LE/FE 时序
6. RAW8 或 RGB888 的像素输出波形
7. error classifier/logger 的错误统计结果
8. preprocess 的像素调整结果
9. system-level smoke 或 real-top smoke 结果

### 8.2 FPGA/实现章节建议表述

建议写法：

- 已完成 Vivado 工程创建、顶层综合、综合网表导出。
- 已完成基础约束适配与时钟占位设置。
- 实现阶段受限于当前研究型顶层外部 IO 数量较多，需后续为原型板卡重构 FPGA 专用顶层接口。
- 因此本文将 FPGA 结果定位为“综合可行性验证”，而非完整板级实现结论。

## 9. 6 月前必须完成的最小闭环

如果时间非常紧，最少要保证以下 6 项全部完成：

1. 顶层综合通过，综合网表和综合报告齐全。
2. CRC 顶层闭环补上。
3. 真实顶层 system TB 至少跑通 RAW8 一条主链路。
4. 错误注入至少覆盖 ECC、CRC、sync 三类。
5. 论文 6 章或 7 章主体内容写完。
6. 明确写清“已完成内容”和“后续工作”，避免答辩时被追问失分。

## 10. 建议的优先级顺序

按重要性排序：

1. CRC 顶层闭环
2. 真实顶层 TB
3. 论文架构和图表先成型
4. 配置寄存器最小可用闭环
5. RAW10/YUV422 系统级补充
6. AXI 顶层闭环或形成清晰边界说明
7. FPGA 原型顶层重构
8. ASIC 评估脚本细化

## 11. 答辩时的推荐表述

建议你把项目表述为：

“本文完成了一个面向数字 RTL 的 MIPI CSI-2 图像采集前端原型设计，重点实现并验证了包解析、多 lane 对齐、ECC/CRC 检测、帧行同步、像素重组、错误监测与恢复、轻量预处理及基础 AXI 写入模块，并通过模块级仿真、系统级仿真及 Vivado 综合验证了设计的可行性。对于真实板级 D-PHY 接口、完整 DDR 写入调度以及 ASIC 工艺库下的后端实现，本文给出了后续扩展方案。” 

