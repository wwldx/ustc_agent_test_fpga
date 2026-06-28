# VerilogCoder

Source:

- Paper PDF used locally: `/Users/wwl_mac/Desktop/2026春季第四学期/校内毕业/临时存放/2408.08927v2.pdf`
- arXiv: https://arxiv.org/abs/2408.08927
- Code: https://github.com/NVlabs/VerilogCoder

Reading date: 2026-06-28

## Problem

The paper targets specification-to-RTL Verilog generation. A plain LLM can often produce syntactically plausible code, but it struggles with functional correctness, especially when the module behavior depends on state machines, waveform examples, transition tables, or indirect natural-language descriptions.

The authors frame the problem as more than "generate one Verilog file." Their workflow needs planning, syntax checking, simulation, waveform debugging, and iterative repair.

## Method

VerilogCoder combines multiple LLM agents with Verilog-specific tools:

- A high-level planner decomposes the module task.
- Example/signal/transition extraction agents build task context.
- A Task and Circuit Relation Graph (TCRG) planner retrieves relevant relationships and creates a task-oriented plan.
- A code agent writes partial or full Verilog.
- A debug agent uses simulator feedback and an AST-based waveform tracing tool to diagnose functional mismatches.

The deterministic tool side is important:

- `iverilog` is used as the syntax checker and simulator front end.
- The simulator produces pass/fail feedback and waveform data.
- The AST-based waveform tracing tool back-traces mismatched signals and gives the agent a smaller, structured debugging view.

The most useful pattern is:

```text
plan -> generate -> compile -> simulate -> trace mismatch -> repair -> record result
```

## Key Results

Benchmark: VerilogEval-Human v2, 156 specification-to-RTL tasks.

Reported pass rates:

| Method | Model type | Pass rate |
| --- | --- | --- |
| GPT-4 Turbo baseline | closed | 60.3% |
| VerilogCoder with Llama 3 70B | open | 67.3% |
| VerilogCoder with GPT-4 Turbo | closed | 94.2% |

Ablation study:

| Planner / tool setup | Pass rate |
| --- | --- |
| Planner1 without AST-WT | 66.7% |
| Planner1 with AST-WT | 78.2% |
| TCRG Planner2 without AST-WT | 74.4% |
| TCRG Planner2 with AST-WT | 94.2% |

The reported average tool/agent cost is also notable: VerilogCoder uses about 13x the token count of the GPT-4 Turbo baseline, with average simulator calls and AST-WT calls per problem. This matters for API cost and latency.

## Reproducibility

The public code exists, but exact reproduction is not yet verified in this repository.

Likely dependencies:

- Python environment.
- Model API configuration such as `OAI_CONFIG_LIST`.
- `iverilog` and `vvp`.
- The repository's agent scripts and benchmark data.

Current local status:

- Paper read and summarized.
- No upstream code cloned into this repository.
- No API key or `OAI_CONFIG_LIST` committed.
- No simulation has been run.
- Current MacBook lacks `iverilog`, Verilator, and Yosys.

## What Transfers To This Repository

Use VerilogCoder as a design reference, but do not copy the whole architecture blindly.

Transferable pieces:

- Separate planner, generator, verifier, debugger, and reporter roles.
- Keep simulator output as evidence, not just conversational text.
- Add structured mismatch summaries so the model does not drown in raw waveform/log output.
- Treat each repair loop as a traceable experiment.

First local experiment should be smaller than full VerilogCoder:

```text
toy Verilog spec
-> generate or edit RTL
-> run iverilog/vvp
-> parse pass/fail
-> write compact evidence report
```

## What Transfers To The Graduation Project

The most relevant graduation-project lesson is not Verilog itself. It is the separation between LLM reasoning and deterministic evidence.

Analogy:

| VerilogCoder | Graduation project |
| --- | --- |
| syntax checker / simulator | deterministic data-checking skill |
| waveform mismatch | response-metric anomaly / missing evidence |
| AST-WT compact trace | evidence summary and credibility admission |
| debug agent | next-test suggestion generator |
| pass/fail under testbench | human-confirmed sample gate |

This supports the current thesis wording:

```text
LLM proposes or organizes; deterministic tools verify; human review gates write-back.
```

## Caveats

- A 94.2% benchmark pass rate does not mean the generated code is trustworthy for real hardware.
- The benchmark uses provided golden testbenches; real lab hardware will not always have such complete oracles.
- The method is API- and token-heavy.
- The AST waveform tracer is domain-specific; replacing it with Claude Code or Codex prompts alone would lose the key deterministic debugging signal.
- This should not become the graduation project's main topic.

## Next Actions

1. Inspect `NVlabs/VerilogCoder` without committing credentials or large artifacts.
2. Record the minimum dependency set in `experiments/verilogcoder_repro/README.md`.
3. Run a tiny local `iverilog` example on Mac mini or Linux first.
4. Only after the toy loop works, evaluate whether full VerilogCoder reproduction is worth the setup cost.
