# DigitalCoder 架构规划说明

## 1. 核心问题

DigitalCoder 面向的是复杂 RTL 生成任务。对于这类任务，不能把一次模型回复直接当成可信源码，因为模型很容易在不同阶段产生并传播幻觉。

典型风险包括：

- planner 规划出不完整或不合理的模块拆分；
- coder 实现超出自己职责范围的逻辑；
- reviewer 给出“修复握手逻辑”“调整状态机”这类过宽修改意见；
- test agent 把 testbench 错误误判成 RTL 错误；
- 后续 agent 继承前一个 agent 的错误假设，并继续放大；
- 某次局部修复看似合理，但让全局设计质量下降。

因此 DigitalCoder 的基本原则是：模型输出只是候选提案，不是可信事实。任何会影响 RTL、testbench、修复路由或版本回滚的模型输出，都必须经过确定性专家系统、上下文隔离、局部化审核和残差仲裁。

项目目标不是单纯“让模型写 RTL”，而是构建一个可控的自迭代多 agent 网络。这个网络通过全局意图、局部实现、验证证据、修改权限的分离，阻断 AI 幻觉在 agent 链路中自由传播。

## 2. 总体架构原则

DigitalCoder 使用 plan 驱动的分布式 AutoGen 工作流。

系统将 agent 按决策层级分离：

- 全局 agent 负责系统意图、模块边界、跨模块链路、全局验证覆盖；
- 局部 agent 只处理自己被分配的模块或 testbench 范围；
- 专家系统是确定性本地程序，用来判断 agent 输出是否足够具体、可执行、可验证；
- 残差仲裁器负责判断本轮修复版本是否应该继续作为当前基线。

整体链路如下：

```text
需求 require.md
  -> planner 生成结构化计划
  -> plan expert 审核计划
  -> 多 RTL coder 并行编码 + 多 testbench coder 并行生成测试
  -> 语法矩阵和多 testbench 仿真矩阵
  -> 局部 reviewer 和局部 test agent 并行审核
  -> 全局 reviewer 和全局 test agent 汇总判断
  -> residual arbiter 判断版本质量
  -> 全局问题路由到局部 reviewer
  -> 局部 reviewer 生成精确修改范围
  -> 对应 coder 执行受限修复
  -> 在 agent 调用预算内循环
```

每一层都有不同权限。没有任何一个模型角色可以同时发现全局问题、任意选择修改文件、直接修改 RTL。这是为了避免单个 agent 的幻觉直接扩散到整个工程。

## 3. Planner 阶段

第一个模型角色是 planner。planner 不生成 RTL。

planner 必须输出结构化 JSON 计划，内容包括：

- 顶层模块；
- RTL 模块拆分；
- 每个模块的功能和接口契约；
- 每个模块对应的 coding agent；
- 每个模块对应的 local reviewer；
- 每个模块对应的 local test agent；
- global reviewer 和 global test agent；
- testbench assignments；
- 全局需求；
- 集成策略；
- 验证策略；
- 验收标准；
- 上下文可见性策略；
- 是否需要并行拆分以及拆分理由。

这样做的原因是先冻结全局架构，再进入实现。如果没有这个阶段，coder 可能自行发明模块边界，reviewer 和 test agent 也会基于不同的设计理解工作，后续错误会互相传递。

planner 输出必须经过 plan expert 审核。缺字段、字段类型错误、模块分工不完整、agent 分配不完整等问题都会被拦截。若计划不合格，会把专家系统错误反馈给 planner，让 planner 重新生成或局部 patch 修复。

planner patch retry 只允许修改专家系统指出的问题字段，不能借一次 schema 修复重写无关架构。这可以防止 planner 在修一个小错误时引入新的全局漂移。

## 4. 全局上下文与局部上下文分离

DigitalCoder 明确区分全局 agent 和局部 agent 的上下文。

全局 agent 可以看到：

- 原始需求；
- 完整实现计划；
- 集成 RTL；
- 局部 review/test 摘要；
- testbench 集合；
- 多 testbench 仿真矩阵；
- 全局验证证据；
- 残差历史。

局部 coder 只能看到：

- 自己的模块任务；
- 自己的模块契约；
- 依赖模块接口摘要；
- 可用 IP 源；
- 明确需要时才提供的已生成依赖 RTL；
- 修复时的精确 allowed/forbidden scope。

局部 reviewer 看到：

