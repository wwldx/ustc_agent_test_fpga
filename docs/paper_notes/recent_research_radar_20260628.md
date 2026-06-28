# Recent Verilog/RTL Agent Research Radar

Date: 2026-06-28

Purpose: collect recent papers, repositories, and practical discussions around Verilog/RTL agents, local/no-API workflows, simulator/formal feedback, benchmark design, and skill-style hardware generation.

This is a radar, not a finished literature review. Do not treat every item as reproduced or equally reliable.

## Short Answer

The current corpus is not limited to VerilogCoder, Agentic Frontier, ChipMATE, LEGO, and MAGE. Those are only the first core readings.

The recent field is moving in several directions:

```text
1. structured agent harnesses instead of naive tool wrappers
2. simulator/formal feedback as the main evidence source
3. local/open-model and small-model routing for confidentiality/cost
4. skill evolution and reusable circuit skills
5. stronger benchmarks for RTL generation, debug, optimization, and verification
6. compact logs and human-in-the-loop to avoid agent loops and token blowups
```

## Priority Queue

| Priority | Item | Year | Link | Why it matters |
| --- | --- | ---: | --- | --- |
| P0 | VeriPilot | 2026 | https://github.com/YihanWn/VeriPilot.git | Very recent agentic workflow using golden models, CDFG analysis, and localized bug repair. |
| P0 | Verilog-Evolve | 2026 | https://arxiv.org/abs/2605.19754 | Skill evolution for Verilog generation; directly related to local Codex/Claude skill design. |
| P0 | HDLFORGE | 2026 | https://arxiv.org/abs/2603.02304 | Uses smaller/faster models first, escalates harder cases; useful cost/control pattern. |
| P0 | ACE-RTL | 2026 | https://arxiv.org/abs/2602.10218 | RTL-specialized LLM plus agentic context evolution; related to local/open model strategy. |
| P1 | LLM4Cov | 2026 | https://arxiv.org/abs/2602.16953 | Execution-aware agentic learning for testbench coverage; shifts focus from RTL generation to verification quality. |
| P1 | SpecLoop | 2026 | https://arxiv.org/abs/2603.02895 | RTL-to-specification with formal feedback; useful for evidence-bound reverse reasoning. |
| P1 | CoverAssert | 2026 | https://arxiv.org/abs/2602.06112 | RL for SystemVerilog coverage/assertion generation; relevant to verification-oriented agents. |
| P1 | Large Language Model for Verilog Code Generation: Literature Review and Road Ahead | 2025 | https://arxiv.org/abs/2512.00020 | Broad review with 102 papers; useful for building the reading map. |
| P1 | CVDP benchmark | 2025 | https://arxiv.org/abs/2506.14074 | Newer benchmark designed for agentic design and verification problems. |
| P2 | SiliconMind-v1 | 2026 | https://arxiv.org/abs/2603.08719 | Multi-agent distillation and debug reasoning workflow. |
| P2 | VeriGraphi | 2026 | https://arxiv.org/abs/2604.08892 | Combines graph representation and LLMs; possible bridge to structured circuit evidence. |
| P2 | EvoVerilog | 2025 | https://arxiv.org/abs/2511.12672 | Evolutionary optimization with LLMs; relevant to iterative repair. |
| P2 | RTLLM / RTLCoder line | 2024-2026 | https://arxiv.org/abs/2308.05345 | Older but still important for benchmarks and specialized RTL datasets/models. |

## Advanced Ideas Worth Borrowing

### 1. Golden model / reference model before agent autonomy

VeriPilot and ChipMATE both point toward independent behavioral references:

```text
candidate RTL
-> golden model / Python reference / formal spec
-> simulator or formal check
-> localized mismatch
-> bounded repair
```

Local implication:

- Keep the mux2 Python oracle.
- Next step after `iverilog` is available: compare simulation output against the oracle truth table.
- Do not trust dual-agent agreement by itself; require executable evidence.

Graduation-project implication:

- Parameter suggestions should be checked against physical/theory priors and deterministic analysis scripts, not only LLM reasoning.

