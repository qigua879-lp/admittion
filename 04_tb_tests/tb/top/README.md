# tb/top

本目录保存顶层 testbench wrapper。

## 当前文件

| 文件 | 作用 | 说明 |
| --- | --- | --- |
| `tb_mipi_csi2_capture_top.sv` | `mipi_csi2_capture_top` 系统级基础 testbench | 用于顶层 DUT 的基础时钟、复位、lane 激励和主链路 smoke 验证。更丰富的真实 wrapper 场景位于 `tb/tests/tb_fpga_wrapper_*.sv`。 |

## 使用说明

该目录用于放置顶层集成 testbench 外壳；具体参数扫描、错误注入和论文指标采集统一放在 `tb/tests/`，便于 VCS/Vivado xsim filelist 管理。
