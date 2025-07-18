// Copyright 2023 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include "air/Transform/Passes.h"

namespace {
#define GEN_PASS_REGISTRATION
#include "air/Transform/Passes.h.inc"
}  // namespace

namespace mlir::iree_compiler::AMDAIE {
void registerAIRTransformPasses() {
  registerAIRBroadcastDetection();
  registerAIRCollapseHerdPass();
  registerAIRDependency();
  registerAIRDependencyCanonicalize();
  registerAIRFuseAllocDealloc();
  registerAIRFuseChannels();
  registerAIRHerdPlacementPass();
  registerAIRHoistDmaInAccumPattern();
  registerAIRIsolateAsyncDmaLoopNests();
  registerAIRLabelScfForLoopInAIRSegmentPattern();
  registerAIRLabelScfForLoopForPingPongPattern();
  registerAIROptimizeMemtileDMABDs();
  registerAIRPingPongTransformationPattern();
  registerAIRRenumberDmaIdPass();
  registerAIRShrinkMemrefSizesByAccess();
  registerAIRSpecializeChannelWrapAndStridePattern();
  registerAIRSpecializeDmaBroadcast();
  registerAIRSplitL2MemrefForBufferConstraintPass();
  registerAIRUnrollLoopForPipeliningPattern();
  registerAIRUnrollOuterPerfectlyNestedLoopsPass();
  registerDmaToChannel();
}
}  // namespace mlir::iree_compiler::AMDAIE
