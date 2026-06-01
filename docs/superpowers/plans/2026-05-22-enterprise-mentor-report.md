# Enterprise Mentor Report Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 生成一份面向企业导师的 `MIPI CSI-2数字逻辑RX端设计及仿真验证说明.md` 初稿，突出我已完成的内容、接口、仿真验证过程和当前可交付材料。

**Architecture:** 以现有接口说明、仿真说明、验证总报告和正式重验证结果为基础，重新组织成学生口吻的阶段性交付说明。正文按“完成内容对比、接口、仿真方法、结果、不足、交付材料”展开，仿真验证结果先展示 7 张正式波形图，再展示覆盖全部 testbench 的总表。

**Tech Stack:** Markdown、现有 `.md` 结果文档、正式波形 PNG、PowerShell 文件检查。

---

### Task 1: 收集写作素材

**Files:**
- Read: `docs/superpowers/specs/2026-05-22-enterprise-mentor-report-design.md`
- Read: `03_interface_tables/接口表格及说明.md`
- Read: `02_vivado_project_and_sim/工程介绍.md`
- Read: `04_tb_tests/TB测试说明.md`
- Read: `05_simulation_results/verification_master_report.md`
- Read: `05_simulation_results/结果验证/正式重验证_20260521/tables/testbench_results.md`

- [ ] **Step 1: 核对设计说明**
- [ ] **Step 2: 整理接口总表与分表来源**
- [ ] **Step 3: 整理 7 张正式波形图路径**
- [ ] **Step 4: 整理全部 testbench 的模块、功能与结果摘要**

### Task 2: 生成企业导师版正文

**Files:**
- Create: `MIPI CSI-2数字逻辑RX端设计及仿真验证说明.md`

- [ ] **Step 1: 写简要说明与预期/完成对比**
- [ ] **Step 2: 写主要完成内容与接口说明**
- [ ] **Step 3: 写仿真与验证方法**
- [ ] **Step 4: 插入 7 张正式波形图**
- [ ] **Step 5: 写全部 testbench 总表**
- [ ] **Step 6: 写关键结果对比、当前不足与可交付材料**

### Task 3: 完成检查

**Files:**
- Read: `MIPI CSI-2数字逻辑RX端设计及仿真验证说明.md`

- [ ] **Step 1: 检查结构是否符合设计说明**
- [ ] **Step 2: 检查波形图路径是否存在**
- [ ] **Step 3: 检查 testbench 总表是否覆盖全部正式重验证条目**
