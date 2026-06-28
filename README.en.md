# USTC Agent Test FPGA

**Language / 语言:** [中文](./README.md) | English

This repository is a collaboration workspace for studying Verilog/RTL coding agents and hardware-adjacent agent workflows.

The near-term goal is not to build a production autonomous hardware controller. The goal is to reproduce and compare selected Verilog-agent systems, extract reusable workflow patterns, and feed the useful parts back into the graduation project on local knowledge enhancement, credibility admission, deterministic skills, and human-confirmed test-parameter suggestions.

## Current Scope

- Reproduce small, safe Verilog/RTL agent examples.
- Study VerilogCoder, Agentic Frontier, ChipMATE, LEGO, and MAGE-style workflows.
- Adapt useful ideas into explicit prompts, deterministic scripts, skills, and handoff records.
- Keep hardware execution behind fixed scripts and dry-run defaults.
- Keep this public repository free of secrets, private data, raw lab data, and large PDF/binary files.

## Repository Map

- `docs/`: project state, decisions, handoff notes, sync guide, and graduation-project bridge.
- `docs/paper_notes/`: paper reading list and reusable summaries.
- `experiments/`: isolated experiment tracks for each system or idea.
- `prompts/`: prompt drafts and agent role definitions that are safe to publish.
- `skills/`: deterministic skill/tool prototypes.
- `scripts/`: repo maintenance, environment checks, and later reproducible commands.
- `tests/`: regression tests for scripts and deterministic skills.
- `third_party/`: instructions for external code. Do not vendor large third-party repositories casually.

## Public Repository Boundary

Do not commit:

- API keys, tokens, credentials, `.env`, `OAI_CONFIG_LIST`, SSH keys, or local auth files.
- Private Verilog/IP, hardware credentials, raw acquisition data, or lab-only logs.
- PDFs, model weights, waveform dumps, generated simulation databases, or large binaries.
- Graduation-project raw materials such as meeting recordings, original data packages, or unpublished slides.

Commit instead:

- Source links, structured notes, small toy examples, deterministic scripts, tests, and reproducible experiment logs.

## First Commands

These commands are safe discovery checks:

```bash
git status --short --branch
bash scripts/check_repo_safety.sh
bash scripts/doctor.sh
```

Run and test commands for each experiment are intentionally recorded inside that experiment directory once the dependency path is known.

## Current Progress

- Initial project scaffold and GitHub sync are complete.
- First-pass notes for VerilogCoder and Agentic Frontier are complete.
- A Verilog-agent comparison matrix has been added.
- Toolchain notes for `iverilog`, Verilator, and Yosys are available.
- A simulation-only structured prompt and `verilog_compile_check` skill contract are drafted.
- The current MacBook is kept notes-only; toy simulation loops should run on Mac mini, lab Linux, or WSL2 first.

## Collaboration Rule

Before handing work to another person or another machine, update:

- `docs/AGENT_STATE.md`
- `docs/handoff.md`
- `docs/experiment_log.md`

This keeps MacBook, Mac mini, and classmates aligned without relying on chat history.
