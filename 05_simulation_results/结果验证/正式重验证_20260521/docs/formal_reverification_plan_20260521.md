# 仿真正式重验证实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 重新验证当前交付包中的仿真验证内容，形成可追溯的日志、Markdown 表格和正式波形截图证据链。

**Architecture:** 使用 `iverilog/vvp` 批量重跑所有可执行 SystemVerilog testbench，并使用 Vivado 2017.3 `xsim` 对论文候选波形重新建 snapshot 与截图。结果集中保存到 `05_simulation_results/结果验证/正式重验证_20260521/`，再用 Markdown 总表索引每条证据。

**Tech Stack:** PowerShell、Icarus Verilog (`iverilog/vvp`)、Vivado 2017.3 (`xvlog/xelab/xsim`)、Markdown。

---

### Task 1: 建立正式重验证输出结构

**Files:**
- Create: `05_simulation_results/结果验证/正式重验证_20260521/verification_run_summary.md`
- Create: `05_simulation_results/结果验证/正式重验证_20260521/wave_capture_summary.md`
- Create: `05_simulation_results/结果验证/formal_reverification_summary_20260521.md`

- [ ] **Step 1: 创建输出目录**

Run:

```powershell
New-Item -ItemType Directory -Force -Path "05_simulation_results/结果验证/正式重验证_20260521/logs","05_simulation_results/结果验证/正式重验证_20260521/waves","05_simulation_results/结果验证/正式重验证_20260521/tables"
```

Expected: 目录存在，后续仿真日志、截图和表格都写入该目录。

### Task 2: 批量重跑 testbench

**Files:**
- Create: `02_vivado_project_and_sim/scripts/run_formal_reverification_20260521.ps1`
- Read: `02_vivado_project_and_sim/sim/vcs/compile.f`
- Read: `04_tb_tests/tb/tests/*.sv`
- Read: `04_tb_tests/tb/top/tb_mipi_csi2_capture_top.sv`

- [ ] **Step 1: 生成绝对路径 filelist**

Use `02_vivado_project_and_sim/sim/vcs/compile.f` as source, remap:

```text
rtl/... -> 01_source_code/rtl/...
tb/...  -> 04_tb_tests/tb/...
+incdir+rtl -> +incdir+<repo>/01_source_code/rtl
+incdir+tb  -> +incdir+<repo>/04_tb_tests/tb
```

- [ ] **Step 2: 对每个 testbench 执行 compile/run**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File "02_vivado_project_and_sim/scripts/run_formal_reverification_20260521.ps1"
```

Expected: 每个 testbench 都生成 `compile.log`、`run.log`、`*.out` 和汇总表；若失败，在表格中保留失败项和日志路径。

### Task 3: 重新生成正式波形截图

**Files:**
- Read: `02_vivado_project_and_sim/vivado/build_one_xsim_snapshot.ps1`
- Read: `02_vivado_project_and_sim/vivado/capture_one_xsim_wave.ps1`
- Read: `02_vivado_project_and_sim/vivado/formal_wave_tcl/*.tcl`
- Create: `05_simulation_results/结果验证/正式重验证_20260521/waves/*.png`

- [ ] **Step 1: 建立独立 Vivado 工作区**

Create `C:\temp\admittion_formal_20260521` with directory junctions:

```text
rtl -> <repo>/01_source_code/rtl
tb  -> <repo>/04_tb_tests/tb
sim -> <repo>/02_vivado_project_and_sim/sim
```

- [ ] **Step 2: 对每个正式波形用 Vivado XSim 重建 snapshot 并截图**

Targets:

```text
RAW8 main path
CRC error
ECC error
resync recovery
lane skew overflow
AXI backpressure
resync clean frame
```

Expected: 每个 target 在 `waves/` 下产生 PNG，并在 `wave_capture_summary.md` 中记录 snapshot、Tcl、日志和截图路径。

### Task 4: 生成统一 Markdown 表格

**Files:**
- Modify: `05_simulation_results/结果验证/formal_reverification_summary_20260521.md`
- Create: `05_simulation_results/结果验证/正式重验证_20260521/tables/testbench_results.md`
- Create: `05_simulation_results/结果验证/正式重验证_20260521/tables/topic_evidence_matrix.md`

- [ ] **Step 1: 从仿真日志提取 `PASS:` / `RESULT:` 行**

Expected: 表格字段包含 testbench、类别、验证对象、状态、关键结果、日志路径。

- [ ] **Step 2: 建立主题证据矩阵**

Expected: 每个结果主题都有对应 testbench、重跑日志、Markdown 表格和可用波形截图。

### Task 5: 完成核对

**Files:**
- Read: `05_simulation_results/结果验证/*.md`
- Read: `05_simulation_results/结果验证/正式波形/README.md`

- [ ] **Step 1: 核对所有结果主题是否有新证据**

Run:

```powershell
Get-ChildItem "05_simulation_results/结果验证/正式重验证_20260521" -Recurse
```

Expected: 能看到日志、表格和波形截图。

- [ ] **Step 2: 记录限制**

If any testbench or wave capture fails, record exact command, exit code, and log path in the summary. Do not silently omit failed items.
