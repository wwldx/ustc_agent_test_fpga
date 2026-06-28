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

## 2026-06-28 - ChipMATE Note And Toy Loop Scaffold

Goal: continue useful work without installing toolchains on the space-limited MacBook.

Actions:

- Wrote `docs/paper_notes/chipmate.md`.
- Updated paper indexes and comparison matrix.
- Added `experiments/toy_iverilog_loop/` with mux2 spec, RTL, testbench, run script, and expected evidence.

Result:

- The repository now has a first executable experiment package ready for a runner with `iverilog`.
- Current MacBook remains notes-only.

Evidence:

- ChipMATE public sources describe a local/open-model dual-agent workflow with Verilog and Python agents.
- Toy loop has a self-checking testbench and a script that records `tool_missing` instead of failing hard when `iverilog` is absent.
- Temp-copy dry run on the current MacBook produced `status=tool_missing`, `missing=iverilog`, `blocked_claims=simulation_not_run`.

Blocked conclusions:

- ChipMATE has not been reproduced.
- No model weights were downloaded.
- The toy loop has not been simulated on this MacBook.

Next:

- Sync to the real repository and run safety checks.
- On a runner with `iverilog`, execute `bash experiments/toy_iverilog_loop/scripts/run_local_check.sh`.

## 2026-06-28 - Python Oracle For Toy mux2

Goal: reduce ChipMATE's Python reference-model idea to a tiny deterministic artifact that runs on the current MacBook.

Actions:

- Added `experiments/toy_iverilog_loop/oracle/mux2_oracle.py`.
- Added `tests/test_mux2_oracle.py`.
- Updated toy loop README.

Result:

- The toy loop now has a Verilog path and an independent Python reference path.
- `python3 -m unittest tests/test_mux2_oracle.py` passed 4 tests.
- `python3 experiments/toy_iverilog_loop/oracle/mux2_oracle.py` printed the 8-row truth table.

Blocked conclusions:

- The oracle has not yet been compared against real Verilog simulation output because `iverilog` is still missing on the current MacBook.

Next:

- On a runner with `iverilog`, compare simulation cases against the oracle truth table.

## 2026-06-28 - Recent Research Radar

Goal: expand the literature/community map beyond the initial five core papers.

Actions:

- Searched for recent Verilog/RTL agent, benchmark, local-model, formal/simulation feedback, and forum/issue discussion sources.
- Added `docs/paper_notes/recent_research_radar_20260628.md`.
- Added `docs/paper_notes/community_discussions.md`.
- Updated paper indexes.

Result:

- The repository now tracks a wider set of 2025-2026 candidates, including Verilog-Evolve, HDLFORGE, VeriPilot, ACE-RTL, LLM4Cov, SpecLoop, CoverAssert, CVDP, SiliconMind-v1, and broader survey/benchmark work.

Blocked conclusions:

- These sources are not yet deeply read or reproduced.
- Forum discussion signals are practical hints, not peer-reviewed evidence.

Next:

- Write focused notes for Verilog-Evolve and HDLFORGE.

## 2026-06-28 - Verilog-Evolve And HDLFORGE Direction Review

Goal: analyze the two newly downloaded PDFs and decide whether the current repository direction needs adjustment.

Actions:

- Read local PDFs:
  - `2605.26498_Verilog-Evolve.pdf`
  - `2603.04646_HDLFORGE.pdf`
- Added:
  - `docs/paper_notes/verilog_evolve.md`
  - `docs/paper_notes/hdlforge.md`
  - `docs/direction_review_20260628.md`
  - `docs/skill_registry_design.md`
- Updated prompt and skill contracts with repair/escalation fields.

Result:

- No major pivot needed.
- Direction refinement: validation-gated skills and bounded escalation should be designed before larger agent reproduction.

Blocked conclusions:

- Neither paper has been reproduced.
- No Yosys/ABC/formal/micro-test tooling was run.

Next:

- Run the existing Python oracle tests and repository safety checks.
- Later, run mux2 simulation on a machine with `iverilog`.

## Template

Date:

Experiment:

Goal:

Commands:

Result:

Evidence:

Blocked conclusions:

Next:
