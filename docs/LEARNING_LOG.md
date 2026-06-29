# Learning Log

Continuity schema: 0.1

## 2026-06-29 - Fork Commits Need An Explicit Upstream Landing Path

### Key Understanding

- A GitHub fork is a separate copy of the repository. A commit pushed there does
  not automatically appear in upstream branches.
- Once a collaborator has write access, the lower-friction route is to clone the
  upstream repo, work on an upstream feature branch, and open a pull request.
- Merging a stale fork `main` can look harmless but may remove newer upstream
  work. Compare branches before importing anything.

### Artifact

- Imported classmate `patch-1` proposal as
  `docs/proposals/hsg_rtl_generation_plan_liujianyu.md`.
- Added `docs/collaboration_guide_for_classmates.md`.
- Added `scripts/collab_submit.sh`.

### Follow-ups

- Send the collaborator guide and script usage to the classmate.
- Review the HSG-RTL proposal into one small executable next step before coding.

## 2026-06-28 - Verilog Agent Papers Favor Structured Evidence Over Broad Tooling

### Key Understanding

- VerilogCoder shows that planning plus simulator/waveform evidence can strongly improve benchmark pass rates, but at high token/API complexity.
- Agentic Frontier shows the opposite risk: naive agent wrappers can perform worse than good non-agentic prompting.
- The common lesson is not "use more agents"; it is "force a bounded workflow and preserve deterministic evidence."
- Simulation is a useful positive signal, but compile success alone is only syntax evidence.
- Long simulator output can crash an agent through context overflow, so logs need compact summaries.

### Decisions

- Keep the current MacBook notes-only until a runner with toolchain and disk space is chosen.
- Start with a toy structured loop before attempting full VerilogCoder or CVDP.

### Follow-ups

- Summarize ChipMATE next for local/no-API lessons.
- Implement the `verilog_compile_check` skill after `iverilog` is available on a runner.
- Feed the same "compact deterministic evidence" pattern back into the graduation project's credibility-gate wording.

## 2026-06-28 - ChipMATE Should Be Treated As A Local-Model Design Reference First

### Key Understanding

- ChipMATE is the most relevant paper so far for no-API / lab-local constraints because it uses open-source/local model routes and a Verilog + Python dual-agent idea.
- It is not lightweight: model weights, vLLM, GPU resources, `iverilog`, and Python dependencies make it unsuitable as the first MacBook experiment.
- The reference-model idea can be tested without full ChipMATE by adding a tiny Python oracle to a toy Verilog loop.

### Decisions

- Do not reproduce full ChipMATE on the current MacBook.
- Use `experiments/toy_iverilog_loop/` as the first executable verification boundary.

### Follow-ups

- Run the toy loop on Mac mini / Linux / WSL2 after `iverilog` is available.
- Add a Python oracle as the next small step after the toy loop passes.

## 2026-06-28 - Deterministic Oracle Before LLM Reference Agent

### Key Understanding

- ChipMATE's Python-agent idea can be usefully approximated by a deterministic Python reference model before adding any model-serving complexity.
- This gives a clean evidence contract: the oracle defines expected behavior, and later Verilog simulation can be compared against it.
- The same pattern maps back to the graduation project: deterministic physical/theory checks should exist before an LLM produces stronger suggestions.

### Decisions

- Add `experiments/toy_iverilog_loop/oracle/mux2_oracle.py`.
- Add a unit test so the oracle itself has a verification boundary.

### Follow-ups

- Once `iverilog` is available, compare the Verilog testbench cases against the oracle truth table.

## 2026-06-28 - Recent RTL Agent Literature Is Broader Than The First Core Set

### Key Understanding

- The field is moving beyond "generate Verilog with an LLM" into structured harnesses, verification feedback, skill evolution, local/no-API deployment, and benchmark design.
- The next most relevant items are Verilog-Evolve, HDLFORGE, VeriPilot, CVDP, LLM4Cov, and SpecLoop.
- Public forum discussion is thin, but GitHub issue threads expose practical failure modes: agent loops, token blowups, syntax issues, and setup friction.

### Decisions

- Keep a radar document separate from finished paper notes.
- Treat GitHub issue signals as practical workflow evidence, not academic conclusions.

### Follow-ups

- Write focused notes for Verilog-Evolve and HDLFORGE before chasing more broad search.
- Add repair limits and stop conditions to prompt/skill contracts.

## 2026-06-28 - Verilog-Evolve And HDLFORGE Refine But Do Not Redirect The Work

### Key Understanding

- Verilog-Evolve turns "skills" into validation-gated reusable artifacts backed by simulation/synthesis/timing/downstream evidence.
- HDLFORGE turns "use a stronger model" into an evidence-driven escalation decision with bounded attempts.
- Both papers support the current local direction: deterministic toy loop first, evidence parser next, larger agent frameworks later.

### Decisions

- Do not pivot to reproducing full Verilog-Evolve or HDLFORGE immediately.
- Add repair limits, escalation recommendations, validation cases, and skill provenance to local contracts now.

### Follow-ups

- After `iverilog` is available, run the mux2 simulation and compare it with the Python oracle.
- Then add a compact simulation-result parser and an evidence schema.

## 2026-06-27 - Separate Repo, Shared Method Bridge

### Key Understanding

- The Verilog-agent direction is useful for the graduation project as a method source, not as a replacement topic.
- Directly pushing the full graduation directory would mix raw data, meeting artifacts, and local state with code experiments.
- A clean repository plus a bridge document keeps collaboration efficient while preserving the graduation project's scope.

### Decisions

- Keep executable Verilog-agent experiments here.
- Feed only digested lessons back into the graduation project.
- Use deterministic checks and evidence records as the common language between both projects.

### Follow-ups

- Convert VerilogCoder and Agentic Frontier into focused paper notes.
- Identify the smallest reproducible Verilog simulation loop.
- Compare API-based, Claude Code/Codex-based, and local-model-based execution paths.
