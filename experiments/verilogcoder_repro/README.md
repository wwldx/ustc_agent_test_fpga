# VerilogCoder Reproduction

Goal: inspect and reproduce the smallest safe part of NVlabs VerilogCoder.

Source:

- Paper: https://arxiv.org/abs/2408.08927
- Code: https://github.com/NVlabs/VerilogCoder

## Initial Questions

- What API configuration is required?
- Can a toy example run with only local `iverilog` verification?
- Which parts are prompt/agent orchestration and which parts are deterministic tooling?
- Can Claude Code or Codex replace a sub-agent while preserving the same verification loop?

## Safety Boundary

- Do not commit `OAI_CONFIG_LIST` or model-provider keys.
- Do not commit generated waveforms or large simulator outputs.
- Run only simulation examples until a fixed dry-run hardware boundary exists.

## Next Steps

1. Paper note is done: `docs/paper_notes/verilogcoder.md`.
2. Do not install or clone full dependencies on the current MacBook unless explicitly approved.
3. On a runner with enough disk and `iverilog`, inspect the upstream repo through `third_party/README.md`.
4. Record exact install and run commands here.
5. Run a toy simulation loop before attempting full VerilogCoder.
