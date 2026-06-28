#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

echo "[safety] checking repository for files that should not be committed"

bad=0

while IFS= read -r path; do
  echo "[safety] disallowed file pattern: ${path}"
  bad=1
done < <(
  find . \
    -path ./.git -prune -o \
    -type f \( \
      -name '*.pdf' -o \
      -name '*.pptx' -o \
      -name '*.docx' -o \
      -name '*.xlsx' -o \
      -name '*.zip' -o \
      -name '*.tar' -o \
      -name '*.tar.gz' -o \
      -name '*.7z' -o \
      -name '*.rar' -o \
      -name '*.bit' -o \
      -name '*.hwh' -o \
      -name '*.vcd' -o \
      -name '*.fst' -o \
      -name '.env' -o \
      -name 'OAI_CONFIG_LIST' -o \
      -name 'auth.json' \
    \) -print
)

if git grep -n -I -E '((OPENAI_API_KEY|ANTHROPIC_API_KEY|GOOGLE_API_KEY|AZURE_OPENAI_API_KEY)[[:space:]]*=[[:space:]]*[^[:space:]]+|sk-[A-Za-z0-9_-]{20,})' -- . ':!.gitignore' ':!scripts/check_repo_safety.sh' >/tmp/ustc_agent_test_fpga_secret_scan.txt 2>/dev/null; then
  echo "[safety] possible secret-like text found:"
  cat /tmp/ustc_agent_test_fpga_secret_scan.txt
  bad=1
fi

if [ "$bad" -ne 0 ]; then
  echo "[safety] failed"
  exit 1
fi

echo "[safety] ok"
