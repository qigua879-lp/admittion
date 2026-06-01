# Preprocess Notes

## Scope
This phase adds lightweight pixel-stream preprocessing blocks:
- `brightness_adjust`
- `contrast_adjust`
- `gray_balance`
- `preprocess_bypass_mux`

The optional `mean_filter_3x3` is not implemented in this phase. System testbench and top integration are intentionally not implemented.

## Insertion Point
The preprocessing chain is intended to sit after pixel repack and before buffering/AXI writing:

```text
pixel_repack_core -> preprocess blocks / bypass mux -> buffer_cdc_subsys -> axi_ddr_writer
```

## Common Pixel Stream Interface
| Signal | Direction | Description |
|---|---:|---|
| `clk_sys` | input | System clock |
| `rst_n` | input | Active-low synchronous reset |
| `pixel_valid_i` | input | Input pixel valid |
| `pixel_ready_o` | output | Module can accept input pixel |
| `pixel_data_i[23:0]` | input | Input pixel, interpreted as three 8-bit channels |
| `pixel_sof_i` | input | Start-of-frame marker |
| `pixel_sol_i` | input | Start-of-line marker |
| `pixel_valid_o` | output | Output pixel valid |
| `pixel_ready_i` | input | Downstream accepts output pixel |
| `pixel_data_o[23:0]` | output | Output pixel |
| `pixel_sof_o` | output | Start-of-frame marker |
| `pixel_sol_o` | output | Start-of-line marker |

Each processing block is a one-entry registered pipeline stage. Output data and markers remain stable while `pixel_valid_o && !pixel_ready_i`.

## Gain And Bias Convention
- Gains are unsigned Q1.7 values.
- `8'h80` represents 1.0x.
- `8'h40` represents 0.5x.
- `8'hff` represents approximately 1.99x.
- Bias values are signed 9-bit offsets.
- Final channel outputs saturate to `[0, 255]`.

## brightness_adjust
For each 8-bit channel:

```text
out = saturate(((in * cfg_gain_i) >> 7) + cfg_bias_i)
```

When `bypass_i` is set, the input pixel and markers pass through unchanged.

## contrast_adjust
For each 8-bit channel:

```text
out = saturate((((in - 128) * cfg_gain_i) >> 7) + 128 + cfg_bias_i)
```

When `bypass_i` is set, the input pixel and markers pass through unchanged.

## gray_balance
The three channels use independent gain and bias settings:

```text
Rout = saturate(((Rin * cfg_gain_r_i) >> 7) + cfg_bias_r_i)
Gout = saturate(((Gin * cfg_gain_g_i) >> 7) + cfg_bias_g_i)
Bout = saturate(((Bin * cfg_gain_b_i) >> 7) + cfg_bias_b_i)
```

When `bypass_i` is set, the input pixel and markers pass through unchanged.

## preprocess_bypass_mux
`preprocess_bypass_mux` selects either the raw pixel stream or processed pixel stream:
- `bypass_i = 1`: select raw stream
- `bypass_i = 0`: select processed stream

The selected stream passes through a one-entry registered output stage.

## Boundary Conditions
- These modules do not check frame size or line length.
- SOF/SOL are sideband markers and are delayed with their associated pixel.
- Incomplete frame/line context is not interpreted inside preprocess blocks.
- Top-level configuration register plumbing is deferred to a later integration phase.

## Self-Check Method
- `tb_brightness_adjust.sv` covers gain/bias, high saturation, low saturation, bypass, and output backpressure.
- `tb_contrast_adjust.sv` covers centered contrast math, bias, saturation, bypass, and output backpressure.
- `tb_gray_balance.sv` covers per-channel gain/bias, per-channel saturation, bypass, marker propagation, and output backpressure.
