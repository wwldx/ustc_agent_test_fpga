# Exploring the Agentic Frontier of Verilog Code Generation

Source:

- Paper PDF used locally: `/Users/wwl_mac/Desktop/2026春季第四学期/校内毕业/临时存放/2603.19347v3.pdf`
- arXiv: https://arxiv.org/abs/2603.19347

Reading date: 2026-06-28

## Problem

The paper asks whether wrapping frontier models in an agentic tool loop actually improves Verilog generation. This is directly relevant to the current "replace sub-agents with Claude Code / Codex" idea.

The key question is not "can an agent use tools?" It is:

```text
Does a Verilog-specific agent harness improve correctness after accounting for crashes, bad tool use, context overflow, and file-editing mistakes?
```

## Method

The paper evaluates model-agnostic Verilog agents on CVDP, a benchmark designed for both non-agentic and agentic hardware-design tasks.

The agent harness gives models access to tools such as:

- Linux file operations.
- `iverilog` compile.
- `vvp` simulation.
- Verilator lint.
- Yosys lint and synthesis.
- module-port checking and formal verification where applicable.

The key experimental variants are:

- non-agentic baseline;
- baseline agent with tool access;
- baseline agent without tool access;
- updated structured system prompt;
- expanded tooling.

## Key Results

The headline result is conservative: naive agent wrapping often makes performance worse than a good non-agentic prompt.

Table I examples:

| Model | Non-agentic | Agentic with tool | Agentic no tool |
| --- | ---: | ---: | ---: |
| Gemini-3.1 Pro Preview | 58.61% | 42.39% | 47.39% |
| GPT Codex-5.3 | 49.67% | 45.65% | 41.96% |
| Claude Opus 4.6 | 50.66% | 43.48% | 36.74% |
| Kimi K2.5 | 47.35% | 21.74% | 34.05% |
| MiniMax | 33.11% | 23.55% | 23.91% |

The updated structured prompt is the most useful intervention:

| Model | No tooling | Baseline agent | Updated system message | New tooling |
| --- | ---: | ---: | ---: | ---: |
| GLM-4.7 | 27.17% | 28.26% | 27.17% | 28.26% |
| Kimi K2.5 | 34.05% | 21.74% | 25.00% | 23.91% |
| Gemini-3.1 Pro Preview | 47.39% | 42.39% | 47.61% | 47.39% |
| Gemini-2.5 Flash | 17.39% | 16.30% | 20.65% | 22.83% |

Crash-rate examples:

| Model | Baseline crash | Updated-prompt crash |
| --- | ---: | ---: |
| Gemini 3.1 Pro | 9.1% | 1.7% |
| GLM-4.7 | 27.2% | 12.0% |
| Kimi K2.5 | 39.1% | 25.0% |

Tool-use analysis:

- Simulation with `vvp` is the strongest positive tool signal.
- `iverilog` compile is useful but does not guarantee functional correctness.
- Excessive `sed`, `find`, and broad filesystem operations correlate with wrong runs, likely because the agent is lost or repeatedly patching without a stable plan.

## Most Important Engineering Lesson

The paper's strongest lesson is:

```text
Agent design matters more than simply adding more tools.
```

A useful Verilog agent must enforce a fixed sequence:

```text
discover files
-> plan edits
-> apply bounded changes
-> verify with relevant tools
-> finish only after checks pass
```

This is very close to the workflow we want in this repository and in the graduation project.

## Reproducibility

The paper describes open-source agent harnesses, but this repository has not yet run CVDP or any harness.

Current status:

- Paper read and summarized.
- No CVDP clone.
- No toolchain installed on the current MacBook.
- No benchmark run.

Given disk constraints, the recommended first step is not CVDP. It is a small local toy loop that copies the paper's structured sequence.

## What Transfers To This Repository

Adopt the structured harness as the default agent rule:

1. Discover and read relevant files.
2. Write a plan before edits.
3. Apply only planned edits.
4. Run verification, starting with compile and simulation.
5. Summarize result and stop only after evidence is available.

Avoid:

- dumping long simulator output directly into model context;
- broad file searches after the relevant files are known;
- unbounded edit loops;
- treating more tools as a substitute for better task structure.

## What Transfers To The Graduation Project

This paper is highly relevant to the "可信评价 + deterministic skill" thesis direction:

- A naive "Agent with tools" is not automatically more reliable.
- Structured admission gates and compact evidence summaries matter.
- Missing evidence should block strong claims.
- Tool output needs summarization and routing, not raw dumping into LLM context.

For the low-temperature readout-chip project, the analogous sequence is:

```text
discover sample/evidence files
-> plan credibility checks
-> run deterministic checks
-> summarize missing evidence and response metrics
-> output next-test suggestions only under explicit evidence level
```

## Caveats

- Results are benchmark-specific; CVDP is not real hardware operation.
- "Agentic tool use can degrade performance" does not mean agents are useless; it means careless harnesses are risky.
- The paper suggests expanded tools have marginal benefit, but this does not remove the need for correct verification tools in real workflows.
- Model names and benchmark results are time-sensitive; treat them as evidence for workflow design, not as permanent model rankings.

## Next Actions

1. Create a local toy structured-agent prompt in `prompts/`.
2. Define a minimal `verilog_compile_check` skill contract in `skills/`.
3. Run the toy loop on a machine with `iverilog`.
4. Compare the toy loop against full VerilogCoder reproduction before spending setup time.
