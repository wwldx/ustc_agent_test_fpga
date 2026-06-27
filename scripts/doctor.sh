#!/usr/bin/env bash
set -euo pipefail

echo "[doctor] repository: $(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"
echo "[doctor] date: $(date '+%Y-%m-%d %H:%M:%S %z')"

check_cmd() {
  local name="$1"
  local version_arg="${2:---version}"
  if command -v "$name" >/dev/null 2>&1; then
    echo "[doctor] ${name}: $(command -v "$name")"
    "$name" "$version_arg" 2>&1 | head -n 3 || true
  else
    echo "[doctor] ${name}: missing"
  fi
}

check_cmd git --version
check_cmd python3 --version
check_cmd iverilog -V
check_cmd verilator --version
check_cmd yosys -V
check_cmd node --version

echo "[doctor] done"
