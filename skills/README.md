# Skills

Store deterministic helper contracts and implementations here.

This directory is for code or specs that can be tested independently of an LLM conversation.

## Candidate Skills

- `verilog_compile_check`: run local syntax/compile checks and return structured errors.
- `testbench_result_parser`: parse simulator output into pass/fail and evidence.
- `waveform_summary`: summarize small waveform evidence without committing large dump files.
- `agent_trace_report`: render a reproducible report from prompts, commands, and verifier outputs.

## Rule

Any skill that affects hardware must default to dry-run and require explicit human confirmation.
