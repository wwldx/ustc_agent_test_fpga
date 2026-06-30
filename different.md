# DigitalCoder 差异化机制说明

## 1. 核心差异

DigitalCoder 的核心差异不在于“调用多个模型写代码”，而在于它在多 agent RTL 生成流程中引入了两类控制机制：

- 门控专家系统；
- 残差仲裁器。

这两套机制的目标不同。

门控专家系统负责判断某个 agent 输出是否足够具体、合法、可执行，是否允许进入下一步。

残差仲裁器负责判断当前修复版本是否真的比上一版本更值得继续，是否应该回滚或补充证据。

前者控制“单步输出是否可信”，后者控制“多轮迭代方向是否正确”。

这两个机制共同解决传统 LLM 编码流程中的两个问题：

- 单个 agent 的模糊输出会被下游 agent 当成事实；
- 多轮修复可能局部前进、全局退化，最后越修越偏。

## 2. 为什么普通多 Agent 不够

普通多 agent 工作流通常会让 planner、coder、reviewer、tester 按顺序交互。这个结构看起来合理，但存在一个严重问题：agent 之间传递的是自然语言和模型判断，而不是受控证据。

例如：

- reviewer 说“握手逻辑可能有问题”；
- coder 收到后修改多个 valid/ready 相关信号；
- tester 看到新错误，又判断“状态机可能有问题”；
- coder 再继续扩大修改范围。

这条链路中，每一步都看似合理，但每一步都可能把上一步的幻觉进一步具体化。错误一旦被写进源码，后续 agent 会把它当成当前事实继续推理。

DigitalCoder 的设计目标是切断这种传播链。模型仍然可以提出判断，但判断必须被转化为结构化、可检查、可回滚的对象。

## 3. 门控专家系统的作用

门控专家系统是本地确定性代码，不是模型。

它负责审核以下类型的输出：

- planner 输出的设计计划；
- testbench coder 输出的测试文件；
- triage agent 输出的失败归因；
- local reviewer 输出的修改建议；
- global reviewer 输出的模块路由；
- local/global test agent 输出的验证判断；
- residual arbiter 输出的版本决策；
- 发送给 coder 前的 repair prompt。

专家系统不会判断 RTL 语义是否完全正确。它主要判断输出是否满足工程流程继续前进的最低条件：

- schema 是否完整；
- 字段类型是否正确；
- 是否给出明确目标模块；
- 是否给出明确寄存器、wire、端口、always block 或 assign 区域；
- 是否包含允许修改范围；
- 是否包含禁止修改范围；
- 是否提供证据；
- 是否引用了当前源码中真实存在的模块和信号；
- repair prompt 是否真的带上了 scope、证据、需求和当前源码。

如果不满足这些条件，输出不会被用于修复。

## 4. 门控专家系统的工作原理

门控专家系统不是一个统一的大模型，而是一组确定性检查器。

主要包括：

- plan expert：检查 planner 是否给出完整多 agent 计划；
- module inventory expert：检查生成 RTL 是否匹配计划模块清单；
- testbench expert：检查 testbench 是否可执行、是否包含 DUT、是否符合仿真约束；
- scope expert：检查 triage/reviewer 的修改范围是否精确；
- test expert：检查 local/global test agent 输出是否符合测试判断 schema；
- prompt quality expert：检查 repair prompt 是否完整；
- residual expert：检查残差仲裁器输出是否是合法版本决策。

这些专家的输出通常包括：

- `passed`；
- `score`；
- `errors`；
- `warnings`；
- `retry_guidance`；
- 可选的源码索引摘要。

如果专家系统发现问题，DigitalCoder 不会放宽规则，而是把错误反馈给对应 AutoGen agent，让它重新生成合格输出。

这种机制把专家系统变成了 agent 的自修复约束器，而不是简单的失败开关。

## 5. Scope Gate 为什么重要

在 RTL 修复中，最危险的模型输出不是明显错误，而是模糊但看似专业的建议。

例如：

- “修复握手逻辑”；
- “调整 FSM 转移”；
- “检查 datapath”；
- “更新相关寄存器”；
- “修改整个 testbench 检查逻辑”。

