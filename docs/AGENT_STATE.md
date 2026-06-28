# Agent State

Continuity schema: 0.1

## Current Focus

Build a clean collaboration repository for Verilog/RTL agent experiments, with explicit links back to the graduation project's method needs: deterministic skills, credibility checks, evidence-bound suggestions, and human-confirmed hardware boundaries.

## Completed

- Created the initial repository skeleton.
- Set the public-repository boundary: no secrets, no PDFs, no raw data, no private IP, and no hardware credentials.
- Split the first study tracks into VerilogCoder reproduction, Agentic Frontier reading, ChipMATE study, LEGO skill study, and MAGE study.
- Added bridge, handoff, experiment log, sync guide, and repository safety scripts.
- Summarized the two local PDFs that can be studied without installing a toolchain:
  - `docs/paper_notes/verilogcoder.md`
  - `docs/paper_notes/agentic_frontier.md`
- Added the cross-paper synthesis `docs/paper_notes/comparison_matrix.md`.
- Added `docs/toolchain_notes.md`, explaining `iverilog`, `vvp`, Verilator, Yosys, storage risk, and why the current MacBook should stay notes-only for now.
- Drafted a simulation-only structured prompt in `prompts/verilog_agent_structured_loop.md`.
- Drafted a deterministic skill contract in `skills/verilog_compile_check_contract.md`.

## Next

- Read and summarize ChipMATE next, because it is most relevant to no-API / local-model constraints.
- Clone or inspect `NVlabs/VerilogCoder` only after choosing a runner with enough disk and `iverilog`.
- Run the smallest toy simulation loop before full VerilogCoder reproduction.
- Decide whether the first executable experiment should use VerilogCoder directly or a small local toy loop that only runs `iverilog`.
- After classmates join the GitHub repository, consider switching the repository to private before adding any hardware-specific scripts or logs.

## Open Questions

- Which machine should be the primary runner first: MacBook Air, Mac mini, or Linux lab machine?
- Which model backend is acceptable for first tests: API model, Claude Code/Codex as coding agent, or local model?
- Whether VerilogCoder's original dependencies are worth reproducing exactly, or whether to extract only the planning/simulation/repair loop.
- Which FPGA/hardware operations, if any, will be represented as dry-run scripts in this repository.

## Verification

- 2026-06-28 local PDFs inspected:
  - VerilogCoder PDF size about 730 KB, 8 pages.
  - Agentic Frontier PDF size about 194 KB, 9 pages.
- 2026-06-28 paper notes were created from local PDFs; no toolchain installation, third-party clone, model download, or simulation run was performed.
- 2026-06-27 `bash scripts/check_repo_safety.sh` passed.
- 2026-06-27 `bash scripts/doctor.sh` ran on the first MacBook checkout: Git, Python 3.14, and Node are available; `iverilog`, Verilator, and Yosys are missing.
- Initial files are scaffolded only; no Verilog agent experiment has been run yet.
- Run `bash scripts/check_repo_safety.sh` before the first commit and before every push.
- Run `bash scripts/doctor.sh` after checking out on a new machine.
