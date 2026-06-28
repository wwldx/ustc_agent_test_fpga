# Verilog-Evolve

Source:

- arXiv: https://arxiv.org/abs/2605.26498
- Local PDF: `/Users/wwl_mac/Desktop/2026春季第四学期/校内毕业/临时存放/2605.26498_Verilog-Evolve.pdf`

Reading date: 2026-06-28

## Problem

Verilog-Evolve argues that most Verilog LLM pipelines still look like isolated sampling plus functional checking. That is too weak for practical RTL design because useful Verilog must be:

- functionally correct;
- synthesizable;
- timing-conscious;
- friendly to downstream hardware objectives such as structure, area, delay, and task-specific kernels.

The paper's key criticism is that pass/fail on a limited functional benchmark is not enough. Two RTL implementations can both pass tests while differing substantially in cell count, wire complexity, timing proxy, or downstream accelerator suitability.

## Method

Verilog-Evolve is a feedback-driven framework with two main layers:

1. Versioned Verilog refinement.
2. Cross-session skill evolution.

For each task, it generates multiple minor candidates, evaluates them with executable tool feedback, and promotes the best candidate into a new major version only if it passes configured gates.

The evaluator stack can include:

- `iverilog` / `vvp` functional simulation.
- Yosys synthesis metrics.
- ABC timing proxy.
- Downstream GEMM metrics.
- Optional industrial adapters such as DC/SEC-style gates.

The skill layer stores reusable guidance as modular skill files. After runs, it aggregates logged histories and decides whether to:

- create a new skill;
- improve an existing skill;
- skip the update.

Skill updates can be published immediately or queued for replay-based validation.

## Key Results

On VerilogEval, the paper reports improvement from direct generation to versioned tool feedback and then to skill evolution.

The extracted table shows:

| Method | Tool feedback | Machine final success | Human final success | Promotion pass | Compile pass |
| --- | --- | ---: | ---: | ---: | ---: |
| Direct generation | none | 81.2 | 68.9 | 63.4 | 88.4 |
| Verilog-Evolve without skill evolution | `iverilog+yosys+abc` | 83.6 | 70.4 | 68.7 | 90.3 |
| Verilog-Evolve full | `iverilog+yosys+abc+skills` | 85.3 | 72.8 | 71.6 | 91.9 |

For mixed-precision GEMM, the important qualitative result is that correctness-only selection is not enough. Adding Yosys, ABC timing proxy, and downstream metrics improves cell count, multiplier usage, delay proxy, ADP proxy, and downstream score.

For skill evolution:

| Skill mode | Human success | GEMM score | GEMM held-out pass |
| --- | ---: | ---: | ---: |
| No skills | 68.9 | 4.37 | 82.1 |
| Static skills | 70.4 | 3.98 | 85.0 |
| Evolved immediate | 72.1 | 3.55 | 87.3 |
| Evolved validated | best reported | best reported | best reported |

The exact "validated" values are hard to read from text extraction, but the conclusion is clear: validation-gated skill evolution is safer and better than writing skill updates directly.

## Reproducibility

Current status in this repository:

- Paper has been read and summarized.
- PDF is stored outside Git.
- No upstream code has been cloned.
- No Yosys, ABC, or `iverilog` run has been performed on this MacBook.

Likely reproduction requirements:

- `iverilog` / `vvp`.
- Yosys and ABC.
- Scripted scoring and promotion logic.
- A persistent skill registry.
- Benchmark tasks and evaluator outputs.

This is not a good first runnable target for the current MacBook, but it is very useful for architecture decisions.

## What Transfers To This Repository

The immediate lesson is to make "skill" mean more than a prompt snippet.

A useful local skill should have:

```text
trigger condition
allowed edits or checks
required deterministic evidence
blocked claims
validation cases
version/hash or provenance
```

For our toy loop, the next extension should be:

```text
simulation evidence
-> oracle comparison
-> compact score/evidence file
-> only then update prompt/skill guidance
```

Do not let an LLM update shared skills just because it thinks the advice is good. Skill updates should be validation-gated.

## What Transfers To The Graduation Project

This paper strongly supports the graduation project's direction:

```text
candidate suggestion -> deterministic evidence -> credibility gate -> validated reusable knowledge
```

Mapping:

| Verilog-Evolve | Graduation project |
| --- | --- |
| major/minor versioned RTL | candidate next-test suggestions |
| functional/synthesis/timing evaluators | data credibility and physical/theory checks |
| promotion gate | historical-label write-back gate |
| validated skill update | human-confirmed historical sample / rule update |
| downstream GEMM metrics | response metrics such as Q/S21/noise and evidence quality |

The thesis direction does not need to pivot to Verilog generation. It should borrow the validation-gated skill memory idea.

## Caveats

- ABC timing proxy is not full signoff timing.
- Downstream GEMM is a specific benchmark; it does not map directly to readout-chip parameter tuning.
- Skill evolution can pollute future runs if validation is weak.
- Results are benchmark-driven and have not been reproduced here.

## Direction Impact

Current direction should be refined, not changed:

- Keep toy loop and Python oracle.
- Add a future `skill_registry/` or `skills/registry_notes.md` only after evidence exists.
- Add validation gates before any skill update.
- Track not only pass/fail, but also downstream-style quality metrics when available.
