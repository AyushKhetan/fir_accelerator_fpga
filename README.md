# Pipelined FIR Accelerator for FPGA using Verilog

A modular **16-tap FIR (Finite Impulse Response) accelerator** implemented in **Verilog HDL**, targeting the **AMD/Xilinx Artix-7 FPGA** family. The design was developed and analyzed using **AMD Vivado 2026.1**.

The project demonstrates the complete RTL design flow—from architecture design and functional simulation to synthesis, implementation, timing analysis, and timing optimization. A pipelined reduction tree was introduced to eliminate setup timing violations and successfully achieve timing closure at **100 MHz**.

---

## Features

- 16-tap signed FIR filter
- Modular RTL architecture
- Streaming input interface (`valid_in`)
- Parallel multiplication using 16 concurrent multipliers
- Balanced reduction tree for accumulation
- Pipelined reduction tree for timing optimization
- Behavioral simulation testbench
- Complete synthesis and implementation using AMD Vivado

---

# Architecture

The FIR accelerator consists of five primary modules:

```
                     sample_in
                         │
                         ▼
                   +-------------+
                   |  fir_core   |
                   +-------------+
                         │
         ┌───────────────┴───────────────┐
         ▼                               ▼
+------------------+          +------------------+
| Window Buffer    |          | Coefficient Bank |
+------------------+          +------------------+
         │                               │
         └───────────────┬───────────────┘
                         ▼
          +-------------------------------+
          | Product Engine                |
          | (16 Parallel Multipliers)     |
          +-------------------------------+
                         │
                         ▼
             +-------------------------+
             | Pipelined Reduction Tree|
             +-------------------------+
                         │
                         ▼
                    sample_out
```

A higher-quality version of this diagram is available in:

```
docs/architecture.png
```

---

# Design Hierarchy

```
fir_accelerator
    └── fir_core
            ├── window_buffer
            ├── coefficient_bank
            ├── product_engine
            └── reduction_tree
```

Hierarchy screenshot:

```
docs/rtl_hierarchy.png
```

---

# Module Description

## fir_accelerator

Top-level wrapper responsible for interfacing the FIR core with the external system. Registers the output signals before driving the module outputs.

---

## fir_core

Implements the complete FIR datapath.

Responsibilities include:

- Module integration
- Sample counting
- Valid signal generation
- Datapath control

---

## window_buffer

Maintains the most recent sixteen input samples.

Features:

- 16 × 16-bit signed storage
- Updates only when `valid_in` is asserted
- Implements the FIR sliding window

---

## coefficient_bank

Stores the FIR coefficients.

The current implementation uses constant Verilog parameters. The modular design allows future replacement with ROM, RAM, or programmable register banks without modifying the datapath.

---

## product_engine

Performs sixteen signed multiplications in parallel.

Inputs:

- Window buffer samples
- FIR coefficients

Outputs:

- Sixteen 32-bit products

---

## reduction_tree

Accumulates the sixteen products using a balanced binary adder tree.

The optimized implementation introduces a pipeline stage after the second addition level to reduce the critical path.

---

# Design Flow

The project was developed following the standard FPGA RTL workflow:

1. RTL Design
2. Functional Simulation
3. Synthesis
4. Implementation
5. Timing Analysis
6. Timing Optimization
7. Resource Utilization Analysis

---

# Timing Optimization

## Initial Design

The original reduction tree consisted of four consecutive addition stages.

```
16 Products
     │
Level 1
     │
Level 2
     │
Level 3
     │
Final Adder
     │
Output Register
```

This resulted in a long combinational path extending from the window buffer registers to the output register.

### Timing Summary (Before Optimization)

| Metric | Value |
|---------|------:|
| Worst Negative Slack (WNS) | **-1.157 ns** |
| Total Negative Slack (TNS) | **-10.135 ns** |
| Timing Constraints | **Failed** |

Screenshot:

```
docs/timing_summary_before.png
```

---

## Optimized Design

Pipeline registers were inserted after **Level 2** of the reduction tree.

This divided the long combinational path into two shorter paths, reducing the setup delay and achieving timing closure.

Pipeline illustration:

```
docs/pipeline_optimization.png
```

### Timing Summary (After Optimization)

| Metric | Value |
|---------|------:|
| Worst Negative Slack (WNS) | **+1.643 ns** |
| Total Negative Slack (TNS) | **0.000 ns** |
| Timing Constraints | **Passed** |

Screenshot:

```
docs/timing_summary_after.png
```

---

# Critical Path Analysis

Before optimization, the longest combinational path consisted of:

```
Multiplier
        ↓
4 Addition Levels
        ↓
Output Register
```

After pipelining:

```
Multiplier
        ↓
2 Addition Levels
        ↓
Pipeline Registers
        ↓
2 Addition Levels
        ↓
Output Register
```

Representative timing report:

```
docs/critical_path_after.png
```

---

# Resource Utilization

| Resource | Used |
|----------|------:|
| Slice LUTs | 658 |
| Slice Registers | 472 |
| DSP48 | 0 |
| BRAM | 0 |
| BUFG | 1 |

Hierarchical utilization report:

```
docs/utilization_hierarchy.png
```

The multipliers were implemented using FPGA logic resources for the current operand widths. Vivado did not infer DSP blocks for this implementation.

---

# Functional Simulation

Behavioral simulation was performed to verify:

- Reset operation
- Streaming input processing
- Sliding window operation
- Parallel multiply-accumulate functionality
- Bubble (invalid cycle) handling
- Pipeline latency

Representative waveform(s):

```
docs/waveform.png
```

(or replace with your final waveform filename if different)

---

# Results Summary

| Parameter | Before | After |
|-----------|--------|-------|
| Worst Negative Slack | -1.157 ns | +1.643 ns |
| Timing Constraints | Failed | Passed |
| Slice LUTs | 658 | 658 |
| Slice Registers | 298 | 472 |
| Pipeline Stages | 0 | 1 |

The optimization successfully eliminated setup timing violations while maintaining the same combinational logic utilization. The increase in register count corresponds to the additional pipeline stage introduced into the reduction tree.

---

# Repository Structure

```text
fir_accelerator_fpga/

├── rtl/
│   ├── fir_accelerator.v
│   ├── fir_core.v
│   ├── window_buffer.v
│   ├── coefficient_bank.v
│   ├── multiplier.v
│   ├── product_engine.v
│   └── reduction_tree.v
│
├── tb/
│   └── tb_fir_core.v
│
├── constraints/
│   └── fir_accelerator.xdc
│
├── docs/
│   ├── architecture.png
│   ├── pipeline_optimization.png
│   ├── rtl_hierarchy.png
│   ├── rtl_schematic.png
│   ├── timing_summary_before.png
│   ├── timing_summary_after.png
│   ├── critical_path_after.png
│   ├── utilization_hierarchy.png
│   └── waveform.png
│
├── README.md
├── results.md
├── LICENSE
└── .gitignore
```

*(Update the waveform filename if you decide to keep two waveform images instead of one.)*

---

# Future Work

Possible extensions include:

- Runtime-programmable coefficient memory
- DSP48-based multiplier implementation
- Multi-stage pipelining for higher operating frequencies
- AXI-Stream interface
- FPGA board deployment
- Enhanced latency-aware verification environment

---

# Tools Used

- Verilog HDL
- AMD Vivado 2026.1
- AMD/Xilinx Artix-7 FPGA (XC7A35T-CPG236-1)

---

# License

This project is released under the MIT License.
