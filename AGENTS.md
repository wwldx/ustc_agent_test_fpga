# Project Work Rules

## Project Purpose

This project evaluates Verilog/RTL coding agents and hardware-adjacent agent workflows as a research and engineering sandbox.

The graduation-project connection is method transfer: task decomposition, deterministic verification, evidence records, and skill/tool boundaries. Do not present this repository as the main graduation thesis by itself, and do not turn it into a broad autonomous hardware agent.

## Main Directories

- `docs/`: durable project memory, handoff, sync instructions, decisions, and paper notes.
- `docs/paper_notes/`: source-linked paper summaries and comparison tables.
- `experiments/verilogcoder_repro/`: NVlabs VerilogCoder reproduction notes and small safe cases.
- `experiments/chipmate_study/`: ChipMATE local-model and dual-agent workflow study.
- `experiments/lego_skill_study/`: LEGO/circuit-skill workflow study.
- `experiments/mage_study/`: MAGE multi-agent RTL-generation workflow study.
- `prompts/`: safe-to-publish prompt and role drafts.
- `skills/`: deterministic skill/tool prototypes.
- `scripts/`: maintenance, environment checks, and reproducible helper commands.
- `tests/`: tests for local deterministic code.
- `third_party/`: external-source handling notes. Prefer links, forks, or submodules over copied code.

## Commands

- Run: `Unknown` until a specific experiment is selected.
- Test: `bash scripts/check_repo_safety.sh` for repository hygiene; experiment tests are recorded per experiment.
- Lint/typecheck: `Unknown`.

Discovery commands:

```bash
git status --short --branch
bash scripts/doctor.sh
bash scripts/check_repo_safety.sh
```

## File Rules

- Keep PDFs and large binaries out of Git. Store paper PDFs outside this repository and record links plus notes here.
- Keep API keys, `.env`, `OAI_CONFIG_LIST`, auth files, SSH keys, and local machine paths out of Git.
- Keep raw lab data, private hardware logs, private bitstreams, and proprietary IP out of Git.
- Put paper summaries in `docs/paper_notes/`.
- Put reproducible experiments under `experiments/<topic>/`.
- Put prompt drafts under `prompts/`; do not paste private system prompts from proprietary services.
- Put deterministic helper code under `scripts/` or `skills/`, with tests when behavior matters.
- Do not let an LLM directly control hardware. Hardware execution must go through fixed scripts, default dry-run, explicit human confirmation, and logged commands.

## Public Repo Safety

This repository is currently public. Treat every committed file as publishable.

Before committing or pushing, run:

```bash
bash scripts/check_repo_safety.sh
```

If the repository later becomes private, the same safety rule still applies because collaborators and machines can still leak secrets by accident.

## Agent Workflow

- Start by reading this file and `docs/AGENT_STATE.md`.
- If decisions matter, read `docs/DECISIONS.md`.
- If learning context matters, read `docs/LEARNING_LOG.md`.
- For paper work, update `docs/paper_notes/README.md` or add a focused note file.
- For experiment work, update `docs/experiment_log.md` and the experiment `README.md`.
- Before finishing substantial work, update `docs/AGENT_STATE.md` and `docs/handoff.md`.
- When a workflow lesson should feed back to the graduation project, update `docs/graduation_project_bridge.md`.
