# Resource, Power, and Latency Optimization Notes

## 1. Conversation Summary

这份对话主要围绕“错误感知的低缓存高可靠图像采集架构”展开。

- 先判断当前 MIPI CSI-2 RX 工程是否达到硕士毕业工作量。结论是：当前系统已经包含 CSI-2 数字接收链路、多 lane 对齐、ECC/CRC、帧行同步、像素重组、AXI 写入、错误恢复、buffer 扫描和 Vivado 结果，工作量是足够的。
- 讨论论文创新点。最稳的表述不是“CSI-2 自动重传”，而是“错误上下文定位、行/帧级错误标记、选择性丢弃与低缓存恢复机制”。
- 明确了行级重采集的前提：普通 MIPI camera 通常不支持标准行重传；RX 端可以产生 retry 请求，但真正重发需要上游图像源或 sensor 控制侧配合。
- 后续实现了 `retry_request_v1`：错误发生后记录 `frame_id / line_id / VC / DT`，通过 APB 暴露最近错误信息，并输出 `retry_req / retry_mode / retry_frame_id / retry_line_id`。
- 讨论并推进了板级工程问题，包括 GitHub 提交、Vivado 资源/时序、AXI sink memory 深度压缩、board IO DRC、bitstream 生成和 timing closure。

因此，这份对话的主线可以归纳为：

```text
错误检测
  -> 错误定位到帧/行
  -> 软件可读/硬件可请求
  -> 行级或帧级恢复策略
  -> 用 buffer、AXI 背压、Vivado 结果量化工程可行性
```

## 2. Current Baseline

### 2.1 Resource Baseline

`timing_cdc_v2` routed implementation:

| Item | Value |
| --- | ---: |
| CLB LUTs | 618 |
| CLB Registers | 1135 |
| BRAM Tile | 0 |
| DSP | 0 |
| Bonded IOB | 77 / 328 |

结论：当前 RTL 面积很小，主要资源不是 BRAM/DSP，而是 LUT/FF、I/O 和若干 FIFO/控制状态机。

### 2.2 Power Baseline

`impl_power.rpt`:

| Item | Value |
| --- | ---: |
| Total On-Chip Power | 0.648 W |
| Dynamic Power | 0.028 W |
| Device Static Power | 0.620 W |
| Clock Power | 0.007 W |
| CLB Logic Power | 0.004 W |
| Signal Power | 0.006 W |
| I/O Power | 0.011 W |

注意：报告提示 I/O activity 缺少真实输入活动率，因此当前功耗更适合作为早期估计，不是最终板级实测功耗。

### 2.3 Latency Baseline

多格式 wrapper 级延迟：

| Format | frame_to_first_pixel | frame_to_end | first_to_last_pixel |
| --- | ---: | ---: | ---: |
| RAW8 | 16 cycles | 34 cycles | 3 cycles |
| RAW10 | 20 cycles | 38 cycles | 3 cycles |
| RGB888 | 18 cycles | 42 cycles | 9 cycles |
| YUV422 | 19 cycles | 40 cycles | 7 cycles |

结论：RAW8 是当前最短路径；RAW10/RGB888/YUV422 的额外延迟主要来自格式整理和打包粒度。

## 3. Resource Saving Improvements

### 3.1 Format Path Pruning

当前工程支持 RAW8、RAW10、RGB888、YUV422。若论文或上板阶段只需要 RAW8/RAW10，可以增加综合参数：

```text
ENABLE_RAW8
ENABLE_RAW10
ENABLE_RGB888
ENABLE_YUV422
```

未启用的 unpacker、format mux 分支和相关控制逻辑不参与综合，可减少 LUT/FF。

### 3.2 FIFO Right-Sizing

已有结果显示：

- `AXI_FIFO_ADDR_WIDTH=3` 是当前更稳妥的最小建议值。
- `AXI_FIFO_ADDR_WIDTH=2` 在连续流压力下出现 timeout/mismatch。
- 增大 `BYTE_FIFO_ADDR_WIDTH` 能吸收更多瞬时积压，但不一定提高最终吞吐。

建议策略：

```text
默认工程配置：AXI_FIFO_ADDR_WIDTH = 3
低资源实验配置：AXI_FIFO_ADDR_WIDTH = 2，但必须专项修复和验证
BYTE FIFO：按实际背压压力选择，不盲目加深
```

### 3.3 Debug Logic Optional

ILA probe、debug bus、详细错误历史寄存器对调试很有用，但最终轻量版本可以参数化关闭：

```text
ENABLE_DEBUG_PROBES = 0
ENABLE_ERROR_HISTORY = 0/1
```

这样可以减少顶层输出、寄存器、debug mux 和相关扇出。

### 3.4 Retry Context Width Reduction

当前 retry/error context 使用较通用的 `frame_id / line_id` 宽度。若目标分辨率固定，可以参数化缩小：

```text
FRAME_ID_WIDTH
LINE_ID_WIDTH
```

例如只需缓存最近 256 帧，可用 8-bit frame id；只需 1080 行，可用 11-bit line id。这样能节约寄存器和比较逻辑。

### 3.5 Sim-Only Memory Removal

对 FPGA wrapper 内部 AXI sink memory，已经做过 `MEM_ADDR_WIDTH=12` 的压缩。后续还可以进一步区分：

```text
simulation wrapper: 保留内部 memory readback
board wrapper: 移除内部 null/memory sink，接真实 AXI/DDR
```

这样上板版本不再综合仿真读回用的存储模型。

## 4. Power Saving Improvements

### 4.1 Clock Enable Gating

