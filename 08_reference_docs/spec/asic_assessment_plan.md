# ASIC Assessment Plan

## Scope

This document defines a placeholder ASIC assessment plan for the digital MIPI
CSI-2 capture project. It does not claim that synthesis, place-and-route, STA,
area, power, or Fmax evaluation has been completed.

The current repository has a compile-checked RTL top and passing RTL regression,
but it does not include any foundry PDK, standard-cell library, ASIC SDC, floorplan,
or signoff report.

## Current Readiness

The project currently has:

| Item | Status |
| --- | --- |
| RTL top | `rtl/top/mipi_csi2_capture_top.sv` compile-only PASS. |
| Verification | L0 compile-only, L1 module unit, L2 system smoke, and L3 FPGA script syntax PASS. |
| RTL filelist seed | `sim/vcs/compile.f`, useful as a starting point but not an ASIC synthesis filelist as-is. |
| Clock-domain documentation | `docs/spec/clock_domains.md` and `docs/spec/top_integration_notes.md`. |
| Top-level interface draft | `docs/spec/top_io.md`. |
| Known placeholders | PHY adapter, payload CRC top integration, full cfg_reg_if, and AXI scheduling are documented. |

## Missing ASIC Inputs

ASIC evaluation cannot begin honestly until these inputs are available:

| Category | Required Inputs |
| --- | --- |
| Technology libraries | Standard-cell Liberty `.lib` or `.db`, technology LEF, cell LEF, QRC/RC extraction tech files. |
| Corners and modes | PVT corners, RC corners, MMMC setup, operating voltages and temperatures. |
| Constraints | ASIC SDC with clocks, generated clocks, IO delays, uncertainty, path groups, false paths, multicycle paths. |
| Hard macros | SRAM, IO, PLL, clock/reset macro models, timing views, LEF abstracts, Liberty views. |
| Physical planning | Die/core size, utilization target, macro placement, pin assignment, routing layer policy. |
| Power intent | UPF/CPF if multiple voltage or power domains are introduced. |
| Signoff decks | DRC/LVS/antenna decks and extraction/signoff rule files. |
| Activity data | SAIF/VCD/FSDB switching activity for realistic dynamic power. |
| DFT inputs | Scan/ATPG strategy, test clocks, reset handling, and test constraints if DFT is in scope. |

## Phase A: RTL And Constraint Preparation

Goals:

1. Freeze the synthesis target top as `mipi_csi2_capture_top`.
2. Create an ASIC-only RTL filelist that excludes TB packages, models, and scoreboards.
3. Replace or explicitly waive top-level placeholders that should not enter ASIC synthesis.
4. Write the first ASIC SDC.
5. Define reset assumptions for each clock domain.
6. Define CDC assumptions and what must be checked by lint/CDC tools.

Deliverables:

- `asic/genus/filelists/rtl_synth.f`
- `asic/genus/constraints/top.sdc`
- `asic/genus/scripts/read_rtl.tcl`
- `asic/genus/scripts/constraints.tcl`
- updated risk register for placeholders and waivers

## Phase B: Genus Synthesis Preparation

Genus should be used for logic synthesis once technology inputs are known.

Preparation tasks:

1. Load Liberty views for all selected analysis corners.
2. Load technology LEF and standard-cell LEF if physical-aware synthesis is planned.
3. Read ASIC RTL filelist.
4. Elaborate `mipi_csi2_capture_top`.
5. Apply ASIC SDC.
6. Run checks for unresolved modules, inferred latches, undriven nets, multi-driven nets, and unconstrained paths.
7. Run synthesis.
8. Export mapped netlist, SDC, and reports.

Reports to archive:

| Report | Purpose |
| --- | --- |
| timing summary | Early setup timing and Fmax estimate basis. |
| area | Cell area and hierarchy area. |
| power | Initial leakage/dynamic estimate when activity is available. |
| QoR | Synthesis quality and optimization summary. |
| check_design | Structural issues and unresolved references. |
| check_timing | Constraint coverage and unconstrained paths. |

## Phase C: Innovus Physical Implementation Preparation

Innovus should begin after a mapped netlist and preliminary SDC are available.

Preparation tasks:

1. Build MMMC setup from selected modes/corners.
2. Import mapped netlist, LEF, Liberty, and SDC.
3. Define die/core size and utilization target.
4. Plan macro placement if SRAM or PLL macros exist.
5. Define pin placement for external top-level interfaces.
6. Build power grid and verify power connectivity.
7. Run placement, pre-CTS optimization, CTS, post-CTS optimization, route, and post-route optimization.
8. Export SPEF/SDF/DEF/netlist and implementation reports.

Reports to archive:

| Report | Purpose |
| --- | --- |
| utilization | Core utilization and physical density. |
| congestion | Routing risk assessment. |
| timing | Post-place, post-CTS, post-route timing snapshots. |
| clock tree | Skew, insertion delay, and clock buffer count. |
| power | Physical implementation power estimate. |
| DRC/antenna | Physical rule status before signoff. |

## Phase D: Tempus / STA Preparation

Tempus or an equivalent signoff STA tool needs:

| Input | Notes |
| --- | --- |
| Gate-level netlist | Post-synthesis or post-route depending on stage. |
| Liberty timing libraries | All signoff PVT corners. |
| SDC | Final constraints from synthesis or implementation. |
| SPEF | Required for post-route parasitic-aware STA. |
| Clock definitions | Source/generated clocks, uncertainty, latency, skew policy. |
| Timing exceptions | False paths, multicycle paths, asynchronous CDC exceptions with justification. |
| Operating modes | Functional, test, low-power, or debug modes if present. |

STA outputs:

- setup slack by corner/mode
- hold slack by corner/mode
- unconstrained path report
- clock gating checks if clock gating is inserted
- min pulse width and max transition/capacitance reports
- exception audit report

## Area / Power / Fmax Evaluation Policy

No PPA number should be reported without an originating tool report.

Recommended metrics:

| Metric | Suggested Definition |
| --- | --- |
| Combinational area | Sum of mapped combinational standard-cell area from Genus/Innovus. |
| Sequential area | Sum of flop/latch area from Genus/Innovus. |
| Macro area | Area of SRAM/PLL/IO/hard macros, reported separately from standard cells. |
| Total cell area | Standard-cell area plus macro area, clearly indicating whether filler/tap/endcap are included. |
| Utilization | Placed standard-cell area divided by core area after macro blockages. |
| Dynamic power | Tool-reported switching/internal power for a named activity source and corner. |
| Leakage power | Tool-reported leakage for a named PVT corner. |
| Fmax | `1 / critical_path_period` from a clean setup timing run at a specified corner/mode. |
| Timing margin | Worst negative or positive slack per mode/corner. |

Power activity policy:

1. Use SAIF/VCD/FSDB from representative simulation when available.
2. If vectorless power is used, label it as vectorless.
3. Do not compare vectorless and activity-based power as equivalent numbers.

Fmax policy:

1. State the clock domain being measured.
2. State corner, mode, voltage, temperature, and wire model/parasitic stage.
3. Do not collapse `clk_sys`, `clk_byte`, `clk_axi`, and `clk_ddr` into a single Fmax unless the scenario explicitly requires it.

## Risk Register Seeds

| Risk | Impact | Planned Resolution |
| --- | --- | --- |
| Top-level AXI scheduling placeholder | ASIC PPA excludes real write traffic scheduler logic. | Implement sys-to-axi buffer and command scheduler before serious PPA. |
| Payload CRC not integrated at top | Reliability path area/timing is incomplete. | Add CRC extraction and top-level checker connection. |
| PHY adapter placeholder | Input timing and lane front-end area are incomplete. | Implement digital `phy_digital_adapter` or define external hard boundary. |
| Missing ASIC SDC | Timing reports would be meaningless. | Create clock/IO/exception constraints before synthesis. |
| No PDK/library | No valid area, timing, or power result can be generated. | Select target process and obtain authorized library kit. |

## Directory Placeholders

| Directory | Purpose |
| --- | --- |
| `asic/genus/` | Future synthesis scripts, constraints, filelists, logs, and outputs. |
| `asic/innovus/` | Future physical implementation scripts, MMMC setup, floorplan, logs, and outputs. |
| `asic/reports/` | Future archived reports and PPA summaries with source references. |

## Current Stage Exit Criteria

This placeholder stage is complete when:

1. ASIC directories explain what belongs there later.
2. The plan lists required technology and constraint inputs.
3. The plan describes Genus, Innovus, and Tempus/STA stages.
4. PPA reporting rules explicitly forbid fabricated numbers.
5. No existing RTL or testbench is modified.
