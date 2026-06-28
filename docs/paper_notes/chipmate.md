# ChipMATE

Source:

- arXiv: https://arxiv.org/abs/2605.12857
- PDF: https://arxiv.org/pdf/2605.12857
- Code: https://github.com/zhongkaiyu/ChipMATE

Reading date: 2026-06-28

## Problem

ChipMATE targets Verilog code generation in settings where API-based agents are hard to use because of chip-design confidentiality, network isolation, or the need for local deployment.

The paper's core problem is not only "generate RTL." It asks how to make an agentic Verilog workflow work with small or local open-source models while still checking functional behavior.

## Method

ChipMATE uses two cooperating agents:

- A Verilog agent that generates or repairs RTL.
- A Python agent that generates a Python reference model and helps validate behavior.

The two agents cross-check each other. The Verilog side is verified through simulation, while the Python side acts as a behavioral reference. The public README describes running with Llama 3.1 8B and Qwen2.5-Coder 7B model variants, using `vllm` plus `iverilog` / `vvp`.

The important workflow pattern is:

```text
task/spec
-> Verilog candidate
-> Python reference model
-> test vectors / simulation
-> mismatch feedback
-> repair
-> evidence log
```

This is more relevant to lab-style environments than pure API-agent systems because the agent can be run with local models, at least in principle.

## Key Claims From Public Sources

The arXiv abstract claims:

- ChipMATE is a fully local framework using fine-tuned open-source LLMs.
- It uses a dual-agent architecture with a Verilog expert and a Python expert.
- It reports strong improvements over baseline models and compares with proprietary-model performance.

The GitHub README says:

- Clone the repo, initialize submodules, and install requirements.
- Install `iverilog`.
- Download or use released Verilog/Python models.
- Start vLLM servers for both agents.
- Run inference through `main.py`.

## Reproducibility

Current repository status:

- Paper and repo links recorded.
- No model weights downloaded.
- No upstream code cloned.
- No vLLM environment created.
- No `iverilog` installed on the current MacBook.
- No ChipMATE run performed.

Likely requirements if reproduced later:

- A Linux-like runner.
- `iverilog` / `vvp`.
- Python environment with ChipMATE requirements.
- Enough GPU/VRAM or a suitable local inference server for Qwen/Llama checkpoints.
- Disk space for model weights and benchmark artifacts.

This makes ChipMATE a bad first executable target for the current MacBook, but a good design reference for no-API constraints.

## What Transfers To This Repository

The strongest transferable idea is the Python reference-model agent.

Instead of jumping to full local LLM deployment, this repository can start with a deterministic miniature version:

```text
toy RTL
-> simple Python oracle or testbench expected table
-> iverilog simulation
-> compare result
-> compact evidence report
```

This supports the planned `toy_iverilog_loop` experiment and the `verilog_compile_check` contract.

## What Transfers To The Graduation Project

ChipMATE is especially useful for the graduation project's lab boundary:

- It takes no-API / local deployment seriously.
- It separates generation from behavioral reference checking.
- It reinforces the idea that an LLM output is not trusted until checked by a deterministic or independently generated reference.

Mapping to the readout-chip parameter-tuning project:

| ChipMATE | Graduation project |
| --- | --- |
| Verilog candidate | next-test suggestion candidate |
| Python reference model | physical/theory prior or deterministic analysis script |
| simulation mismatch | credibility warning / missing evidence |
| repair loop | revised suggestion after evidence check |
| local model route | lab-intranet / no-API deployment route |

The useful thesis language is:

```text
本地模型或 agent 不是直接给出结论，而是生成候选解释/建议；
独立的确定性模型、历史样本和人工复核共同约束输出可信度。
```

## Caveats

- Local-model does not mean lightweight. The released workflow can require model weights, vLLM, GPU memory, and environment setup.
- The Python reference model is only as good as the generated reference and test coverage.
- Dual-agent agreement is not proof of hardware correctness.
- The current public repo should be treated as a study target first, not as a dependency to vendor into this repository.

## Next Actions

1. Use ChipMATE's dual-agent idea to extend the toy loop with a tiny Python oracle later.
2. Keep full ChipMATE reproduction for a machine with GPU/disk resources.
3. After the toy loop runs, compare whether a local Python oracle adds more value than a larger agent framework.
