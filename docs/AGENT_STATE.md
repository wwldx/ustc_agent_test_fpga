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
- Summarized ChipMATE in `docs/paper_notes/chipmate.md`; current conclusion is to borrow the dual-agent/reference-model idea, not to run full local-model inference on the current MacBook.
- Scaffolded the first executable toy loop under `experiments/toy_iverilog_loop/`.
- Added a tiny Python reference model for the toy mux2 loop under `experiments/toy_iverilog_loop/oracle/`.
- Added recent research/community radar docs:
  - `docs/paper_notes/recent_research_radar_20260628.md`
  - `docs/paper_notes/community_discussions.md`
- Summarized Verilog-Evolve and HDLFORGE:
  - `docs/paper_notes/verilog_evolve.md`
  - `docs/paper_notes/hdlforge.md`
- Added `docs/direction_review_20260628.md`; conclusion is to refine the direction with validation-gated skills and escalation limits, not pivot away from the toy/evidence-first path.
- Added `docs/skill_registry_design.md`.
- Imported classmate fork branch `liujianyu20021122:patch-1` proposal commit `0e59e72` as `docs/proposals/hsg_rtl_generation_plan_liujianyu.md`; fork `main` was behind upstream and was not merged.
- Added collaborator workflow documentation and a helper script:
  - `docs/collaboration_guide_for_classmates.md`
  - `scripts/collab_submit.sh`

## Next

- Run `experiments/toy_iverilog_loop/scripts/run_local_check.sh` on a machine with `iverilog` / `vvp`.
- Run the Python oracle tests on each checkout; later connect oracle output to the Verilog simulation evidence after `iverilog` is available.
- Read the next radar items in order: Verilog-Evolve, HDLFORGE, VeriPilot, then CVDP / LLM4Cov / SpecLoop as needed.
- Update future scripts/evidence files with repair limits, escalation recommendations, and validation-case fields.
- Clone or inspect `NVlabs/VerilogCoder` only after choosing a runner with enough disk and `iverilog`.
- Run the smallest toy simulation loop before full VerilogCoder reproduction.
- Decide whether the first executable experiment should use VerilogCoder directly or a small local toy loop that only runs `iverilog`.
- After classmates join the GitHub repository, consider switching the repository to private before adding any hardware-specific scripts or logs.
- Ask collaborators to push upstream feature branches with `scripts/collab_submit.sh` instead of accumulating work only in personal forks.
- Review the HSG-RTL proposal and reduce it to the next small deterministic artifact before implementation, such as a minimal graph schema or interface-contract schema.

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
- 2026-06-28 ChipMATE was summarized from arXiv/GitHub public sources; no model weights, vLLM server, upstream clone, or simulation run was performed.
- 2026-06-28 toy loop scaffold was added; current MacBook is expected to report `tool_missing` until `iverilog` is available.
- 2026-06-28 `bash experiments/toy_iverilog_loop/scripts/run_local_check.sh` was run in a temp copy on the current MacBook -> `status=tool_missing`, `missing=iverilog`, `blocked_claims=simulation_not_run`.
- 2026-06-28 `python3 -m unittest tests/test_mux2_oracle.py` -> 4 tests passed.
- 2026-06-28 `python3 experiments/toy_iverilog_loop/oracle/mux2_oracle.py` printed the 8-row mux2 truth table.
- 2026-06-28 recent radar was built from public search results and source links; no PDFs, model weights, or upstream repositories were downloaded.
- 2026-06-28 Verilog-Evolve and HDLFORGE local PDFs were analyzed from `临时存放/`; no new toolchain, model weights, or upstream repositories were downloaded.
- 2026-06-29 fetched classmate fork branches `main` and `patch-1`. Fork `main` is at `f06177c` and would remove the later upstream direction-review work if merged. Branch `patch-1` adds one proposal file, imported as a proposal document.
- 2026-06-27 `bash scripts/check_repo_safety.sh` passed.
- 2026-06-27 `bash scripts/doctor.sh` ran on the first MacBook checkout: Git, Python 3.14, and Node are available; `iverilog`, Verilator, and Yosys are missing.
- Initial files are scaffolded only; no Verilog agent experiment has been run yet.
- Run `bash scripts/check_repo_safety.sh` before the first commit and before every push.
- Run `bash scripts/doctor.sh` after checking out on a new machine.
