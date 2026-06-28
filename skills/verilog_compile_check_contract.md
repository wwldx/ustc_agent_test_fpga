# verilog_compile_check Skill Contract

Status: draft contract only. No implementation yet.

## Purpose

Run a bounded local Verilog compile/simulation check and return structured evidence that an LLM agent can use without reading large raw logs.

## Inputs

```text
rtl_files: list of paths
testbench_files: list of paths
top_module: optional string
work_dir: path
max_output_chars: integer, default 12000
timeout_seconds: integer, default 30
```

## Commands

Phase 1 target:

```bash
iverilog -g2012 -o build/sim.out <rtl_files> <testbench_files>
vvp build/sim.out
```

## Outputs

```text
status: compile_failed | simulation_failed | passed | tool_missing | timeout
compile_command:
simulation_command:
compile_exit_code:
simulation_exit_code:
compact_stdout:
compact_stderr:
evidence_level:
blocked_claims:
```

## Safety Rules

- Never run hardware programming commands.
- Never execute commands outside the provided working directory.
- Truncate long output and preserve the first and last relevant sections.
- Treat compile success as syntax evidence only, not functional proof.
- Treat simulation pass as testbench-specific evidence only, not hardware proof.

## Relation To Graduation Project

This contract mirrors the parameter-response credibility skills:

```text
deterministic check -> compact evidence -> blocked claims -> next action
```

It is a method prototype, not part of the low-temperature readout-chip control path.