- 单个模块契约；
- 当前候选 RTL；
- 自己模块的局部审核任务，或全局 agent 路由到本模块的问题；
- source index 提供的模块、信号、代码块候选信息。

局部 test agent 看到：

- 模块级测试任务；
- 当前候选 RTL；
- 模块局部覆盖要求。

这样分离的原因是，大上下文会诱导模型“顺手解决所有问题”，并把一个模块中的假设传播到另一个模块。局部 agent 不能随意扩展全局架构；全局 agent 也不能直接给寄存器级修复。这样可以把幻觉限制在局部，并让它更容易被专家系统和局部 reviewer 捕获。

## 5. 并行 RTL Coder 网络

plan 通过专家审核后，DigitalCoder 会调度多个 RTL coder。

每个计划模块都有具体的 `coding_agent`。独立模块会并行执行。planner 的 `dependencies` 默认描述设计连接关系，不直接用于串行化编码。只有当 plan 明确写出 `coding_dependencies`、`source_dependencies`、`requires_existing_verilog_from` 或 `requires_generated_source_from` 时，才会让对应 coder 等待依赖源码。

这样做的原因是支持大型任务。复杂 RTL 不应该交给单个 coder 一次性完成。多 coder 并行可以降低每个 agent 的上下文压力，也让每个模块的实现更容易被单独审核。

并行 coder 的风险是接口不一致。DigitalCoder 通过以下机制约束：

- planner 生成模块契约；
- coder prompt 中包含依赖接口摘要；
- module inventory expert 检查模块清单；
- global reviewer 检查跨模块集成；
- syntax matrix 和 simulation matrix 提供工具证据。

## 6. 并行 Testbench Coder 网络

testbench 生成不等待 RTL 编码完成，而是在 plan 通过后与 RTL coder 同步并行启动。

每个 `testbench_assignment` 可以指定独立的 `testbench_agent` 和验证范围。每个 testbench coder 必须生成完整可执行的 SystemVerilog `module tb`。

testbench expert 会拒绝以下候选：

- 没有定义顶层 `tb`；
- 包含 DUT 实现；
- 没有实例化顶层模块；
- 没有打印规定格式的 mismatch summary；
- 使用当前仿真后端不支持的语法；
- 缺少过程化激励或检查逻辑。

多 testbench agent 的原因是，一个 testbench 很容易覆盖不足，或者把错误 reference 假设写死。多个 testbench 候选形成验证集。global test agent 看到的是完整 testbench set 和仿真矩阵，而不是盲目信任一个测试文件。

当某个 testbench 失败而其它 testbench 通过时，修复只替换失败候选，不会把整个 testbench 集合压缩成单个文件。这样可以保留验证多样性，避免 testbench 修复本身继续传播错误假设。

## 7. Module Inventory Expert

初始 RTL 生成后，DigitalCoder 会检查生成结果是否符合 planner 的模块清单。

module inventory expert 检查：

- 每个计划模块是否都真实生成；
- 是否存在重复模块；
- 生成模块名是否匹配 assignment 目标；
- 可解析时，是否暴露 planner 要求的端口；
- 依赖模块是否看起来被实例化。

这个 gate 用来捕获常见 coder 幻觉：模块名写错、多个模块合成一个、漏掉 wrapper、凭空增加未规划 helper 模块等。如果不提前检查，后续 syntax/review/test 会在一个已经偏离 plan 的工程上继续工作。

## 8. 语法矩阵

DigitalCoder 会让每个通过 testbench expert 的 testbench 候选都参与语法检查。

语法阶段输出 multi-testbench syntax matrix。如果语法失败，triage agent 判断失败来源：

- testbench；
- RTL；
- both；
- unclear。

矩阵化语法检查的原因是，单个 testbench 编译失败无法说明错误是 testbench 局部问题，还是 RTL 全局问题。矩阵证据能更精确地定位失败范围。

testbench-only 语法失败会路由给 testbench coder。RTL 语法失败不会直接交给 coder，而是先通过 local reviewer，要求 local reviewer 给出寄存器、wire、always block、assign 等级的精确修复范围。

## 9. 局部 Reviewer

每个模块都有自己的 local reviewer，多个 local reviewer 可以并行运行。

local reviewer 如果判定模块失败，必须输出精确修改建议，包括：

- 目标模块或 testbench block；
- 精确寄存器、wire、端口、状态、always block、assign 表达式；
- 允许修改的动作；
- 禁止修改的动作；
- 证据。

