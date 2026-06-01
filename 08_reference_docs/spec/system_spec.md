# system_spec.md

## 1. System Goal
构建一个面向数字 RTL 的 MIPI CSI-2 高速高可靠图像采集前端系统，实现从数字化 lane 字节流输入，到 CSI-2 包解析、像素重组、缓存、AXI/DDR 写入、基础预处理与错误监测的完整链路。

## 2. Scope
### In scope
- D-PHY 数字抽象
- CSI-2 short/long packet 解析
- 多 lane 对齐与重排序
- Header ECC / Payload CRC 检测
- 帧/行同步
- RAW8 / RAW10 / RGB888 / YUV422 像素重组
- 错误统计、重同步、降级恢复
- FIFO/CDC
- AXI DDR 写入
- 轻量预处理
- TB、错误注入、scoreboard
- Vivado 原型脚本

### Out of scope
- 真实模拟 D-PHY
- 自研 DDR PHY
- 复杂 ISP 全流程
- 最终流片级 signoff

## 3. Clock Domains
- clk_byte：lane 字节流接收域
- clk_sys：协议处理域
- clk_axi：AXI 主接口域
- clk_ddr：DDR 控制域

## 4. Main Data Path
lane_data -> phy_digital_adapter -> csi2_rx_core -> pixel_repack_core -> buffer_cdc_subsys -> axi_ddr_writer -> DDR
同时：
csi2_rx_core / reliability_monitor 输出调试和错误状态
preprocess_core 可以插在 pixel_repack_core 之后，支持旁路

## 5. Key Functional Blocks
### 5.1 cfg_reg_if
参数配置、状态读取、错误计数器读取

### 5.2 phy_digital_adapter
对接桥接后的数字输入，提供 HS/LP 抽象状态、同步字节检测、lane 数据适配

### 5.3 csi2_rx_core
- SoT/EoT 检测
- lane deskew / merge
- short/long packet parser
- header ECC
- payload CRC
- 帧/行同步

### 5.4 pixel_repack_core
- 按数据类型重组像素
- 统一内部像素总线格式
- 输出 frame/line markers

### 5.5 reliability_monitor
- 错误分类
- 错误帧/行记录
- 丢弃/标记/重同步策略
- 降级与恢复

### 5.6 buffer_cdc_subsys
- async FIFO
- line buffer
- flow control

### 5.7 axi_ddr_writer
- burst 写
- 地址生成
- 帧映射

### 5.8 preprocess_core
- brightness/contrast
- gray balance
- optional 3x3 filter
- bypass

## 6. Error Policy Overview
- ECC error：记录、计数、可配置标记或丢包
- CRC error：记录、计数、可配置丢行或标记
- Sync error：触发重同步 FSM
- Lane align error：标记并尝试恢复
- 所有错误都应绑定 frame_id / line_id / vc / dt

## 7. Initial Priorities
P0:
- system spec
- reusable TB skeleton
- ECC/CRC reference
- short/long packet parser
- frame/line sync

P1:
- lane deskew / merge
- pixel repack RAW8 / RGB888
- async FIFO

P2:
- RAW10 / YUV422
- reliability monitor
- AXI writer

P3:
- preprocess
- Vivado Tcl
- ASIC assessment scripts

## 8. Coding Rules
- synchronous RTL only
- rst_n active-low
- parameterizable widths when practical
- no magic numbers without localparam
- one module, one clear responsibility
