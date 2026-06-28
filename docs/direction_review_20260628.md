# Direction Review After Verilog-Evolve And HDLFORGE

Date: 2026-06-28

Question: Do the new papers require changing the current repository direction?

## Short Answer

No major pivot is needed. The current direction is basically right:

```text
small deterministic toy loop
-> Python oracle
-> compact evidence
-> later simulator/formal tools
-> then agent/skill expansion
```

But two refinements should be made now:

1. Treat skills as validation-gated artifacts, not prompt snippets.
2. Add repair limits and escalation states before trying larger agents.

## What Verilog-Evolve Changes

Verilog-Evolve shows that reusable skill memory is valuable only when grounded in tool evidence.

Implication:

- Do not create a big `skills/` library by hand too early.
- Add skill metadata only after an experiment has evidence.
- Future skill entries should include:

```text
trigger
evidence source
validation cases
blocked claims
version/provenance
```

For the graduation project:

- This supports the existing write-back gate idea.
- Historical samples and rules should be promoted only after evidence and human review.

## What HDLFORGE Changes

HDLFORGE shows that model escalation should be diagnostic-driven.

Implication:

- The repo should not default to a frontier model or full VerilogCoder/ChipMATE reproduction.
- Start with deterministic checks and a small model/human/Codex path.
- Escalate only when evidence says the cheap path is insufficient.

For the graduation project:

- Suggestions should have escalation states:

```text
low_risk_check
needs_more_evidence
needs_human_review
needs_stronger_model_or_script
blocked
```

## Current Direction Assessment

| Current choice | Keep? | Adjustment |
| --- | --- | --- |
| Keep PDFs out of Git | Yes | Continue storing only notes/links in Git. |
| Current MacBook notes-only | Yes | Do not install toolchains unless explicitly approved. |
| Toy `iverilog` loop first | Yes | Run on Mac mini/Linux/WSL2 when ready. |
| Python oracle | Yes | Use it as the first reference-model evidence path. |
| Full VerilogCoder reproduction later | Yes | Treat as optional escalation after toy loop. |
| ChipMATE local-model route | Yes, but later | Do not download weights before runner planning. |
| Skill contracts | Yes | Add validation/provenance/blocked-claim fields. |
| Prompt loop | Yes | Add repair limit and escalation recommendation. |

## Recommended Next Implementation Steps

No `iverilog` needed:

1. Update `prompts/verilog_agent_structured_loop.md` with a repair limit and escalation states.
2. Update `skills/verilog_compile_check_contract.md` with `repair_attempt`, `escalation_recommendation`, and `validation_cases`.
3. Add a lightweight `docs/skill_registry_design.md`.

Needs `iverilog`:

1. Run the mux2 toy loop.
2. Compare simulation result with Python oracle.
3. Add a compact simulation-result parser.

Needs more tooling later:

1. Add Yosys/ABC-style optional metrics.
2. Add micro-test generation only after a nontrivial failing example exists.
3. Consider full VerilogCoder / ChipMATE / HDLFORGE reproduction only after the deterministic path is stable.

## Bottom Line

The direction should not become "reproduce every Verilog agent paper."

The stronger thesis-aligned direction is:

```text
learn from Verilog-agent research to build evidence-gated, validation-aware,
human-confirmed skill workflows for hardware-adjacent reasoning.
```

That aligns with both this side repository and the graduation project's parameter-tuning credibility loop.
