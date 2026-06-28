# Learning Log

Continuity schema: 0.1

## 2026-06-28 - Verilog Agent Papers Favor Structured Evidence Over Broad Tooling

### Key Understanding

- VerilogCoder shows that planning plus simulator/waveform evidence can strongly improve benchmark pass rates, but at high token/API complexity.
- Agentic Frontier shows the opposite risk: naive agent wrappers can perform worse than good non-agentic prompting.
- The common lesson is not "use more agents"; it is "force a bounded workflow and preserve deterministic evidence."
- Simulation is a useful positive signal, but compile success alone is only syntax evidence.
- Long simulator output can crash an agent through context overflow, so logs need compact summaries.

### Decisions

- Keep the current MacBook notes-only until a runner with toolchain and disk space is chosen.
- Start with a toy structured loop before attempting full VerilogCoder or CVDP.

### Follow-ups

- Summarize ChipMATE next for local/no-API lessons.
- Implement the `verilog_compile_check` skill after `iverilog` is available on a runner.
- Feed the same "compact deterministic evidence" pattern back into the graduation project's credibility-gate wording.

## 2026-06-27 - Separate Repo, Shared Method Bridge

### Key Understanding

- The Verilog-agent direction is useful for the graduation project as a method source, not as a replacement topic.
- Directly pushing the full graduation directory would mix raw data, meeting artifacts, and local state with code experiments.
- A clean repository plus a bridge document keeps collaboration efficient while preserving the graduation project's scope.

### Decisions

- Keep executable Verilog-agent experiments here.
- Feed only digested lessons back into the graduation project.
- Use deterministic checks and evidence records as the common language between both projects.

### Follow-ups

- Convert VerilogCoder and Agentic Frontier into focused paper notes.
- Identify the smallest reproducible Verilog simulation loop.
- Compare API-based, Claude Code/Codex-based, and local-model-based execution paths.
