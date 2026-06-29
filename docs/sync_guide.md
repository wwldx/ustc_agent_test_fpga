# Sync Guide

This repository is intended to move between MacBook, Mac mini, and classmates' machines through GitHub.

## First Clone On A New Machine

```bash
git clone https://github.com/wwldx/ustc_agent_test_fpga.git
cd ustc_agent_test_fpga
bash scripts/doctor.sh
bash scripts/check_repo_safety.sh
```

## Daily Collaboration Loop

Before starting:

```bash
git pull --ff-only
git status --short --branch
```

For classmates with collaborator access, prefer an upstream feature branch rather
than personal-fork-only work:

```bash
git switch main
git pull --ff-only origin main
git switch -c liujianyu/short-topic-name
```

Then submit with:

```bash
bash scripts/collab_submit.sh -m "Describe the change"
```

See `docs/collaboration_guide_for_classmates.md` for the full fork/upstream
workflow.

Before handing off:

```bash
bash scripts/check_repo_safety.sh
git status --short --branch
```

Then commit only publishable files.

## What To Sync Through Git

- Small source files.
- Prompts and role definitions that are safe to publish.
- Deterministic scripts and tests.
- Paper notes and source links.
- Experiment logs and handoff notes.

## What Not To Sync Through Git

- API keys or model-provider config files.
- Local model weights or checkpoints.
- Paper PDFs.
- Raw lab data and private hardware logs.
- Large generated simulator outputs.
- Private Verilog/IP or bitstreams.

## Public-To-Private Transition

After classmates are added, consider making the GitHub repository private before adding hardware-specific scripts, lab topology notes, or detailed logs.

Even after switching to private, continue using `scripts/check_repo_safety.sh` before each push.
