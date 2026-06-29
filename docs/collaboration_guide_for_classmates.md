# 同学协作提交指南

适用对象：已经被加为 `wwldx/ustc_agent_test_fpga` collaborator 的同学。

## 核心规则

后续日常开发优先把共享主仓库设为 `origin`：

```bash
git@github.com:wwldx/ustc_agent_test_fpga.git
```

不要长期只往自己的 fork 里提交。fork 是你账号下的一份拷贝，推到 fork
以后，主仓库不会自动出现这些提交。已经有 collaborator 权限后，更推荐：

```text
主仓库 main -> 主仓库功能分支 -> PR/检查 -> 合入主仓库 main
```

## 一次性配置

最推荐重新 clone 主仓库：

```bash
git clone git@github.com:wwldx/ustc_agent_test_fpga.git
cd ustc_agent_test_fpga
git config user.name "liujianyu20021122"
git config user.email "your_email@example.com"
bash scripts/doctor.sh
bash scripts/check_repo_safety.sh
```

如果你现在本地目录是从自己的 fork clone 的，不用删目录，可以把 fork
保留下来，同时把真正共享的仓库改成 `origin`：

```bash
git remote -v
git remote rename origin fork
git remote add origin git@github.com:wwldx/ustc_agent_test_fpga.git
git fetch origin
git switch -c liujianyu/first-upstream-branch origin/main
```

如果 SSH key 没配好，也可以用 HTTPS：

```bash
git remote add origin https://github.com/wwldx/ustc_agent_test_fpga.git
```

## 每次开始前

先同步主仓库最新 `main`，再开自己的工作分支：

```bash
git switch main
git pull --ff-only origin main
git switch -c liujianyu/short-topic-name
```

分支名建议能看懂，例如：

```bash
git switch -c liujianyu/interface-contract-draft
git switch -c liujianyu/hsg-rtl-plan-review
git switch -c liujianyu/toy-iverilog-notes
```

## 改完后自动检查、提交、推送

普通交互式用法：

```bash
bash scripts/collab_submit.sh -m "Add HSG RTL proposal notes"
```

不想二次确认时：

```bash
bash scripts/collab_submit.sh -m "Add HSG RTL proposal notes" --yes
```

指定分支名时：

```bash
bash scripts/collab_submit.sh \
  -m "Add interface contract draft" \
  --branch liujianyu/interface-contract-draft
```

这个脚本会做这些事：

1. 检查 `origin` 是否指向 `wwldx/ustc_agent_test_fpga`。
2. 如果还在 fork-only 目录里，会直接退出并提示怎么改 remote。
3. 如果当前在 `main` 上，会自动新建一个 collaborator 分支，避免直接把零散改动推到 `main`。
4. 运行 `scripts/check_repo_safety.sh`，避免把密钥、PDF、原始数据等误提交。
5. 暂存改动、显示 diff 摘要、创建 commit、push 当前分支。
6. 输出 GitHub compare/PR 链接。

## 哪些东西可以提交

适合提交：

- 小型源码文件。
- Markdown 调研笔记、论文总结、方案草案。
- 可以公开的 prompt 草案。
- 确定性脚本和测试。
- 小型示例 Verilog / testbench。

不要提交：

- API key、token、`.env`、登录文件、SSH key。
- 论文 PDF。
- 模型权重和 checkpoint。
- 原始实验数据、私有硬件日志、bitstream、专有 IP。
- 大体积仿真输出目录。

## 如果已经提交到了 fork

2026-06-29 这次你的 fork 里有两个分支：

- `main`：停在旧提交 `f06177c`，比主仓库落后，不应该直接合回来。
- `patch-1`：新增了一个 `PLAN.md`，已经被导入主仓库：

```text
docs/proposals/hsg_rtl_generation_plan_liujianyu.md
```

以后新工作建议直接从主仓库分支开始：

```bash
git fetch origin
git switch -c liujianyu/next-topic origin/main
```

改完后：

```bash
bash scripts/collab_submit.sh -m "Describe the change"
```

## 几个概念

- `commit`：在本机保存一次快照。
- `push`：把本机 commit 上传到 GitHub。
- `fork`：你自己账号下的一份仓库拷贝。
- `upstream`：真正共享的主项目 `wwldx/ustc_agent_test_fpga`。
- `branch`：一条独立工作线。
- `pull request`：把某个分支请求合入 `main` 的 GitHub 审查入口。

最推荐的协作路径是：

```text
git pull 主仓库 main
-> 新建 liujianyu/<topic> 分支
-> 修改文件
-> bash scripts/collab_submit.sh -m "..."
-> 打开 PR 或让另一个人检查
-> 合入 main
```
