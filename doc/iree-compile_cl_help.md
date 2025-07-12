<!--
 * @Author: Albresky albre02@outlook.com
 * @Date: 2025-07-12 20:40:54
 * @LastEditors: Albresky albre02@outlook.com
 * @LastEditTime: 2025-07-12 20:57:44
 * @FilePath: /iree-amd-aie/doc/iree-compile_cl_help.md
 * @Description: IREE-AMD-AIE 项目 `iree-compile` 命令行帮助文档
-->
# `iree-compile` 帮助文档

**概览**: IREE 编译驱动程序

**用法**: `iree-compile [选项] <输入文件>`

>   - **`<输入文件>`**: 您的模型文件，通常是 `.mlir` 格式。如果使用 `-`，表示从标准输入流读取。

-----

### <H2>🚀 核心编译选项</H2>

<p>这些是控制编译流程、输入和输出的最基本也是最重要的选项。</p>

  - **`--iree-hal-target-backends=<string>`**

      - **解释**: 指定要为哪种硬件后端进行编译。 这是决定最终产物给谁用的关键参数。你可以指定一个或多个后端，用逗号隔开。
      - **示例**:
        ```bash
        # 为 AMD AIE 硬件编译
        --iree-hal-target-backends=amd-aie

        # 同时为 CPU 和英伟达 GPU 编译
        --iree-hal-target-backends=llvm-cpu,cuda
        ```

  - **`-o <filename>`**

      - **解释**: 指定输出文件的名字。
      - **示例**:
        ```bash
        -o my_model.vmfb
        ```

  - **`--output-format=<value>`**

      - **解释**: 指定编译产物的格式。
          - `vm-bytecode` (默认): 编译成 IREE 虚拟机可以执行的二进制字节码。 这是最常用的格式。
          - `vm-c`: 编译成 C 语言源代码。
          - `vm-asm`: 编译成 IREE 虚拟机的汇编语言（一种特殊的 MLIR 格式）。
      - **示例**:
        ```bash
        # 输出 C 源码，用于研究或集成到 C 项目中
        --output-format=vm-c -o my_model.c
        ```

  - **`--compile-mode=<value>`**

      - **解释**: 选择编译模式，决定了整个编译流水线的类型。
          - `std` (默认): 标准编译流程，适用于将完整模型编译成可执行模块。
          - `hal-executable`: 特殊模式，只编译一个包含硬件抽象层（HAL）可执行文件的模块，常用于底层算子调试。
          - `precompile`: 预编译流水线，进行输入转换和全局优化。
      - **示例**:
        ```bash
        # 当你的输入 .mlir 文件只包含一个 hal.executable 时使用
        --compile-mode=hal-executable
        ```

  - **`--compile-to=<value>`**

      - **解释**: 让编译流程在某个特定阶段**提前停止**，并输出当时的中间代码（IR）。 这是进行**分步调试**和分析编译过程的利器。
          - `input`: 在输入处理和初步 lower 之后停止。
          - `flow`: 在编译到 `flow` 方言后停止。
          - `stream`: 在编译到 `stream` 方言后停止。
          - `executable-targets`: 在代码生成（Codegen）完成，生成了特定于硬件的代码之后停止。
          - `hal`: 在编译到 `hal` 方言后停止。
      - **示例**:
        ```bash
        # 查看代码生成后的结果，但不进行最终的打包
        --compile-to=executable-targets -o codegen_output.mlir
        ```

<br>
<details>
<summary><strong>➕ 点击展开/折叠 更多编译阶段选项</strong></summary>

  - **`--compile-from=<value>`**
      - **解释**: 让编译从某个特定阶段**之后**开始，跳过前面的步骤。 这对于从已有的中间产物恢复编译很有用。
      - **示例**:
        ```bash
        # 假设我们已经有了 stream.mlir，想从 stream 阶段之后继续编译
        # iree-compile --compile-from=stream stream.mlir ...
        ```

</details>

-----

### <H2>🧠 AMD AIE 专用选项</H2>

