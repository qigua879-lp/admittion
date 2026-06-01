# RAW8 Lane Configuration Results

## Purpose

本文件用于补 `lane1 / lane4 wrapper` 级系统证据，回答“1 / 2 / 4 lane 可配置”目前是否已经具有真实 wrapper 路径下的 smoke 闭环。

## Testbench

- 系统级 TB：
  - `tb/tests/tb_fpga_wrapper_raw8_lane_config_smoke.sv`
- 批量脚本：
  - `scripts/run_raw8_lane_config_smokes.ps1`

## Configuration

- Fixed traffic: `RAW8` single-frame wrapper path
- `LANE_NUM ∈ {1, 4}`
- Testbench forces boot cfg lane selection only in the stimulus layer:
  - lane1 uses `cfg_lane_num_minus1=0`, `lane_enable_mask=0001`
  - lane4 uses `cfg_lane_num_minus1=3`, `lane_enable_mask=1111`
- To make lane4 grouping exact, this smoke uses a minimal `RAW8` long-packet payload of `2` bytes

## Result Table

| lane num | exp pixels | act pixels | frames |
| --- | --- | --- | --- |
| 1 | 2 | 2 | 1 |
| 4 | 2 | 2 | 1 |

## Conclusions

- `lane1` 与 `lane4` 现在都已经补到真实 wrapper 路径下的 `RAW8` smoke 证据。
- 配合既有 `lane2 RAW8 smoke`，当前论文和工程都可以更稳妥地表述为：`1 / 2 / 4 lane` 配置能力已实现，并且三种配置都已具备至少一条 wrapper 级系统闭环证据。
- 这批结果仍属于最小 smoke 闭环，不等价于三种 lane 配置都已经完成等强度的异常注入、恢复和吞吐量化。
