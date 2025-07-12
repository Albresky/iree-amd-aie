<!--
 * @Author: Albresky albre02@outlook.com
 * @Date: 2025-07-12 14:00:23
 * @LastEditors: Albresky albre02@outlook.com
 * @LastEditTime: 2025-07-12 14:57:50
 * @FilePath: /iree-amd-aie/debug.md
 * @Description: IREE-AMD-AIE 项目端到端调试指南
-->

# IREE-AMD-AIE 项目端到端调试指南

本文旨在记录如何对 `IREE-AMD-AIE` 项目中的核心工具 `iree-compile` 进行端到端的源码级调试，涵盖从 Python 入口到核心 C++ 二进制文件的完整调试链条。

## 1. **核心方法论**：理解工具链的调用层次

调试该项目的关键在于理解 `iree-compile` 命令*并非一个单一程序，而是一个多阶段、多语言的调用链*，在 CMake 大型项目中，这种混合多个不同语言源码的调用链条非常普遍。

其基本调用层次如下：

> **终端命令** (`iree-compile ...`) -\> **Python 包装器** (`__main__.py`) -\> **C/C++ 核心二进制文件 (`iree-compile`) -\> **C++ 源码** (`IREECompileTool.c`)**

1.  **Python 包装器**:

      * 这是面向用户的直接入口。当命令行输入 `iree-compile` 时，首先执行的是一个 Python 脚本。
      * **作用**: 这个脚本非常轻量，主要负责解析复杂的命令行参数，设置必要的环境变量，并定位核心的 C++ 编译器程序。
      * **对应源码**: `./iree-amd-aie/third_party/iree/compiler/bindings/python/iree/compiler/tools/scripts/iree_compile/__main__.py`

> **[如何找到 Python 包装器的入口?]** 在工程根目录下搜索：`find . -type f -path "*/iree_compile/__main__.py"`， 这会列出所有包含该脚本的路径，在每个源码的开头打印当前源码文件的路径，然后重新运行调试器，观察输出的入口路径即可。

2.  **子进程调用**:

      * Python 包装器在完成准备工作后，并**不会**在自己的进程内执行编译。
      * 它通过 Python 的 `subprocess.call()` 或类似函数，**启动一个全新的、独立的子进程**来运行真正的 C++ 编译器。
      * 这是整个调试流程中最关键的转折点，意味着我们不能用一个调试会话从头跟到尾，而必须分阶段进行。

3.  **C/C++ 核心二进制文件**:

      * 这才是执行所有重量级编译工作（如 MLIR Pass 运行、代码生成、优化等）的程序。
      * **对应源码**: `./iree-amd-aie/third_party/iree/compiler/bindings/python/IREECompileTool.c`
      * **对应二进制文件**: 该 C 源码编译后生成的可执行文件，位于构建目录中，路径为 `/root/iree-amd-aie/iree-build/compiler/bindings/python/iree/compiler/_mlir_libs/iree-compile`。

基于此调用链，我们的调试策略必须 **“两步走”**：

  * **第一步**: 调试 Python 包装器，目的是 **“侦察”** —— 弄清楚它最终调用的 C++ 二进制文件的确切路径，以及传递给它的完整参数列表。
  * **第二步**: 直接调试这个 C++ 二进制文件，传入第一步侦察到的参数，从而对核心逻辑进行深入分析。

## 2. VS Code 配置步骤

下面在 VS Code 中配置和执行两步调试法。

### 2.1 准备工作

  * **安装 VS Code 扩展**:
      * `ms-python.python` (Python)
      * `ms-vscode.cpptools` (C/C++)
  * **Debug 模式编译**: 确保项目是在 `Debug` 模式下编译的 (`-DCMAKE_BUILD_TYPE=Debug`)，否则 C/C++ 调试器无法找到符号，断点也不会生效。

### 2.2 第一步：调试 Python 包装器

> **[注意]** 这种大型 CMake 项目往往让用户针对 Python Bindings 创建了虚拟环境和解释器路径，因此在调试时需要确保使用正确的 **Python 解释器** 和 **包路径**。

此阶段的目标是找到 C++ 程序的路径和其所需的参数。

1.  **创建 `launch.json`**: 在 VS Code 的 "Run and Debug" 视图中，创建或打开 `.vscode/launch.json` 文件。

2.  **添加 Python 调试配置**: 将以下配置添加到 `launch.json` 中。它会启动 Python 包装器。

    ```json
    {
        "name": "Debug Python Wrapper: iree-compile",
        "type": "python",
        "request": "launch",
        "module": "iree.compiler.tools.scripts.iree_compile",
        "args": [
            // 在这里列出要调试的参数
            "--iree-hal-target-backends=amd-aie",
            "--compile-to=executable-targets",
            "--iree-amdaie-enable-ukernels=all",
            "test/amd_aie_target_backend.mlir",
            "-o",
            "test/amd_aie_target_backend_vmfb.mlir"
        ],
        "env": {
            // 设置 iree-compile 二进制、Python包 的环境变量
            "PATH": "${workspaceFolder}/iree-install/bin:${env:PATH}",
            "PYTHONPATH": "${workspaceFolder}/iree-build/compiler/bindings/python:${workspaceFolder}/iree-build/runtime/bindings/python"
        },
        "justMyCode": false, // 允许调试lib库代码
        "console": "integratedTerminal"
    }
    ```

