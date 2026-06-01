# 数字可靠性调研报告（面向 MIPI CSI-2 图像采集前端）

## 1. 文档目的

本文档面向当前仓库的数字 RTL 原型，调研“可靠性”在高速数字接收链路中的常见做法，并结合本项目现状，整理出：

- 哪些可靠性机制是通用且必要的
- 哪些机制已经在本项目中有初步实现
- 哪些机制仍有明显优化空间
- 哪些方向值得优先讨论，但不建议在当前阶段一次性做得过深

本文档先用于方案讨论，不代表立刻进入 RTL 实现。

---

## 2. 调研范围与基本判断

### 2.1 本次调研聚焦范围

本次只看数字逻辑与数字系统层面的可靠性，不涉及真实模拟 D-PHY 电气实现，不涉及板级电源完整性、SI/PI、传感器模拟侧失效，也不以整机功能安全认证为目标。

重点观察以下几类机制：

- CDC 与亚稳态控制
- FIFO / buffer / 数据通路健康监测
- 协议层错误检测与恢复
- 错误事件留痕与可观测性
- 看门狗 / 超时 / 停滞检测
- 降级恢复与故障隔离
- reset / soft-reset / resync 的闭环
- BIST / error injection / 诊断覆盖思路

### 2.2 调研后的总判断

对于本项目这种“多时钟域 + 高速流式数据 + 协议解析 + 缓冲 + DDR 写入”的数字接收链路，可靠性不应只理解为“ECC/CRC 做了没有”，而应分成四层：

1. **检测层**：发现错误，例如 ECC、CRC、illegal sequence、FIFO overflow。
2. **隔离层**：让错误不继续污染后级，例如 drop packet、drop line、flush partial state。
3. **恢复层**：让系统回到已知可工作的状态，例如 resync、soft-reset、lane degrade。
4. **观测层**：让验证和后续寄存器/软件知道发生了什么，例如 event log、counter、context。

从这个角度看，当前仓库已经具备了第一层和部分第二、第三层能力，但第四层和策略统一层仍然偏弱。

---

## 3. 外部调研结论

### 3.1 CDC / 亚稳态是数字可靠性的基础前提

Intel 在其亚稳态白皮书中明确指出：当信号在异步或无关时钟域之间传递时，可能违反寄存器的 setup/hold 要求，从而进入 metastable 状态；系统 MTBF 与同步链设计直接相关。文中还指出，设计者常用两级同步器，而为了更高保护，三极同步链会进一步提高 MTBF，只是要增加延迟。  
来源：

