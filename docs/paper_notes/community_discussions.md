# Community And Issue Signals

Date: 2026-06-28

This file records practical discussion signals around Verilog/RTL agents. It is intentionally separate from paper notes because issue threads are weaker evidence than peer-reviewed or arXiv papers, but often reveal reproduction and workflow pain points.

## Findings So Far

Public forum discussion is less dense than the paper stream. The most useful material found so far is in GitHub issue trackers for relevant repositories.

## VerilogCoder: Human In The Loop

Source: https://github.com/NVlabs/VerilogCoder/issues/2

Signal:

- A user wanted a "human in the loop" option.
- The reason was practical: agents can repeatedly call tools until hitting max token limits.
- The user wanted to intervene when the agent is looping or misunderstanding feedback.

Repository lesson:

```text
Add explicit repair limits, compact evidence, and stop conditions before making loops autonomous.
```

Graduation-project lesson:

```text
Human review is not a weakness; it is a safety boundary for expensive or ambiguous conclusions.
```

## MAGE: Syntax Correctness Issues

Source: https://github.com/stable-lab/MAGE/issues/17

Signal:

- Users reported syntax-correctness problems in generated/evaluated RTL flows.
- This reinforces that pass rates and benchmark claims need independent verification.

Repository lesson:

```text
Always run compile/simulation checks locally before trusting generated Verilog.
```

Graduation-project lesson:

```text
可信度准入应先于结论生成；不能直接把上游输出当作可回写样本。
```

## General Pattern

The issue signals align with the papers:

- Tool loops can fail operationally even when the idea is good.
- Setup friction matters.
- Compile/simulation evidence is not optional.
- Human intervention should be designed into the workflow.

## Next Search Targets

- More GitHub issues under VeriPilot, ChipMATE, LEGO, and MAGE after they become active.
- Reddit / FPGA forum discussions around "ChatGPT for Verilog" and "LLM RTL generation"; currently these are scattered and less actionable than repository issues.
- Benchmark leaderboards or reproduction reports, if published.
