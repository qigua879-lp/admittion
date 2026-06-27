# 基于 MIPI CSI-2 的图像采集系统设计与仿真验证 —— 项目说明书

> 完整毕设版。本说明书系统描述一个 MIPI CSI-2 RX 数字图像采集前端的设计、实现与仿真验证，
> 重点呈现创新点——**单向链路下的行级选择性重采集**。
>
> 红线声明（贯穿全文）：本工程为**数字 RTL 原型**，不含真实模拟 D-PHY 电气；板级已过
> `write_bitstream` DRC 但**时序未收敛、引脚为占位约束**，故**全文不作"已上板/上板验证"表述**。
> 标准 MIPI CSI-2 高速数据链路为单向、无 ACK/NACK，**不作"实现 CSI-2 自动重传"表述**；
> 恢复能力明确归因于"低速反向通道(CCI/I²C) + 可控可重发图像源"这一系统性前提。

---

## 目录

1. 绪论
2. MIPI CSI-2 协议与关键技术基础
3. 系统总体架构
4. 关键模块 RTL 设计
5. 创新点：单向链路下的行级选择性重采集
6. 验证与实验
7. 结论与展望
- 附录 A 寄存器映射 ｜ B 顶层接口 ｜ C 测试用例与结果索引 ｜ D 仿真复现命令

---

# 第 1 章 绪论

## 1.1 研究背景

MIPI CSI-2（Camera Serial Interface 2）是移动与嵌入式视觉领域事实上的图像传感器接口标准，
以 D-PHY/C-PHY 物理层承载高速串行像素流。其典型链路特征是**单向**：传感器（发送端）通过
数据 lane 把帧/行/像素单向推送给接收端（RX），高速数据通道上**没有反向的 ACK/NACK 握手**。
接收端的职责是：物理层适配、多 lane 对齐、包解析、帧/行同步、像素重组，并把像素写入帧缓冲。

## 1.2 问题与动机

单向链路带来一个固有的可靠性短板：当链路出现位错误，接收端通过包头 ECC、载荷 CRC、帧行
时序检查能够**检出**错误，但由于没有反向重传机制，传统接收端对坏数据只有两条退路：

1. **整帧丢弃**：丢掉含坏行的整帧，等待下一帧。对运动视频会产生卡顿/撕裂，且坏帧永久丢失。
2. **整帧重传**（需上游配合）：让上游重发整帧。代价是需要整帧大小的缓存与一帧的恢复时延。

二者的共性缺点是**粒度太粗**：一帧里往往只有极少数行真正出错，却要按整帧付出内存与时延代价。
本项目正是针对这一短板提出更细粒度的恢复方法。

## 1.3 本文工作与创新点

本文在完成 CSI-2 RX 数字前端主链路的基础上，提出并验证一个收窄的、可证伪的研究命题：

> **面向单向 MIPI CSI-2 链路，提出基于错误上下文定位的行级选择性重采集机制，并给出其相比
> "整帧重传 / 整帧丢弃"在内存开销与有效帧率之间取得更优折中的条件与量化边界。**

该命题由三根支柱支撑，对应本文三块工作：

- **机制**（第 5.2/5.3 节）：错误定位 → 重采集请求 → **按行号写回覆盖**的闭环，并推广到多帧。
- **量化边界**（第 5.4 节）：三策略的内存-帧率-时延闭式模型，给出划算边界 ρ=D/H。
- **条件**（第 5.5 节）：单向链路上补出行级恢复的形式化可行性条件 C1–C4。

## 1.4 文档结构

第 2 章铺垫协议与关键技术（含跨时钟域基础）；第 3 章给系统总体架构；第 4 章逐模块描述 RTL
设计（重要模块重墨）；第 5 章是创新点重点章；第 6 章给验证方法与实验结果；第 7 章总结、给出
距离板级的差距与改进方向；附录给寄存器/接口/用例/复现命令。

---

# 第 2 章 MIPI CSI-2 协议与关键技术基础

## 2.1 CSI-2 分层与包结构

CSI-2 在物理层之上定义了低层协议：数据被组织为**短包**与**长包**。

- **短包**（4 字节）：用于帧/行同步事件，数据类型（DT）包括帧起始 FS、帧结束 FE、行起始
  LS、行结束 LE，并携带虚拟通道号 VC。包头含 ECC 校验。
- **长包**：承载实际像素载荷，结构为「包头(4B：DT + 字数 WC + ECC) + 载荷(WC 字节) + 包尾
  CRC16」。DT 标识像素格式（RAW8/RAW10/RGB888/YUV422 等），WC 为载荷字节数。

接收端据此恢复出"帧—行—像素"的层次结构：FS 开帧、若干 (LS + 长包 + LE) 构成各行、FE 收帧。