这样做的原因是，local reviewer 是 coder repair 前的最后一道语义门。若 reviewer 只说“修 FSM”“修 datapath”“修握手”，coder 可能修改大量无关逻辑并引入更大回归。因此 reviewer 输出必须精确到源代码范围。

## 10. 全局 Reviewer

global reviewer 不允许生成 coder 级别的修改范围。

它只负责检查：

- 模块集成；
- 顶层连接；
- 协议级一致性；
- 全局机制；
- 跨模块假设。

如果发现问题，global reviewer 输出 `module_repair_routes`。route 只描述：

- 目标模块；
- 受影响链路；
- 全局机制；
- 证据；
- local reviewer 约束；
- 禁止 local reviewer 做出的假设。

然后 route 会交给对应 local reviewer。local reviewer 再把全局问题转换成寄存器、wire、always block 级别的 coder-facing scope。

这样做是为了防止全局推理变成全局编辑。global reviewer 可以说“某模块和某链路存在机制问题”，但不能直接授权修改任意 RTL 细节。

## 11. 局部 Test Agent

local test agent 评估模块局部覆盖和局部功能义务。它不写 RTL，也不写 testbench。

如果 local test agent 发现失败，DigitalCoder 会把它转成模块 route，交给对应 local reviewer 生成精确修复范围。

这样做的原因是 test agent 只产生证据和覆盖判断，不直接产生源码修改权限。证据必须经过 local reviewer 局部化，才能进入 coder prompt。

## 12. 全局 Test Agent

global test agent 接收：

- 原始需求；
- 实现计划；
- 生成的 testbench set；
- multi-testbench simulation matrix；
- local test records；
- 集成 RTL。

它负责判断：

- 验证覆盖是否足够；
- 失败更可能属于 RTL、testbench、both、unclear 还是 none；
- 哪些模块需要 local reviewer 处理；
- testbench-only 问题应修改哪个 testbench block 或检查逻辑。

对于 RTL 或 mixed 失败，global test agent 输出 `module_repair_routes`，仍然要经过 local reviewer 才能进入 coder repair。

这样做的原因是把“失败分类”和“修改授权”分离。global test 拥有广泛证据，但广泛证据不等于可以直接修改广泛源码。

## 13. 专家系统

专家系统是确定性代码，不是模型。

它审核以下输出：

- planner；
- testbench coder；
- syntax triage；
- functional triage；
- local reviewer；
- global reviewer；
- local test agent；
- global test agent；
- residual arbiter；
- repair prompt 构造结果。

专家系统检查 schema、具体性、源码可解析性和 prompt 完整性。

对于修改建议，它要求包含：

- `file_or_artifact`；
- `module_or_tb_block`；
- `signal_or_variable`；
- `code_region`；
- allowed 或 forbidden action；
- evidence 或 reason。

它会拒绝把以下宽泛词当成修改范围：

- handshake；
- FSM；
- datapath；
- related logic；
- whole RTL；
- entire testbench。

这样做的原因是，模型生成的修改建议经常语义上看似合理，但工程上不可执行。例如“修复握手”可能导致 coder 改动一整片逻辑。专家系统强制每条修复建议都变成有边界的源码合同。

如果输出不通过专家 gate，DigitalCoder 不会放宽规则，而是把专家错误反馈给同一个 AutoGen role，让它重新生成合格 JSON。这使专家系统成为 agent 自修复接口，而不是简单的硬失败机制。

## 14. Source Index 与影响半径

scope expert 会从当前 RTL 和 testbench 文本构建轻量 source index。

source index 提取：

- 模块名；
- 端口；
- reg、wire、logic 声明；
- always/assign 区域；
- 局部 def-use 关系。

专家系统用它判断 scope 中的模块和信号是否真实存在。它还会给出轻量影响半径，提示某个信号修改可能影响哪些下游信号。

这样做的原因是把模型声明绑定到当前源码。reviewer 不能凭空说修改 `state_next` 或 `valid_reg`，除非该信号真实存在，或者明确说明这是新声明。

## 15. Repair Prompt Quality Gate

在 coder 接收 repair prompt 之前，DigitalCoder 会检查 prompt 本身。

repair prompt 必须包含：

- 原始需求上下文；
- 实现计划上下文；
- 模块 assignment；
- 当前源码；
- 失败证据；
- allowed modification scope；
- forbidden modification scope；
- 精确约束。

这样做的原因是，即使 reviewer JSON 合格，最终拼装给 coder 的 prompt 也可能漏掉 scope 或 evidence。prompt-quality gate 检查的是实际发送给 coder 的消息，这是幻觉进入修复阶段前的最后一道门。

