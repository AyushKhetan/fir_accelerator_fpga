# Pipelined FIR Accelerator for FPGA using Verilog

## Overview

This project implements a modular **16-tap Finite Impulse Response (FIR) accelerator** in Verilog HDL. The design targets AMD/Xilinx Artix-7 FPGAs and was developed using AMD Vivado.

The accelerator accepts streaming signed 16-bit input samples and computes the FIR output using a parallel multiply-accumulate architecture. During implementation, the design was optimized by introducing a pipeline stage in the reduction tree to eliminate setup timing violations and successfully meet a 100 MHz clock constraint.

---

## Features

- 16-tap signed FIR filter
- Streaming input interface using `valid_in`
- Parallel multiplication of all taps
- Balanced reduction tree for accumulation
- Modular RTL architecture
- Pipelined reduction tree for timing optimization
- Behavioral simulation testbench
- Synthesized and implemented in AMD Vivado

---

## Architecture

```
                     +-------------------+
sample_in ---------->|   Window Buffer   |
                     +-------------------+
                               |
                               |
                     +-------------------+
                     | Coefficient Bank  |
                     +-------------------+
                               |
                               |
                     +-------------------+
                     |  Product Engine   |
                     | (16 Multipliers)  |
                     +-------------------+
                               |
                               |
                     +-------------------+
                     | Pipelined         |
                     | Reduction Tree    |
                     +-------------------+
                               |
                               |
                           sample_out
```

The design hierarchy is organized as

```
fir_accelerator
    └── fir_core
            ├── window_buffer
            ├── coefficient_bank
            ├── product_engine
            └── reduction_tree
```

---

# Module Description

## fir_accelerator

Top-level wrapper responsible for interfacing the FIR core with the external system. Registers the output signals before driving the module outputs.

---

## fir_core

Implements the complete FIR datapath and instantiates all functional modules.

Responsibilities include

- sample counting
- valid signal generation
- module integration

---

## window_buffer

Maintains the most recent 16 input samples.

- shifts only when `valid_in` is asserted
- stores signed 16-bit samples
- forms the FIR sliding window

---

## coefficient_bank

Provides the FIR coefficients.

The current implementation stores coefficients as Verilog parameters, allowing future replacement by ROM, RAM, or programmable register banks without changing the datapath.

---

## product_engine

Performs sixteen signed multiplications in parallel.

Inputs

- samples from the window buffer
- coefficients from the coefficient bank

Outputs

- sixteen 32-bit products

---

## reduction_tree

Accumulates the sixteen products using a balanced adder tree.

The optimized implementation inserts pipeline registers after the second level of additions, reducing the combinational critical path.

---

# Timing Optimization

## Initial implementation

The original reduction tree consisted of four consecutive addition stages.

```
Multipliers

↓

L1 Adders

↓

L2 Adders

↓

L3 Adders

↓

Final Adder
```

Vivado reported a setup timing violation due to the long combinational path extending from the window buffer registers to the output register.

### Timing Summary (Before Optimization)

| Metric | Value |
|--------|-------|
| Worst Negative Slack | -1.157 ns |
| Total Negative Slack | -10.135 ns |
| Timing | Failed |

---

## Optimized implementation

Pipeline registers were inserted after the second addition stage.

```
Multipliers

↓

L1 Adders

↓

L2 Adders

↓

Pipeline Registers

↓

L3 Adders

↓

Final Adder

↓

Output Register
```

This reduced the longest combinational delay while increasing the number of sequential elements.

### Timing Summary (After Optimization)

| Metric | Value |
|--------|-------|
| Worst Negative Slack | +1.643 ns |
| Total Negative Slack | 0 ns |
| Timing | Passed |

---

# Resource Utilization

| Resource | Used |
|----------|-----:|
| Slice LUTs | 658 |
| Slice Registers | 472 |
| DSP48 | 0 |
| BRAM | 0 |
| BUFG | 1 |

The design is implemented entirely using FPGA logic resources. For the current operand widths, Vivado inferred LUT-based multipliers rather than DSP blocks.

---

# Simulation

Behavioral simulation was used to verify

- reset operation
- streaming input processing
- valid signal handling
- FIR output generation
- handling of invalid (bubble) cycles

Representative simulation waveforms are included in the `docs` directory.

---

# Repository Structure

```
rtl/
    fir_accelerator.v
    fir_core.v
    window_buffer.v
    coefficient_bank.v
    multiplier.v
    product_engine.v
    reduction_tree.v

tb/
    tb_fir_core.v

constraints/
    fir_accelerator.xdc

docs/
    rtl_hierarchy.png
    rtl_schematic.png
    timing_summary.png
    timing_paths.png
    hierarchical_utilization.png
    waveform.png
```

---

# Future Work

Possible extensions include

- Runtime-programmable coefficient memory
- DSP48-based multiplier implementation
- Multi-stage pipelining for higher frequencies
- AXI-Stream interface
- FPGA board deployment
- Enhanced latency-aware regression testbench

---

# Tools Used

- Verilog HDL
- AMD Vivado 2026.1
- Artix-7 (XC7A35T-CPG236-1)

---

# License

This project is released under the MIT License.
