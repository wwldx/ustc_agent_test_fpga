# Experiment Log

Continuity schema: 0.1

Use this file for concise cross-experiment status. Put detailed artifacts inside each `experiments/<topic>/` directory.

## 2026-06-27 - Repository Bootstrap

Goal: create a clean collaboration repository for Verilog/RTL agent experiments and method transfer.

Actions:

- Created project skeleton.
- Added safety boundary and bridge documents.
- Added reading-list and experiment-track placeholders.

Verification:

- `bash scripts/check_repo_safety.sh` passed.
- `bash scripts/doctor.sh` found Git, Python 3.14, and Node; `iverilog`, Verilator, and Yosys are missing.
- No Verilog-agent experiment executed yet.

Next:

- Summarize VerilogCoder and Agentic Frontier. Done on 2026-06-28.
- Run repository safety check.
- Check local simulator tooling with `bash scripts/doctor.sh`.

## 2026-06-28 - Paper-First Work While Toolchain Is Missing

Goal: complete useful work that does not require installing `iverilog` on the space-limited MacBook.

Actions:

- Read local VerilogCoder PDF.
- Read local Agentic Frontier PDF.
- Wrote:
  - `docs/paper_notes/verilogcoder.md`
  - `docs/paper_notes/agentic_frontier.md`
  - `docs/paper_notes/comparison_matrix.md`
  - `docs/toolchain_notes.md`
  - `prompts/verilog_agent_structured_loop.md`
  - `skills/verilog_compile_check_contract.md`

Result:

- The first executable direction is now a tiny simulation-only structured loop on a machine with `iverilog`, not full VerilogCoder.

Evidence:

- VerilogCoder reports 94.2% pass rate on VerilogEval-Human v2 with GPT-4 Turbo agent setup, but high token/API cost.
- Agentic Frontier reports that naive agentic wrapping can degrade performance; structured prompting reduces crashes and recovers performance.

Blocked conclusions:

- No claim that VerilogCoder is reproduced.
- No claim that CVDP harness is run.
- No claim that this repository can run Verilog experiments on the current MacBook.

Next:

- Summarize ChipMATE.
- Choose Mac mini, lab Linux, or WSL2 as the first runner.
- Install/check `iverilog` there and run the toy loop.

## Template

Date:

Experiment:

Goal:

Commands:

Result:

Evidence:

Blocked conclusions:

Next:
