#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"
EVIDENCE_FILE="${BUILD_DIR}/evidence.txt"

mkdir -p "${BUILD_DIR}"

{
  echo "task=toy_iverilog_loop"
  echo "rtl=rtl/mux2.v"
  echo "testbench=tb/tb_mux2.v"
  echo "timestamp=$(date '+%Y-%m-%d %H:%M:%S %z')"
} > "${EVIDENCE_FILE}"

if ! command -v iverilog >/dev/null 2>&1; then
  {
    echo "status=tool_missing"
    echo "missing=iverilog"
    echo "blocked_claims=simulation_not_run"
  } | tee -a "${EVIDENCE_FILE}"
  exit 0
fi

if ! command -v vvp >/dev/null 2>&1; then
  {
    echo "status=tool_missing"
    echo "missing=vvp"
    echo "blocked_claims=simulation_not_run"
  } | tee -a "${EVIDENCE_FILE}"
  exit 0
fi

COMPILE_CMD=(iverilog -g2012 -o "${BUILD_DIR}/mux2.out" "${ROOT_DIR}/rtl/mux2.v" "${ROOT_DIR}/tb/tb_mux2.v")
SIM_CMD=(vvp "${BUILD_DIR}/mux2.out")

{
  echo "compile_command=${COMPILE_CMD[*]}"
  echo "simulation_command=${SIM_CMD[*]}"
} >> "${EVIDENCE_FILE}"

"${COMPILE_CMD[@]}" > "${BUILD_DIR}/compile.stdout" 2> "${BUILD_DIR}/compile.stderr"
"${SIM_CMD[@]}" > "${BUILD_DIR}/sim.stdout" 2> "${BUILD_DIR}/sim.stderr"

if grep -q "PASS mux2" "${BUILD_DIR}/sim.stdout"; then
  {
    echo "status=passed"
    echo "simulation_result=PASS mux2"
    echo "blocked_claims=hardware_correctness_not_claimed"
  } | tee -a "${EVIDENCE_FILE}"
  exit 0
fi

{
  echo "status=simulation_failed"
  echo "simulation_stdout_tail=$(tail -n 5 "${BUILD_DIR}/sim.stdout" | tr '\n' ';')"
  echo "blocked_claims=functional_correctness_not_established"
} | tee -a "${EVIDENCE_FILE}"
exit 1