### 2. Structured harness beats "more tools"

Agentic Frontier shows that naive tool wrappers can underperform. Expanded tools help less than a disciplined loop.

Local implication:

- The first local prompt should enforce:

```text
discover -> read -> plan -> edit -> compile/simulate -> compact evidence -> stop
```

Graduation-project implication:

- This supports deterministic credibility gates and fixed report formats over a broad "万能 Agent".

### 3. Small-model escalation is more practical than always using frontier models

HDLFORGE-style routing is attractive:

```text
cheap/small model first
-> if compile/simulation fails, escalate to stronger model or human
-> preserve evidence at every stage
```

Local implication:

- On Mac mini/Linux, start with deterministic scripts and human/Codex edits before trying local model weights.
- If a local model is tested later, route only simple cases to it first.

Graduation-project implication:

- Low-risk checks can be deterministic; ambiguous tuning suggestions should escalate to human review.

### 4. Verification may be more valuable than generation

LLM4Cov, CoverAssert, SpecLoop, and related works show that the field is not only "generate RTL." Verification, coverage, assertions, and spec recovery are rapidly growing.

Local implication:

- Treat `verilog_compile_check` as the first skill.
- Later add `simulation_result_parser`, then maybe `coverage_or_assertion_note`.

Graduation-project implication:

- The thesis should emphasize credibility admission, evidence coverage, and blocked conclusions, not only suggestion generation.

### 5. Community pain point: token loops and human-in-the-loop

VerilogCoder issue discussions show practical pain:

- Agents can repeat tool calls and waste tokens.
- Users want human intervention in the loop.
- Full automation is less attractive when failures are expensive or opaque.

Local implication:

- Add repair limits to toy scripts and future prompts.
- Keep `blocked_claims` and `next_step` in evidence files.

Graduation-project implication:

- Keep human confirmation as the write-back boundary.

## Forum / Community Signals

Public long-form forum discussion is thinner than the paper stream. The most actionable community signals found so far are GitHub issue threads:

| Source | Link | Signal |
| --- | --- | --- |
| VerilogCoder issue: Human in the loop | https://github.com/NVlabs/VerilogCoder/issues/2 | User reports agents can call tools in loops until max tokens; asks for human intervention to steer the loop. |
| MAGE issue: syntax correctness bug | https://github.com/stable-lab/MAGE/issues/17 | Even agent-generated RTL benchmark outputs can have syntax issues; verification pipeline matters. |
| VerilogCoder issue: setup/import failures | https://github.com/NVlabs/VerilogCoder/issues | Reproduction can fail at dependency/import setup before any research comparison. |

Practical conclusion:

```text
Before chasing full reproduction, make local toy checks and handoff logs boringly reliable.
```

## Items To Read Next

Recommended next reading order:

1. `Verilog-Evolve`: because it directly addresses skill evolution and reusable experience.
2. `HDLFORGE`: because cost/model-routing is useful for our Mac mini / lab setup.
3. `VeriPilot`: because it is very recent and focuses on golden model + CDFG bug localization.
4. `CVDP`: because Agentic Frontier depends on it and it can guide future benchmark choices.
5. `LLM4Cov` or `SpecLoop`: because verification/evidence is more aligned with the graduation project than pure RTL generation.

## Repository Actions Suggested By This Radar

Short-term, no new toolchain:

- Add `docs/paper_notes/verilog_evolve.md`.
- Add `docs/paper_notes/hdlforge.md`.
- Add a GitHub issue template for `paper-note`, `experiment`, and `runner`.
- Add a repair-limit field to prompt/skill contracts.

After `iverilog` is available:

- Run `experiments/toy_iverilog_loop/scripts/run_local_check.sh`.
- Compare simulation cases against `oracle/mux2_oracle.py`.
- Add a compact `simulation_result_parser`.

Do not do yet:

- Do not download local model weights on the current MacBook.
- Do not clone all upstream repositories.
- Do not run CVDP or full VerilogCoder until toy checks are stable.