<p>这些选项专门用于控制针对 AMD AIE 硬件的编译行为。</p>

  - **`--iree-amdaie-target-device=<value>`**

      - **解释**: **（极其重要）** 指定目标 AIE 设备的具体型号。 不同的型号有不同的架构、核心数和内存大小，必须正确选择。
          - `npu1`: 默认的 Phoenix NPU 型号。
          - `npu1_2col`: 使用 2 列核心的 Phoenix NPU。
          - `npu4`: Strix B0 NPU，拥有8列6行核心。
          - `xcvc1902`, `xcve2802` 等: 其他具体的 Versal AI Core 器件型号。
      - **示例**:
        ```bash
        # 明确指定目标设备为 npu1
        --iree-amdaie-target-device=npu1
        ```

  - **`--iree-amdaie-num-cols=<uint>`** 和 **`--iree-amdaie-num-rows=<uint>`**

      - **解释**: 告知编译器在 AIE 核心阵列中可以使用多少行和多少列。 这会影响编译器如何切分（Tiling）计算任务以适应硬件规模。 注意，对于某些算子（如卷积），此标志可能被忽略。
      - **示例**:
        ```bash
        # 限制编译器最多使用 4 列核心和 2 行核心
        --iree-amdaie-num-cols=4 --iree-amdaie-num-rows=2
        ```

  - **`--iree-amdaie-enable-ukernels=<string>`**

      - **解释**: 启用针对特定算子的高度优化的微内核（uKernel），以获得更好的性能。
          - `none`: 不启用任何微内核。
          - `all`: 启用所有可用的微内核。
          - `matmul,conv`: 只启用 `matmul` 和 `conv` 算子的微内核（用逗号分隔）。
      - **示例**:
        ```bash
        # 为了获得最佳性能，启用所有微内核
        --iree-amdaie-enable-ukernels=all
        ```

  - **`--iree-amdaie-lower-to-aie-pipeline=<value>`**

      - **解释**: 选择将高层算子（如 Linalg）降低到 AIE 指令所使用的流水线策略。
          - `air`: 通过 AIR (AI Engine IR) 进行降低。
          - `objectFifo`: 使用 objectFifo 机制进行降低，这是一种数据交换方式。
      - **示例**:
        ```bash
        # 选择 objectFifo 降低流水线
        --iree-amdaie-lower-to-aie-pipeline=objectFifo
        ```

  - **`--iree-amdaie-show-invoked-commands`**

      - **解释**: 在编译过程中，会调用很多外部工具（如 aie-opt, peano-opt, vitis aietools 等）。 使用此选项可以**打印出所有这些被调用的命令**及其参数，对于调试工具链本身非常有帮助。
      - **示例**:
        ```bash
        # 查看编译过程中都调用了哪些底层命令
        --iree-amdaie-show-invoked-commands
        ```

  - **`--iree-amd-aie-peano-install-dir=<string>`** 和 **`--iree-amd-aie-vitis-install-dir=<string>`**

      - **解释**: 分别指定 Peano 编译器（一个新的 AIE 后端）和 Vitis aietools 的安装路径。通常编译器会自动寻找，但在特殊环境下需要手动指定。
      - **示例**:
        ```bash
        --iree-amd-aie-peano-install-dir=/opt/peano
        --iree-amd-aie-vitis-install-dir=/opt/Xilinx/Vitis/2023.2
        ```

  - **`--iree-amdaie-enable-control-packet`**

      - **解释**: 启用控制包（Control Packet）功能。 这是一种用于快速重新配置 AIE 硬件的技术，可以将配置信息打包发送，而不是完全重新加载。
      - **示例**:
        ```bash
        # 为需要动态配置的场景启用控制包
        --iree-amdaie-enable-control-packet
        ```

<br>
<details>
<summary><strong>➕ 点击展开/折叠 更多 AMD AIE 选项</strong></summary>

  - **`--iree-amdaie-device-hal=<value>`**: 设置目标设备的硬件抽象层（HAL）。 可以是 `xrt` 或 `xrt-lite`。
  - **`--iree-amdaie-tile-pipeline=<value>`**: 选择用于 tiling 的流水线策略。 例如 `pack-peel` 或 `conv-decompose`。
  - **`--iree-amdaie-packet-flow-strategy=<value>`**: 启用包路由数据移动。 `auto` 选项会进行拥塞感知分配。
  - **`--iree-amdaie-enable-function-outlining=<value>`**: 控制是否将 linalg 操作提取成独立函数。
  - **`--iree-amdaie-call-replication=<int>`**: 重复调用被提取出的函数。 主要用于性能剖析，例如n=0测试数据移动，n\>\>1测试核心计算。
  - **`--iree-amdaie-stack-size=<uint>`**: 设置AIE核心的堆栈大小。
  - **`--iree-amd-aie-additional-peano-opt-flags=<string>`**: 为 Peano 的 `opt` 工具提供额外的标志，例如 `"-O3 --magic-flag"`。
  - **`--iree-amd-aie-install-dir=<string>`**: AMDAIE 的安装目录路径。
  - **`--iree-amdaie-enable-infinite-loop-around-core-block`**: 在核心代码块外插入无限循环，通常仅用于精确的性能测量。
  - **`--iree-amdaie-enable-vectorization-passes`**: 启用或禁用某些流水线中的向量化 pass，仅用于开发。
  - **`--iree-amdaie-enable-coalescing-loops`**: 在向量化时启用循环合并，仅用于开发。
  - **`--iree-amdaie-enable-collapsing-unit-dims`**: 在向量化时启用对单位维度的折叠，仅用于开发。
  - **`--iree-amdaie-matmul-elementwise-fusion`**: 启用 MLIR-AIR 中用于 matmul-elementwise 融合的特殊 pass，仅用于开发。

