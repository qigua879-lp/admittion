# 系统加固验证：DDR 延迟/背压模型 + D-PHY 错误注入

> 目的：把"系统"二字做满——主链路此前只对"理想 AXI sink（永远就绪）"和"干净 PPI 输入"
> 闭环过；本轮补上**真实感内存行为**与**PHY 层错误指示**两类现实工况。

## 1. DDR 延迟/背压闭环（tb_axi_ddr_latency_closure）

### 模型

[axi_ddr_latency_model.sv](../../04_tb_tests/tb/models/axi_ddr_latency_model.sv)——
与 `axi_write_null_slave` 同语义的可回读存储，外加 DDR 控制器风格行为：

| 参数 | 含义 | 本次取值 |
|---|---|---|
| `AW_DELAY_CYCLES` | 地址接受延迟（bank 打开/命令队列） | 8 |
| `W_FIXED_STALL_CYCLES` + LFSR | 每拍固定 + 伪随机 wready 反压（刷新/调度） | 2 + ~25% |
| `B_DELAY_CYCLES` | 写响应延迟（提交） | 12 |

模型输出 `aw/w/b` 压力计数器，TB **断言压力真实施加**（三者均 >0），防止"配置失效导致假通过"。

### 场景与结果

TB 直接实例化 `mipi_csi2_capture_top`（显式 `AXI_DATA_WIDTH=128`），**通过真实 APB 接口配置**
（TB 做 APB 主机，无 force），单帧 RAW8 4 行经模型写入后逐字节回读：

```text
PASS: tb_axi_ddr_latency_closure lines=4 aw_stall=36 w_stall=12 b_delay=48
```

- 4 个行槽全部字节精确（`11/22/33/44`）；
- 压力计数 aw=36 / w=12 / b=48，三类延迟/反压全部真实施加；
- 零协议错误、零丢行事件——异步 FIFO + AXI 写主机在真实内存行为下不丢不错。

### 过程发现（诚实记录）

首版 TB 未显式传 `AXI_DATA_WIDTH=128`（top 默认 32），128 位模型对 32 位主机产生 Z 选通，
数据错乱——**是 TB 参数失配，不是 RTL 缺陷**；修正后一次通过。`axi_write_master` 的 W 通道
数据保持（wready 反压直通上游 FIFO）经 mid-burst 随机 stall 实测正确。

## 2. D-PHY PPI 错误注入（tb_mipi_csi2_capture_dphy_error_inject）

对 `mipi_csi2_capture_dphy_wrapper` 注入 PHY 层现实工况：

| 场景 | 注入 | 预期 | 结果 |
|---|---|---|---|
| SoT 错误 | HS 进入时 `dl0_errsoths` 脉冲 | `dphy_err_sot_hs_o` 观测到 | ✅ |
| SoT sync 错误 | 帧间 `dl0_errsotsynchs` 脉冲 | `dphy_err_sot_sync_hs_o` 观测到 | ✅ |
| valid 间隙 | 长包内每字节组间插 2 拍 `rxvalidhs=0`（真实 D-PHY 字节流非背靠背） | 帧照常解析 | ✅ |
| 错误后恢复 | 事件后再发干净帧 | 流恢复、像素正确 | ✅ |

```text
PASS: tb_mipi_csi2_capture_dphy_error_inject pixels=8 sot=1 sot_sync=1 gaps_ok=1 recovery_ok=1
```

关键断言：PHY 层错误指示**不污染协议解析**（ECC/CRC/sync 全零），两帧 8 像素全部正确。

## 3. 意义

- 主链路的闭环证据从"理想外设"升级到"带延迟/反压的内存 + 带错误指示/间隙的 PHY 输入"；
- 为板级集成（真实 DDR 控制器 / 真实 D-PHY RX IP）预演了接口行为契约；
- 仿真器：Vivado xsim 2017.3。
