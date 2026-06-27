# MAGE Study

Goal: compare a multi-agent RTL-generation workflow against VerilogCoder and newer agentic evaluations.

Source:

- Paper: https://arxiv.org/abs/2412.07822
- Code: https://github.com/stable-lab/MAGE

## Initial Questions

- What roles does MAGE separate?
- Which roles require model API calls?
- What verification signal is used?
- Which parts can be replaced by Claude Code or Codex while keeping deterministic checks?

## Next Steps

1. Write `docs/paper_notes/mage.md`.
2. Inspect upstream install instructions.
3. Compare role decomposition with VerilogCoder.