</details>

-----

### <H2>⚙️ 全局优化与流程控制</H2>

  - **`--iree-opt-level=<optimization level>`**

      - **解释**: 设置全局优化等级，应用于整个编译流程。
      - **示例**:
        ```bash
        # 为了获得发布级的性能，使用O3优化
        --iree-opt-level=3
        ```

  - **`--iree-opt-data-tiling`**

      - **解释**: 启用数据切分（Data Tiling）优化。 这是一个关键的性能优化步骤，它会将大块数据切成小块以更好地利用缓存。 默认开启。
      - **示例**:
        ```bash
        # 如果想禁用数据切分以进行调试，可以设置为 false
        --iree-opt-data-tiling=false
        ```

  - **`--iree-input-type=<string>`**

      - **解释**: 指定输入模型的方言类型，例如 `tosa`, `stablehlo`。 `auto` 会让编译器自动检测。
      - **示例**:
        ```bash
        # 明确告知输入是 tosa 方言
        --iree-input-type=tosa
        ```

<br>
<details>
<summary><strong>➕ 点击展开/折叠 更多全局优化选项</strong></summary>

  - **`--iree-global-optimization-opt-level=<optimization level>`**: 单独为全局优化阶段设置优化等级。
  - **`--iree-dispatch-creation-opt-level=<optimization level>`**: 单独为 dispatch region 创建阶段设置优化等级。
  - **`--iree-opt-const-eval`**: 启用常量的即时求值（默认开启）。
  - **`--iree-opt-const-expr-hoisting`**: 将常量表达式的结果提升为不可变的全局初始化器。
  - **`--iree-opt-numeric-precision-reduction`**: 在可能的情况下，将数值精度降低到更低的位宽。
  - **`--iree-input-demote-f32-to-f16`**: 在全局优化前，强制将所有 f32 操作和值转换为 f16。
  - **`--iree-scheduling-optimize-bindings`**: 启用绑定融合和调度点特化。
  - **`--iree-flow-enable-pad-handling`**: 启用对 `tensor.pad` 操作的原生处理。

</details>

-----

### <H2>🐞 MLIR 调试与打印选项\</H2>

<p>这些选项用于在编译的各个阶段打印中间表示（IR），是调试编译问题的核心工具。</p>

  - **`--mlir-print-ir-before-all`** 和 **`--mlir-print-ir-after-all`**

      - **解释**: 分别在**每个** MLIR Pass (编译步骤) **执行前** 或**执行后** 打印出整个模块的 IR。这会产生大量输出，但能让你精确地看到每一步对代码做了什么改变。
      - **示例**:
        ```bash
        # 追踪所有 Pass 的效果
        --mlir-print-ir-after-all
        ```

  - **`--mlir-print-ir-before=<pass-arg>`** 和 **`--mlir-print-ir-after=<pass-arg>`**

      - **解释**: 只在**指定**的某个 Pass **执行前** 或**执行后** 打印 IR。这比 `...-all` 的目标更明确。`<pass-arg>` 是 Pass 的参数名。
      - **示例**:
        ```bash
        # 只看 iree-amdaie-tile-and-fuse 这个 Pass 执行后的结果
        --mlir-print-ir-after=iree-amdaie-tile-and-fuse
        ```

  - **`--mlir-pass-statistics`**

      - **解释**: 显示每个 Pass 的统计信息，例如它改变了多少个操作（Op）。
      - **示例**:
        ```bash
        --mlir-pass-statistics
        ```

  - **`--mlir-timing`**

      - **解释**: 显示每个 Pass 的执行耗时，用于性能分析。
      - **示例**:
        ```bash
        --mlir-timing
        ```

  - **`--dump-compilation-phases-to=<string>`**

      - **解释**: 将每个主要编译阶段（如 `flow`, `stream`, `hal`）结束时的 IR 转储到一个指定的目录中，每个阶段一个文件。 这比打印到控制台更方便管理和比较。
      - **示例**:
        ```bash
        # 将所有中间结果保存到 /tmp/iree_dumps/ 目录
        --dump-compilation-phases-to=/tmp/iree_dumps/
        ```