## 2.2 D-PHY/PPI 接口与本工程的数字抽象边界

D-PHY 是 CSI-2 常用物理层，RX 侧通过 PPI（PHY-Protocol Interface）把模拟前端恢复出的字节流
（每 lane 一路字节 + 同步信号）交给协议层。**本工程聚焦数字逻辑**：以 `phy_digital_adapter`
提供 D-PHY 的**数字抽象输入**（直接吃每 lane 的字节与有效信号），不实现真实模拟电气（CDR、
LP/HS 切换的模拟细节等）。另有 `mipi_dphy_ppi_adapter` 面向 PPI 风格的数字对接。这一边界意味着：
仿真验证可在数字层完整闭环，但接真实摄像头需补真实 D-PHY RX（详见第 7.2 节差距分析）。

## 2.3 跨时钟域（CDC）基础

系统横跨三个时钟域（D-PHY 字节域 `clk_byte`、处理域 `clk_sys`、写入域 `clk_axi`），数据跨域
必须正确处理，否则会触发**亚稳态**：当源端信号恰好在目的端采样沿附近变化，触发器采到一个
既非 0 也非 1、仍在建立的中间电平，若被后续逻辑当真则导致功能错误。本工程采用**分层 CDC 策略**：

- **连续数据流** → **异步 FIFO**：读写指针用**格雷码**（相邻值仅 1 位变化，避免多位同时翻转被
  采到乱码），指针经**两级触发器同步器**跨域，并以 `ASYNC_REG` 属性约束综合，保证 MTBF。
- **准静态配置**（图像宽高、基址、步长等，配置后基本不变）→ **两级电平同步器**直接打拍即可。
- **单拍控制脉冲**（清空/冲刷）→ **toggle 同步器**：把脉冲转成电平翻转再同步、对端边沿检测，
  避免快域脉冲被慢域漏采。

具体实现见第 4.6 节。

## 2.4 错误检测机制

接收端的可观测错误有三类：① **包头 ECC**——对短/长包头做单比特纠错、多比特检错；
② **载荷 CRC16**——对长包载荷做循环冗余校验，检出载荷位错误；③ **帧行时序（sync）检查**——
检测非法的事件次序（如帧内套帧、LS/LE 不配对）。这三类错误是后续可靠性子系统与创新点的输入。

---

# 第 3 章 系统总体架构

## 3.1 总体数据通路

主链路自前向后为：

```
D-PHY 数字适配 → 多 lane 去歪斜/合并 → CSI-2 包解析(ECC/CRC) → 帧行同步 FSM
   → 像素重组(RAW/RGB/YUV) → 轻量预处理(可旁路) → 异步 FIFO(CDC) → AXI 写入 → 帧缓冲
```

旁路其上的是：**配置/状态寄存器（APB）** 与 **可靠性/错误处理子系统**（错误分类、定位记录、
重同步、降级恢复、错误策略，以及创新点的重采集请求与写回闭环）。

## 3.2 时钟域划分与分层 CDC

| 时钟域 | 覆盖范围 | 与相邻域的 CDC |
|---|---|---|
| `clk_byte` | D-PHY 字节流、lane 对齐合并 | byte→sys：异步 FIFO |
| `clk_sys` | 解析、帧行同步、像素重组、预处理、可靠性、寄存器 | sys→axi：写通路内 data/cmd FIFO + 配置两级同步 + 清空 toggle |
| `clk_axi` | AXI 写主机、帧缓冲写入 | — |

## 3.3 APB 配置/状态寄存器接口

`cfg_reg_if_apb` 实现 APB 从机，提供主链路配置（图像宽高、lane 数/掩码、DT/VC、帧基址、行步长、
AXI 突发、错误策略、预处理开关）与状态回读（帧/行计数、各类错误计数、最近错误位置、重采集请求
摘要等）。板级由 `fpga_apb_boot_cfg`（片上 APB 引导序列器）在复位后写入一组启动配置，避免把 APB
总线引出封装引脚。寄存器映射见附录 A。

## 3.4 可靠性与错误处理子系统总览

该子系统把 2.4 节的三类错误转化为带上下文的事件并施加策略：

- `err_classifier`：分类 ECC/CRC/sync/lane 错误，绑定 frame_id / 帧内行号 / VC / DT，并计数。
- `err_frame_line_logger`：锁存最近一次错误的完整上下文，供软件读最近错误位置。
- `resync_ctrl_fsm`：sync 错误后清状态、等下一帧**重新对齐**（注意是重新对齐，不是重传）。
- `degrade_recover_fsm`：lane 异常降级，多帧后恢复。
- `packet_error_policy`：坏 ECC 长包标记、CRC 坏行丢弃请求。
- `retry_request_ctrl` + `recapture_writeback_ctrl`：**创新点载体**，第 5 章详述。

