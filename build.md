<!--
 * Copyright (c) 2025 by Albresky, All Rights Reserved. 
 * 
 * @Author: Shi Kai albre02@outlook.com
 * @Date: 2025-06-02 14:00:25
 * @LastEditTime: 2025-06-02 14:08:27
 * @FilePath: /iree-amd-aie/build.md
 * 
 * @Description: 
-->
# How to Build IREE-AMD-AIE on Local Machine (Linux)


## 1. Prerequisites

- **1.1 Clone the IREE-AMD-AIE repository:**

```bash
git clone https://github.com/nod-ai/iree-amd-aie.git
cd iree-amd-aie
git submodule update --init --recursive --depth 1
```

- **1.2 Install the required system packages:**

```bash
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install -y python3.11 python3-pip python3.11-dev python3.11-venv build-essential ninja-build clang lld libudev-dev uuid-dev git
```

## 2. Setup Environment

- **2.1 Install the required Python packages:**

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r third_party/iree/runtime/bindings/python/iree/runtime/build_requirements.txt
pip install pyyaml pybind11[global]==2.13.6 nanobind==2.4.0
```


- **2.2 Install the required CMake modules:**

```bash
bash build_tools/ci/install_cmake.sh
```

## 3. Download PEANO(LLVM-AIE)

```bash
# download peano
bash build_tools/download_peano.sh

# export the PEANO install directory to env
export PEANO_INSTALL_DIR=$PWD/llvm-aie
```

## 4. Build LLVM

```bash
# build llvm
bash build_tools/build_llvm.sh ON

# export the LLVM install directory to env
export llvm_install_dir=$PWD/llvm-install
```

## 5. Build IREE and run unit tests

```bash
bash build_tools/build_test_cpp.sh ON
```

- Expected output:

```bash
...
...

194/200 Test #1044: iree-amd-aie/aie_runtime/test/test_0335_aie_dma_tile_dma_packet_switch_mode_lit_test ...............   Passed    0.12 sec
        Start 1045: iree-amd-aie/aie_runtime/test/test_1114_aie_stream_switch_packet_switch_control_packets
195/200 Test #1045: iree-amd-aie/aie_runtime/test/test_1114_aie_stream_switch_packet_switch_control_packets ............   Passed    0.00 sec
        Start 1046: iree-amd-aie/aie_runtime/test/test_1114_aie_stream_switch_packet_switch_control_packets_lit_test
196/200 Test #1046: iree-amd-aie/aie_runtime/test/test_1114_aie_stream_switch_packet_switch_control_packets_lit_test ...   Passed    0.13 sec
        Start 1047: iree-amd-aie/aie_runtime/test/test_transaction
197/200 Test #1047: iree-amd-aie/aie_runtime/test/test_transaction .....................................................   Passed    0.00 sec
        Start 1048: iree-amd-aie/aie_runtime/test/test_transaction_lit_test
198/200 Test #1048: iree-amd-aie/aie_runtime/test/test_transaction_lit_test ............................................   Passed    0.11 sec
        Start 1049: iree-amd-aie/aie_runtime/test/AMSelGeneratorTest
199/200 Test #1049: iree-amd-aie/aie_runtime/test/AMSelGeneratorTest ...................................................   Passed    0.00 sec
        Start 1050: iree-amd-aie/aie_runtime/test/ControlPacketHeaderTest
200/200 Test #1050: iree-amd-aie/aie_runtime/test/ControlPacketHeaderTest ..............................................   Passed    0.00 sec

100% tests passed, 0 tests failed out of 200

Label Time Summary:
hostonly                                      =  48.66 sec*proc (175 tests)
iree-amd-aie/aie_runtime/Utils/test           =   0.01 sec*proc (3 tests)
iree-amd-aie/aie_runtime/test                 =   0.50 sec*proc (9 tests)
iree/target/amd-aie/IR/test                   =   0.49 sec*proc (4 tests)
iree/target/amd-aie/Target/test               =   4.58 sec*proc (16 tests)
iree/target/amd-aie/Test/OPT/failing_tests    =   1.35 sec*proc (2 tests)
iree/target/amd-aie/Test/samples              =  11.46 sec*proc (7 tests)
iree/target/amd-aie/Test/transform_dialect    =   0.89 sec*proc (5 tests)
iree/target/amd-aie/Transforms/test           =  22.68 sec*proc (89 tests)
iree/target/amd-aie/aie/test                  =  18.60 sec*proc (56 tests)
iree/target/amd-aie/aievec/test               =   1.47 sec*proc (9 tests)
test-type=lit-test                            =  61.95 sec*proc (187 tests)

Total Test time (real) =  62.32 sec
```