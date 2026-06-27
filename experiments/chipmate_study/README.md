# ChipMATE Study

Goal: study the local/open-model and dual-agent reference-model workflow.

Source:

- Paper: https://arxiv.org/abs/2605.12857
- Code: https://github.com/zhongkaiyu/ChipMATE

## Why This Matters

ChipMATE is relevant when API-based agents are undesirable because of secrecy, offline operation, or lab network constraints.

## Initial Questions

- What is the minimal local-model setup?
- How does the Verilog agent interact with the Python reference-model agent?
- Can the reference-model idea become a deterministic local skill for small examples?
- What evidence should be logged before claiming a generated design is correct?

## Next Steps

1. Write `docs/paper_notes/chipmate.md`.
2. Inspect upstream dependency and model-weight requirements.
3. Prototype a tiny reference-model verification loop without downloading large weights.
