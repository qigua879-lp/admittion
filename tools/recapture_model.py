#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
行级选择性重采集 — 内存/可靠性量化模型（T1 数值实现）

实现交接文档 §3 / line_level_recapture_model.md 的三种恢复策略闭式模型：
  A = 行级选择性重采集 (line-level selective re-capture)
  B = 整帧重传        (full-frame retransmit)
  C = 整帧丢弃        (full-frame discard, no recovery, 基线)

输出：
  1) 始终打印一张对比表（无需任何第三方库即可运行）；
  2) 若安装了 matplotlib，则额外把内存/有效帧率/恢复时延 vs BER 曲线
     存到 07_project_result_analysis/figs/ 下，供 T3 基线对比复用。

用法:
  python tools/recapture_model.py
  python tools/recapture_model.py --width 1920 --height 1080 --bpp 1.25 \
         --fps 30 --rt-lines 8 --headroom 1.05
"""
import argparse
import math
import os
import sys

# Windows 控制台默认 GBK，强制 stdout 用 UTF-8 避免中文乱码
try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

# ----------------------------------------------------------------------------
# 基础参数容器
# ----------------------------------------------------------------------------
class Params:
    def __init__(self, W, H, bpp, fps, D, headroom):
        self.W = W                       # 每行像素
        self.H = H                       # 每帧行数
        self.bpp = bpp                   # 每像素打包字节
        self.fps = fps                   # 标称帧率
        self.D = D                       # 往返窗口跨越的行数
        self.h = headroom                # 链路带宽余量系数
        self.L = W * bpp                 # 每行字节
        self.F = H * self.W * bpp        # 每帧字节
        self.T_f = 1.0 / fps             # 帧周期 (s)
        self.T_l = self.T_f / H          # 行周期 (s)


def p_line_from_ber(ber, line_bytes):
    """单行残余失效概率: 1-(1-BER)^(8L)。小 BER 时 ~ 8L*BER。"""
    n_bits = 8.0 * line_bytes
    return 1.0 - (1.0 - ber) ** n_bits


def p_frame(p, H):
    """整帧含>=1坏行的概率。"""
    return 1.0 - (1.0 - p) ** H


# ----------------------------------------------------------------------------
# 三种策略的闭式指标
# 返回 dict: extra_mem_bytes, eff_fps, recover_latency_s, perm_loss_frac,
#            headroom_needed
# ----------------------------------------------------------------------------
def strat_A_line(pr, p):
    """行级选择性重采集。"""
    pf = p_frame(p, pr.H)
    headroom_needed = 1.0 / (1.0 - p) if p < 1 else math.inf
    sustained = pr.h >= headroom_needed
    # 余量不足时, 有效帧率按可分配给“新帧”的带宽比例下降
    if sustained:
        eff_fps = pr.fps
    else:
        # 每帧需要的总带宽倍数 = 1/(1-p)(行重传) , 可用 = h
        eff_fps = pr.fps * pr.h * (1.0 - p)
    return dict(
        extra_mem_bytes=pr.D * pr.L,
        eff_fps=eff_fps,
        recover_latency_s=pr.D * pr.T_l,
        perm_loss_frac=0.0,
        headroom_needed=headroom_needed,
    )


def strat_B_frame(pr, p):
    """整帧重传（单缓冲 F）。"""
    pf = p_frame(p, pr.H)
    headroom_needed = 1.0 / (1.0 - pf) if pf < 1 else math.inf
    sustained = pr.h >= headroom_needed
    eff_fps = pr.fps if sustained else pr.fps * (1.0 - pf)
    return dict(
        extra_mem_bytes=pr.F,
        eff_fps=eff_fps,
        recover_latency_s=pr.T_f,
        perm_loss_frac=0.0,
        headroom_needed=headroom_needed,
    )


def strat_C_discard(pr, p):
    """整帧丢弃，不重采（基线）。"""
    pf = p_frame(p, pr.H)
    return dict(
        extra_mem_bytes=0.0,
        eff_fps=pr.fps * (1.0 - pf),
        recover_latency_s=pr.T_f,
        perm_loss_frac=pf,
        headroom_needed=1.0,
    )


# ----------------------------------------------------------------------------
# 友好单位
# ----------------------------------------------------------------------------
def fmt_bytes(b):
    for unit in ("B", "KiB", "MiB", "GiB"):
        if b < 1024 or unit == "GiB":
            return f"{b:7.2f} {unit}"
        b /= 1024.0


def fmt_time(s):
    if s < 1e-3:
        return f"{s*1e6:7.2f} us"
    if s < 1.0:
        return f"{s*1e3:7.2f} ms"
    return f"{s:7.2f} s"


# ----------------------------------------------------------------------------
# 主流程
# ----------------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--width", type=int, default=1920)
    ap.add_argument("--height", type=int, default=1080)
    ap.add_argument("--bpp", type=float, default=1.25, help="bytes/pixel, RAW10=1.25")
    ap.add_argument("--fps", type=float, default=30.0)
    ap.add_argument("--rt-lines", type=int, default=8, dest="D",
                    help="往返窗口跨越的行数 D")
    ap.add_argument("--headroom", type=float, default=1.05,
                    help="链路带宽余量系数 h (>=1)")
    args = ap.parse_args()

    pr = Params(args.width, args.height, args.bpp, args.fps, args.D, args.headroom)

    print("=" * 78)
    print("行级选择性重采集 — 量化模型 (T1)")
    print("=" * 78)
    print(f"分辨率 {pr.W}x{pr.H}  bpp={pr.bpp}  fps={pr.fps}")
    print(f"每行 L = {fmt_bytes(pr.L)}   每帧 F = {fmt_bytes(pr.F)}")
    print(f"帧周期 T_f = {fmt_time(pr.T_f)}  行周期 T_l = {fmt_time(pr.T_l)}")
    print(f"往返窗口 D = {pr.D} 行  (rho = D/H = {pr.D/pr.H:.4f})   链路余量 h = {pr.h}")
    print()

    # BER 扫描点
    bers = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3]
    strategies = [("A 行级重采", strat_A_line),
                  ("B 整帧重传", strat_B_frame),
                  ("C 整帧丢弃", strat_C_discard)]

    for ber in bers:
        p = p_line_from_ber(ber, pr.L)
        pf = p_frame(p, pr.H)
        print(f"--- BER = {ber:.0e}   p_line = {p:.3e}   p_frame = {pf:.3e} ---")
        print(f"  {'策略':<12}{'额外内存':>14}{'有效帧率':>12}"
              f"{'恢复时延':>12}{'永久丢帧':>10}{'需余量h':>10}")
        for name, fn in strategies:
            m = fn(pr, p)
            hn = m["headroom_needed"]
            hn_s = ">1e3" if hn > 1e3 else f"{hn:.3f}"
            print(f"  {name:<12}{fmt_bytes(m['extra_mem_bytes']):>14}"
                  f"{m['eff_fps']:>9.2f}fps"
                  f"{fmt_time(m['recover_latency_s']):>12}"
                  f"{m['perm_loss_frac']*100:>8.2f}%"
                  f"{hn_s:>10}")
        print()

    # A vs B 边界小结
    print("-" * 78)
    print("量化边界小结 (A 相对 B):")
    print(f"  内存比   ΔM_A/ΔM_B = D/H = {pr.D/pr.H:.4f}  -> 约省 {pr.H/pr.D:.0f}x")
    print(f"  时延比   τ_rt/T_f  = D/H = {pr.D/pr.H:.4f}  -> 约省 {pr.H/pr.D:.0f}x")
    print("  结论: rho = D/H << 1 且 p 小到 h>=1/(1-p) 可满足时, 行级严格更优。")
    print("-" * 78)

    _t3_measured_crosscheck(pr)
    _t4_design_space(pr)
    _maybe_plot(pr, bers)


def _t4_design_space(pr):
    """T4 design-space sweep over the round-trip window D.

    Line-level (A) extra memory = D*L and recovery latency = D*T_l grow linearly
    with D; full-frame (B) costs are fixed at the frame (H). So A's advantage is
    exactly H/D and the profitability boundary is rho = D/H: A wins while D < H,
    degenerates to B at D = H. Simulation anchors (tb_recapture_strategy_compare
    runners tb_strat_a_d1/d2/d4) confirm buffer_lines scales as D and the recovery
    cost stays one line.
    """
    print("T4 设计空间扫描 (扫往返窗口 D, 与整帧重传 B 比):")
    print(f"  {'D(行)':>6}{'rho=D/H':>10}{'A额外内存':>14}{'A恢复时延':>12}"
          f"{'省内存/时延':>12}{'划算?':>8}")
    d_list = sorted(set([1, 2, 4, 8, max(1, pr.H // 4), pr.H // 2, pr.H]))
    for d in d_list:
        if d < 1 or d > pr.H:
            continue
        rho = d / pr.H
        mem = d * pr.L
        lat = d * pr.T_l
        adv = pr.H / d
        worth = "是" if d < pr.H else "退化=B"
        print(f"  {d:>6}{rho:>10.4f}{fmt_bytes(mem):>14}{fmt_time(lat):>12}"
              f"{adv:>10.0f}x{worth:>8}")
    print(f"  边界: rho=D/H<1 时行级严格更优(省 H/D 倍内存与时延); D->H 退化为整帧重传。")
    print(f"  仿真锚点: tb_strat_a_d1/d2/d4 实测 buffer_lines=D, 恢复流量恒=1 行(18B)。")
    print(f"  时间窗 C2: 单次未决请求, 注错快于服务则旧行丢失(tb_recapture_window_limit)。")
    print("-" * 78)


def _t3_measured_crosscheck(pr):
    """Print the T3 simulation-measured operating point against the model.

    Measured by tb_recapture_strategy_compare.sv at H=8, D=1, RAW8 (see
    05_simulation_results/结果验证/recapture_strategy_compare_results.md).
    Only meaningful when run at that geometry (--width 4 --height 8 --bpp 1
    --rt-lines 1); otherwise shown for reference.
    """
    # The simulation anchor was measured at H=8, D=1 (RAW8). Only present the
    # measured comparison at that geometry; elsewhere just note where it lives.
    if not (pr.H == 8 and pr.D == 1):
        print("-" * 78)
        print("T3 仿真实测锚点在 H=8, D=1 (RAW8); 用 --width 4 --height 8 --bpp 1 "
              "--rt-lines 1 复现对比。")
        print("-" * 78)
        return
    # (buffer_lines, recovery_lines, recovered) measured in simulation
    meas = {"A": (1, 1, True), "B": (pr.H, pr.H, True), "C": (0, 0, False)}
    print("-" * 78)
    print("T3 仿真实测 vs 模型 (操作点 H=%0d, D=%0d):" % (pr.H, pr.D))
    print(f"  {'策略':<14}{'实测缓存(行)':>14}{'实测恢复(行)':>14}{'恢复?':>8}"
          f"{'模型内存':>12}")
    model_mem = {"A": pr.D * pr.L, "B": pr.F, "C": 0.0}
    names = {"A": "A 行级重采", "B": "B 整帧重传", "C": "C 只丢"}
    for k in ("A", "B", "C"):
        bl, rl, rec = meas[k]
        print(f"  {names[k]:<14}{bl:>14}{rl:>14}{('是' if rec else '否'):>8}"
              f"{fmt_bytes(model_mem[k]):>12}")
    print(f"  内存比 A:B = D:H = {pr.D}:{pr.H} (rho={pr.D/pr.H:.3f})  "
          f"-> 行级省 {pr.H/pr.D:.0f}x 缓存, 与实测缓存行数比一致")
    print("-" * 78)


def _maybe_plot(pr, bers):
    try:
        import numpy as np
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
    except Exception as e:
        print(f"[info] 未绘图 (matplotlib/numpy 不可用: {e}). 表格已生成。")
        return

    ber_grid = np.logspace(-7, -2.5, 60)
    out = {k: {m: [] for m in ("mem", "fps", "lat")}
           for k in ("A", "B", "C")}
    for ber in ber_grid:
        p = p_line_from_ber(ber, pr.L)
        for key, fn in (("A", strat_A_line), ("B", strat_B_frame),
                        ("C", strat_C_discard)):
            m = fn(pr, p)
            out[key]["mem"].append(m["extra_mem_bytes"] / 1024.0)   # KiB
            out[key]["fps"].append(m["eff_fps"])
            out[key]["lat"].append(m["recover_latency_s"] * 1e3)    # ms

    figdir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                          "07_project_result_analysis", "figs")
    os.makedirs(figdir, exist_ok=True)

    # 用 ASCII 标签避免 matplotlib 缺中文字体的告警
    panels = [("mem", "Extra memory (KiB, log)", "Memory", True),
              ("fps", "Effective frame rate (fps)", "Throughput", False),
              ("lat", "Recovery latency (ms, log)", "Latency", True)]
    labels = {"A": "A line-level recapture",
              "B": "B full-frame retransmit",
              "C": "C full-frame discard"}
    for metric, ylabel, title, logy in panels:
        fig, ax = plt.subplots(figsize=(6, 4))
        for key in ("A", "B", "C"):
            ax.plot(ber_grid, out[key][metric], label=labels[key], marker="")
        ax.set_xscale("log")
        if logy:
            ax.set_yscale("log")
        ax.set_xlabel("BER")
        ax.set_ylabel(ylabel)
        ax.set_title(f"{title} vs BER  ({pr.W}x{pr.H} RAW10, D={pr.D})")
        ax.grid(True, which="both", alpha=0.3)
        ax.legend()
        fig.tight_layout()
        path = os.path.join(figdir, f"recapture_{metric}_vs_ber.png")
        fig.savefig(path, dpi=130)
        plt.close(fig)
        print(f"[fig] {path}")


if __name__ == "__main__":
    main()
