# HSG-RTL 层次化系统图驱动 RTL 生成方案草案

Source: `liujianyu20021122/ustc_agent_test_fpga:patch-1`

Imported from commit: `0e59e7272daf7c768abfaee7eecf89ad054fb0d7`

Author: `liujianyu20021122`

Import date: 2026-06-29

Status: proposal / reading draft. This document is not an implemented workflow yet.

Boundary:

- Treat this as a system-level design proposal for future RTL-agent experiments.
- Do not present it as verified Verilog generation capability.
- Before implementation, reduce it to small deterministic artifacts: graph schema, interface contract schema, toy module, testbench, and EDA evidence parser.

Original draft begins below.

## 原始草案

层次化系统图驱动的 SoC 级 RTL 生成机制

核心定位：

面向复杂 SoC / 多 IP / 多接口 / 多时钟域设计的 Verilog/SystemVerilog 自动生成系统。
它不是单模块代码生成器，而是一个从规格到架构、从接口契约到 RTL、从验证到修复的闭环式 RTL 设计代理系统。

1. 设计目标

传统 Verilog 自动生成通常是：

自然语言规格 → LLM → Verilog

这种方式适合小模块，例如：

计数器
FIFO
简单状态机
仲裁器
UART
小型 ALU

但对复杂 SoC，直接生成会遇到几个核心问题：

1. 模块层次过深，LLM 难以保持全局一致性。
2. 接口数量多，容易出现位宽、握手、时序语义不一致。
3. 多个状态机跨模块耦合，局部正确不代表系统正确。
4. 多时钟/多复位域复杂，容易产生 CDC / reset sequencing 错误。
5. 数据流与控制流分离，容易出现 descriptor/data 不匹配。
6. 验证空间巨大，单个 testbench 无法覆盖真实 SoC 行为。
7. 错误溯源不能只定位代码行，还要定位系统级因果链。

因此，通用机制的目标应当是：

从“代码生成”升级为“系统级硬件设计综合”。

即：

System Specification
  → Architecture Graph
  → Interface Contract
  → Transaction Model
  → RTL Implementation
  → Verification Assets
  → EDA Feedback
  → Root-Cause Repair
2. 总体架构

完整系统可以分为 8 层。

这套架构的关键不在于“LLM 写代码”，而在于：

让 LLM 不能直接越过架构、接口、事务和验证约束。

也就是说，LLM 的输出必须被系统图、接口契约、事务模型和 EDA 结果约束。

3. 第一层：Specification Ingestion，规格输入层

这一层负责把非结构化需求转成结构化需求。

输入类型
1. 自然语言设计需求
2. Markdown / PDF / Word 设计文档
3. 协议规范
4. IP 数据手册
5. 总线接口说明
6. 时钟/复位约束
7. 性能指标
8. 面积/功耗/时序目标
9. 既有 RTL 代码
10. 既有 testbench
11. 既有约束文件
12. 既有 bug report / waveform / log
输出结果

输出不是 Verilog，而是结构化规格对象。

示例：

design:
  name: generic_soc
  type: soc
  description: multi-ip digital system

requirements:
  functional:
    - support multiple data-processing blocks
    - provide memory-mapped configuration interface
    - support streaming data movement
    - support interrupt/status reporting

  non_functional:
    - no combinational loop
    - no inferred latch
    - all CDC paths must be explicit
    - reset behavior must be defined
    - all bus interfaces must follow contract

interfaces:
  - type: axi_lite
  - type: axi_stream
  - type: apb
  - type: fifo
  - type: interrupt

constraints:
  timing:
    target_frequency: user_defined
  reset:
    polarity: active_low_or_high
    style: sync_or_async
  verification:
    require_unit_tb: true
    require_integration_tb: true
    require_assertions: true

这一层的核心作用是：

不允许系统直接从模糊自然语言跳到 RTL，而是先形成可追踪、可检查、可更新的规格模型。

