# 三策略基线对比 — 仿真实测 vs 模型（T3）

## 目的

交接文档 §4 的 T3：在**同一注错场景**下，对比行级重采集与基线策略，给出
“有效恢复 / 内存占用 / 恢复延迟”的量化差异，并与 T1 模型相互印证——把
“我做了 X”升级为“X 在某条件下优于 Y、Z”。

## 方法

参数化测量 TB `04_tb_tests/tb/tests/tb_recapture_strategy_compare.sv`，
同一帧（RAW8，H=8 行 × 4 像素）固定在 line3 注入 CRC 坏行，切换三种策略，
直接从仿真测量**恢复传输量 / 上游缓存 / 是否恢复 / 恢复延迟**。
DUT = `mipi_csi2_capture_recap_wrapper`（含 AXI sink memory 回读）。

- A（行级重采，STRATEGY=1）：只重发坏行，写回覆盖该槽。
- B（整帧重传，STRATEGY=2）：出错后重发整帧。
- C（只丢不重采，STRATEGY=0）：坏行 CRC 丢弃，不恢复。

运行（本机 Vivado arg 解析对 `=` 处理有问题，故用 RTL runner wrapper 绑定参数，
`04_tb_tests/tb/tests/tb_recapture_strategy_runners.sv`，按模块名直接 elaborate）：

```
# 同时分析 compare TB 与 runners，再分别 elaborate 三个 runner
xvlog -sv -f <filelist> tb_recapture_strategy_compare.sv tb_recapture_strategy_runners.sv
xelab tb_strat_line_a  -s a && xsim a -R   # A 行级重采
xelab tb_strat_frame_b -s b && xsim b -R   # B 整帧重传
xelab tb_strat_drop_c  -s c && xsim c -R   # C 只丢不重采
```

## 实测结果（xsim 2017.3）

| 策略 | 恢复传输量 | 上游缓存(行) | 是否恢复出正确帧 | 恢复延迟 |
|---|---:|---:|:--:|---:|
| **A 行级重采** | 18 B（1 行）| **1**（=D）| ✅ | 1551 ns |
| **B 整帧重传** | 152 B（8 行 + FS/FE）| **8**（=H）| ✅ | 3321 ns |
| **C 只丢不重采** | 0 | 0 | ❌（永久丢失）| — |

实测 METRIC 行（可复现）：
```
METRIC strategy=1 label=A_line_recapture   recovery_bytes=18  buffer_lines=1 recovered=1 recovery_latency_ns=1551
METRIC strategy=2 label=B_frame_retransmit recovery_bytes=152 buffer_lines=8 recovered=1 recovery_latency_ns=3321
METRIC strategy=0 label=C_discard          recovery_bytes=0   buffer_lines=0 recovered=0 recovery_latency_ns=-1
```

## 与 T1 模型相互印证

模型在同一几何（H=8，D=1，RAW8）下的预测（`python tools/recapture_model.py --width 4 --height 8 --bpp 1 --rt-lines 1`）：

| 量 | 模型 A | 模型 B | 模型比 A:B | 实测比 A:B | 结论 |
|---|---:|---:|:--:|:--:|---|
| 额外内存 | 4 B (1 行) | 32 B (8 行) | **1:8 (ρ=D/H)** | 1:8（缓存行数）| **精确吻合** |
| 恢复传输量 | 1 行 | 1 帧(8 行) | ~1:8 | 9:76 群组 ≈ 1:8.4 | 吻合（B 多 FS/FE 开销）|
| 能否恢复 | A/B 可，C 永久丢 | — | — | A/B recovered=1，C=0 | 吻合 |

**核心结论（可证伪命题成立）**：在 ρ=D/H=1/8 的工作点，行级重采集相比整帧重传
**省 8× 上游缓存、约 8× 恢复流量**，且与“只丢不重采”不同——它能恢复出正确帧。
这正是 T1 §3 命题“ρ≪1 时行级严格更优”的仿真实证。

## 诚实边界

- **恢复延迟的绝对比**实测 2.1×（1551 vs 3321 ns），小于模型的 8×（T_l:T_f）。
  原因：仿真为**背靠背**发送（无帧间空闲），B 的重传紧接首帧，恢复点落在重传帧的
  line3；模型按帧周期 T_f 计延迟（含链路空闲）。**延迟的“A<B”定性结论一致**，绝对比
  随链路利用率变化——这一差异已在模型假设 §5 中说明。
- 当前为**单注错点**实测（验证 per-event 代价结构）；多 BER 扫描的曲线由 T1 模型给出，
  本实测为其代价基元（每次恢复 = 1 行 vs 1 帧；缓存 = D·L vs F）提供仿真锚点。
- 守红线：B/C 为对比基线；A 的“重发坏行”仍以“可控图像源前提”表述，不声称标准链路重传。

## 后续

- T4：扫 D 与注错密度，定位 ρ=D/H 的“划算/不划算”交叉边界（含请求窗口外被拒的 D 边界演示）。
- 多帧推广：当前行号基转换仅首帧成立，多帧需帧内行索引（见 recapture_writeback_ctrl 注释）。
