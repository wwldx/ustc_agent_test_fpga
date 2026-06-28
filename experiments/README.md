# Experiments

Each experiment directory should stay small and reproducible.

## Rules

- Start with a README before adding code.
- Record dependencies and exact commands.
- Prefer simulation-only examples first.
- Keep hardware execution dry-run by default.
- Store large generated artifacts outside Git or under ignored scratch directories.
- Update `../docs/experiment_log.md` when the experiment changes project direction or handoff state.

## Tracks

- `verilogcoder_repro/`: reproduce or adapt NVlabs VerilogCoder.
- `chipmate_study/`: study local-model and reference-model ideas.
- `lego_skill_study/`: extract skill-contract ideas from LEGO.
- `mage_study/`: compare MAGE-style multi-agent workflow.

## First Executable Experiment

The first executable experiment should be smaller than any full paper reproduction:

```text
toy spec + RTL + testbench
-> structured prompt
-> iverilog compile
-> vvp simulation
-> compact evidence report
```

Run this on Mac mini, lab Linux, or WSL2 after `bash scripts/doctor.sh` confirms `iverilog` is available.