4. 第二层：System Graph Construction，系统图构建层

这是整个机制的核心。

复杂 SoC 不能只用代码树表示，而应该用多张图表示。

4.1 模块层次图

描述 SoC 中有哪些 IP、子模块、wrapper、adapter。

作用：

1. 防止 LLM 生成一个巨大的单体 RTL。
2. 明确模块边界。
3. 明确哪些模块可以复用模板。
4. 明确哪些模块需要独立验证。
4.2 数据流图

描述数据如何从输入经过处理、缓存、调度、输出。

每条边要有属性：

edge:
  name: stream_a_to_b
  type: dataflow
  protocol: axi_stream
  data_width: 512
  sideband:
    - keep
    - last
    - user
  ordering: in_order
  backpressure: supported
  frame_based: true

作用：

1. 检查数据宽度。
2. 检查 sideband 是否完整。
3. 检查 backpressure 是否闭合。
4. 检查 frame 边界是否保持。
5. 检查是否存在数据丢失或乱序风险。
4.3 控制流图

描述寄存器配置、状态机、enable、commit、interrupt、error 等控制信号传播。

作用：

1. 防止状态机控制遗漏。
2. 防止 commit 过早或过晚。
3. 防止 error/status 没有闭环。
4. 防止配置寄存器和实际数据路径不一致。
4.4 时钟/复位域图

复杂 SoC 必须显式建模 clock/reset。

clock_domains:
  clk_ctrl:
    purpose: register/config/control
    frequency: low_or_medium
  clk_data:
    purpose: data_path
    frequency: high
  clk_mem:
    purpose: memory_controller
    frequency: independent
  clk_ext:
    purpose: external_io
    frequency: external

reset_domains:
  rst_ctrl:
    clock: clk_ctrl
    style: synchronous
  rst_data:
    clock: clk_data
    style: synchronous
  rst_mem:
    clock: clk_mem
    style: vendor_specific

cdc_paths:
  - from: clk_ctrl
    to: clk_data
    type: config_register_sync
  - from: clk_data
    to: clk_mem
    type: async_fifo
  - from: clk_ext
    to: clk_data
    type: handshake_sync

作用：

1. 自动识别 CDC。
2. 禁止普通寄存器直接跨时钟。
3. 自动插入 CDC primitive 或要求用户确认。
4. 自动生成 CDC 检查项。
5. 自动生成 reset sequencing 检查项。
4.5 事务图

这是支持复杂 SoC 的关键。

事务图描述的是：

一个完整操作从开始到结束经过哪些模块、状态、数据和控制事件。

例如通用 streaming transaction：

transaction:
  name: stream_packet_transaction
  start:
    condition: input_valid && input_ready
  stages:
    - accept_input
    - capture_metadata
    - buffer_payload
    - process_payload
    - generate_output
    - output_handshake
    - commit_status
  end:
    condition: output_last && output_valid && output_ready
  invariants:
    - metadata must remain stable during transaction
    - payload order must be preserved
    - commit occurs after output completion
    - error abort must flush partial state

作用：

1. 防止跨模块事务断裂。
2. 防止 metadata 和 data 不一致。
3. 防止状态机提前释放资源。
4. 防止 backpressure 下 transaction 被破坏。
5. 第三层：Architecture Decomposition，架构分解层

这一层负责把系统图切分成合理模块。

5.1 分解原则
原则一：按功能内聚划分

每个模块只负责一类核心功能。

好：
  input_adapter
  protocol_parser
  scheduler
  buffer_manager
  register_bank
  output_formatter

不好：
  big_top_do_everything
  mixed_control_data_path
原则二：按接口边界划分

凡是接口协议不同的地方，都应考虑模块边界。

AXI-Lite ↔ internal config
AXIS ↔ FIFO
FIFO ↔ processing pipeline
APB ↔ register bank
NoC ↔ local bus
原则三：按时钟域划分

跨时钟处必须显式模块化。