---

# 第 4 章 关键模块 RTL 设计

> 约定：与创新点/CDC 强相关的模块（4.3 帧行同步、4.6 异步 FIFO、4.7 AXI 写入、4.8 可靠性）
> 重墨；其余模块给功能与接口要点。

## 4.1 D-PHY 数字适配与多 lane 对齐合并

- `phy_digital_adapter` / `mipi_dphy_ppi_adapter`：把每 lane 的数字字节与有效/同步信号整理为
  统一的内部 lane 字节流，提供 HS/LP 模式数字抽象与 lane 就绪握手（`phy_lane_ready`）。
- `lane_deskew_buffer`：吸收多 lane 之间的到达歪斜（skew），按可配置深度对齐各 lane，使合并时
  同一字节边界对齐。深度是吞吐/容歪斜能力的折中（验证中做了深度扫描，见 6.2）。
- `lane_reorder_merge`：按 lane 使能掩码与 lane 数，把对齐后的各 lane 字节**合并**成单路字节流，
  供下游解析。支持 1/2/4 lane 配置闭环。

## 4.2 CSI-2 包解析（ECC/CRC）

- `csi2_short_packet_parser` / `csi2_long_packet_parser`：从字节流中切分短/长包，抽取 DT、VC、
  WC、载荷与包尾。
- `csi2_header_ecc_checker`：对包头做 ECC（单纠多检），输出纠错后的包头与 ECC 错误事件。
- `csi2_payload_crc_checker`：对长包载荷做 CRC16，输出 CRC 错误事件。
  这两者产生的错误事件是可靠性子系统与重采集机制的触发源。

## 4.3 帧行同步 FSM（重点）

`frame_line_sync_fsm`（`clk_sys`）是把"包事件"翻译成"帧/行结构"的核心状态机：

- 输入短包事件（DT/VC），按 FS/FE/LS/LE 维护 `frame_active` / `line_active`，并产生 `frame_start`
  / `frame_end` / `line_start` / `line_end` 单拍脉冲。
- 计数：`frame_cnt`（帧计数）、`line_cnt`（**自由计数**，跨帧累加，仅复位/清零时归零）。
- **非法次序检测**：FS 套 FS、无帧时 LS、LS/LE 不配对等会拉 `sync_error`。
- **帧内行号 `line_in_frame`（本文新增，多帧推广关键）**：在 FS 复位为 0、每个 LS 自增（帧内
  1 基）。它与 `line_cnt` 的区别是**每帧复位**——这正好对应"按帧复位的写缓冲槽位"。
  错误路径的行号由 `line_cnt` 改接 `line_in_frame`，使重采集在第 2 帧及以后也能把坏行映射到
  正确的帧内槽（详见 5.3）。首帧 `line_in_frame == line_cnt`，故对既有首帧逻辑零影响。

## 4.4 像素重组

`raw8_unpack` / `raw10_unpack` / `rgb888_unpack` / `yuv422_unpack`：按 DT 把长包载荷字节解包为
统一的像素数据（含 SOF/SOL 标记），供预处理与写入。RAW10 处理打包字节边界，YUV422/RGB888 处理
分量排布。验证对四种格式均做了 smoke + metrics 用例（见 6.2）。

## 4.5 轻量预处理与 adaptive_v1

- `brightness_adjust` / `contrast_adjust` / `gray_balance`：逐像素亮度/对比度/灰度平衡调整。
- `preprocess_bypass_mux`：预处理可整体旁路（不影响主链路功能验证）。
- `adaptive_v1`（`pixel_frame_stats_v1` + `adaptive_preprocess_ctrl_v1`）：对当前帧做像素统计
  （均值等），据此算出**下一帧**的系数（AWB / 范围拉伸），形成帧间自适应。属加分功能，非主线。

## 4.6 异步 FIFO 与 CDC 实现（重点）

`async_fifo`（参数化 `DATA_WIDTH`/`ADDR_WIDTH`）是数据通路 CDC 的核心，实现标准格雷码指针异步
FIFO：

- 写域 `clk_wr`、读域 `clk_rd` 各维护二进制指针并转格雷码；**跨域只传格雷码指针**，经两级
  `(* ASYNC_REG="TRUE", SHREG_EXTRACT="NO" *)` 触发器同步。
- `full` 由写域比较「写格雷指针」与「同步过来的读格雷指针」的"满判据"（高两位取反）得到；
  `empty` 由读域比较读格雷指针与同步过来的写格雷指针得到。
