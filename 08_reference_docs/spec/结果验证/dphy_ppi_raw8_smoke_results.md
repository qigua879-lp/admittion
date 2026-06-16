# D-PHY PPI RAW8 Smoke Results

## Purpose

本文件记录新增 `mipi_csi2_capture_dphy_wrapper` 的最小 RAW8 端到端验证。目标是证明 AMD MIPI D-PHY RX IP 的 PPI 风格入口可以通过 `mipi_dphy_ppi_adapter` 接入现有 CSI-2 RX 主链路。

## Testbench

| Item | Value |
| --- | --- |
| Testbench | `tb_mipi_csi2_capture_dphy_wrapper_raw8_smoke.sv` |
| DUT | `mipi_csi2_capture_dphy_wrapper` |
| Lane mode | `2 lane` |
| Data type | `RAW8` |
| Traffic | `FS -> LS -> RAW8 long packet -> LE -> FE` |

## Result

```text
PASS: tb_mipi_csi2_capture_dphy_wrapper_raw8_smoke exp=4 act=4 frames=1
```

Observed closure:

- `rxbyteclkhs` drives the wrapper byte clock path.
- `dl0/1_rxactivehs` and `dl0/1_rxvalidhs` produce 2-lane byte intake.
- `dphy_hs_mode_o`, `dphy_lp_mode_o`, and `dphy_lane_valid_hs_o` are observable.
- `frame_start_o / line_start_o / line_end_o / frame_end_o` are produced.
- `pixel_valid_o` produces the expected RAW8 pixels.
- scoreboard reports `exp=4`, `act=4`, `mismatch=0`.
- `err_ecc_o / err_crc_o / err_sync_o` and D-PHY SoT error debug outputs remain low.

## Verification Command

```powershell
iverilog -g2012 -Wall -s tb_mipi_csi2_capture_dphy_wrapper_raw8_smoke ...
vvp outputs\dphy_ppi_tdd\tb_mipi_csi2_capture_dphy_wrapper_raw8_smoke.vvp
```

## Boundary

This is still a digital RTL smoke test. It does not instantiate the AMD D-PHY RX IP, does not verify ZCU102/FMC pinout, and does not replace ILA-based board bring-up. Its value is proving the new PPI-facing wrapper can carry a valid RAW8 CSI-2 byte stream into the existing parser/pixel path.
