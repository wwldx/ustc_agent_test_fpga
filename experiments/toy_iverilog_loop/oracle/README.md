# mux2 Python Oracle

This directory contains a tiny deterministic reference model for the toy mux2 experiment.

It is intentionally simple:

```text
sel = 0 -> expected_y = a
sel = 1 -> expected_y = b
```

This is the local miniature version of the ChipMATE lesson:

```text
candidate RTL + independent behavioral reference -> evidence-bound check
```

It does not require model weights, API calls, `iverilog`, or hardware.

## Run

From the repository root:

```bash
python3 experiments/toy_iverilog_loop/oracle/mux2_oracle.py
python3 -m unittest tests/test_mux2_oracle.py
```