- 数据写入/读出本地 RAM，数据本身不跨域同步（读出时该格早已写稳）。
- 提供 `wr_level`/`rd_level` 余量观测，支撑背压与深度扫描。

应用：`clk_byte→clk_sys` 用一个 `async_fifo`；`clk_sys→clk_axi` 在写入模块内部用 data/cmd FIFO
（见 4.7）。准静态配置与清空脉冲分别用两级同步与 toggle 同步（见 4.7、2.3）。

## 4.7 AXI 写入通路（重点）

`pixel_to_axi_writer` 把像素流写入帧缓冲，并完成 `clk_sys→clk_axi` 的 CDC 与地址生成：

- **CDC**：像素数据与写命令经内部异步 FIFO 跨入 `clk_axi`；准静态配置（`frame_base_addr`、
  `line_stride`、`max_burst_len`、`enable`）经两级同步（`cfg_*_meta_q → cfg_*_axi_q`）；
  清空请求经 toggle 同步（`clear_req_toggle_sys → 同步 → 边沿检测`）。
- **地址生成**：行写地址 = `frame_base + line_stride × 槽位`，槽位由内部**按帧复位**的行计数器
  （`sys_line_id_q`，0 基）给出；行计数到达图像高度则丢弃越界行。
- **重采集写回端口（本文新增）**：`recap_active_i` / `recap_line_id_i`。当其有效时，写地址改由
  `recap_line_id` 指定、**不推进行计数器、不触发高度丢弃**，从而把重采行**覆盖**到坏行原槽。
  默认 0 时完全等价于原通路（零回归）。
- 辅助：`addr_gen_frame_based`、`axi_burst_gen`、`axi_write_master`、`mem_map_ctrl` 完成突发切分
  与 AXI 写主机时序；`axi_write_null_slave` 是带回读存储的内部 AXI sink（验证用，可逐字节回读校验）。

## 4.8 可靠性模块（重点）

- `err_classifier`：把 ECC/CRC/sync/lane 错误分类并绑定 `frame_id / line_in_frame / VC / DT`，
  输出带优先级的错误事件并对各类错误计数。
- `err_frame_line_logger`：锁存最近一次错误上下文 → `LAST_ERR_FRAME/LINE` 等寄存器。
- `resync_ctrl_fsm`：sync 错误后清状态、等下一帧重新对齐（**重新对齐 ≠ 重传**）。
- `degrade_recover_fsm`：lane 异常时降级，多帧后恢复。
- `packet_error_policy`：坏 ECC 长包打标、CRC 坏行发出丢弃请求（与重采集配合：先丢坏行、再覆盖）。
- `retry_request_ctrl` + `recapture_writeback_ctrl`：创新点载体，第 5 章详述。

---

# 第 5 章 创新点：单向链路下的行级选择性重采集

## 5.1 问题定义与命题收窄

如 1.2 节所述，单向链路对位错误只有"整帧丢弃"与"整帧重传"两条粗粒度退路，而一帧中通常只有
极少数行真正出错。本文把贡献收窄为一个**可证伪命题**：在保留高速数据链路单向性的前提下，借助
系统中已存在的低速控制反向通道（CCI/I²C）传回"重采请求 + 行定位"，并以可控可重发图像源为前提，
实现**行级**的选择性重采集，并给出其相对整帧策略更优的**条件**与**量化边界**。

> 术语守界：本机制不是链路级 ARQ，**不声称"CSI-2 自动重传"**；"重发"的执行主体是上游可控源，
> 不是 CSI-2 链路。`resync` 是重新对齐，`retry` 是请求 + 定位 + 写回。

## 5.2 机制设计：定位 → 请求 → 写回覆盖闭环

机制由三段构成：

1. **错误定位**（已有可靠性子系统）：`err_classifier` 在坏行出现时绑定 `frame_id / line_in_frame
   / VC / DT`，`packet_error_policy` 对 CRC 坏行发出丢弃请求（坏行不写、留空槽）。
2. **重采集请求**（`retry_request_ctrl`）：错误有效时锁存上下文，输出一拍 `retry_req` 并置
   `retry_pending`，区分帧级/行级模式（`retry_mode`），由 `ack` 清除 pending。寄存器侧给出
   `RETRY_STATUS/FRAME/LINE` 供软件读取请求位置。
3. **写回覆盖闭环**（`recapture_writeback_ctrl`，本文新增）：这是把"只发请求"推进到"真的恢复"的
   关键。其要点：
   - **三重门控**：`recap_active = retry_pending && retry_line_mode && src_recap_line_valid`。
     即"有未决的行级请求"且"可控源正在重发该行"时才武装写回，拒绝杂散脉冲。
   - **写地址语义**：把写回的目标槽交给 `pixel_to_axi_writer` 的 `recap_line_id`，使重采行
     **按行号寻址、不推进行计数器、不触发高度丢弃**——从而**覆盖坏行原槽**，而非朴素重发落到下一槽。
   - **行号基转换**：定位行号取自帧行同步的帧内行号（帧内 1 基），而写缓冲槽位 0 基，写回控制按
     `recap_line_id = retry_line_id − 1` 映射到目标槽，并在重采行收尾拉 `retry_ack` 清 pending。