clk_a module
  ↓
cdc_bridge / async_fifo
  ↓
clk_b module
原则四：按事务边界划分

一个事务的关键 metadata 绑定点不能被随意切断。

例如：

metadata capture
payload capture
transaction commit

这三类逻辑通常需要显式定义所有权。

原则五：按验证可分解性划分

每个模块都应该能单独构造 testbench。

如果一个模块无法定义明确输入输出行为，就说明架构边界可能不合理。

5.2 分解产物

系统输出：

1. module_tree.yaml
2. module_responsibility.md
3. interface_map.yaml
4. clock_domain_map.yaml
5. transaction_ownership.yaml
6. verification_partition.yaml

示例：

modules:
  input_adapter:
    responsibility:
      - receive external stream
      - validate input sideband
      - convert to internal transaction
    clock: clk_data

  buffer_manager:
    responsibility:
      - allocate buffer entries
      - maintain occupancy
      - provide flow control
    clock: clk_data

  scheduler:
    responsibility:
      - select next transaction
      - enforce priority
      - generate dispatch event
    clock: clk_data

  register_bank:
    responsibility:
      - expose configuration registers
      - expose status registers
      - handle software read/write
    clock: clk_ctrl
6. 第四层：Interface Contract，接口契约层

这是通用 SoC 级生成机制最重要的环节之一。

LLM 直接写 RTL 容易出现：

信号少了
位宽错了
ready/valid 语义错了
tlast 没保持
寄存器写响应时序错了
FIFO full/empty 使用错了
CDC 没处理

因此每个模块生成前，必须先生成接口契约。

6.1 通用接口契约格式
interface_contract:
  module: module_name
  clock: clk
  reset: resetn

  ports:
    input:
      - name: in_valid
        width: 1
        role: handshake_valid
      - name: in_ready
        width: 1
        role: handshake_ready
      - name: in_data
        width: 512
        role: payload
    output:
      - name: out_valid
        width: 1
        role: handshake_valid
      - name: out_ready
        width: 1
        role: handshake_ready
      - name: out_data
        width: 512
        role: payload

  rules:
    stable_when_stalled:
      condition: in_valid && !in_ready
      signals:
        - in_data
    no_drop:
      input_transaction_must_eventually_be_consumed: true
    no_duplicate:
      one_input_transaction_maps_to_one_output_transaction: true
6.2 AXI-Stream 契约
axis_contract:
  signals:
    tdata: required
    tkeep: optional_or_required_by_width
    tlast: frame_based_required
    tvalid: required
    tready: required
    tuser: optional
    tid: optional
    tdest: optional

  rules:
    valid_ready_handshake:
      transfer_occurs_when: tvalid && tready

    stable_during_stall:
      when: tvalid && !tready
      stable:
        - tdata
        - tkeep
        - tlast
        - tuser

    frame_semantics:
      one_tlast_per_frame: true
      no_interleaving_unless_tid_supported: true

    keep_semantics:
      middle_beat_full_keep: true
      last_beat_prefix_valid: configurable
6.3 AXI-Lite 契约
axil_contract:
  channels:
    write_address:
      signals: [awvalid, awready, awaddr]
    write_data:
      signals: [wvalid, wready, wdata, wstrb]
    write_response:
      signals: [bvalid, bready, bresp]
    read_address:
      signals: [arvalid, arready, araddr]
    read_data:
      signals: [rvalid, rready, rdata, rresp]

  rules:
    aw_and_w_can_arrive_independently: true
    bvalid_after_write_accept: true
    rvalid_after_read_accept: true
    response_stable_until_ready: true
6.4 FIFO 契约
fifo_contract:
  write:
    wr_en_only_when_not_full: true
    din_stable_on_wr_en: true
  read:
    rd_en_only_when_not_empty: true
    dout_latency: first_word_fallthrough_or_registered
  count:
    exact_or_approximate: specified
    latency: specified