<br>
<details>
<summary><strong>➕ 点击展开/折叠 更多调试打印选项</strong></summary>

  - **`--mlir-print-ir-module-scope`**: 打印 IR 时，总是从顶层的模块开始打印。
  - **`--mlir-print-op-on-diagnostic`**: 当报告诊断信息（如错误或警告）时，同时打印出相关的操作。
  - **`--mlir-print-stacktrace-on-diagnostic`**: 当报告诊断信息时，同时打印出当前的调用栈。
  - **`--mlir-pretty-debuginfo`**: 以更美观、易读的格式打印调试信息。
  - **`--verify`**: 在整个编译过程中验证 IR 的正确性。

</details>

-----

### <H2>🌍 其他通用和专业选项（折叠）</H2>

<details>
<summary><strong> HAL (硬件抽象层) 选项</strong></summary>

  - **`--iree-hal-dump-executable-files-to=<string>`**: 一个元标志，用于将所有可执行文件相关的内容（源码、二进制、中间文件等）写入指定路径。
  - **`--iree-hal-dump-executable-binaries-to=<string>`**: 将翻译和序列化后的可执行文件二进制内容写入指定路径。
  - **`--iree-hal-dump-executable-intermediates-to=<string>`**: 将翻译过程中的中间文件（如 .bc, .o）写入指定路径。
  - **`--iree-hal-dump-executable-sources-to=<string>`**: 将每个 `hal.executable` 的输入源码列表写入指定路径。
  - **`--iree-hal-executable-debug-level=<int>`**: 可执行文件翻译的调试等级（0-3）。
  - **`--iree-hal-list-target-backends`**: 列出所有已注册的、可用于可执行文件编译的目标后端。

</details>

<details>
<summary><strong> LLVMCPU Target (CPU后端) 选项</strong></summary>

  - **`--iree-llvmcpu-target-triple=<string>`**: 指定 LLVM 的目标三元组（Target Triple），例如 `x86_64-linux-gnu`。
  - **`--iree-llvmcpu-target-cpu=<string>`**: 指定 LLVM 的目标 CPU 型号。 使用 `host` 来自动检测本机CPU。
  - **`--iree-llvmcpu-target-cpu-features=<string>`**: 指定 LLVM 的目标 CPU 特性，例如 `+avx2`。 使用 `host` 来自动检测。
  - **`--iree-llvmcpu-debug-symbols`**: 生成并嵌入调试信息（如 DWARF）。
  - **`--iree-llvmcpu-link-static`**: 静态链接系统库，以减少运行时依赖。
  - **`--iree-llvmcpu-enable-ukernels=<string>`**: 为 LLVMCPU 后端启用微内核。
  - **`--iree-llvmcpu-loop-vectorization`**: 启用 LLVM 的循环向量化优化。
  - **`--iree-llvmcpu-sanitize=<value>`**: 应用 LLVM 的消毒器（Sanitizer）特性，如地址消毒器 (`address`) 或线程消毒器 (`thread`)。

</details>

<details>
<summary><strong> Plugin (插件) 和 Preprocessing (预处理) 选项</strong></summary>

  - **`--iree-plugin=<string>`**: 激活指定的插件。
  - **`--iree-list-plugins`**: 列出所有已加载的插件。
  - **`--iree-preprocessing-pass-pipeline=<string>`**: 在正常的 IREE 编译流程开始前，先运行一个自定义的 pass 流水线。
  - **`--iree-preprocessing-pdl-spec-filename=<string>`**: 使用指定的 PDL 描述文件进行预处理。

</details>

<details>
<summary><strong> VM (虚拟机) 选项</strong></summary>

  - **`--iree-vm-bytecode-module-optimize`**: 在序列化之前，对 VM 模块进行优化（如 CSE、内联）。
  - **`--iree-vm-target-index-bits=<int>`**: 设置索引类型的位宽。
  - **`--iree-vm-target-truncate-unsupported-floats`**: 当不支持 f64 时，将其截断为 f32。

</details>