闭环时序：坏行 → CRC 丢弃（留空槽）→ 定位置 pending → 可控源重发该行并拉 `src_recap` →
写回覆盖原槽 → `retry_ack` 清 pending。

## 5.3 多帧推广：帧内行索引

朴素实现存在一个隐患：帧行同步的 `line_cnt` 是**跨帧自由计数**（FS 不复位），而写缓冲槽位
**按帧复位**，于是 `retry_line_id − 1` 的映射**只在第一帧成立**；第 2 帧起 `line_cnt = H + 帧内
行号`，映射错位。解决办法是在帧行同步 FSM 增设**帧内行号 `line_in_frame`**（FS 复位、LS 自增），
并把错误路径行号由 `line_cnt` 改接 `line_in_frame`（首帧等价、零回归）。这样定位行号与写缓冲槽位
同基，重采集对**任意帧**都把坏行映射到正确槽。该改造对应 5.5 节可行性条件 C4 在 RTL 上的闭合。

## 5.4 量化模型：内存-帧率-时延与划算边界 ρ=D/H

设每行 L 字节、每帧 F = H·L 字节、行/帧周期 T_l/T_f，单行残余失效概率 p、整帧含坏行概率
p_f = 1−(1−p)^H，往返窗口跨越行数 D = ⌈τ_rt/T_l⌉，链路带宽余量系数 h。三策略闭式：

| 指标 | A 行级重采 | B 整帧重传 | C 整帧丢弃 |
|---|---|---|---|
| 额外内存 | **D·L** | F (=H·L) | 0 |
| 维持满帧率所需余量 | 1/(1−p) ≈ 1+p | 1/(1−p_f) ≈ 1+Hp | 不适用（丢帧） |
| 永久丢帧 | 0 | 0 | p_f ≈ Hp |
| 恢复时延 | D·T_l | T_f (=H·T_l) | ≤ T_f |

**核心边界**：以往返跨度比 **ρ = D/H** 统一三项差异——内存比、时延比均为 ρ。行级相对整帧重传
**省 H/D 倍**内存与时延；当 ρ ≪ 1 且 p 小到 `h ≥ 1/(1−p)` 可满足时，行级严格更优；当 D→H（源只能
按帧粒度缓存/重发）退化为整帧重传。代表数值（1920×1080 RAW10、D=8）：内存 18.75 KiB vs 2.47 MiB
≈ 省 135×；恢复时延同比。模型脚本 `tools/recapture_model.py`（含 T3/T4 实测交叉核对与 D 扫描）。

## 5.5 可行性条件（单向链路如何补出行级恢复）

把"单向链路本无重传、却能补出行级恢复"的前提形式化为四个条件：

- **C1 上游行缓存**：源须保留坏行直到请求到达，缓存深度 `B_src ≥ D+1`，对应额外内存 ≈ D·L。
- **C2 请求时间窗（活性）**：`τ_det + τ_bc ≤ B_src · T_l`，即"检出 + 反向通道时延"须落在源缓存
  覆盖的时间窗内；否则请求落在窗口外、该行丢失。
- **C3 链路带宽余量**：`h ≥ 1/(1−p)`（整帧重传需 `h ≥ 1/(1−p_f) ≈ 1+Hp`，行级需求约小 H 倍）。
- **C4 帧内行索引与幂等写回**：须以帧内行号定位、写回对坏行槽恰好覆盖一次（5.3 已在 RTL 闭合）。

**可行性命题**：单向 CSI-2 数据链路外加低速反向通道、且上游为可控可重发源时，若 C1–C4 成立，则
可恢复每个可丢弃的单行错误，额外内存 ≈ D·L、恢复时延 = D·T_l，且与帧高 H 无关。其三条**退化边界**
（D→H ⇒ 退化为整帧重传；无反向通道/源不可重发 ⇒ 只能整帧丢弃；h<1/(1−p) ⇒ 过载）恰好对应第 6.4
节的三条基线，使命题可被实验证伪。守红线：恢复能力归因"反向通道 + 可控源"，不归因链路重传。

---

# 第 6 章 验证与实验

## 6.1 验证方法与平台