6.5 CDC 契约
cdc_contract:
  crossing_type:
    - single_bit_control
    - multi_bit_status
    - data_stream
    - pulse
    - reset

  allowed_solution:
    single_bit_control: two_ff_sync
    pulse: pulse_sync_or_toggle_sync
    multi_bit_status: gray_code_or_handshake
    data_stream: async_fifo
    reset: reset_synchronizer

  forbidden:
    - direct_multi_bit_reg_crossing
    - combinational_crossing
7. 第五层：Transaction and State Modeling，事务与状态建模层

复杂 SoC 的 bug 很多来自事务级语义错误。

因此每个复杂模块生成前，都需要生成 transaction model。

7.1 通用事务模型
transaction_model:
  name: generic_transaction

  participants:
    - producer
    - buffer
    - consumer
    - status_manager

  lifecycle:
    - created
    - accepted
    - buffered
    - processed
    - emitted
    - committed
    - retired

  invariants:
    - transaction_id_is_unique_until_retired
    - metadata_stable_after_accept
    - data_order_preserved
    - commit_after_emit
    - abort_flushes_partial_state
7.2 状态机模型

所有复杂 FSM 先用抽象状态图描述，再生成 RTL。

fsm:
  name: controller_fsm
  states:
    - IDLE
    - ACCEPT
    - PROCESS
    - WAIT_OUTPUT
    - COMMIT
    - ERROR

  transitions:
    - from: IDLE
      to: ACCEPT
      condition: input_available
    - from: ACCEPT
      to: PROCESS
      condition: input_handshake_done
    - from: PROCESS
      to: WAIT_OUTPUT
      condition: process_done
    - from: WAIT_OUTPUT
      to: COMMIT
      condition: output_handshake_done
    - from: COMMIT
      to: IDLE
      condition: commit_done
    - from: any
      to: ERROR
      condition: protocol_violation
7.3 状态/事务一致性检查

系统应自动检查：

1. 是否存在不可达状态。
2. 是否存在无出口状态。
3. 是否存在 transaction 创建后无法释放。
4. 是否存在资源重复释放。
5. 是否存在 commit 早于 output。
6. 是否存在 error 后没有 flush。
7. 是否存在 reset 后残留 valid/status。
8. 第六层：Constrained RTL Generation，受约束 RTL 生成层

这一层才真正生成 Verilog/SystemVerilog。

但它不是自由生成，而是被前面几层约束。

输入：

1. module responsibility
2. interface contract
3. transaction model
4. FSM graph
5. timing requirement
6. coding style
7. reusable templates
8. verification hooks

输出：

1. synthesizable RTL
2. module-level assertions
3. local testbench
4. metadata for system graph update
8.1 RTL 生成策略
策略一：模板优先

通用结构不应让 LLM 反复自由生成。

模板库包括：

1. AXIS register slice
2. AXIS skid buffer
3. AXIS frame FIFO
4. AXI-Lite register bank
5. APB slave
6. async FIFO wrapper
7. reset synchronizer
8. pulse synchronizer
9. round-robin arbiter
10. priority arbiter
11. counter/timer
12. descriptor FIFO
13. transaction table
14. CSR/status block
15. interrupt controller

这样可以减少 LLM 幻觉。

策略二：LLM 只填“逻辑差异部分”

例如通用 AXIS 模块框架由模板提供：

module axis_transform #(
    parameter DATA_WIDTH = 512
)(
    input  wire clk,
    input  wire resetn,

    input  wire [DATA_WIDTH-1:0] s_axis_tdata,
    input  wire                  s_axis_tvalid,
    output wire                  s_axis_tready,
    input  wire                  s_axis_tlast,

    output wire [DATA_WIDTH-1:0] m_axis_tdata,
    output wire                  m_axis_tvalid,
    input  wire                  m_axis_tready,
    output wire                  m_axis_tlast
);

LLM 只生成 transform 逻辑，而不是整个握手机制。