这些建议的问题是范围过宽。coder 收到后可以合理地改很多地方，导致局部错误扩散成全局改动。

因此 DigitalCoder 要求所有修复建议必须精确到：

- 文件或 artifact；
- 模块或 testbench block；
- 具体 signal/register/wire/port；
- 具体 always block、assign、state 或表达式；
- 允许动作；
- 禁止动作；
- 证据。

如果 scope 只包含“handshake”“FSM”“datapath”“whole RTL”这类词，会被专家系统拒绝。

这样做的效果是把自然语言建议压缩成可执行的工程合同。coder 不再被要求“理解并自由发挥”，而是在有限范围内执行修复。

## 6. Source Index 的作用

为了防止 reviewer 或 triage agent 编造信号名，scope expert 会基于当前 RTL/testbench 构建 source index。

source index 记录：

- 模块名；
- 端口；
- reg/wire/logic 声明；
- always/assign 区域；
- 简单 def-use 关系。

当 agent 输出修改范围时，专家系统会检查模块名和信号名是否能在当前源码中找到。

如果 agent 提到不存在的 `state_next`、`valid_reg` 或某个未生成模块，就会被拦截，除非它明确说明这是一个新声明。

这能减少一类常见幻觉：模型基于“常见 RTL 写法”生成看似合理但实际不存在的信号。

## 7. Repair Prompt Quality Gate

即使 reviewer 输出了合格 JSON，最终发送给 coder 的 prompt 仍可能因为拼装错误而缺少关键信息。

因此 DigitalCoder 在调用 coder 前，还会检查实际 repair prompt。

repair prompt 必须包含：

- 原始需求；
- 实现计划；
- 当前源码；
- 失败证据；
- allowed modification scope；
- forbidden modification scope；
- 当前模块 assignment；
- 明确禁止修改的边界。

这个 gate 的作用是保证 coder 看到的就是专家系统批准过的修复合同。如果 prompt 里没有 scope 或 evidence，就不会调用 coder。

这一步能防止“专家系统通过了，但实际模型调用没带约束”的工程链路漏洞。

## 8. 残差仲裁器的作用

门控专家系统解决的是单步输出质量问题，但它不能判断多轮修复方向是否越来越好。

例如某次修复：

- 通过了语法；
- 修复了一个局部 mismatch；
- 但引入了更多全局 mismatch；
- 或导致 coverage 下降；
- 或让源码 churn 很大但没有实际收益。

如果系统只看当前局部结果，就可能继续沿着错误方向迭代。

残差仲裁器解决这个问题。它把每一轮候选版本和上一轮版本进行比较，判断当前版本是否值得继续作为基线。

## 9. 残差仲裁器的输入

每个被测试的 attempt 都会形成版本 snapshot。

snapshot 包含：

- 当前 RTL；
- 当前 testbench bundle；
- attempt metadata；
- syntax 结果；
- review 结果；
- simulation 结果；
- local/global test 结果；
- mismatch count；
- coverage score；
- schema 错误；
- prompt-quality 错误；
- 源码 diff；
- 历史失败签名。

当 global test 失败时，residual arbiter 会收到当前 snapshot 和上一 snapshot 的对比信息。

它不是凭感觉判断，而是结合：

- 确定性 residual score；
- 当前/上一版本差异；
- 失败是否重复；
- mismatch 是否增加；
- coverage 是否下降；
- 修改量是否过大；
- agent trace 是否显示反复失败；
- global test agent 的证据。

## 10. 残差仲裁器的输出

残差仲裁器只能输出版本决策，不能直接修改代码。

允许的决策包括：

- `continue_current`：当前版本虽然失败，但比上一版本更值得继续；
- `rollback_previous`：当前版本退化，回滚到指定历史版本；
- `request_more_evidence`：证据不足，要求 global test agent 补充判断。

它不能输出：

- RTL 代码；
- testbench 代码；
- coder-level allowed scope；
- coder-level forbidden scope。

