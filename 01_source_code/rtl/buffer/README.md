# rtl/buffer

本目录保存 FIFO、CDC 和缓存逻辑。

规划模块：
- `buffer_cdc_subsys`

职责：
- 提供 async FIFO 跨域。
- 在 backpressure 下保持像素数据顺序。
- 按需要补充 line-buffer 支持。

CDC 模块需要重点覆盖 reset、full、empty 和顺序保持测试。
