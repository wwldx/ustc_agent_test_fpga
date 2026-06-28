# Handoff

Continuity schema: 0.1

## Current Status

Initial scaffold is in place. VerilogCoder, Agentic Frontier, and ChipMATE have been summarized. A toy `iverilog` loop and a tiny Python oracle are scaffolded, but no Verilog simulation experiment has been run yet.

Recent radar docs now list additional 2025-2026 sources and practical GitHub issue signals.

Verilog-Evolve and HDLFORGE have now been summarized; direction review says to keep toy/evidence-first path but add validation-gated skill design and bounded escalation.

## Most Useful Next Step

Continue the paper-to-experiment loop:

1. Run `python3 -m unittest tests/test_mux2_oracle.py` on any checkout.
2. Choose a runner with enough disk and `iverilog`, or implement the next no-tooling step: compact evidence schema.
3. Run `bash experiments/toy_iverilog_loop/scripts/run_local_check.sh` on that runner.
4. Record exact commands, outputs, failures, and next actions in `docs/experiment_log.md`.

## Before Handing Off

- Run `git status --short --branch`.
- Run `bash scripts/check_repo_safety.sh`.
- Update `docs/AGENT_STATE.md`.
- Update this file with the latest runnable command and known blockers.

## Known Constraints

- Repository is currently public.
- Paper PDFs are stored outside Git.
- No hardware execution path is approved yet.
- First MacBook environment check found Git, Python 3.14, and Node, but no `iverilog`, Verilator, or Yosys.
- Current MacBook should remain notes-only unless the user explicitly approves installing toolchains.