这样设计是为了让残差仲裁器只做版本管理，不参与源码编辑。版本仲裁和源码修复保持分离，防止它成为另一个高权限幻觉源。

## 11. 残差仲裁器如何提高迭代效率

没有残差仲裁时，系统常见行为是：

- 每轮都在当前版本上继续修；
- 即使当前版本已经明显更差，也继续叠加修改；
- 后续 agent 被迫解释越来越复杂的错误；
- 修复范围越来越大；
- 最后进入震荡或退化。

残差仲裁器能减少这种无效前进。

它的效率提升体现在：

- 发现当前修复退化时及时回滚；
- 对重复失败签名请求更多证据，而不是盲目修复；
- 对 mismatch 增加、coverage 下降、源码 churn 过大的版本提高警惕；
- 避免把坏版本当成新基线；
- 降低后续 reviewer/coder 在错误状态上继续工作的概率。

因此它不是为了让每一轮更快，而是为了避免在错误方向上消耗大量轮次。

## 12. 对 AI 幻觉传播的抑制效果

门控专家系统和残差仲裁器分别在两个尺度上抑制幻觉传播。

门控专家系统抑制单步传播：

- agent 输出不合格就不能进入下一步；
- 模糊建议不能变成 coder prompt；
- 编造模块或信号会被 source index 拦截；
- 修复 prompt 缺证据或缺 scope 会被拒绝。

残差仲裁器抑制多轮传播：

- 坏修复不能轻易成为新基线；
- 退化版本会回滚；
- 证据不足时不会强行修复；
- 反复失败会被识别为模式，而不是每次都当成新问题。

两者结合后，模型幻觉不再是线性传播链，而是会在多个边界上被检查、局部化、回滚或要求补证。

## 13. 对编码前进效率的影响

这些机制会增加单轮检查成本，但提高整体前进效率。

原因是 RTL 生成失败的主要成本通常不是多一次 schema 检查，而是：

- 错误修改进入源码；
- 后续 agent 基于错误源码继续推理；
- 修复范围不断扩大；
- 测试失败无法定位；
- 版本质量震荡；
- 最后需要大量轮次才能恢复。

门控专家系统让不合格输出在进入源码前被拦截。

残差仲裁器让错误版本在成为长期基线前被识别。

所以 DigitalCoder 用更多结构化检查换取更少无效迭代。对于小任务，这可能显得严格；对于大任务，这种严格性可以显著减少无方向修复。

## 14. 为什么这是本工程的创新点

DigitalCoder 的创新点不是简单地堆叠 planner、coder、reviewer、tester，而是给这些 agent 增加了工程控制面。

核心创新包括：

- planner 不直接生成 RTL，而是先生成可审计的多 agent 计划；
- 全局 agent 和局部 agent 权限分离；
- 全局 agent 只能路由，不能直接授权寄存器级修改；
- 局部 reviewer 是 coder repair 前的必经翻译层；
- 专家系统作为所有修改建议的确定性 gate；
- source index 把模型声明绑定到真实源码；
- prompt quality gate 检查实际发送给 coder 的 prompt；
- 多 testbench 候选形成验证集，而不是单一测试入口；
- 残差仲裁器用版本记忆防止退化修复继续扩散；
- 统一 agent-call budget，让所有自修复都受同一个真实模型调用预算约束。

这些机制使 DigitalCoder 更像一个“受控多 agent 编译-验证-修复系统”，而不是普通聊天式代码生成器。

## 15. 当前效果边界

门控专家系统和残差仲裁器不能保证模型一定生成正确 RTL。

它们能保证的是：

- 模型输出必须结构化；
- 修改建议必须精确；
- 修复范围必须受限；
- 不合格输出会被要求重生成；
- 当前源码版本会被历史版本约束；
- 明显退化的修复不会无限向后传播。

因此它们解决的是工程可控性问题，而不是替代形式化验证或完整综合时序分析。

在当前架构中，专家系统负责“能不能让这条 agent 输出继续前进”，残差仲裁器负责“这个版本值不值得继续前进”。这两个问题分开处理，是 DigitalCoder 相比普通多 agent 代码生成流程最重要的差异。
