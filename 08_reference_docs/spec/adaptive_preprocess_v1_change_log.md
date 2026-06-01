# Adaptive Preprocess V1 Change Log

## 文档目的

本文档用于集中记录本次 `adaptive_v1` 图像预处理版本迭代的全部代码修改，覆盖：

1. 修改背景
2. 修改文件清单
3. 新增模块功能
4. 顶层集成变化
5. 接口与寄存器变化
6. 验证与自检结果
7. 边界条件与已知限制
8. 后续迭代建议

本文档对应 Git 提交：

- `37ec011 Add adaptive preprocess v1 statistics and control`

对应 Git 分支：

- `codex/adaptive-preprocess-v1`

## 1. 修改背景

在原有工程中，预处理链路已经具备以下基础模块：

- `brightness_adjust`
- `contrast_adjust`
- `gray_balance`
- `preprocess_bypass_mux`

但原版本存在两个明显特点：

1. 预处理系数基本固定为恒等变换，只保留了 bypass 结构。
2. 系统没有对原始像素流做在线统计，因此无法根据图像内容自动决定增强策略。

为满足“根据原始图像参数进行自适应图像优化”的需求，本次迭代新增 `adaptive_v1` 子版本，目标是：

- 在不推翻现有预处理链路的前提下增量扩展；
- 复用已有像素流接口和基础处理模块；
- 保持默认行为不变，避免破坏现有顶层与测试；
- 实现“上一帧统计，下一帧生效”的低风险自适应策略。

## 2. 本次修改文件清单

### 2.1 新增文件

| 路径 | 类型 | 作用 |
| --- | --- | --- |
| `rtl/preprocess/adaptive_v1/README.md` | RTL 说明 | 说明 `adaptive_v1` 子目录职责、范围和限制。 |
| `rtl/preprocess/adaptive_v1/pixel_frame_stats_v1.sv` | RTL | 逐帧统计原始像素参数。 |
| `rtl/preprocess/adaptive_v1/adaptive_preprocess_ctrl_v1.sv` | RTL | 根据统计结果生成 AWB 与线性拉伸系数。 |
| `tb/tests/tb_pixel_frame_stats_v1.sv` | testbench | 对逐帧统计模块进行自检。 |
| `tb/tests/tb_adaptive_preprocess_ctrl_v1.sv` | testbench | 对自适应系数控制模块进行自检。 |
| `docs/spec/preprocess_adaptive_v1_notes.md` | 文档 | 说明 `adaptive_v1` 的功能、接口、验证与限制。 |
| `docs/spec/adaptive_preprocess_v1_change_log.md` | 文档 | 本次所有修改的集中变更说明。 |

### 2.2 修改文件

| 路径 | 类型 | 修改内容 |
| --- | --- | --- |
| `rtl/top/mipi_csi2_capture_top.sv` | RTL | 集成自适应统计与控制路径，扩展 APB 控制与状态寄存器。 |
| `rtl/preprocess/README.md` | 文档 | 补充 `adaptive_v1` 目录说明。 |
| `sim/vcs/compile.f` | 仿真 filelist | 增加新增 RTL 文件。 |
| `sim/vcs/run_smoke.sh` | 仿真脚本 | 增加新增模块 smoke 测试。 |
| `sim/vcs/run_regression.sh` | 仿真脚本 | 增加新增模块回归测试。 |
| `docs/spec/top_integration_notes.md` | 文档 | 补充顶层预处理链与 APB 控制变化。 |
| `docs/spec/regression_plan.md` | 文档 | 补充新增模块测试项。 |

## 3. 代码结构层面的变化

### 3.1 新建版本化目录

本次没有直接改写原有 `rtl/preprocess/` 下的基础模块，而是新建：

```text
rtl/preprocess/adaptive_v1/
```

这样做的目的：

1. 保持原有稳定模块不被破坏。
2. 明确这是一次独立的版本演进，而不是对旧逻辑的无边界叠改。
3. 方便后续继续扩展 `adaptive_v2`、`adaptive_v3`。
4. 对答辩、周报和 git 历史都更友好。

### 3.2 原有预处理链的复用方式

本次没有新增一整条全新的复杂预处理流水，而是复用已有模块：

- `brightness_adjust`
  - 复用为自动线性拉伸执行单元
- `gray_balance`
  - 复用为自动白平衡执行单元
- `contrast_adjust`
  - 在本版本中保留位置，但配置为 identity pass-through
- `preprocess_bypass_mux`
  - 保留为原始流/处理流选择器

