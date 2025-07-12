#!/bin/bash
#
# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set -eux -o errtrace

this_dir="$(cd $(dirname $0) && pwd)"
repo_root="$(cd $this_dir/.. && pwd)"
iree_dir="$(cd $repo_root/third_party/iree && pwd)"
build_dir="$repo_root/iree-build"
install_dir="$repo_root/iree-install"
mkdir -p "$build_dir"
build_dir="$(cd $build_dir && pwd)"
cache_dir="${cache_dir:-}"
llvm_install_dir="${llvm_install_dir:-}"
assertions="$1"
enable_ctest="$2"
build_type=RELEASE # Set to `Debug` to enable symbol debugging. Default for official is `Release`.


# Setup cache dir.
if [ -z "${cache_dir}" ]; then
  cache_dir="${repo_root}/.build-cache"
  mkdir -p "${cache_dir}"
  cache_dir="$(cd ${cache_dir} && pwd)"
fi
echo "Caching to ${cache_dir}"
mkdir -p "${cache_dir}/ccache"
mkdir -p "${cache_dir}/pip"

python="$(which python)"
echo "Using python: $python"

if [[ "$OSTYPE" == "linux"* ]]; then
  export CMAKE_TOOLCHAIN_FILE="$this_dir/linux_default_toolchain.cmake"
  export CC=clang
  export CXX=clang++
fi

export CCACHE_DIR="${cache_dir}/ccache"
export CCACHE_MAXSIZE="5G"
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_CXX_COMPILER_LAUNCHER=ccache
export CCACHE_SLOPPINESS=include_file_ctime,include_file_mtime,time_macros

# Clear ccache stats.
ccache -z

echo "Building IREE"
echo "============="
echo '{
    "version": 4,
    "cmakeMinimumRequired": {
      "major": 3,
      "minor": 23,
      "patch": 0
    },
    "include": [
        "build_tools/cmake/presets/all.json"
    ]
}' > $iree_dir/CMakeUserPresets.json

cd $iree_dir
CMAKE_ARGS=(
  -GNinja
  -DCMAKE_BUILD_TYPE=$build_type
  -DCMAKE_INSTALL_PREFIX="$install_dir"
  -DCMAKE_INSTALL_LIBDIR=lib
  -DCMAKE_OBJECT_PATH_MAX=4096

  -DENABLE_XRT_LITE_CTS_TESTS=ON

  -DIREE_ERROR_ON_MISSING_SUBMODULES=OFF
  -DIREE_ENABLE_ASSERTIONS=$assertions
  
  # HAL API tracing, defaults to OFF
  # This will show all the HAL APIs that have `IREE_TRACE_ZONE_BEGIN ... IREE_TRACE_ZONE_END`
  # that are hit during a run/execution (of, e.g., iree-run-module).
  -DIREE_ENABLE_RUNTIME_TRACING=ON
  -DIREE_TRACING_PROVIDER=console
  // optional but recommended
  -DIREE_TRACING_CONSOLE_FLUSH=1

  # Enable VM execution tracing, defaults to OFF
  # This will show all of the VM dispatches that actually occur during a run/execution. 
  # Note, this is roughly equivalent to passing `--compile-to=vm` to `iree-compile`.
  -DIREE_VM_EXECUTION_TRACING_ENABLE=1
  -DIREE_VM_EXECUTION_TRACING_FORCE_ENABLE=1
  // optional
  -DIREE_VM_EXECUTION_TRACING_SRC_LOC_ENABLE=1
  
  -DIREE_BUILD_SAMPLES=OFF
  -DIREE_BUILD_PYTHON_BINDINGS=ON
  -DIREE_BUILD_BINDINGS_TFLITE=OFF
  -DIREE_HAL_DRIVER_DEFAULTS=OFF
  -DIREE_HAL_DRIVER_LOCAL_SYNC=ON
  -DIREE_HAL_DRIVER_LOCAL_TASK=ON
  -DIREE_TARGET_BACKEND_DEFAULTS=OFF
  -DIREE_TARGET_BACKEND_LLVM_CPU=ON
  -DIREE_INPUT_TOSA=OFF
  -DIREE_INPUT_STABLEHLO=OFF
  -DIREE_INPUT_TORCH=ON
  -DIREE_CMAKE_PLUGIN_PATHS="$repo_root"
)

