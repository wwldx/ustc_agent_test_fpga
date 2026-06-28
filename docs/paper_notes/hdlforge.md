# HDLFORGE

Source:

- arXiv: https://arxiv.org/abs/2603.04646
- Local PDF: `/Users/wwl_mac/Desktop/2026春季第四学期/校内毕业/临时存放/2603.04646_HDLFORGE.pdf`

Reading date: 2026-06-28

## Problem

HDLFORGE targets the accuracy-latency trade-off in Verilog generation. Prior systems often fix one model scale and treat wall-clock time, tool cost, and escalation strategy as secondary.

The paper asks:

```text
Can a cheap/medium model solve easy cases first, while a stronger model is invoked only when diagnostic evidence says escalation is needed?
```

This is highly relevant to local/no-API and cost-aware workflows.

## Method

HDLFORGE is a two-stage multi-agent framework.

Stage A:

- Uses a medium-sized coder, e.g. Qwen2.5-Coder-7B.
- Generates candidates.
- Runs inexpensive diagnostics: compile, lint, smoke tests.
- Repairs using tracer/reflection feedback.
- Accumulates micro-tests from counterexamples.

Stage B:

- Uses a stronger model, e.g. Claude 3.5 in the paper.
- Is invoked at most once when Stage A stalls or diagnostic score falls below a threshold.
- Receives summarized Stage A failures, suspect cones, and micro-tests.

The diagnostic vector includes:

- compile score;
- lint score;
- smoke consistency;
- trace stability;
- remaining budget.

The escalation controller computes a score and escalates only if the score is below threshold or attempt budget is exhausted.

## Counterexample-Guided Micro-Tests

The most useful idea is the "formal amplifier":

```text
bounded model checking trace
-> counterexample
-> deterministic micro-testbench
-> cheap future smoke test
```

This turns a failure into a reusable executable test rather than a long log. The paper reports that micro-tests improve detection and reduce repair iterations.

## Key Results

The paper reports:

- HDLFORGE-Qwen achieves 91.2% Pass@1 on VerilogEval Human.
- HDLFORGE-Qwen achieves 91.8% Pass@1 on VerilogEval V2.
- HDLFORGE-Qwen achieves 97.2% Pass@5 on RTLLM.
- The Qwen variant reportedly cuts median latency by roughly 50% while improving accuracy over medium-model baselines.
- HDLFORGE-GPT4o reaches higher absolute scores, but the cost/latency lesson remains: escalation should be evidence-driven.

Bug-injection micro-test study:

| Variant | Bug detection | Repair iterations | Wall-clock time |
| --- | ---: | ---: | ---: |
| HDLFORGE without micro-tests | 82.5 | 5.0 | 36.8 |
| HDLFORGE with micro-tests | 95.0 | 3.0 | 33.1 |

The extracted text also says micro-tests help especially for reset and FSM bugs where counterexamples can be encoded as short deterministic traces.

## Reproducibility

Current status in this repository:

- Paper has been read and summarized.
- PDF is stored outside Git.
- No upstream implementation has been cloned.
- No formal tools, Verilator, Yosys, or `iverilog` run has been performed on this MacBook.

Likely reproduction requirements:

- `iverilog` / `vvp`.
- Verilator or `svlint`.
- Yosys / SymbiYosys / SMTBMC for formal counterexamples.
- At least one local or API model backend.
- Benchmark harness.

This is not a first MacBook experiment, but it directly informs how the future runner should be designed.

## What Transfers To This Repository

HDLFORGE gives a clear escalation policy:

```text
small/cheap path first
-> diagnostic score
-> repair with bounded attempts
-> escalate once when evidence says it is needed
```

Immediate repository improvements:

- Add repair limits to prompt/skill contracts.
- Add `escalation_recommendation` to future evidence files.
- Keep Stage B optional and human-triggered for now.
- Treat micro-tests as reusable evidence artifacts.

For the toy mux2 loop, the micro-test idea is already represented in a minimal way:

- testbench checks all truth-table cases;
- Python oracle independently renders expected values;
- future simulation parser can compare simulation output to oracle cases.

## What Transfers To The Graduation Project

The paper maps well to the thesis workflow:

| HDLFORGE | Graduation project |
| --- | --- |
| Stage A medium model | deterministic/local checks and low-risk suggestions |
| Stage B stronger model | human/stronger-model review for ambiguous cases |
| diagnostic score | credibility level / warning severity |
| micro-tests | small evidence packets / reduced exports / fit figures |
| bounded escalation | no direct "best parameter" claim without evidence |

This suggests the graduation software should support escalation states:

```text
accepted_low_risk
needs_more_evidence
needs_human_review
needs_stronger_model_or_script
blocked
```

## Caveats

- Reported performance depends on benchmark and model choices.
- Stage B in the paper uses cloud/frontier models, which may conflict with no-API constraints.
- Formal micro-tests require formal tooling and task properties; not every module or lab-data problem has a formal oracle.
- Escalation score calibration is itself an engineering task.

## Direction Impact

Current direction should be improved in two ways:

1. Add explicit repair/escalation limits to the toy prompt and future skill contracts.
2. Treat "stronger model / full framework" as an escalation path, not the default path.

This reinforces the current plan:

```text
toy deterministic loop first
-> evidence parser
-> oracle comparison
-> repair/escalation policy
-> only then larger agent frameworks
```