策略三：状态机由 FSM IR 编译生成

FSM 不直接让 LLM 手写，而是：

FSM YAML → RTL FSM generator → Verilog

LLM 负责补充状态语义，代码生成器负责结构正确性。

策略四：自动插入 debug/trace hook

每个复杂模块应自动生成：

1. state debug signal
2. transaction_id debug signal
3. error_code
4. accepted_count
5. emitted_count
6. dropped_count
9. 第七层：Verification Generation，验证生成层

复杂 SoC 级 RTL 生成必须同步生成验证。

9.1 验证资产类型
1. Unit testbench
2. Integration testbench
3. System testbench
4. Protocol monitor
5. Scoreboard
6. Reference model
7. Assertion file
8. Coverage model
9. Random stimulus generator
10. Regression test list
9.2 Unit-level 验证

每个模块至少验证：

1. reset 后状态正确。
2. 基本功能路径。
3. backpressure。
4. 边界长度。
5. 随机输入。
6. 非法输入。
7. error handling。
8. no deadlock。
9. no data duplication。
10. no data loss。
9.3 Interface-level 验证

每个接口自动插入 monitor。

例如 ready/valid monitor：

property valid_stable_until_ready;
  @(posedge clk) disable iff (!resetn)
    valid && !ready |=> valid;
endproperty

property payload_stable_when_stalled;
  @(posedge clk) disable iff (!resetn)
    valid && !ready |=> $stable(payload);
endproperty
9.4 Transaction-level 验证

系统应自动生成 transaction scoreboard：

input transaction accepted
  → record metadata/data
output transaction emitted
  → compare with expected
commit event
  → check it corresponds to emitted transaction
9.5 System-level 验证

SoC 级验证包括：

1. 多模块互联。
2. 多事务连续输入。
3. 随机 backpressure。
4. 随机配置寄存器访问。
5. 多时钟异步关系。
6. reset during active transaction。
7. error injection。
8. timeout/deadlock 检查。
9. resource full/empty 边界。
10. 长时间压力测试。
10. 第八层：EDA Feedback Loop，EDA 反馈闭环

生成 RTL 后必须进入工具闭环。

10.1 工具反馈类型
1. Verilog parser feedback
2. lint feedback
3. simulation feedback
4. assertion failure
5. coverage report
6. synthesis report
7. timing report
8. CDC report
9. resource utilization report
10. formal verification result
10.2 反馈归一化

工具日志不能直接扔给 LLM，而要先结构化。

示例：

failure:
  type: assertion_failure
  module: output_adapter
  property: stable_when_stalled
  cycle: 12840
  signal_snapshot:
    valid: 1
    ready: 0
    data_changed: true

classification:
  layer: interface_contract
  contract: ready_valid_stability
  likely_cause:
    - missing skid buffer
    - data register overwritten during stall
11. Root-Cause Analysis，系统级根因分析

这是通用架构区别于简单 VerilogCoder 溯源机制的关键。

普通 RTL agent 的修复路径是：

报错 → 找到代码行 → 修改代码

HSG-RTL 的修复路径是：

报错
 → 映射到 assertion / scoreboard
 → 映射到 interface contract
 → 映射到 transaction model
 → 映射到 system graph edge
 → 判断错误类型
 → 选择 patch 类型
11.1 错误分类
error_taxonomy:
  syntax_error:
    repair_level: rtl

  width_mismatch:
    repair_level: interface_or_rtl

  handshake_violation:
    repair_level: interface_contract_or_rtl

  transaction_mismatch:
    repair_level: transaction_model_or_architecture

  cdc_violation:
    repair_level: clock_domain_architecture

  deadlock:
    repair_level: system_graph_or_fsm

  timing_violation:
    repair_level: microarchitecture_or_pipeline

  coverage_hole:
    repair_level: verification_plan
11.2 Patch 类型
1. RTL patch
   修具体代码。

2. Interface patch
   修接口契约或端口定义。

