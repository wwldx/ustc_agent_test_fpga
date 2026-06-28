# Verilog Agent Paper Comparison Matrix

Reading status date: 2026-06-28

## Summary Table

| Item | Main idea | Repro status here | API/local implication | Most useful lesson |
| --- | --- | --- | --- | --- |
| VerilogCoder | Multi-agent Verilog generation with TCRG planning and AST waveform tracing | Paper summarized; code not run | API-heavy in original setup; depends on simulator feedback | Pair LLM agents with compact deterministic debug evidence. |
| Agentic Frontier | Systematic evaluation of Verilog agents on CVDP | Paper summarized; harness not run | Model-agnostic; compares open/closed models | Naive agents can hurt; structured workflow matters most. |
| ChipMATE | Local/open-model dual-agent Verilog + Python reference-model workflow | Paper/repo summarized; not run | Strong candidate for no-API environments, but likely GPU/model-weight heavy | Reference-model cross-check should be reduced into a small deterministic toy loop first. |
| LEGO | Skill-based front-end design generation | Reading pending | Skill-contract framing; public repo may be incomplete | Useful abstraction for local Codex/Claude skills. |
| MAGE | Multi-agent RTL code generation engine | Reading pending | Open multi-agent comparison point | Compare role decomposition with VerilogCoder. |

## Immediate Ranking

1. `Agentic Frontier`: best current guide for how not to build a weak agent wrapper.
2. `VerilogCoder`: best concrete older baseline for multi-agent + simulator + waveform-debug flow.
3. `ChipMATE`: most relevant when API use is not acceptable, but not lightweight enough for the current MacBook.
4. `LEGO`: conceptually relevant for skill contracts, but must verify public artifact completeness.
5. `MAGE`: useful comparison after the first two are understood.

## Cross-Paper Lessons So Far

- Simulation is the key verification signal, but it must be compactly summarized.
- Compile success is necessary but insufficient.
- More tools do not automatically improve outcomes.
- Agent crashes and context overflow are real engineering failure modes.
- Open/local models may work on easy tasks but can fail more on medium/hard tasks because of crashes and weaker tool-output interpretation.
- A good workflow should be small, bounded, and auditable before it is made autonomous.
- Local/no-API workflows still need serious runner planning: model weights, vLLM, GPU memory, and simulator tools can dominate setup cost.

## Relevance To Graduation Project

The common transferable pattern is:

```text
LLM organization + deterministic tool evidence + explicit missing-evidence gate + human confirmation
```

This maps directly to the low-temperature readout-chip work:

```text
historical test data / new sweep
-> deterministic feature and credibility checks
-> evidence-bound response metric summary
-> warning and missing-evidence output
-> next-test suggestion
-> human-confirmed write-back
```

Do not use these papers to claim that the graduation project is a Verilog-agent project. Use them to justify a more disciplined local-knowledge and deterministic-skill architecture.
