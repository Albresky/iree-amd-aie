<!--
 * @Author: Albresky albre02@outlook.com
 * @Date: 2025-07-12 20:40:54
 * @LastEditors: Albresky albre02@outlook.com
 * @LastEditTime: 2025-07-12 20:41:11
 * @FilePath: /iree-amd-aie/doc/iree-compile_cl_help.md
 * @Description: IREE-AMD-AIE 项目 `iree-compile` 命令行帮助文档
-->
### `iree-compile` 帮助文档

**概览**: IREE 编译驱动程序

**用法**: `iree-compile [选项] <输入文件>`

>   - **`<输入文件>`**: 你的模型文件，通常是 `.mlir` 格式。如果用 `-`，表示从标准输入读取。

-----

### 🚀 核心编译选项

这些是控制编译流程、输入和输出的最基本也是最重要的选项。

  - **`--iree-hal-target-backends=<string>`**

      - **解释**: 指定要为哪种硬件后端进行编译。这是决定最终产物给谁用的关键参数。你可以指定一个或多个后端，用逗号隔开。
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
          - `vm-bytecode` (默认): 编译成 IREE 虚拟机可以执行的二进制字节码。这是最常用的格式。
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
      - **示例**:
        ```bash
        # 当你的输入 .mlir 文件只包含一个 hal.executable 时使用
        --compile-mode=hal-executable
        ```

  - **`--compile-to=<value>`**

      - **解释**: 让编译流程在某个特定阶段**提前停止**，并输出当时的中间代码（IR）。这是进行**分步调试**和分析编译过程的利器。
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

-----

### 🧠 AMD AIE 专用选项

这些选项专门用于控制针对 AMD AIE 硬件的编译行为。

  - **`--iree-amdaie-target-device=<value>`**

      - **解释**: **（极其重要）** 指定目标 AIE 设备的具体型号。不同的型号有不同的架构、核心数和内存大小，必须正确选择。
          - `npu1`: 默认的 Phoenix NPU 型号。
          - `npu1_2col`: 使用 2 列核心的 Phoenix NPU。
          - `xcvc1902`, `xcve2802` 等: 其他具体的 Versal AI Core 器件型号。
      - **示例**:
        ```bash
        # 明确指定目标设备为 npu1
        --iree-amdaie-target-device=npu1
        ```

  - **`--iree-amdaie-num-cols=<uint>`** 和 **`--iree-amdaie-num-rows=<uint>`**

      - **解释**: 告知编译器在 AIE 核心阵列中可以使用多少行和多少列。这会影响编译器如何切分（Tiling）计算任务以适应硬件规模。
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

      - **解释**: 在编译过程中，会调用很多外部工具（如 aie-opt, peano-opt, vitis aietools 等）。使用此选项可以**打印出所有这些被调用的命令**及其参数，对于调试工具链本身非常有帮助。
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

      - **解释**: 启用控制包（Control Packet）功能。这是一种用于快速重新配置 AIE 硬件的技术，可以将配置信息打包发送，而不是完全重新加载。
      - **示例**:
        ```bash
        # 为需要动态配置的场景启用控制包
        --iree-amdaie-enable-control-packet
        ```

-----

### ⚙️ 全局优化与流程控制

  - **`--iree-opt-level=<optimization level>`**

      - **解释**: 设置全局优化等级。
          - `-O0`: 不优化。
          - `-O1`, `-O2`: 开启一些优化。
          - `-O3`: 开启更激进的优化。
      - **示例**:
        ```bash
        # 为了获得发布级的性能，使用O3优化
        --iree-opt-level=3
        ```

  - **`--iree-opt-data-tiling`**

      - **解释**: 启用数据切分（Data Tiling）优化，这是一个关键的性能优化步骤，它会将大块数据切成小块以更好地利用缓存。默认开启。
      - **示例**:
        ```bash
        # 如果想禁用数据切分以进行调试，可以设置为 false
        --iree-opt-data-tiling=false
        ```

  - **`--iree-input-type=<string>`**

      - **解释**: 指定输入模型的方言类型，例如 `tosa`, `stablehlo`。`auto` 会让编译器自动检测。
      - **示例**:
        ```bash
        # 明确告知输入是 tosa 方言
        --iree-input-type=tosa
        ```

-----

### 🐞 MLIR 调试与打印选项

这些选项用于在编译的各个阶段打印中间表示（IR），是调试编译问题的核心工具。

  - **`--mlir-print-ir-before-all`** 和 **`--mlir-print-ir-after-all`**

      - **解释**: 分别在**每个** MLIR Pass (编译步骤) **执行前**或**执行后**打印出整个模块的 IR。这会产生大量输出，但能让你精确地看到每一步对代码做了什么改变。
      - **示例**:
        ```bash
        # 追踪所有 Pass 的效果
        --mlir-print-ir-after-all
        ```

  - **`--mlir-print-ir-before=<pass-arg>`** 和 **`--mlir-print-ir-after=<pass-arg>`**

      - **解释**: 只在**指定**的某个 Pass **执行前**或**执行后**打印 IR。这比 `...-all` 的目标更明确。`<pass-arg>` 是 Pass 的参数名。
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

      - **解释**: 将每个主要编译阶段（如 `flow`, `stream`, `hal`）结束时的 IR 转储到一个指定的目录中，每个阶段一个文件。这比打印到控制台更方便管理和比较。
      - **示例**:
        ```bash
        # 将所有中间结果保存到 /tmp/iree_dumps/ 目录
        --dump-compilation-phases-to=/tmp/iree_dumps/
        ```