3. Architecture patch
   修模块边界或数据路径。

4. Transaction patch
   修事务生命周期。

5. Verification patch
   修 testbench / scoreboard / assertion。

6. Timing patch
   加 pipeline / register slice / retiming。

7. CDC patch
   加同步器 / async FIFO / handshake bridge。
12. 多 Agent 组织方式

通用 SoC 生成系统不适合一个 Agent 全包，应使用多 Agent。

12.1 Spec Agent

职责：

1. 解析需求。
2. 提取功能目标。
3. 提取接口目标。
4. 提取性能目标。
5. 提取验证目标。
6. 生成 requirement traceability。
12.2 Architecture Agent

职责：

1. 构建系统图。
2. 做模块划分。
3. 识别复用 IP。
4. 识别时钟域。
5. 识别资源边界。
12.3 Interface Contract Agent

职责：

1. 为每个模块生成接口契约。
2. 检查接口完整性。
3. 生成协议 assertion。
4. 生成接口 monitor。
12.4 Transaction Agent

职责：

1. 建模事务生命周期。
2. 生成 transaction invariant。
3. 生成 scoreboard 规则。
4. 检查跨模块状态一致性。
12.5 RTL Generation Agent

职责：

1. 按 contract 生成 RTL。
2. 复用模板库。
3. 遵守编码规范。
4. 生成 debug hook。
12.6 Verification Agent

职责：

1. 生成 testbench。
2. 生成 directed/random tests。
3. 生成 assertions。
4. 生成 coverage。
5. 生成 reference model。
12.7 EDA Runner Agent

职责：

1. 调用编译器。
2. 调用仿真器。
3. 调用综合工具。
4. 调用 CDC/lint/formal 工具。
5. 结构化日志。
12.8 Root Cause Agent

职责：

1. 从失败结果回溯到系统图。
2. 判断错误属于哪一层。
3. 生成修复策略。
4. 防止局部修复破坏全局契约。
12.9 Patch Agent

职责：

1. 生成最小 patch。
2. 更新 RTL 或 contract。
3. 触发局部回归。
4. 记录 patch rationale。
13. 通用数据资产

系统运行时应维护一组长期资产。

project/
 ├── specs/
 │   ├── requirements.yaml
 │   └── requirement_trace.md
 │
 ├── graphs/
 │   ├── system_graph.yaml
 │   ├── dataflow_graph.yaml
 │   ├── control_graph.yaml
 │   ├── clock_reset_graph.yaml
 │   └── transaction_graph.yaml
 │
 ├── contracts/
 │   ├── module_a_contract.yaml
 │   ├── module_b_contract.yaml
 │   └── interface_contracts.yaml
 │
 ├── rtl/
 │   ├── module_a.sv
 │   ├── module_b.sv
 │   └── top.sv
 │
 ├── verification/
 │   ├── tb_module_a.sv
 │   ├── tb_module_b.sv
 │   ├── scoreboard.sv
 │   ├── assertions.sv
 │   └── testlist.yaml
 │
 ├── reports/
 │   ├── lint_report.json
 │   ├── sim_report.json
 │   ├── synth_report.json
 │   └── coverage_report.json
 │
 └── patches/
     ├── patch_001.diff
     ├── patch_001_reason.md
     └── regression_result.md
14. 工作流程
14.1 初始生成流程
Step 1: 用户输入系统需求
Step 2: Spec Agent 生成结构化规格
Step 3: Architecture Agent 生成系统图
Step 4: Interface Agent 生成接口契约
Step 5: Transaction Agent 生成事务模型
Step 6: RTL Agent 生成模块 RTL
Step 7: Verification Agent 生成验证环境
Step 8: EDA Agent 运行编译/仿真/综合
Step 9: Root Cause Agent 分析失败
Step 10: Patch Agent 修改
Step 11: 回归直到通过
14.2 迭代修改流程

当用户提出新需求：