采用 SystemVerilog testbench，分**模块级**与**系统级（wrapper）**两层，配 scoreboard、参考模型
（`csi2_reference_helpers`）、传感器/相机激励模型与带回读存储的内部 AXI sink。系统级用例直接驱动
`fpga_wrapper`/`recap_wrapper`（自启动 APB 引导 + 内部 AXI 存储，可层次化回读校验）。仿真器为
Vivado xsim 2017.3（`xvlog`/`xelab`/`xsim`）。

## 6.2 功能验证矩阵

- 模块级：ECC/CRC/短包/长包解析、帧行同步、四种像素重组、亮度/对比度/灰度平衡、自适应统计、
  异步 FIFO、AXI 写主机、错误分类/记录、resync、错误策略、重采集请求、APB 寄存器、boot 配置等。
- 系统级：RAW8/10、RGB888、YUV422 的 smoke + metrics；ECC/CRC/sync 错误注入；lane skew 容忍/溢出；
  resync 恢复/重复错误；AXI 背压/内存闭合；1/2/4 lane 配置闭环。
- 参数化扫描：buffer 深度扫描、lane skew 扫描、lane/buffer 敏感性、RAW8 背压 stress、soak 吞吐。

## 6.3 闭环验证：行级闭环与多帧重采集

- **单帧闭环**（`tb_recapture_line_level_closed_loop`）：单帧 RAW8、line2 注 CRC 坏行 → 丢弃
  (slot2 留空) → 行级定位 → 可控源重发 → **写回覆盖**。结果：`slot2 由 0 → 11 22 33 44（==slot0
  干净）`，pending 经 ack 清除。**PASS**。
- **多帧**（`tb_recapture_multiframe`）：先发整帧干净（帧 1），帧 2 的 line2 注错。判别性证据：定位
  行号 = **3（帧内 1 基，而非自由计数 7）**，写回槽 = 2，槽被覆盖干净。**PASS**——证明跨帧成立。

## 6.4 对比实验：A/B/C 三基线（升级为"优于 Y/Z"）

`tb_recapture_strategy_compare` 在**同一注错场景**下实测三策略（runner 按模块名 elaborate）：

| 策略 | 恢复传输量 | 上游缓存(行) | 是否恢复 | 备注 |
|---|---:|---:|:--:|---|
| A 行级重采 | 18 B（1 行）| 1（=D） | ✅ | 只重发坏行 |
| B 整帧重传 | 152 B（8 行）| 8（=H） | ✅ | 重发整帧 |
| C 只丢不重采 | 0 | 0 | ❌ 永久丢失 | 无恢复 |

内存比 A:B = 1:8 = D:H，与 5.4 模型 ρ=D/H **精确吻合**；A/B 可恢复而 C 永久丢失。诚实边界：恢复
时延绝对比实测约 2.1×（小于模型 8×），因仿真背靠背、无帧间空闲；"A<B"定性一致，绝对比随链路利用率
变化（已在模型假设说明）。

## 6.5 设计空间扫描与 C2 时间窗边界

- **D 扫描**（runner `tb_strat_a_d1/d2/d4`）：实测 `buffer_lines = D`，而 A 的恢复流量恒为 1 行，
  印证"行级只重发坏行"；模型给出 ρ=D/H 划算边界（D<H 优、D→H 退化为 B）。
- **C2 边界**（`tb_recapture_window_limit`）：一帧内 line3 与 line5 连续出错、其间不重采，单次重采。
  结果：单未决请求只保留最近（line5）→ line5 恢复、**line3 丢失（slot3 留空）**。这是可行性条件 C2
  的仿真对应——注错快于服务则旧行落在可恢复窗口之外。**PASS**。

## 6.6 综合与可实现性（含板级差距，诚实标注）

- 已生成 bitstream，`write_bitstream` DRC = 0 Errors，`impl_drc.rpt` Violations = 0，NSTD-1/UCIO-1
  已清零，并有验收脚本与留痕。
- **时序未收敛**：`WNS = −3.398 ns`。**LOC/IOSTANDARD 为实验占位版（无真实原理图）**。
- 因此**本工程不作"已上板/上板验证"结论**；当前结论是"数字前端 RTL 主体完成、系统级仿真闭环、
  具备 FPGA 可实现性评估"。距离真正板级测试的差距详见 7.2。

---

# 第 7 章 结论与展望

## 7.1 工作总结

完成了一个 MIPI CSI-2 RX 数字采集前端的设计与系统级仿真验证，并在其上提出、实现、验证了**单向
链路下的行级选择性重采集**：机制（定位→请求→写回覆盖闭环 + 多帧推广）、量化边界（三策略闭式 +
ρ=D/H，仿真与模型互证，省 H/D 倍内存/时延）、可行性条件（C1–C4 + 三退化边界，与三基线对应）。
相对整帧策略，在 ρ≪1 且误码可承受时，行级以约 1/8（本实验 H/D）的内存/时延代价达到等效恢复，
且不像"只丢"那样永久丢失。

