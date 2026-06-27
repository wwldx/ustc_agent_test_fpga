# LEGO Skill Study

Goal: extract reusable skill-contract ideas from LEGO-style circuit-design generation.

Source:

- Paper: https://arxiv.org/abs/2604.23355
- Code: https://github.com/loujc/LEGO-An-LLM-Skill-Based-Front-End-Design-Generation-Platform

## Why This Matters

The graduation project also needs explicit deterministic skills, not a broad agent. LEGO's skill framing may help define reusable contracts for Verilog generation, verification, and report rendering.

## Initial Questions

- What is a circuit skill input/output contract?
- Which skills are deterministic and which are prompt-only?
- Can a "Verilog simulation verification skill" be defined locally?
- Which parts remain unpublished or incomplete in the public repo?

## Next Steps

1. Write `docs/paper_notes/lego.md`.
2. Draft one local skill contract in `skills/`.
3. Compare it with the graduation project's deterministic skill pattern.