这种方式的优点是：

- 代码变更局部化
- 验证成本低
- 保持接口一致
- 符合“逐模块交付”的项目约束

## 4. 新增模块说明

## 4.1 `pixel_frame_stats_v1`

文件：

- [pixel_frame_stats_v1.sv](/C:/Users/qigua/OneDrive/Desktop/MIPI%20ALL/rtl/preprocess/adaptive_v1/pixel_frame_stats_v1.sv:1)

### 4.1.1 功能

该模块对统一 `24-bit pixel stream` 做逐帧统计，输出：

- `pixel_cnt`
- `mean_r`
- `mean_g`
- `mean_b`
- `luma_min`
- `luma_max`
- `dark_cnt`
- `bright_cnt`

### 4.1.2 设计意图

该模块是“根据原始图像参数决定后续优化算法”的基础。没有它，就无法知道：

- 图像整体偏亮还是偏暗
- RGB 三通道是否失衡
- 图像动态范围是否过窄
- 暗部/亮部饱和是否明显

### 4.1.3 输入输出风格

复用现有系统中的像素流接口：

- `pixel_valid_i`
- `pixel_ready_i`
- `pixel_data_i[23:0]`
- `pixel_sof_i`

附加控制接口：

- `enable_i`
- `clear_i`
- `pixel_format_i[2:0]`
- `frame_end_i`

### 4.1.4 像素格式处理策略

本模块支持的统计语义如下：

| 像素格式 | 统计解释 |
| --- | --- |
| `RAW8` | 将 `pixel_data_i[7:0]` 视为单通道亮度 |
| `RAW10` | 将 `pixel_data_i[9:2]` 视为调试亮度 |
| `RGB888` | 分别统计 `R/G/B`，亮度取三通道平均 |
| `YUV422` | 当前仅以 `Y` 作为亮度统计，色度不参与自适应决策 |

### 4.1.5 工作机制

采用“帧内累计、帧尾锁存”的结构：

1. 像素流进入时按格式提取统计样本。
2. 帧内持续累加均值相关量与 min/max。
3. 在 `frame_end_i` 到来时锁存本帧统计结果。
4. 下一帧由控制模块消费该结果，形成新的处理系数。

### 4.1.6 边界条件

- 统计模块不主动对像素流施加 backpressure。
- 若 `enable_i=0`，则停止统计。
- 若 `clear_i=1`，则同时清除运行中统计与锁存值。
- 若某帧像素数为 0，则不更新有效统计输出。

## 4.2 `adaptive_preprocess_ctrl_v1`

文件：

- [adaptive_preprocess_ctrl_v1.sv](/C:/Users/qigua/OneDrive/Desktop/MIPI%20ALL/rtl/preprocess/adaptive_v1/adaptive_preprocess_ctrl_v1.sv:1)

### 4.2.1 功能

根据上一帧统计量，生成下一帧要使用的：

- 自动白平衡增益 `awb_gain_r/g/b`
- 自动线性拉伸系数 `stretch_gain`
- 自动线性拉伸偏置 `stretch_bias`

### 4.2.2 设计意图

该模块把“统计量”转换成“可驱动现有预处理模块的控制量”，是连接图像内容分析与图像增强执行的桥梁。

### 4.2.3 白平衡策略

采用简化的 gray-world 思路：

```text
target_mean = (mean_r + mean_g + mean_b) / 3
gain_ch = target_mean / mean_ch
```

然后转成现有预处理链使用的 Q1.7 增益格式，并做上下限钳位。

### 4.2.4 自动拉伸策略

根据亮度范围：

```text
range = luma_max - luma_min
gain  = 255 / range
bias  = -(luma_min * gain)
```

再根据当前 `brightness_adjust` 的数据格式限制，转成：

- `stretch_gain_o[7:0]`
- `stretch_bias_o[8:0]`

### 4.2.5 工作方式

- 在 `stats_valid_i` 有效时更新系数。
- 更新后的系数保存为寄存器值。
- 后续帧使用该系数。

也就是说，本版本采用的是：

```text
Frame N statistics -> Frame N+1 coefficients
```

而不是同帧闭环。这种做法更稳妥，也更容易综合和验证。

### 4.2.6 边界条件

- 若某功能关闭，则输出 identity 系数。
- 若全局 adaptive 关闭，则所有输出回到 identity。
- 若亮度动态范围太小，则不做 aggressive stretch。
- 若输入均值为 0，则采用保护性饱和策略。

## 5. 顶层修改说明

文件：

