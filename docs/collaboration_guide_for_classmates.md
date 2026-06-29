# Classmate Collaboration Guide

This guide is for classmates who already have collaborator access to
`wwldx/ustc_agent_test_fpga`.

## Core Rule

Use the upstream repository as `origin`:

```bash
git@github.com:wwldx/ustc_agent_test_fpga.git
```

Do not keep doing daily work only inside a personal fork. A fork is useful for
external contributors, but collaborators should normally push a feature branch
to the upstream repository, then open a pull request or ask for review.

## One-Time Setup

Recommended clean setup:

```bash
git clone git@github.com:wwldx/ustc_agent_test_fpga.git
cd ustc_agent_test_fpga
git config user.name "liujianyu20021122"
git config user.email "your_email@example.com"
bash scripts/doctor.sh
bash scripts/check_repo_safety.sh
```

If the local checkout was cloned from the fork, keep the fork as `fork` and add
the real shared repository as `origin`:

```bash
git remote -v
git remote rename origin fork
git remote add origin git@github.com:wwldx/ustc_agent_test_fpga.git
git fetch origin
git switch -c liujianyu/first-upstream-branch origin/main
```

HTTPS also works if SSH keys are not configured:

```bash
git remote add origin https://github.com/wwldx/ustc_agent_test_fpga.git
```

## Daily Branch Workflow

Start from the latest shared `main`:

```bash
git switch main
git pull --ff-only origin main
git switch -c liujianyu/short-topic-name
```

After editing files, use the helper script:

```bash
bash scripts/collab_submit.sh -m "Add HSG RTL proposal notes"
```

For non-interactive use:

```bash
bash scripts/collab_submit.sh -m "Add HSG RTL proposal notes" --yes
```

The script will:

1. Check that `origin` points to `wwldx/ustc_agent_test_fpga`.
2. Refuse unsafe direct work on an ambiguous detached checkout.
3. Run `scripts/check_repo_safety.sh`.
4. Stage changes, show a diff summary, commit, and push the current branch.
5. Print the GitHub compare URL for opening a pull request.

## What To Commit

Good Git content:

- Small source files.
- Markdown notes and paper summaries.
- Prompt drafts that are safe to publish.
- Deterministic scripts and tests.
- Small example RTL/testbench files.

Do not commit:

- API keys, tokens, `.env`, auth files, SSH keys.
- Paper PDFs.
- Model weights and checkpoints.
- Raw lab data, private hardware logs, bitstreams, or proprietary IP.
- Large simulator output directories.

## If Work Already Landed In The Fork

For the 2026-06-29 import, fork branch `patch-1` contained one new file:
`PLAN.md`. It was imported into the upstream repo as:

```text
docs/proposals/hsg_rtl_generation_plan_liujianyu.md
```

Future work should happen on an upstream branch:

```bash
git fetch origin
git switch -c liujianyu/next-topic origin/main
```

Then edit, run checks, and submit:

```bash
bash scripts/collab_submit.sh -m "Describe the change"
```

## Vocabulary

- `commit`: save a local snapshot.
- `push`: upload local commits to GitHub.
- `fork`: personal copy under your own GitHub account.
- `upstream`: the shared project under `wwldx/ustc_agent_test_fpga`.
- `branch`: a named line of work.
- `pull request`: a GitHub review/merge request from a branch into `main`.

Preferred route:

```text
upstream main -> upstream feature branch -> pull request/review -> upstream main
```
