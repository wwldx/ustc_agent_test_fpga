# Toy Icarus Verilog Loop

Status: scaffolded, not yet run on this MacBook.

## Purpose

This is the first executable experiment for the repository. It is intentionally smaller than VerilogCoder, CVDP, or ChipMATE.

The goal is to validate the basic structured workflow:

```text
spec -> RTL -> testbench -> iverilog compile -> vvp simulation -> compact evidence report
```

No hardware is involved.

## Files

- `specs/mux2_spec.md`: human-readable toy specification.
- `rtl/mux2.v`: tiny RTL implementation.
- `tb/tb_mux2.v`: self-checking testbench.
- `oracle/mux2_oracle.py`: tiny Python reference model.
- `scripts/run_local_check.sh`: local compile/simulation wrapper.
- `expected_evidence.md`: what a successful or tool-missing run should record.

## Run

On a runner with `iverilog` and `vvp`:

```bash
cd experiments/toy_iverilog_loop
bash scripts/run_local_check.sh
```

On the current MacBook, this script is expected to report `tool_missing` until `iverilog` is installed. Do not install toolchains here by default.

The Python oracle can run on the current MacBook:

```bash
python3 experiments/toy_iverilog_loop/oracle/mux2_oracle.py
python3 -m unittest tests/test_mux2_oracle.py
```

## Expected Success Criteria

- `iverilog` compiles `rtl/mux2.v` and `tb/tb_mux2.v`.
- `vvp` runs the compiled simulation.
- Testbench prints `PASS mux2`.
- The script writes `build/evidence.txt`.
- Python oracle tests pass.

## Why This Comes Before Full VerilogCoder

VerilogCoder and ChipMATE introduce model APIs, multi-agent orchestration, or local model-serving complexity. This toy loop proves the deterministic verification boundary first.

The Python oracle is the smallest local version of ChipMATE's reference-model idea. It gives this repository a no-model-weight baseline before any local LLM or dual-agent setup.