- [Intel metastability white paper](https://cdrdv2-public.intel.com/650346/wp-01082-quartus-ii-metastability.pdf)

AMD 的 `XPM_CDC_GRAY` 资料则进一步说明：对多 bit CDC，灰码同步是标准方法之一，尽管静态 CDC 工具可能将其标成 warning，但灰码总线本身就是为此类跨域设计的。  
来源：

- [AMD XPM_CDC_GRAY](https://docs.amd.com/r/2023.1-English/ug953-vivado-7series-libraries/XPM_CDC_GRAY)

**对本项目的启示：**

- `clk_byte -> clk_sys -> clk_axi` 三域结构下，CDC 不是配角，而是可靠性主线之一。
- 除了数据 FIFO，错误事件、clear/reset 脉冲、状态边沿也必须被当成 CDC 对象认真处理。
- “功能上能跑通”不等于“可靠”，CDC 链的弱点会直接决定整条链路的 MTBF。

### 3.2 CRC / ECC 的价值不只是“发现错了”，而是触发策略

Microchip 在其功能安全与 CRC 资料中都强调：CRC 是数字数据完整性检查的重要机制，常用于发现传输或存储中的隐蔽错误；CRC mismatch 本身就是系统诊断输入，而不应只作为一个旁路状态位。  
来源：

- [Microchip Functional Safety](https://www.microchip.com/en-us/products/microcontrollers/8-bit-mcus/functional-safety)
- [Microchip CRC overview](https://www.microchip.com/en-us/products/microcontrollers/8-bit-mcus/peripherals/safety-monitoring/crc)

对 MIPI CSI-2 协议，Microchip 的接收器文档清楚给出：long packet 包含 packet header、payload 和 16-bit CRC；header 内包含 DI、WC、ECC。  
来源：

- [Microchip PolarFire MIPI CSI-2 Receiver Decoder IP User Guide](https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/ip_cores/directcores/MIPI_CSI2_Receiver_Decoder_IP_UG.pdf)

AMD 的 MIPI CSI-2 RX 产品文档也把 ECC/CRC forwarding、protocol configuration、interrupt/status 单独作为控制器能力的一部分。  
来源：

- [AMD PG232 MIPI CSI-2 RX](https://docs.amd.com/r/5.2-English/pg232-mipi-csi2-rx/MIPI-CSI-2-Receiver-Subsystem-Product-Guide-PG232)

**对本项目的启示：**

- ECC / CRC 检查本身不是终点，真正重要的是“检查结果如何影响 packet、line、frame 和后续写内存行为”。
- 在图像链路里，错误隔离粒度通常至少要区分：packet 级、line 级、frame 级。
- 对 header ECC，后续可以考虑“可纠错与不可纠错分流”；对 payload CRC，当前的“丢当前行”方向是合理的。

### 3.3 reset / soft-reset / resync 是恢复闭环的核心

Intel 关于 CRC error 恢复和配置扰动处理的资料提出一个很重要的工程观点：即使底层检测和纠正机制存在，错误被发现后仍应把系统拉回“known good state”；如果单纯 correction 不足以保证系统状态一致，就应该执行 soft-reset，必要时再进一步重配置。  
来源：

- [Intel recovering from CRC errors](https://www.intel.com/content/www/us/en/docs/programmable/683461/current/recovering-from-crc-errors.html)

**对本项目的启示：**

- 对流式协议接收机来说，恢复不是“计一个数再继续跑”，而是清理 parser partial state、CDC FIFO、pixel unpacker partial state、writer in-flight state。
- `resync` 最理想的目标不是发一个请求脉冲，而是完成一次“有序排空 + 已知状态重建”。
- 当前仓库在这一点上已经走在正确方向上，但还没做到完整的“端到端恢复证明”。

### 3.4 watchdog / timeout 是检测“没按预期发生”的关键机制

Intel 的用户 watchdog 文档把看门狗描述为：用于防止系统在错误状态中无限停滞，若在规定时间内没有被周期性喂狗，则触发超时与恢复流程。Microchip 的功能安全资料也把 WDT / Windowed WDT 视为常见硬件安全特性。  
来源：

- [Intel user watchdog timer](https://www.intel.com/content/www/us/en/docs/programmable/683865/current/user-watchdog-timer.html)
- [Microchip Functional Safety](https://www.microchip.com/en-us/products/microcontrollers/8-bit-mcus/functional-safety)

**对本项目的启示：**

- 当前链路更偏向“发现收到的东西有错”，而不擅长“发现本该收到但没收到”。
- 对协议接收前端而言，timeout / watchdog 非常实用，尤其适合：
  - frame timeout
  - line timeout
  - payload stall timeout
  - FIFO drain timeout
  - resync clear timeout

这些机制几乎都属于纯数字 RTL，成本不高，但对可靠性闭环帮助很大。

### 3.5 功能安全资料强调“诊断接口统一”和“错误注入”

AMD 和 Intel 的功能安全材料都强调两点：

- 错误检测接口应能被统一接出、组合和上报
- 设计中应支持 error injection / self-test / diagnostic coverage 证明

Intel 在 Agilex 功能安全方案里提到 standardized error interface connection、watchdog、RAM ECC、error injection；AMD 的方案也强调 Logic BIST、Memory BIST、Error Injection、Software Test Libraries。  
来源：

- [Intel Agilex functional safety solution brief](https://cdrdv2-public.intel.com/759482/agilex-5-fpgas-e-series-functional-safety-solution-brief.pdf)
- [AMD functional safety solution brief](https://www.amd.com/content/dam/amd/en/documents/products/adaptive-socs-and-fpgas/technologies/xilinx-functional-safety-solution-brief.pdf)

**对本项目的启示：**

- 项目后续不一定要上升到标准化功能安全认证，但“错误接口统一”和“错误注入可验证”这两点非常值得借鉴。
- 这也说明：仅有 counter 不够，还需要结构化 error event 和可重复注入点。

---

## 4. 当前项目可靠性现状评估

### 4.1 已经具备的能力

结合仓库已有 RTL、spec 和 TB，当前工程已经具备以下能力：

#### A. 协议级错误检测

- Header ECC check
- Payload CRC check
- frame/line sync error
- lane deskew overflow / lane error

#### B. 基础策略执行

- bad-ECC long packet 可配置不进入像素路径
- CRC error 可配置丢当前行
- sync error 可触发 resync
- lane error 可触发 degrade/recover

#### C. 恢复闭环的雏形

- `resync` 已可清 parser、sync FSM、unpacker、FIFO、adaptive stats、AXI writer
- AXI writer 已支持 clear 后有序排空

#### D. 基础可观测性

- `err_classifier`
- `err_frame_line_logger`
- per-type counter
- frame/line/VC/DT context
- 单元 TB 覆盖

### 4.2 当前实现的优点

当前工程的可靠性设计有几个明显优点：

1. **不是只有检测，没有动作。**  
   很多学生工程只做到 `err_crc_o` 拉高，这个仓库已经把错误开始接入真实数据路径。

2. **恢复动作考虑了跨域与有序 flush。**  
   这比“直接全局 reset”成熟很多。

3. **可靠性逻辑和 parser / writer / FIFO 之间已经有真实耦合。**  
   说明架构方向是对的。

4. **文档对当前限制写得比较诚实。**  
   这对后续论文和阶段交付是好事。

### 4.3 当前主要薄弱点

当前最明显的短板不在“有没有错误检测”，而在下面几类问题。

#### 4.3.1 事件留痕仍然偏弱

当前 `err_classifier` 在 backpressure 时只保留当前事件，`err_frame_line_logger` 也是 last-event logger，不是深度错误事件 FIFO。

这意味着：

- 多错误密集发生时，软件/寄存器侧只能看到最后一次或最高优先级事件
- 难以做时序追踪
- 不利于系统 TB 和后续板级 bring-up 的问题定位

#### 4.3.2 策略分散，缺统一决策层

现在错误策略分散在多个模块中：

- `packet_error_policy`
- `resync_ctrl_fsm`
- `degrade_recover_fsm`
- top 中的 `line_crc_drop_pending`

这种做法在 P0/P1 阶段是合理的，但继续往下扩时，容易出现：

- 新增错误类型后处理逻辑分散
- 同一错误在不同上下文下策略不一致
- 难以定义“升级规则”，例如连续 CRC error 是否应上升为 frame drop 或 resync

#### 4.3.3 timeout / stall 类检测不足

当前更擅长检测“收到的内容错了”，不够擅长检测“流停止了、状态卡住了、预期事件长时间没来”。

这会导致：

- parser 卡在半包状态时，不一定能被及时发现
- line_end / frame_end 丢失后，可能只能靠后续错误间接暴露
- resync / clear 虽然有流程，但缺少 watchdog 证明其一定完成

#### 4.3.4 恢复条件仍偏局部

当前 `resync` 的 ack 主要依赖 AXI writer clear 路径完成，这已经比之前成熟，但仍偏向“本地通路清干净了”，还不等于“输入侧已回到协议安全起点”。

简单说：

- downstream 清空了，不代表 upstream 已真正重新对齐
- 数字前端在没有 sensor-side 明确信号时，至少还需要 idle / gap / timeout 辅助判断

#### 4.3.5 “好帧”定义偏粗

lane 恢复当前依赖 `good_frame_i`，而“好帧”的定义还比较粗。未来如果引入：

- ECC corrected
- CRC line drop
- AXI bresp error
- FIFO overflow

那么“是否恢复满 lane”最好基于一套 frame quality 评价，而不是单拍级错误有效信号。

---

## 5. 面向本项目的可靠性优化方向

以下不是立即实现清单，而是建议讨论优先级的模块方向。

### 5.1 优先级最高：watchdog / timeout monitor

这是我认为最适合当前项目补强的方向。

建议增加一个或多个轻量监测模块：

- `frame_timeout_monitor`
- `line_timeout_monitor`
- `payload_stall_monitor`
- `resync_timeout_monitor`
- `fifo_drain_timeout_monitor`

核心作用：

- 检测“预期事件未在时限内发生”
- 把“静默停滞”转化成显式 error event
- 为 resync 提供更合理触发条件

为什么优先级高：

- 纯数字 RTL，难度可控
- 与现有架构兼容
- 非常符合高速流式接收链路的可靠性需求

### 5.2 优先级高：统一错误事件 FIFO

建议引入 `err_event_fifo` 或 `fault_history_buffer`：

- 输入：统一的错误事件
- 内容：error type、severity、frame_id、line_id、vc、dt、附加信息
- 输出：寄存器读口或 debug 读口

收益：

- 解决 last-event logger 的信息丢失问题
- 提升系统验证和 bring-up 可观测性
- 为论文里的“高可靠监测与恢复”提供更完整证据链

### 5.3 优先级高：统一策略管理器

建议将现有分散策略收敛成一个 `reliability_manager` 或 `fault_policy_manager`。

它不一定立刻替代全部现有模块，但至少可以做：

- 输入所有 error event
- 根据寄存器策略、上下文和累计条件决定动作
- 输出统一动作：
  - `mark_packet`
  - `drop_packet`
  - `drop_line`
  - `drop_frame`
  - `req_resync`
  - `req_degrade`
  - `capture_halt`

这样做的价值在于：

- 后续加 FIFO error、AXI error、unsupported DT error 时更自然
- 策略文档会比现在清晰
- top 里的零散状态机/标志位会减少

### 5.4 优先级中高：buffer health monitor

建议把以下对象正式纳入可靠性监控：

- async FIFO overflow / underflow
- parser busy 超时
- AXI writer clear 超时
- AXI `bresp` 异常
- discard 次数过多
- line buffer 中止次数

原因很直接：对图像接收系统而言，可靠性不只是协议正确，还包括“数据有没有被可靠地搬到下一级”。

### 5.5 优先级中：frame quality tracker

建议新增 `frame_quality_tracker`，为每帧累计：

- ECC error 次数
- CRC drop line 次数
- sync error 是否出现
- lane error 是否出现
- FIFO / AXI error 是否出现
- 当前帧是否可标记为 clean / degraded / bad

这样可以支持：

- degrade/recover 更稳妥
- 后续统计更有工程意义
- 论文里更容易表述“高可靠恢复策略”

### 5.6 优先级中：header ECC corrector

当前 header ECC 已能 detect / classify，后续可以考虑：

- 若为单 bit 可纠正错误，则直接输出 corrected header
- 同时记一条 corrected event
- 不把所有 header error 一律等同为 unusable packet

这个方向很适合体现“高可靠”而不只是“严格丢弃”。

但它的优先级略低于 watchdog / event FIFO，因为：

- 当前工程先把恢复闭环补稳更重要
- ECC corrector 会引入 parser 语义变化，验证量更大

### 5.7 中后期方向：自检与 error injection 体系化

当前 TB 已有错误注入雏形，后续可继续增强：

- timeout 注入
- lane skew / lane stop 注入
- CRC 与 line_end 交错注入
- AXI backpressure / bresp 注入
- clear/resync 中途插入新数据

如果之后要增强论文或答辩说服力，这一块非常有价值。

---

## 6. 不建议当前阶段优先投入过深的方向

### 6.1 不建议现在就做重型冗余架构

例如：

- TMR 覆盖整个接收链
- 双通道并行 parser 比对
- 全链路 lockstep

这些方案当然能提升可靠性，但对当前毕业设计阶段来说：

- 面积、验证和架构复杂度会急剧上升
- 与当前“逐模块交付”的约束不匹配
- 对论文交付收益不一定高于 watchdog + policy + observability

### 6.2 不建议现在就做完整功能安全认证式设计

例如 FMEDA 全量分析、ASIL/SIL 合规论证、认证文档体系。可以借鉴其理念，但不建议把当前项目目标直接抬到那个层级。

更现实的做法是：

- 借鉴其错误分类、诊断、恢复、error injection 思维
- 保持工程结构清晰，为未来扩展留接口

---

## 7. 结合仓库现状的结论

### 7.1 当前项目已经具备“可靠性框架”

从架构角度说，项目已经不是“只有一个接收器”，而是已经初步具备：

- error detect
- error classify
- error log
- packet / line 级隔离
- resync
- degrade / recover

这说明后续的工作重点不应该是“再补一个简单 error counter”，而是把现在这些能力组织得更系统。

### 7.2 当前最值得增强的是三条主线

如果只选三个方向继续讨论，我建议优先看：

1. **timeout / watchdog 系列**
2. **统一 error event FIFO**
3. **统一 reliability manager**

这三项同时具备以下优点：

- 纯数字 RTL，可综合
- 与现有 top 架构兼容
- 能明显提升“高可靠”含金量
- 便于写 spec、做 testbench、形成阶段性交付

### 7.3 从论文和工程表达上，这样也更好讲

如果后续按这个路线推进，论文中“高可靠”不再只是说：

- 做了 ECC
- 做了 CRC
- 有个 resync FSM

而可以更完整地表述为：

- 基于多层错误检测
- 基于上下文的错误留痕
- 基于策略的 packet/line/frame 级隔离
- 基于 timeout/watchdog 的异常停滞检测
- 基于 resync/degrade 的恢复与退化运行

这会明显更像一个完整系统，而不是若干独立功能块拼起来。

---

## 8. 建议的下一步讨论问题

在不立刻改 RTL 的前提下，我建议我们接下来优先讨论这几个问题：

1. timeout/watchdog 需要覆盖哪些对象  
   是只看 frame/line，还是把 parser/FIFO/AXI clear 也纳入？

2. error event FIFO 需要多深  
   8 条、16 条还是 32 条？是否只做最近事件窗口？

3. 策略管理器的动作粒度怎么定  
   只到 line drop / resync，还是引入 frame drop / halt capture？

4. “好帧”怎么定义  
   只要没有 sync error 就算好，还是要排除 CRC drop/FIFO/AXI 错误？

5. unsupported DT / VC mismatch 是否要正式升格为 error type  
   还是继续只当作 policy 条件处理？

---

## 9. 参考资料

### 协议与接收器相关

- AMD, *MIPI CSI-2 Receiver Subsystem Product Guide (PG232)*  
  [https://docs.amd.com/r/5.2-English/pg232-mipi-csi2-rx/MIPI-CSI-2-Receiver-Subsystem-Product-Guide-PG232](https://docs.amd.com/r/5.2-English/pg232-mipi-csi2-rx/MIPI-CSI-2-Receiver-Subsystem-Product-Guide-PG232)

- Microchip, *PolarFire MIPI CSI-2 Receiver Decoder IP User Guide*  
  [https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/ip_cores/directcores/MIPI_CSI2_Receiver_Decoder_IP_UG.pdf](https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/ip_cores/directcores/MIPI_CSI2_Receiver_Decoder_IP_UG.pdf)

### CDC / 亚稳态 / 灰码同步

- Intel, *Understanding Metastability in FPGAs*  
  [https://cdrdv2-public.intel.com/650346/wp-01082-quartus-ii-metastability.pdf](https://cdrdv2-public.intel.com/650346/wp-01082-quartus-ii-metastability.pdf)

- AMD, *XPM_CDC_GRAY*  
  [https://docs.amd.com/r/2023.1-English/ug953-vivado-7series-libraries/XPM_CDC_GRAY](https://docs.amd.com/r/2023.1-English/ug953-vivado-7series-libraries/XPM_CDC_GRAY)

### watchdog / reset / 功能安全思路

- Intel, *User Watchdog Timer (MAX 10 FPGA Configuration User Guide)*  
  [https://www.intel.com/content/www/us/en/docs/programmable/683865/current/user-watchdog-timer.html](https://www.intel.com/content/www/us/en/docs/programmable/683865/current/user-watchdog-timer.html)

- Intel, *Recovering from CRC Errors*  
  [https://www.intel.com/content/www/us/en/docs/programmable/683461/current/recovering-from-crc-errors.html](https://www.intel.com/content/www/us/en/docs/programmable/683461/current/recovering-from-crc-errors.html)

- Microchip, *Functional Safety With PIC and AVR MCUs*  
  [https://www.microchip.com/en-us/products/microcontrollers/8-bit-mcus/functional-safety](https://www.microchip.com/en-us/products/microcontrollers/8-bit-mcus/functional-safety)

- Microchip, *Cyclic Redundancy Check (CRC/SCAN)*  
  [https://www.microchip.com/en-us/products/microcontrollers/8-bit-mcus/peripherals/safety-monitoring/crc](https://www.microchip.com/en-us/products/microcontrollers/8-bit-mcus/peripherals/safety-monitoring/crc)

- Intel, *Agilex 5 FPGAs D-Series and E-Series: Functional Safety*  
  [https://cdrdv2-public.intel.com/759482/agilex-5-fpgas-e-series-functional-safety-solution-brief.pdf](https://cdrdv2-public.intel.com/759482/agilex-5-fpgas-e-series-functional-safety-solution-brief.pdf)

- AMD, *Functional Safety Solution Brief*  
  [https://www.amd.com/content/dam/amd/en/documents/products/adaptive-socs-and-fpgas/technologies/xilinx-functional-safety-solution-brief.pdf](https://www.amd.com/content/dam/amd/en/documents/products/adaptive-socs-and-fpgas/technologies/xilinx-functional-safety-solution-brief.pdf)

---

## 10. 备注

本文档为讨论稿。后续如果需要继续推进，建议下一版文档拆成两份：

- 一份“可靠性架构 spec”
- 一份“可靠性优化实施计划”

这样能把“调研结论”和“具体改哪些 RTL”分开管理。