- [mipi_csi2_capture_top.sv](/C:/Users/qigua/OneDrive/Desktop/MIPI%20ALL/rtl/top/mipi_csi2_capture_top.sv:89)

## 5.1 新增内部信号

顶层新增了三类信号：

1. 自适应配置位
   - `cfg_adaptive_enable`
   - `cfg_adaptive_awb_enable`
   - `cfg_adaptive_stretch_enable`

2. 统计结果信号
   - `stats_pixel_cnt`
   - `stats_mean_r/g/b`
   - `stats_luma_min/max`
   - `stats_valid`

3. 自适应系数信号
   - `adaptive_awb_gain_r/g/b`
   - `adaptive_stretch_gain`
   - `adaptive_stretch_bias`

## 5.2 新增 APB 控制位

原先 `APB_ADDR_CTRL = 0x0000` 只有：

- bit0 preprocess bypass
- bit1 resync enable
- bit2 degrade enable

现在扩展为：

- bit0 preprocess bypass
- bit1 resync enable
- bit2 degrade enable
- bit3 adaptive preprocess global enable
- bit4 adaptive AWB enable
- bit5 adaptive stretch enable

这样设计的目的：

- 保持原有控制寄存器风格不变
- 不引入新的顶层端口
- 保留默认关闭行为

## 5.3 新增 APB 只读状态寄存器

本次新增：

- `0x0024`：当前 adaptive gain 汇总
- `0x0028`：统计得到的 `mean_r / mean_g`
- `0x002c`：统计得到的 `mean_b / luma_min / luma_max`

这些寄存器的意义：

- 便于软件侧观察 adaptive 结果
- 便于 testbench 和 bring-up 时读取统计信息
- 便于后续做硬件在线调参

## 5.4 预处理链结构变化

原链路：

```text
pixel_repack -> brightness -> contrast -> gray_balance -> bypass_mux
```

修改后结构：

```text
pixel_repack
  -> pixel_frame_stats_v1    (只观察，不反压)
  -> brightness_adjust       (用于 auto stretch)
  -> contrast_adjust         (本版保持 identity)
  -> gray_balance            (用于 auto AWB)
  -> preprocess_bypass_mux
```

## 5.5 对原有模块的使用变化

### `brightness_adjust`

- 原本是固定 identity 配置
- 现在在 adaptive stretch 有效时加载自动生成的 gain/bias
- 否则 bypass

### `gray_balance`

- 原本是固定 identity 配置
- 现在在 adaptive AWB 有效时加载自动生成的三通道 gain
- 否则 bypass

### `contrast_adjust`

- 本次保留实例，但 `bypass_i=1`
- 用于给下一版本保留固定的链路位置

## 6. 原始图像点提取方式的工程化落实

本次修改实际上也回答并落实了“原始数据图像点如何提取”这个问题。

工程中的提取位置已经明确为：

```text
CSI-2 payload byte stream
  -> raw8/raw10/rgb888/yuv422 unpack
  -> unified 24-bit pixel stream
  -> pixel_frame_stats_v1
```

也就是说，本次不是直接在 lane 级或 packet header 级做图像分析，而是在：

- 协议解析完成后
- 像素重组完成后
- 得到统一像素流之后

再做统计。这是当前工程最合理、风险最低、语义最清晰的提取点。

## 7. 接口一致性说明

本次修改严格遵守了当前仓库的接口和命名风格：

- 时钟：`clk_sys`
- 复位：`rst_n`
- valid/ready：`xxx_valid_i/o`、`xxx_ready_i/o`
- 数据：`xxx_data`
- 计数器：`xxx_cnt`

并且没有新增顶层外部端口，只在顶层内部添加逻辑与 APB 占位寄存器映射。

## 8. testbench 与验证修改说明

### 8.1 新增 testbench

#### `tb_pixel_frame_stats_v1.sv`

验证内容：

- RGB888 逐帧统计
- RAW8 逐帧统计
- `dark_cnt` / `bright_cnt`
- `clear_i` 清零行为

#### `tb_adaptive_preprocess_ctrl_v1.sv`

验证内容：

- AWB 增益方向是否合理
- stretch gain/bias 是否合理
- 局部 enable 是否生效
- 全局 disable 是否退回 identity
- `clear_i` 是否恢复 identity

### 8.2 更新仿真 filelist

文件：

- [compile.f](/C:/Users/qigua/OneDrive/Desktop/MIPI%20ALL/sim/vcs/compile.f:1)

新增：

