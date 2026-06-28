# USTC Agent Test FPGA

**语言 / Language:** 中文 | [English](./README.en.md)

本仓库是一个面向 Verilog/RTL coding agent 与硬件相邻 agent 工作流的协作实验仓库。

短期目标不是做生产级自治硬件控制系统，而是复现和比较若干 Verilog-agent 系统，提炼可复用的工程模式，并把有价值的部分反哺到毕业项目中的本地知识增强、可信度准入、确定性 skill 和人工确认边界。

## 当前定位

- 复现小规模、安全的 Verilog/RTL agent 示例。
- 学习 VerilogCoder、Agentic Frontier、ChipMATE、LEGO、MAGE 等方向。
- 将有用经验沉淀为 prompt、确定性脚本、skill 合约和交接记录。
- 硬件执行必须走固定脚本，默认 dry-run，并要求人工确认。
- 当前仓库仍按 public-safe 处理，不放密钥、隐私数据、原始实验数据、大 PDF 或大二进制文件。

## 目录结构

- `docs/`：项目状态、决策记录、交接文档、同步指南、毕业项目桥接说明。
- `docs/paper_notes/`：论文阅读队列、论文笔记和横向比较。
- `experiments/`：按系统或想法拆分的独立实验线。
- `prompts/`：可公开的 prompt 草案和 agent 角色定义。
- `skills/`：确定性 skill / tool 原型或合约。
- `scripts/`：仓库维护、环境检查和后续可复现实验脚本。
- `tests/`：脚本和确定性 skill 的回归测试。
- `third_party/`：第三方代码处理说明。不要随手把大仓库复制进来。

## 公开仓库边界

不要提交：

- API key、token、`.env`、`OAI_CONFIG_LIST`、SSH key、本地认证文件。
- 私有 Verilog/IP、硬件凭据、原始采集数据、实验室内部日志。
- PDF、模型权重、波形 dump、仿真数据库、大二进制产物。
- 毕业项目中的组会录音、原始数据包、未公开 PPT 或其它原始材料。

可以提交：

- 来源链接、结构化笔记、小型 toy 示例、确定性脚本、测试、可复现实验日志。

## 先跑这些命令

这些命令只做安全检查和环境发现：

```bash
git status --short --branch
bash scripts/check_repo_safety.sh
bash scripts/doctor.sh
```

每条具体实验线的运行和测试命令，等依赖路径确定后写在对应 `experiments/<topic>/` 目录里。

## 当前进度

- 已建立项目骨架和 GitHub 同步。
- 已完成 VerilogCoder 与 Agentic Frontier 的第一轮论文笔记。
- 已整理 Verilog agent 横向比较矩阵。
- 已写 `iverilog` / Verilator / Yosys 工具链说明。
- 已草拟 simulation-only 的结构化 prompt 和 `verilog_compile_check` skill 合约。
- 已为 toy mux2 loop 增加 Python reference-model oracle 和单元测试。
- 当前 MacBook 不安装工具链；后续优先在 Mac mini、实验室 Linux 或 WSL2 上跑 toy simulation loop。

## 协作规则

把工作交给同学、Mac mini 或另一个 agent 前，至少更新：

- `docs/AGENT_STATE.md`
- `docs/handoff.md`
- `docs/experiment_log.md`

这样可以避免只靠聊天记录交接，也能让 MacBook、Mac mini 和同学的进度保持一致。
