# Implementation Results

## Target Device

AMD Artix-7
XC7A35T-CPG236-1

Clock Constraint:
100 MHz (10 ns)

---

## Resource Utilization

LUTs : 658

Registers : 472

DSP48 : 0

BRAM : 0

BUFG : 1

---

## Timing

Worst Negative Slack : +1.643 ns

Total Negative Slack : 0 ns

Failing Endpoints : 0

Timing Constraints : PASSED

---

## Optimization

The reduction tree was pipelined by inserting registers after the second addition stage.

This reduced the critical path sufficiently to meet the 100 MHz timing requirement while increasing register count due to the additional pipeline stage.