## 7.2 局限与距离板级的差距

如实列出距离真正"上板测试"的差距（不可写"已上板"）：

1. **时序收敛**：`WNS=−3.398 ns` 未收敛，需定位关键路径（128bit AXI、格雷码组合、长解析链）做
   插流水/重定时/约束细化。
2. **真实约束**：占位 LOC/IOSTANDARD 需按真实原理图替换；补 `create_clock`、`set_input/output_delay`，
   **以及给 CDC 同步器补 `set_false_path`/`set_max_delay`**（当前可能缺，与时序未收敛或相关）。
3. **真实 D-PHY 前端**：现仅数字抽象输入；接真摄像头需真实 D-PHY RX（硬 IP / CSI-2 RX 子系统 / 桥）。
4. **真实后端 DDR**：现写内部 sink 存储；上板需真实 DDR 控制器 + AXI 互联并过 DDR 时序。
5. **重采集的板级前提**：需真有"可控可重发源 + 反向通道(CCI/I²C)"；普通 sensor 不按行重发，否则
   板级只能演示帧级。
另含真实时钟生成（MMCM/PLL）、复位上电序列、ILA 板级观测与 bring-up 流程。

## 7.3 改进方向（围绕重采集）

1. **多深度未决请求队列**：把单未决请求扩成小队列，突发多坏行可全部恢复，把 C2 边界外推。
2. **自适应策略切换**：以片上误码计数 + ρ=D/H 判据，运行时在行级/整帧重传/只丢之间自动切换，
   把量化模型变成在线控制器。
3. **真实反向通道实现**：把请求接到 I²C/CCI 主控真去触发源端重读，补成完整系统闭环。
4. **帧缓冲地址管理**：加帧地址/双缓冲，多帧重采不互相覆盖。
5. **与前向纠错(FEC)互补对比**：在行载荷上加轻量 FEC 以减少"需要重采"的次数（带宽换往返），在
   模型中与重采集对比，给出新的折中边界。
6. **验证增强**：补 SVA 断言与功能覆盖率，强化重采集协议的形式化验证（提升论文严谨度）。

---

# 第 8 章 板级实施方案

> 本章给出从当前"仿真闭环 + 可综合"到真正板级测试的硬件选型、连接方案、实施路线与预算。
> 守红线：板级未收口前不作"已上板"表述；4-lane 维持"仿真已验 + 能力可配"，板级按实际 lane 数说明。

## 8.1 硬件选型与清单

平台必须为 **Xilinx（Zynq / UltraScale+）**——因为 `mipi_dphy_ppi_adapter` 是按 AMD MIPI D-PHY
RX IP 的 PPI 接口实现的。最终选型（¥5 万预算内，实花约 ¥2 万）：

| 角色 | 型号 | 订货号 | 数量 | 价格(约) |
|---|---|---|---|---|
| RX 主板（本设计实现载体）| Digilent Genesys ZU-5EV（Zynq UltraScale+ ZU5EV）| 410-383-5EV | 1 | ¥1.6–1.8 万 |
| 可控 MIPI 发送端（重采集硬件演示）| Digilent Zybo Z7-20（Zynq-7020）| 410-351-20 | 1 | ¥2.8–3.2 k |
| 真实相机（数据源）| Digilent Pcam 5C（OV5640，2-lane MIPI CSI-2）| 410-358 | 1 | ¥0.5–0.7 k |
| 配件 | 电源 ×2、micro-USB、microSD、反向通道杜邦线 | — | — | ¥0.5 k |
| 可选 | 第 2 个 Pcam 5C（演示多相机/VC，Genesys 有 2 个 MIPI 口）| 410-358 | (1) | (+¥0.5 k) |

**选型理由**：① Genesys ZU-5EV 原生 MIPI D-PHY + DDR4 + UltraScale+ 大资源，一次消除 7 系列
MIPI 娇气/资源紧/lane 受限等硬伤，且 Digilent 生态、有 Pcam 参考设计、自定义 RTL 友好；
② 第二块板提供"可控可重发源"，把创新点从仿真验证升级到**硬件演示**；③ 真相机验证 RX 主链路
端到端落地。

## 8.2 系统连接

两条数据路径共用 RX 主板：

**路径 1 —— 真实采集（验证 RX 主链路）**
```
Pcam 5C → Genesys 板载 MIPI D-PHY RX IP（输出 PPI）→ mipi_dphy_ppi_adapter
        → lane 对齐/解析/帧行同步/像素重组 → AXI → PS DDR4
```

