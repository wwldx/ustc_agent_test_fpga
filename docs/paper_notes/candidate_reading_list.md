# Candidate Reading List

This list starts with papers and repositories that are directly relevant to Verilog/RTL agents, agentic code generation, and hardware-design verification loops.

## Core

For a broader recent scan, see `recent_research_radar_20260628.md`.

### VerilogCoder: Autonomous Verilog Coding Agents with Graph-based Planning and Abstract Syntax Tree (AST)-based Waveform Tracing Tool

- Source: https://arxiv.org/abs/2408.08927
- Code: https://github.com/NVlabs/VerilogCoder
- Status: summarized in `verilogcoder.md`.
- Initial reason to read: baseline "Verilog coding agent" workflow; includes planning, simulation, and repair ideas.
- Repro question: can the smallest example run locally without leaking API keys into the repo?

### Exploring the Agentic Frontier of Verilog Code Generation

- Source: https://arxiv.org/abs/2603.19347
- Status: summarized in `agentic_frontier.md`.
- Initial reason to read: recent evidence on agentic wrappers for Verilog generation, including failure modes.
- Repro question: what parts are evaluation methodology versus reusable engineering workflow?

### ChipMATE

- Source: https://arxiv.org/abs/2605.12857
- Code: https://github.com/zhongkaiyu/ChipMATE
- Status: summarized in `chipmate.md`.
- Initial reason to read: local/open-model and dual-agent reference-model direction; relevant to no-API or lab-intranet constraints.
- Repro question: can the reference-model verification idea be reduced to a small deterministic skill?

### LEGO: An LLM-Skill-Based Front-End Design Generation Platform

- Source: https://arxiv.org/abs/2604.23355
- Code: https://github.com/loujc/LEGO-An-LLM-Skill-Based-Front-End-Design-Generation-Platform
- Initial reason to read: skill abstraction for circuit-design generation.
- Repro question: even if public skills are incomplete, what should a local "circuit skill" contract look like?

### MAGE: A Multi-Agent Engine for Automated RTL Code Generation

- Source: https://arxiv.org/abs/2412.07822
- Code: https://github.com/stable-lab/MAGE
- Initial reason to read: open multi-agent RTL-generation architecture and benchmark comparison.
- Repro question: which components can be replaced by Claude Code/Codex without losing verification discipline?

## Next Radar Items

### Verilog-Evolve

- Source: https://arxiv.org/abs/2605.26498
- Initial reason to read: skill evolution for Verilog generation; closely related to Codex/Claude skill design.
- Repro question: can "evolved skill" be represented as a small local deterministic prompt/skill contract?

### HDLFORGE

- Source: https://arxiv.org/abs/2603.04646
- Initial reason to read: cost-aware small-model-first workflow with escalation.
- Repro question: can we use deterministic checks and human escalation before trying local model serving?

### VeriPilot

- Source: https://github.com/YihanWn/VeriPilot.git
- Initial reason to read: very recent golden-model and CDFG-assisted repair workflow.
- Repro question: can its golden-model idea map to the toy Python oracle path?

### LLM4Cov

- Source: https://arxiv.org/abs/2602.16953
- Initial reason to read: verification coverage rather than RTL generation; aligned with evidence gates.
- Repro question: can coverage/evidence summaries become a deterministic skill later?

## Comparison Axes

- API dependency versus local model dependency.
- Agent roles: planner, generator, verifier, debugger, reporter.
- Verification loop: simulator, waveform tracing, reference model, testbench generation, or static analysis.
- Evidence trace: what is logged, what is reproducible, and what remains a model claim.
- Hardware boundary: simulation-only versus hardware-adjacent execution.
- Transfer value for the graduation project: deterministic skill, credibility gate, human review, or presentation story.

Current synthesis is in `comparison_matrix.md`.
