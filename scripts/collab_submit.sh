#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/collab_submit.sh -m "Commit message" [--branch branch-name] [--yes]

Examples:
  bash scripts/collab_submit.sh -m "Add HSG RTL proposal notes"
  bash scripts/collab_submit.sh -m "Add interface contract draft" --branch liujianyu/interface-contract --yes

This script is for collaborators pushing branches to:
  wwldx/ustc_agent_test_fpga

It intentionally avoids personal-fork-only submission.
USAGE
}

commit_message=""
requested_branch=""
yes="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--message)
      if [[ $# -lt 2 ]]; then
        echo "error: missing commit message after $1" >&2
        exit 2
      fi
      commit_message="$2"
      shift 2
      ;;
    --branch)
      if [[ $# -lt 2 ]]; then
        echo "error: missing branch name after --branch" >&2
        exit 2
      fi
      requested_branch="$2"
      shift 2
      ;;
    -y|--yes)
      yes="1"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ -z "$commit_message" ]]; then
  echo "error: commit message is required" >&2
  usage
  exit 2
fi

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "error: not inside a Git repository" >&2
  exit 2
fi

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

origin_url="$(git remote get-url origin 2>/dev/null || true)"
case "$origin_url" in
  git@github.com:wwldx/ustc_agent_test_fpga.git|\
  https://github.com/wwldx/ustc_agent_test_fpga.git|\
  https://github.com/wwldx/ustc_agent_test_fpga)
    ;;
  *)
    cat >&2 <<EOF
error: origin is not the shared upstream repository.

Current origin:
  ${origin_url:-<missing>}

If this checkout came from a fork, run:
  git remote rename origin fork
  git remote add origin git@github.com:wwldx/ustc_agent_test_fpga.git
  git fetch origin
  git switch -c liujianyu/your-topic origin/main
EOF
    exit 2
    ;;
esac

git fetch origin

current_branch="$(git branch --show-current)"
if [[ -z "$current_branch" ]]; then
  echo "error: detached HEAD; create or switch to a branch first" >&2
  exit 2
fi

if [[ -n "$requested_branch" && "$requested_branch" != "$current_branch" ]]; then
  if git show-ref --verify --quiet "refs/heads/$requested_branch"; then
    git switch "$requested_branch"
  else
    if [[ "$current_branch" == "main" ]]; then
      git pull --ff-only origin main
    fi
    git switch -c "$requested_branch"
  fi
  current_branch="$requested_branch"
fi

if [[ "$current_branch" == "main" ]]; then
  safe_user="$(git config user.name | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9._-' '-' | sed 's/^-//;s/-$//')"
  if [[ -z "$safe_user" ]]; then
    safe_user="collab"
  fi
  timestamp="$(date +%Y%m%d-%H%M%S)"
  current_branch="collab/${safe_user}/${timestamp}"
  git pull --ff-only origin main
  git switch -c "$current_branch"
fi

if ! git merge-base --is-ancestor origin/main HEAD; then
  cat >&2 <<EOF
error: current branch is not based on latest origin/main.

Run:
  git fetch origin
  git rebase origin/main

Then retry this script.
EOF
  exit 2
fi

if git diff --quiet && git diff --cached --quiet && [[ -z "$(git ls-files --others --exclude-standard)" ]]; then
  echo "No local changes to submit."
  exit 0
fi

bash scripts/check_repo_safety.sh

echo
echo "Current branch: $current_branch"
echo "Working tree changes:"
git status --short

git add -A

if git diff --cached --quiet; then
  echo "No staged changes after git add."
  exit 0
fi

echo
echo "Staged diff summary:"
git diff --cached --stat

if [[ "$yes" != "1" ]]; then
  echo
  read -r -p "Commit and push these staged changes? [y/N] " answer
  case "$answer" in
    y|Y|yes|YES)
      ;;
    *)
      echo "Aborted before commit."
      exit 1
      ;;
  esac
fi

git commit -m "$commit_message"
git push -u origin "$current_branch"

cat <<EOF

Pushed branch:
  $current_branch

Open a pull request:
  https://github.com/wwldx/ustc_agent_test_fpga/compare/main...$current_branch?expand=1
EOF