**路径 2 —— 双板重采集闭环演示（验证创新点）**
```
 Zybo(TX, 可控源) ──① MIPI 数据(含坏行)──▶ Genesys(RX, 本设计)
        ▲                                        │② 检出CRC坏行→定位→retry_req
        │③ 反向通道(GPIO/I²C)"重发第k行"          │
        └──────④ 重发干净第k行 ───────────────────┘⑤ 写回覆盖坏行槽→读DDR核对
```
- **可控发送端**：Zybo 编程为 MIPI CSI-2 发送器，发已知测试帧、可注入坏行、并**响应"重发第 k 行"**。
- **反向通道**：两板间几根 GPIO 或一条 I²C，承载重采请求（即 T5 的 CCI/I²C 反向通道前提）。
- 普通相机不可控、不响应重发，故重采集闭环必须用可控源演示——此即 §5.5 可行性条件 C1–C2 的硬件实现。

## 8.3 板级实施路线（从现状到上板）

1. **工程切器件**：Vivado part 切到 Genesys ZU-5EV（XCZU5EV，封装/速度从 Digilent board file 取），挂 board file。
2. **真实约束**：基于 Digilent 主 XDC 写真实时钟（板载振荡器）、MIPI/Pcam 引脚 LOC/IOSTANDARD、
   DDR4 约束，并给 CDC 同步器补 `set_false_path`/`set_max_delay`（第 7.2 节差距 ②）。
3. **时序收敛**（T6）：跑实现、读时序报告、对关键路径（128bit AXI / 格雷码组合 / 长解析链）插
   流水或重定时，迭代至 WNS≥0。
4. **真 D-PHY 接入**：实例化 Genesys 的 MIPI D-PHY RX IP，PPI 接到 `mipi_dphy_ppi_adapter`。
5. **真 DDR4 后端**：用 PS DDR4 / MIG 替换仿真 sink，过 DDR 接口。
6. **真相机采集**：接 Pcam 5C，验证端到端 RX（路径 1）。
7. **双板重采集演示**：Zybo 配可控 TX + 反向通道，跑路径 2，读 DDR 核对坏行恢复。

> 其中 4/5/6 的功能正确性可先在仿真侧用更真实模型预验（行为级 D-PHY 错误注入、AXI-VIP/MIG 仿真），
> 与器件无关、降低板级风险。

## 8.4 预算分配与边界

- 实花约 ¥2 万 / ¥5 万预算，余量 ¥3 万留给 4-lane 升级或意外。
- **4-lane 边界**：仿真已验（1/2/4 lane 配置闭环）；Pcam 5C 为 2-lane、板级演示 2-lane；真要
  4-lane 上板需 4-lane MIPI 源 + 4-lane 通道（如 FMC 4-lane MIPI 采集卡，约 ¥1 万内），列为按需追加。
- **不采购**：MIPI 协议分析仪等高价实验室设备（远超本项目需求）。

---

# 附录

## 附录 A 寄存器映射（节选）
见 `03_interface_tables/register_map.md`。关键新增：`LAST_ERR_FRAME/LINE`、`RETRY_STATUS/FRAME/LINE`；
`ERR_POLICY` 位含 enable_retry(5)、retry_line_mode(6)、drop_on_crc(2)。

## 附录 B 顶层接口
见 `03_interface_tables/接口表格及说明.md` 与 `08_reference_docs/spec/top_io.md`。

## 附录 C 测试用例与结果索引
- 闭环：[recapture_line_level_closed_loop_results.md](../05_simulation_results/结果验证/recapture_line_level_closed_loop_results.md)
- 多帧：[recapture_multiframe_results.md](../05_simulation_results/结果验证/recapture_multiframe_results.md)
- 三基线：[recapture_strategy_compare_results.md](../05_simulation_results/结果验证/recapture_strategy_compare_results.md)
- 设计空间/C2：[recapture_design_space_results.md](../05_simulation_results/结果验证/recapture_design_space_results.md)
- 模型与条件：[line_level_recapture_model.md](line_level_recapture_model.md)、[unidirectional_recapture_feasibility.md](unidirectional_recapture_feasibility.md)
- 总入口：[行级重采集_工作总结与索引.md](行级重采集_工作总结与索引.md)

## 附录 D 仿真复现命令（要点）
```
# 分析全设计 + 目标 TB（filelist 见 04_tb_tests/compile.f）
xvlog -sv -i <rtl> -i <tb> -f files_abs.f <tb>.sv
xelab <tb> -s snap && xsim snap -R
# 三策略 runner（参数用 RTL wrapper 绑定，避免本机 Vivado 对 '=' 的解析问题）
xelab tb_strat_line_a -s a && xsim a -R   # 同理 frame_b / drop_c / a_d1 / a_d2 / a_d4
```

