# Graduation Project Bridge

This repository supports the graduation project indirectly. It studies Verilog/RTL agent workflows so that useful engineering patterns can be reused in the low-temperature readout-chip software project.

## What Transfers Back

- Deterministic skill boundaries: agents propose, scripts verify, humans approve.
- Evidence-bound outputs: every recommendation should cite test results, missing evidence, and blocked conclusions.
- Tool-loop design: edit code, run simulator, parse failure, repair, and record the trace.
- Sub-agent decomposition: split generation, verification, diagnosis, and report writing instead of using one broad agent role.
- Handoff discipline: make every experiment resumable by another person or another machine.

## What Does Not Transfer Back Directly

- The graduation project should not become a general Verilog-agent thesis.
- Hardware control should not be delegated directly to an LLM.
- API-based agent designs should not be copied blindly into lab environments where secrecy, offline operation, and reproducibility matter.
- Verilog benchmark wins should not be presented as evidence that readout-chip test parameters are optimized.

## Sync Rule

When an experiment produces a reusable lesson, update both sides:

- In this repository: `docs/experiment_log.md`, relevant experiment README, and `docs/LEARNING_LOG.md`.
- In the graduation project: a digested technical-research note or project-management update, not raw experiment clutter.

## Group-Meeting Use

Use this project as a source of concrete examples for:

- why deterministic skills are safer than a vague autonomous agent;
- how simulator feedback can inspire credibility gates for test data;
- how missing evidence should block strong claims;
- how human review remains the write-back boundary.
