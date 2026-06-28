# Skill Registry Design Notes

Status: design note, not an implementation.

This document translates the Verilog-Evolve lesson into a local, lightweight skill registry concept.

## Why This Exists

The repository already has prompt drafts and skill contracts. Verilog-Evolve shows that a skill should not be treated as a convenient prompt snippet. A useful skill needs evidence and validation.

## Minimum Skill Metadata

Each future reusable skill should record:

```text
skill_id:
version:
purpose:
trigger_condition:
allowed_inputs:
allowed_outputs:
deterministic_tools:
required_evidence:
validation_cases:
blocked_claims:
known_failure_modes:
provenance:
last_reviewed:
```

## Promotion Rule

A skill should move from draft to reusable only when:

```text
at least one deterministic check passes
and validation cases are recorded
and blocked claims are explicit
and a human reviewer or maintainer accepts the update
```

## Current First Candidate

The first candidate is not a Verilog generation prompt. It is the deterministic verification boundary around:

```text
experiments/toy_iverilog_loop/
skills/verilog_compile_check_contract.md
```

## Relation To Graduation Project

This mirrors the graduation project's historical-label write-back rule:

```text
candidate knowledge
-> evidence
-> validation
-> human acceptance
-> reusable sample/rule/skill
```
