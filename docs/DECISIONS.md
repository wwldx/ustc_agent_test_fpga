# Decisions

Continuity schema: 0.1

## 2026-06-28 - Keep Current MacBook Notes-Only Until A Runner Is Chosen

Decision: Do not install Verilog toolchains or clone large experiment dependencies on the current MacBook by default.

Reason:

- The user reported limited free disk space on the current Mac.
- The useful work available now is paper analysis, workflow design, prompt contracts, skill contracts, and handoff preparation.
- The first executable loop only needs a machine with `iverilog` / `vvp`; it can run later on Mac mini, Linux, or WSL2.

Impact:

- Current MacBook remains the coordination and writing machine.
- Mac mini / lab Linux / WSL2 should be preferred for simulation runs.
- Before installing anything on a runner, run `bash scripts/doctor.sh` and record the result.

## 2026-06-28 - Start With A Toy Structured Loop Before Full VerilogCoder

Decision: The first executable experiment should be a tiny simulation-only toy loop, not full VerilogCoder or CVDP.

Reason:

- VerilogCoder has API and multi-agent complexity.
- Agentic Frontier shows naive agent scaffolding can degrade performance and crash.
- A toy loop is enough to validate the core method: discover files, plan, edit, compile, simulate, summarize evidence.

Impact:

- `prompts/verilog_agent_structured_loop.md` becomes the first prompt contract.
- `skills/verilog_compile_check_contract.md` defines the deterministic verification boundary.
- Full VerilogCoder reproduction is deferred until the toy loop and toolchain runner are stable.

## 2026-06-27 - Keep Verilog Agent Work In A Separate Repository

Decision: Use this repository for Verilog/RTL agent experiments instead of placing code directly inside the graduation-project directory.

Reason:

- The graduation directory contains meeting records, PPTs, raw data packages, PDFs, and local project state that should not be pushed to GitHub.
- The Verilog-agent work needs a clean collaboration surface that classmates and the Mac mini can clone independently.
- A separate repository makes it easier to run experiments, review commits, and hand off work.

Impact:

- This repository stores code, experiment logs, paper notes, prompts, and deterministic skills.
- The graduation project stores only digested conclusions, group-meeting materials, and thesis-aligned bridge notes.

## 2026-06-27 - Public Repository Safety Boundary

Decision: Treat this repository as public and publishable until explicitly changed.

Reason:

- The GitHub repository is currently public while classmates are being added.
- Early experiments may be safe, but accidental secrets or raw data would be hard to clean after being pushed.

Impact:

- Do not commit API keys, credentials, local auth files, private IP, raw lab data, PDFs, or generated large binaries.
- Run `bash scripts/check_repo_safety.sh` before committing and pushing.
- Use links and notes for papers instead of committing PDF files.

## 2026-06-27 - Hardware Actions Require Deterministic Dry-Run Boundaries

Decision: Any hardware-adjacent action must be represented by a fixed script with dry-run defaults and human confirmation.

Reason:

- The project is for learning Verilog-agent workflows and method transfer, not autonomous hardware control.
- This mirrors the graduation-project boundary: LLMs can suggest and explain, but deterministic skills/tools execute bounded checks.

Impact:

- LLM agents may write or edit Verilog and propose test commands.
- Actual hardware or FPGA programming steps must be logged, dry-run by default, and explicitly confirmed by a human.

## 2026-06-27 - Paper Notes Instead Of PDF Storage

Decision: Keep downloaded papers outside Git and store source-linked notes in `docs/paper_notes/`.

Reason:

- PDFs make the repository heavy and can introduce copyright or redistribution issues.
- Notes, links, and comparison tables are enough for collaboration and group-meeting reuse.

Impact:

- Each paper note should record title, authors or institution if known, source link, reading date, key claims, reproducibility status, and relevance to the graduation project.
