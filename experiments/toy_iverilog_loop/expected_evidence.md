# Expected Evidence

## Tool Missing Case

On a machine without `iverilog`, the script should exit successfully and write:

```text
status=tool_missing
missing=iverilog
blocked_claims=simulation_not_run
```

This is the expected result on the current MacBook.

## Passing Simulation Case

On a machine with `iverilog` and `vvp`, the expected evidence includes:

```text
status=passed
simulation_result=PASS mux2
blocked_claims=hardware_correctness_not_claimed
```

Even a passing simulation only proves this tiny testbench passed. It does not prove hardware correctness.