3.  **设置断点**: 在 Python 包装器脚本 `/root/iree-amd-aie/third_party/iree/compiler/bindings/python/iree/compiler/tools/scripts/iree_compile/__main__.py` 的 `subprocess.call` 这一行设置断点。

4.  **启动调试**: 运行 `Debug Python Wrapper: iree-compile` 配置。当断点命中时，可以查看 `exe` 和 `args` 变量的值，从而获得下一步所需的所有信息。

### 2.3 第二步：调试核心 C++ 二进制文件

现在我们有了 C++ 程序的路径和参数，可以直接对它进行调试。

> **[注意]** 由于 `iree-compile` 二进制文件在 Cmake 项目中可能不会显式地暴露其源码文件，因此不方便找到程序的函数入口。这里，我们在调试器中设置 `stopAtEntry` 选项，这样调试器会在 `main` 函数入口处停下，方便我们进行单步调试。

1.  **添加 C++ 调试配置**: 将以下配置添加到同一个 `launch.json` 文件中。

    ```json
    {
        "name": "Debug C++ Core: iree-compile",
        "type": "cppdbg",
        "request": "launch",
        "program": "${workspaceFolder}/iree-build/compiler/bindings/python/iree/compiler/_mlir_libs/iree-compile",
        "args": [
            // 从第一步侦察到的、传递给 subprocess.call 的完整参数列表
            "--iree-hal-target-backends=amd-aie",
            "--compile-to=executable-targets",
            "--iree-amdaie-enable-ukernels=all",
            "test/amd_aie_target_backend.mlir",
            "-o",
            "test/amd_aie_target_backend_vmfb.mlir"
        ],
        "stopAtEntry": true, // 在 main 函数入口处停下
        "cwd": "${workspaceFolder}",
        "environment": [],
        "externalConsole": false,
        "MIMode": "gdb",
        "setupCommands": [
            {
                "description": "Enable pretty-printing for gdb",
                "text": "-enable-pretty-printing",
                "ignoreFailures": true
            }
        ],
        "sourceFileMap": {
            "/root/iree-amd-aie": "${workspaceFolder}"
        }
    }
    ```

2.  **设置断点**: 在 C/C++ 源文件中设置断点，例如在入口文件 `/root/iree-amd-aie/third_party/iree/compiler/bindings/python/IREECompileTool.c` 中，或在任何深层的 AIE 插件代码中。

3.  **启动调试**: 运行 `Debug C++ Core: iree-compile` 配置。调试器将在 C 语言的 `main` 函数入口处停下，之后就可以自由地进行单步调试、查看变量和内存。

## 3\. 完整的 `launch.json`

通过上述两步法，即可清晰、高效地对 `iree-compile` 工具链进行全面的源码级调试。下面是包含所有配置的完整 `launch.json` 文件：

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug Python Wrapper: iree-compile",
            "type": "python",
            "request": "launch",
            "module": "iree.compiler.tools.scripts.iree_compile",
            "args": [
                "--iree-hal-target-backends=amd-aie",
                "--compile-to=executable-targets",
                "--iree-amdaie-enable-ukernels=all",
                "test/amd_aie_target_backend.mlir",
                "-o",
                "test/amd_aie_target_backend_vmfb.mlir"
            ],
            "env": {
                "PATH": "${workspaceFolder}/iree-install/bin:${env:PATH}",
                "PYTHONPATH": "${workspaceFolder}/iree-build/compiler/bindings/python:${workspaceFolder}/iree-build/runtime/bindings/python"
            },
            "justMyCode": false,
            "console": "integratedTerminal"
        },
        {
            "name": "Debug C++ Core: iree-compile",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/iree-build/compiler/bindings/python/iree/compiler/_mlir_libs/iree-compile",
            "args": [
                "--iree-hal-target-backends=amd-aie",
                "--compile-to=executable-targets",
                "--iree-amdaie-enable-ukernels=all",
                "test/amd_aie_target_backend.mlir",
                "-o",
                "test/amd_aie_target_backend_vmfb.mlir"
            ],
            "stopAtEntry": true,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "sourceFileMap": {
                "/root/iree-amd-aie": "${workspaceFolder}"
            }
        }
    ]
}
```

## 4. 调试过程遇到的问题

### 4.1 C++ 调试结束时报错

**报错内容**：

**libc_start_call_main.h**
```
Could not load source './csu/../sysdeps/nptl/libc_start_call_main.h': 'SourceRequest' not supported..
```

**原因**：这是因为 C++ 调试器在结束时尝试加载一些系统库的源代码，但这些源代码并不在当前工作目录下。

**解决方法**：将 `cwd` 设置为 `glibc` 的源代码目录。（似乎不会影响 IREE项目的调试）

- i. 安装 `glibc` 源代码：

```bash
apt-get install glibc-source
```

- ii. 解压 `glibc` 源代码：

```bash
cd /usr/src/glibc
tar -xvf glibc-2.*.tar.xz
```

- iii. 在 `launch.json` 中添加或修改 `cwd`：

```json
"cwd": "/usr/src/glibc-2.31", // 替换为实际的 glibc 源代码目录
``` 