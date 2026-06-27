# Decisions

Continuity schema: 0.1

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