- `rtl/preprocess/adaptive_v1/pixel_frame_stats_v1.sv`
- `rtl/preprocess/adaptive_v1/adaptive_preprocess_ctrl_v1.sv`

### 8.3 更新 smoke / regression 脚本

文件：

- [run_smoke.sh](/C:/Users/qigua/OneDrive/Desktop/MIPI%20ALL/sim/vcs/run_smoke.sh:1)
- [run_regression.sh](/C:/Users/qigua/OneDrive/Desktop/MIPI%20ALL/sim/vcs/run_regression.sh:1)

新增测试项：

- `tb_pixel_frame_stats_v1`
- `tb_adaptive_preprocess_ctrl_v1`

## 9. 已执行的验证结果

本次在本地执行并通过的验证包括：

1. `tb_pixel_frame_stats_v1`
2. `tb_adaptive_preprocess_ctrl_v1`
3. `tb_brightness_adjust`
4. `tb_gray_balance`
5. `tb_contrast_adjust`
6. `tb_mipi_csi2_capture_top` lane2 RAW8
7. `tb_mipi_csi2_capture_top` lane2 RGB888
8. `mipi_csi2_capture_top` compile-only

说明：

- 由于当前环境为 Windows PowerShell，本地没有 `bash`，仓库里的 `run_smoke.sh` 没有直接运行。
- 但相关测试已经通过 `iverilog + vvp` 手工执行验证。

## 10. 边界条件说明

本次设计中特别限制了 adaptive 的适用范围：

### 10.1 AWB 只对 `RGB888` 生效

原因：

- 当前 `RGB888` 是真实的三通道像素语义
- `RAW8/RAW10` 不是彩色三通道
- `YUV422` 当前只是调试式展开，不是完整 ISP 色彩空间处理

### 10.2 Stretch 只建议对 `RGB888/RAW8` 生效

原因：

- `RAW8` 可视为单通道灰度亮度
- `RGB888` 可直接做每通道统一拉伸
- `RAW10/YUV422` 当前顶层的 24-bit debug pixel 语义不适合直接做这一版自适应增强

### 10.3 `contrast_adjust` 本版本未参与自适应控制

原因：

- 为了限制版本风险
- 当前线性 stretch 已能覆盖主要的动态范围扩展需求
- 后续若加入 gamma、局部对比度增强或 tone mapping，可继续复用该位置

## 11. 已知限制

1. 本版本是 frame-based adaptation，不是 line-based 或 tile-based adaptation。
2. 统计结果对下一帧生效，不是当前帧闭环即时生效。
3. 没有实现复杂 ISP 级功能，如去噪、边缘增强、gamma LUT、局部直方图均衡。
4. 没有新增 line buffer，因此不涉及 3x3 空域滤波。
5. 顶层 APB 仍然是 placeholder，不是完整 `cfg_reg_if`。
6. `RAW10` 和 `YUV422` 的自适应处理被刻意限制，避免错误语义扩展。

## 12. 与项目约束的一致性说明

本次修改符合 `AGENTS.md` 中的关键约束：

- 只实现数字逻辑，不涉及模拟 D-PHY
- 使用 Verilog/SystemVerilog
- DUT 与 testbench 严格分离
- 低有效复位 `rst_n`
- 逐模块迭代交付，没有一次性推翻整个工程
- 优先保证正确性、可验证性和接口一致性
- 对新增模块补充了注释、接口说明和自检 testbench
- 未擅自改变顶层接口风格和时钟域划分

## 13. 后续建议

基于当前 `adaptive_v1`，后续建议按以下顺序继续演进：

1. `adaptive_v2`
   - 增加 `gamma_lut`
   - 引入更自然的非线性亮度增强

2. `adaptive_v3`
   - 增加 `mean_filter_3x3` 或 `median_filter_3x3`
   - 引入 line buffer，支持轻量去噪

3. `adaptive_v4`
   - 增加 tile-based statistics
   - 支持局部亮度和局部对比度调节

4. 与完整寄存器接口结合
   - 把 adaptive 统计量和阈值完整映射到 `cfg_reg_if`
   - 支持软件可调阈值和模式切换

## 14. 本次交付总结

本次 `adaptive_v1` 的核心成果不是简单“多加了两个模块”，而是把图像预处理从：

```text
固定系数的静态预处理
```

推进到了：

```text
基于原始像素统计的帧级自适应预处理
```

并且整个过程保持了以下特性：

- 顶层默认行为不变
- 旧代码可复用
- 新代码边界清晰
- 测试可落地
- 文档可追踪
- 方便继续版本演进

