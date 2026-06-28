# Toolchain Notes

Date: 2026-06-28

## What Is `iverilog`?

`iverilog` is Icarus Verilog, an open-source Verilog compiler/simulator front end.

In the early Verilog-agent loop it usually does this:

```text
Verilog RTL + testbench
-> iverilog compile
-> vvp run simulation
-> pass/fail and error log
```

It is not a complete FPGA vendor IDE and it does not program a board. It is closer to a lightweight local verification tool for checking syntax and simple simulation behavior.

## Relation To Other Tools

| Tool | Role | Needed now? |
| --- | --- | --- |
| `iverilog` | compile Verilog and produce runnable simulation | first executable toy loop |
| `vvp` | run the compiled Icarus simulation | comes with Icarus Verilog |
| Verilator | lint/compile SystemVerilog and catch semantic issues | useful later |
| Yosys | synthesis/lint/structural checks | useful later |
| Vivado/Quartus | vendor FPGA build/programming | not needed for first agent study |

## Storage Guidance

The Icarus Verilog package itself is small compared with FPGA vendor tools, but installing and experimenting can still create clutter:

- package manager cache;
- build dependencies;
- third-party repos;
- Python environments;
- benchmark datasets;
- simulator outputs and waveforms;
- optional model weights if local models are used.

Given the current MacBook disk-pressure concern, do not install toolchains here by default.

Recommended runners:

1. Lab Linux machine or Linux VM/WSL2.
2. Mac mini if it has enough free space and Homebrew access.
3. Current MacBook only for notes, prompts, scripts, and repository coordination.

## Minimal Check On A Runner

After cloning:

```bash
bash scripts/doctor.sh
```

For a machine intended to run Verilog examples, the target minimum is:

```text
git: available
python3: available
iverilog: available
vvp: available
```

Verilator and Yosys are nice-to-have for the second phase.

## Install Hints

macOS with Homebrew:

```bash
brew install icarus-verilog
```

Ubuntu / Debian / WSL2:

```bash
sudo apt-get update
sudo apt-get install -y iverilog
```

Do not run installation from this repository unless the machine owner agrees on disk use.
