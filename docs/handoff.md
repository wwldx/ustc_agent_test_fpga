# Handoff

Continuity schema: 0.1

## Current Status

Initial scaffold is in place. VerilogCoder and Agentic Frontier have been summarized. No simulation experiment has been run yet.

## Most Useful Next Step

Continue the paper-to-experiment loop:

1. Summarize ChipMATE for local/no-API lessons.
2. Choose a runner with enough disk and `iverilog`.
3. Run the smallest safe toy example that only requires local simulation.
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
