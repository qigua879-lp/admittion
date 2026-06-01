# 运行日志

本目录用于集中保存 `Vivado / xsim / xvlog / xelab / webtalk` 的运行期日志和状态文件，避免这些工具生成物散落在仓库根目录。

## 当前约定

- `root_workspace/`
  - 保存从仓库根目录运行工具时产生的历史 `*.jou / *.log / *.str / *.pb`
  - 采用更细的分类命名：
    - `01_vivado_main/`
      - 当前主 `vivado.jou` / `vivado.log`
    - `02_vivado_backup/`
      - `vivado_*.backup.*` 历史备份日志
    - `03_webtalk/`
      - `webtalk` 遥测/报告相关日志
    - `04_xsim/`
      - `xsim` 运行日志和备份日志
    - `05_frontend_compile/`
      - `xvlog` / `xelab` 前端编译日志
    - `06_session_state/`
      - `vivado_pid*.str` 会话状态文件

## 说明

- 这些文件主要用于问题回溯，不作为正式交付物的一部分。
- 当前需要长期引用的综合/实现结果应保留在 `fpga/vivado/reports/`。