## 16. 残差仲裁器

global test 失败后，在下一步修复路由被消费之前，DigitalCoder 会调用 residual arbiter。

它比较：

- 当前版本 snapshot；
- 上一版本 snapshot；
- RTL diff；
- testbench diff；
- local/global review 状态；
- local/global test 状态；
- mismatch count；
- coverage score；
- schema failure 数量；
- prompt-quality failure 数量；
- 源码 churn；
- 重复失败签名。

residual arbiter 可以决定：

- `continue_current`：保留当前版本继续修复；
- `rollback_previous`：回滚到指定历史版本；
- `request_more_evidence`：请求 global test agent 补充证据。

它不能写 RTL，不能写 testbench，也不能输出 coder 级 allowed/forbidden scope。

这样做的原因是防止坏修复成为新的基线。在自迭代系统里，某次 repair 可能让局部指标看起来更好，但让整体行为变差。残差仲裁器引入版本记忆和回归意识，判断当前版本是否真的值得继续。

确定性 residual scorer 会在模型仲裁前生成本地报告。如果 mismatch 增加、coverage 下降、失败签名重复、源码 churn 很大但没有改善，它会建议回滚或补充证据。AutoGen residual arbiter 可以不同意，但必须给出具体证据。

## 17. 回滚与重新验证

当 residual arbiter 决定回滚时，DigitalCoder 不会直接使用旧证据继续修复。

被恢复的 RTL/testbench 必须重新进入完整循环：

- syntax matrix；
- local review；
- global review；
- simulation matrix；
- local test；
- global test。

原因是回滚改变了当前源码状态。针对被丢弃版本生成的修复 route 可能已经不适用于恢复后的源码。重新验证可以防止 stale evidence 驱动错误修改。

## 18. Agent 调用预算

DigitalCoder 只使用一个进度预算：AutoGen agent 调用总数。

以下调用都会消耗预算：

- planner；
- coder；
- reviewer；
- testbench coder；
- test agent；
- triage agent；
- residual arbiter；
- continuation；
- schema retry；
- prompt-quality retry。

系统没有单独的 expert failure counter，也没有固定外层 repair round。

这样做的原因是让自迭代系统按真实模型工作量受控，而不是按人为轮数受控。专家失败本身就是模型工作的一部分：如果某个 agent 持续输出不合格内容，它会通过 retry 消耗 agent budget，直到流程自然停止。

## 19. 如何降低幻觉传播链

DigitalCoder 在多个位置切断幻觉传播：

- planner 幻觉由结构化 JSON 和 plan expert 约束；
- 模块边界幻觉由 module contracts 和 inventory expert 约束；
- coder 幻觉由局部 assignment 和 module inventory 约束；
- reviewer 幻觉由 exact scope schema 和 source index 约束；
- global reviewer 幻觉由 route-only 权限约束；
- test agent 幻觉由 expert schema 和仿真证据约束；
- testbench 幻觉由多个独立 testbench candidate 和 testbench expert 约束；
- repair 幻觉由 prompt-quality gate 约束；
- 迭代回归幻觉由 residual memory 和 rollback 约束。

核心思想是：任何模型输出都不会因为语言流畅就被信任。它必须满足至少一种条件：

- 通过确定性验证；
- 被转换成更小的局部 route；
- 被仿真证据支持；
- 或者在残差比较中证明没有让版本退化。

这样，模型回复链被改造成了一个由提案、专家 gate、证据、局部授权和版本仲裁组成的受控图。

## 20. 当前架构状态

当前代码按职责组织：

- `DigitalCoder/agent`：AutoGen facade、模型调用、prompt 渲染；
- `DigitalCoder/workflow`：分布式工作流 stage、scheduler、repair routing、finalization；
- `DigitalCoder/experts`：确定性专家系统；
- `DigitalCoder/residual`：残差记忆和评分；
- `DigitalCoder/tools`：本地 Verilog、波形和 debug 工具；
- `DigitalCoder/prompt_templates`：可编辑 prompt 合同。

当前最大的剩余模块是 `DigitalCoder/agent/autogen_latest_agent.py` 中的顶层 workflow loop。planning、initial generation 和 finalization 已经拆到独立 workflow stage。下一步最自然的拆分方向是继续抽出 syntax stage 和 review/test stage，让 facade 只保留状态机级别的编排逻辑。