当前动态功耗不高，但仍可优化。最直接方向是给空闲模块加 clock enable，而不是每拍都翻转：

- 未启用 lane 的 deskew/reorder 不工作。
- 未选中的 format unpacker 不工作。
- 没有 payload 时 CRC 计算逻辑保持。
- 没有 APB 访问时寄存器读 mux 不频繁切换。

这类优化对 FPGA 上的动态功耗和 ASIC 口径都比较好解释。

### 4.2 Data Valid Gating

很多数据总线只有在 `valid=1` 时才有意义。建议在 RTL 中保持：

```text
valid = 0 时，data 寄存器保持不变
```

不要在无效周期继续更新宽数据总线。这样可以减少 signal toggle。

### 4.3 Lane-Aware Power Control

如果当前配置是 2 lane，就让 lane2/lane3 相关逻辑完全关闭；如果是 1 lane，就只保留 lane0。

这既能节约资源，也能节约功耗。论文里可以表述为：

```text
基于 lane_enable_mask 的活动 lane 门控
```

### 4.4 Realistic Activity-Based Power

当前 power report 的 I/O activity 不完整。建议后续用仿真 VCD/SAIF 重新估计：

```text
RAW8 normal stream
CRC error stream
AXI backpressure stream
multi-frame soak stream
```

这样可以得到“不同场景下功耗”的论文图表，而不是只引用默认静态估计。

### 4.5 I/O Power Constraint Tuning

I/O power 当前约 `0.011 W`。真实板级约束固定后，可以检查：

- IOSTANDARD 是否过高。
- drive strength 是否过大。
- slew rate 是否可以设为 slow。
- debug 输出是否可以减少。

这部分对最终上板功耗更有意义。

## 5. Latency and Processing-Time Improvements

### 5.1 RAW8 Fast Path

RAW8 当前已经是最短路径，但仍可进一步做专用 fast path：

```text
RAW8 payload
  -> 直接像素输出
  -> 绕过不需要的格式选择和复杂 unpack 状态
```

适合做成论文里的“低延迟模式”。

### 5.2 Early Pixel Output

当前不同格式的首像素延迟为 16 到 20 cycles。可以检查 header parse、long packet parser、unpacker 之间是否有不必要的等待。

目标是：

```text
payload 第一个可解像素一到，就尽快输出 pixel_valid
```

尤其 RAW10/RGB888/YUV422 可重点检查是否必须等完整打包组，还是可以更早吐出首个像素。

### 5.3 AXI Writer Command/Data Decoupling

已有 AXI 背压基础结果里，`aw_release_to_fire` 曾达到 `81` 个 `clk_axi` 周期。这说明 AXI 写地址通道仍有优化空间。

可改进方向：

- AW command FIFO 和 W data FIFO 更彻底解耦。
- 提前生成 burst command。
- 行长度对齐 AXI beat。
- 减少等待整行完成后才发起写入的路径。

目标是减少：

```text
frame/line 完成 -> AXI 写启动
AXI ready 释放 -> handshake fire
```

之间的等待。

### 5.4 Error Recovery Time Quantization

文档里已有 `resync_req -> busy -> done -> clear` 链路，但可以进一步量化：

```text
sync error 到 resync_done 周期数
CRC error 到 line discard 完成周期数
retry_req 到 retry_ack 周期数
错误帧到下一 clean frame 周期数
```

这不一定减少硬件延迟，但能把“恢复速度”变成论文可比较指标。

### 5.5 Low-Cache Error Recovery

最值得包装成创新点的处理时间优化是：

```text
错误发生后，不做整机 reset
不等待大量缓存清空
只标记当前行/帧
下一行或下一帧快速恢复
```

如果上游支持重采集，则进一步使用：

```text
retry_frame_id / retry_line_id
```

只请求重采集错误帧或错误行，避免整帧缓存和全链路重启。

### 5.6 4-Lane Throughput Bottleneck Check

已有 soak 结果显示 2 lane 和 4 lane 的 `pix/byte-clk` 指标接近，说明当前小样例下 4 lane 还没有充分转化为吞吐优势。

后续可以检查：

- lane merge 是否成为瓶颈。
- pixel unpack 是否成为瓶颈。
- AXI writer 是否成为瓶颈。
- testbench payload 是否太短，无法体现 lane 数优势。

这可以形成“吞吐瓶颈定位”实验。

## 6. Recommended Priority

建议按下面顺序推进：

1. **先做参数化裁剪**
   - 关闭不用的格式路径、debug probe、仿真 memory。
   - 成本低，最容易看到 LUT/FF 下降。

2. **再做 FIFO 深度选型**
   - 保留 `AXI_FIFO_ADDR_WIDTH=3` 作为稳定基线。
   - 针对 `AXI_FIFO_ADDR_WIDTH=2` 做专项修复和压力验证。

3. **补功耗活动率实验**
   - 用 VCD/SAIF 重新跑 power。
   - 对比 normal/error/backpressure 三类场景。

4. **优化 AXI writer 延迟**
   - 重点减少 AW release 到 fire 的等待。
   - 同时观察资源是否明显增加。

5. **包装低缓存错误恢复创新点**
   - 用行/帧级错误定位 + retry request + clean frame 恢复来证明节约缓存和恢复时间。

## 7. Thesis-Friendly Innovation Statement

可以把后续优化收束成一句论文创新点：

```text
本文设计了一种面向 MIPI CSI-2 图像采集链路的错误感知低缓存恢复架构，
通过帧/行级错误上下文绑定、选择性丢弃与重采集请求机制，
在避免整帧缓存和全链路复位的同时，降低资源占用、动态切换功耗和错误恢复时间。
```