增加一个 DMA 通道
修改 AXI 数据宽度
增加中断
增加低功耗门控
增加多 clock 支持

系统不能直接改 RTL，而要：

1. 更新 requirement。
2. 更新 system graph。
3. 检查受影响模块。
4. 更新 interface contract。
5. 更新 transaction model。
6. 局部重新生成 RTL。
7. 自动选择受影响 testcase。
8. 运行局部+系统回归。
15. 评价指标

通用架构应使用多层指标评价，而不是只看 pass@1。

15.1 代码级指标
1. 语法通过率
2. lint clean rate
3. 可综合率
4. latch-free rate
5. no comb-loop rate
15.2 接口级指标
1. 接口信号完整率
2. 位宽一致率
3. ready/valid contract 通过率
4. AXI/AXIS/APB protocol assertion 通过率
5. CDC 违规数量
15.3 事务级指标
1. transaction completion rate
2. no data loss
3. no duplication
4. no reorder unless allowed
5. metadata-data consistency
6. commit correctness
15.4 系统级指标
1. integration simulation pass rate
2. random regression pass rate
3. coverage closure
4. deadlock-free duration
5. reset recovery success rate
6. long-run stability
15.5 修复效率指标
1. 平均修复轮数
2. 每轮 patch 大小
3. patch 是否破坏旧功能
4. root cause 分类准确率
5. 局部回归命中率
16. 与传统 VerilogCoder 类方法的区别
维度	传统 VerilogCoder 类机制	HSG-RTL 通用机制
生成对象	单模块或小型设计	多 IP / 复杂 SoC
核心表示	AST / 代码图 / 局部波形	系统图 / 接口契约 / 事务图
错误溯源	代码级、信号级	系统级因果链
生成方式	Prompt-to-RTL	Spec-to-Graph-to-Contract-to-RTL
验证方式	编译/仿真反馈	单元/集成/系统/接口/事务多层验证
修复方式	修改局部 RTL	RTL / 接口 / 架构 / 事务 / 验证多级 patch
适用范围	简单模块、中等模块	复杂 IP、子系统、SoC
风险	局部正确但系统错误	通过 contract 和 graph 降低全局失配
17. 最核心创新点

这套通用架构可以概括为五个核心创新点。

17.1 System Graph First

先建系统图，再写 RTL。

不是 Verilog 驱动架构，
而是架构驱动 Verilog。
17.2 Interface Contract Before Implementation

先定义接口契约，再生成模块实现。

接口语义优先于代码。
17.3 Transaction-Centric Generation

复杂 SoC 不以 always block 为中心，而以 transaction lifecycle 为中心。

一个事务如何创建、传播、完成、提交、释放，是生成 RTL 的主线。
17.4 Multi-Level Verification Co-Generation

生成 RTL 的同时生成验证资产。

没有 testbench / assertion / scoreboard 的 RTL 生成是不完整的。
17.5 Root-Cause Repair Across Abstraction Levels

修复不能只改代码，要能在不同抽象层回退。

代码错，修 RTL。
接口错，修 contract。
事务错，修 transaction model。
架构错，修 system graph。
验证错，修 testbench。
18. 最终定义

这套通用机制可以正式定义为：

HSG-RTL 是一种面向复杂 SoC 的层次化系统图驱动 RTL 生成机制。它通过结构化规格输入、系统图建模、架构分解、接口契约生成、事务/状态建模、受约束 RTL 生成、验证资产共生成和 EDA 闭环修复，将传统 prompt-to-Verilog 方式提升为 spec-to-system-to-RTL 的可验证生成流程。其核心目标是解决复杂 SoC 中跨模块接口失配、事务语义断裂、多时钟域风险、局部修复破坏全局一致性等问题。

复杂 SoC 的 AI Verilog 生成，不应该是“让模型写代码”，而应该是“让模型维护系统图、接口契约和事务一致性，再在这些约束下生成 RTL”。
