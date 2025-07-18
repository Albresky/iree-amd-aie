# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

iree_cc_binary(
  NAME
    aie_cdo_gen_test
  SRCS
    aie_cdo_gen_test.cpp
  DEPS
    iree::target::amd-aie::aie::AIEDialectIR
    iree::target::amd-aie::Target::AIETargets
  TESTONLY
)

iree_cc_binary(
  NAME
    aie2xclbin_test
  SRCS
    aie2xclbin_test.cpp
  DEPS
    iree::target::amd-aie::aie::AIEDialectIR
    iree::target::amd-aie::Target::AIETargets
    iree::compiler::Dialect::HAL::IR::IR
    iree::compiler::Dialect::HAL::IR::HALDialect
  TESTONLY
)

iree_cc_binary(
  NAME
    aie_elf_files_gen_test
  SRCS
    aie_elf_files_gen_test.cpp
  DEPS
    iree::target::amd-aie::aie::AIEDialectIR
    iree::target::amd-aie::Target::Target
  TESTONLY
)

iree_cc_test(
  NAME
    AMDAIEXCLBinGenTest
  SRCS
    AMDAIEXCLBinGenTest.cpp
  DEPS
    gtest
    iree::target::amd-aie::Target::AIETargets
    iree::compiler::Dialect::HAL::IR::HALDialect
    iree::compiler::Dialect::HAL::IR::IR
)

file(GLOB _mlir_files *.mlir)

iree_lit_test_suite(
  NAME
    lit
  SRCS
    ${_mlir_files}
  TOOLS
    ${IREE_LLD_TARGET}
    ::aie_cdo_gen_test
    ::aie_elf_files_gen_test
    ::aie2xclbin_test
    FileCheck
    iree-compile
  LABELS
    "hostonly"
)