PEANO_INSTALL_DIR=${PEANO_INSTALL_DIR:-""}
if [ "$PEANO_INSTALL_DIR" != "" ] && [ -d "$PEANO_INSTALL_DIR" ]; then
  CMAKE_ARGS+=(-DPEANO_INSTALL_DIR="$PEANO_INSTALL_DIR")
fi
ENABLE_XRT_LITE_CTS_TESTS=${ENABLE_XRT_LITE_CTS_TESTS:-""}
if [ "$ENABLE_XRT_LITE_CTS_TESTS" != "" ]; then
  CMAKE_ARGS+=(-DENABLE_XRT_LITE_CTS_TESTS="$ENABLE_XRT_LITE_CTS_TESTS")
fi

if [ -d "$llvm_install_dir" ]; then
  CMAKE_ARGS+=(
    -DIREE_BUILD_BUNDLED_LLVM=OFF
    -DClang_DIR="$llvm_install_dir/lib/cmake/clang"
    -DLLD_DIR="$llvm_install_dir/lib/cmake/lld"
    -DMLIR_DIR="$llvm_install_dir/lib/cmake/mlir"
    -DLLVM_DIR="$llvm_install_dir/lib/cmake/llvm"
  )
fi

if [[ "$OSTYPE" == "linux"* ]]; then
  CMAKE_ARGS+=(
    -DCMAKE_EXE_LINKER_FLAGS_INIT="-fuse-ld=lld"
    -DCMAKE_SHARED_LINKER_FLAGS_INIT="-fuse-ld=lld"
    -DCMAKE_MODULE_LINKER_FLAGS_INIT="-fuse-ld=lld"
    -DCMAKE_C_COMPILER="${CC}"
    -DCMAKE_CXX_COMPILER="${CXX}"
    -DLLVM_TARGET_ARCH=X86
    -DLLVM_TARGETS_TO_BUILD=X86
    -DIREE_EXTERNAL_HAL_DRIVERS="xrt-lite"
    -S
    "$iree_dir"
    -B
    "$build_dir"
  )
elif [[ "$OSTYPE" == "darwin"* ]]; then
  CMAKE_ARGS+=(
    -DLLVM_TARGET_ARCH="X86;ARM"
    -DLLVM_TARGETS_TO_BUILD="X86;ARM"
    -S
    "$iree_dir"
    -B
    "$build_dir"
  )
fi

cmake "${CMAKE_ARGS[@]}" 2>&1 | tee "$build_dir/cmake.log"

echo "Building all"
echo "------------"
cmake --build "$build_dir" -- -k 0 2>&1 | tee "$build_dir/build.log"

echo "Installing"
echo "----------"
echo "Install to: $install_dir"
cmake --build "$build_dir" --target install 2>&1 | tee "$build_dir/install.log"
# TODO(max): there's no way to install the python runtime bindings
# ninja iree-install-dist install-IREECompilerPythonModules install-IREEDialectsPythonModules
cmake --build "$build_dir" --target iree-install-dist 2>&1 | tee "$build_dir/iree-install-dist.log"


if [[ "$enable_ctest" == "ON" ]]; then
  echo "CTest"
  echo "-----"
  if [[ "$OSTYPE" == "linux"* ]] && [[ "$assertions" == "ON" ]]; then
    ctest --test-dir "$build_dir" -R amd-aie -E "driver" --output-on-failure -j 2>&1 | tee "$build_dir/ctest_linux.log"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    ctest --test-dir "$build_dir" -R amd-aie -E "matmul_pack_peel_air_e2e|matmul_elementwise_pack_peel_air_e2e" --output-on-failure -j --repeat until-pass:5 2>&1 | tee "$build_dir/ctest_darwin.log"
  fi
else
  echo "Skipping CTest"
fi

if [ -d "$llvm_install_dir" ]; then
  echo "Copying LLVM tools($llvm_install_dir) to install directory($install_dir)"
  cp "$llvm_install_dir/bin/lld" "$install_dir/bin"
  cp "$llvm_install_dir/bin/FileCheck" "$install_dir/bin"
  cp "$llvm_install_dir/bin/not" "$install_dir/bin"
fi

cp "$build_dir/tools/testing/e2e/iree-e2e-matmul-test" "$install_dir/bin"
if [[ "$OSTYPE" == "linux"* ]]; then
  echo "Copying AMD-AIE CTS tests to install directory($install_dir)"
  mkdir -p "$install_dir/device_tests"
  cp "$build_dir"/runtime/plugins/AMD-AIE/iree-amd-aie/driver/xrt-lite/cts/*test "$install_dir/device_tests"
fi
