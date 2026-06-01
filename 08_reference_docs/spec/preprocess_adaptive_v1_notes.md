# Preprocess Adaptive V1 Notes

## Scope

This iteration adds a frame-based adaptive preprocess extension while reusing
the existing pixel-stream blocks already present in `rtl/preprocess/`.

New modules:

- `pixel_frame_stats_v1`
- `adaptive_preprocess_ctrl_v1`

Reused modules in the top integration path:

- `brightness_adjust`
- `gray_balance`
- `preprocess_bypass_mux`

## Versioning Intent

- `adaptive_v1` is an additive step, not a rewrite.
- Default top-level behavior remains unchanged because the adaptive path resets
  to disabled.
- Statistics from frame `N` are applied to frame `N+1`.

## Insertion Point

The adaptive statistics observer taps the raw repacked pixel stream:

```text
pixel_repack_core
  -> pixel_frame_stats_v1       (observe only, no backpressure added)
  -> brightness_adjust          (reused for auto linear stretch)
  -> contrast_adjust            (identity pass-through in this iteration)
  -> gray_balance               (reused for auto white balance)
  -> preprocess_bypass_mux
```

## Common Interface

The new logic follows the existing `pixel_valid/pixel_ready/pixel_data/pixel_sof`
style and keeps all state in `clk_sys`.

`pixel_frame_stats_v1` additionally consumes:

- `pixel_format_i[2:0]`
- `frame_end_i`

## Supported Pixel Meanings

| Format | Statistics interpretation | Adaptive support |
| --- | --- | --- |
| `RGB888` | `R/G/B` and luma from average of channels | AWB + stretch |
| `RAW8` | mono intensity from `pixel_data_i[7:0]` | stretch only |
| `RAW10` | debug mono intensity from `pixel_data_i[9:2]` | pass-through only |
| `YUV422` | luma from `Y`, chroma ignored for adaptation | pass-through only |

The current top-level debug stream is not yet a full ISP-domain representation,
so adaptive color processing is intentionally constrained.

## `pixel_frame_stats_v1`

### Function

Collect one frame of:

- pixel count
- channel means
- luma min/max
- dark pixel count
- bright pixel count

### Boundary Conditions

- A frame starts when the accepted pixel carries `pixel_sof_i`.
- Statistics are latched when `frame_end_i` arrives.
- If adaptive mode is disabled, the observer stops accumulating.
- `clear_i` clears both running and latched statistics.

### Self-Check

`tb/tests/tb_pixel_frame_stats_v1.sv` checks:

- RGB frame statistics
- RAW8 mono statistics
- dark/bright counters
- clear behavior

## `adaptive_preprocess_ctrl_v1`

### Function

Generate:

- Gray-world style AWB gains for `gray_balance`
- Linear stretch gain/bias for `brightness_adjust`

### Formulas

AWB target:

```text
target_mean = (mean_r + mean_g + mean_b) / 3
gain_ch = clamp_q1.7(target_mean / mean_ch)
```

Stretch coefficients:

```text
range = luma_max - luma_min
gain  = clamp_q1.7(255 / range)
bias  = saturate_s9(-(luma_min * gain))
```

### Boundary Conditions

- Coefficients update only on `stats_valid_i`.
- If a sub-function is disabled, its coefficients return to identity.
- A minimum luma range threshold avoids aggressive stretching on near-flat
  frames.

### Self-Check

`tb/tests/tb_adaptive_preprocess_ctrl_v1.sv` checks:

- AWB gain direction
- stretch gain/bias generation
- local enable bits
- global disable
- clear behavior

## Top Integration

Top-level APB placeholder register `0x0000` now includes:

- bit0 preprocess bypass
- bit1 resync enable
- bit2 degrade enable
- bit3 adaptive preprocess global enable
- bit4 adaptive AWB enable
- bit5 adaptive stretch enable

Read-only additions:

- `0x0024`: current adaptive gain summary
- `0x0028`: mean R/G
- `0x002c`: mean B and luma min/max

## Known Limitations

- AWB is intentionally limited to `RGB888`.
- Stretch is intended for `RGB888` and `RAW8` only.
- `contrast_adjust` remains identity in this iteration; the file is preserved so
  the next iteration can add richer tone shaping without changing the base
  interface.
- Statistics are frame-based, not line-based or tile-based.
