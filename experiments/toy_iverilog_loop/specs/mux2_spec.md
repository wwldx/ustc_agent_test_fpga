# mux2 Specification

Implement a 1-bit 2-to-1 multiplexer.

## Interface

```verilog
module mux2(
    input wire a,
    input wire b,
    input wire sel,
    output wire y
);
```

## Behavior

```text
sel = 0 -> y = a
sel = 1 -> y = b
```

## Test Cases

The testbench should check all eight combinations of `a`, `b`, and `sel`.

## Out Of Scope

- No clock.
- No reset.
- No FPGA programming.
- No timing constraints.
