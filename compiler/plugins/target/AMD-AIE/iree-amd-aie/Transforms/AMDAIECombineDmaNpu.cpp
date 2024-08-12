// Copyright 2024 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the transformation that combines doubly strided operations
// in the same block if possible.
//
//===----------------------------------------------------------------------===//

#include "iree-amd-aie/IR/AMDAIEOps.h"
#include "iree-amd-aie/Transforms/AMDAIEDmaUtils.h"
#include "iree-amd-aie/Transforms/AMDAIEUtils.h"
#include "iree-amd-aie/Transforms/Passes.h"
#include "llvm/ADT/STLExtras.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#define DEBUG_TYPE "iree-amdaie-combine-strided-ops"

namespace mlir::iree_compiler::AMDAIE {

namespace {

// struct CombineDmaNpu
//     : public OpInterfaceRewritePattern<AMDAIE::DoublyStridedOpInterface> {
//   using OpInterfaceRewritePattern::OpInterfaceRewritePattern;

//   LogicalResult matchAndRewrite(AMDAIE::DoublyStridedOpInterface op,
//                                 PatternRewriter &rewriter) const override {
//     // Get the device model.
//     auto targetAttr = IREE::HAL::ExecutableTargetAttr::lookup(op);
//     std::optional<AMDAIEDevice> device = getConfigAMDAIEDevice(targetAttr);
//     if (!device)
//       return op.emitOpError()
//              << "No AMDAIEDevice found in the target attribute configuration";
//     AMDAIE::AMDAIEDeviceModel deviceModel =
//         AMDAIE::getDeviceModel(device.value());

//     Block *block = op->getBlock();
//     if (!block) return failure();

//     size_t sourceMaxNbDims{0};
//     size_t targetMaxNbDims{0};
//     SmallVector<Operation *> userOpsToBeErased;
//     AMDAIE::DoublyStridedOpInterface nextStridedOp;

//     if (auto npuDmaOp = dyn_cast<AMDAIE::NpuDmaCpyNdOp>(op.getOperation())) {
//       // Fail if any non-wait user operations.
//       SmallVector<AMDAIE::NpuDmaWaitOp> waitUserOps;
//       for (Operation *userOp : npuDmaOp->getUsers()) {
//         if (isa<AMDAIE::NpuDmaWaitOp>(userOp)) {
//           userOpsToBeErased.push_back(userOp);
//         } else {
//           return failure();
//         }
//       }

//       // Find next NPU DMA op.
//       Block::iterator begin = std::next(npuDmaOp->getIterator());
//       block->walk(begin, block->end(), [&](AMDAIE::NpuDmaCpyNdOp other) {
//         if (npuDmaOp.getDma() != other.getDma()) return WalkResult::advance();
//         Block *otherBlock = other->getBlock();
//         if (!otherBlock) return WalkResult::advance();
//         if (otherBlock != block) return WalkResult::interrupt();
//         nextStridedOp =
//             cast<AMDAIE::DoublyStridedOpInterface>(other.getOperation());
//         return WalkResult::interrupt();
//       });

//       uint8_t sourceMemspaceInt = npuDmaOp.getSourceMemorySpaceAsUInt();
//       uint8_t targetMemspaceInt = npuDmaOp.getTargetMemorySpaceAsUInt();
//       AMDAIE::DmaDimConfig dmaDimConfig(deviceModel, sourceMemspaceInt,
//                                         targetMemspaceInt);
//       sourceMaxNbDims = dmaDimConfig.sourceMaxNbDims;
//       targetMaxNbDims = dmaDimConfig.targetMaxNbDims;
//     } else {
//       return failure();
//     }

//     if (!nextStridedOp) return failure();

//     SmallVector<OpFoldResult> sourceOffsetsA = op.getSourceMixedOffsets();
//     SmallVector<OpFoldResult> sourceSizesA = op.getSourceMixedSizes();
//     SmallVector<OpFoldResult> sourceStridesA = op.getSourceMixedStrides();
//     SmallVector<OpFoldResult> sourceOffsetsB =
//         nextStridedOp.getSourceMixedOffsets();
//     SmallVector<OpFoldResult> sourceSizesB =
//         nextStridedOp.getSourceMixedSizes();
//     SmallVector<OpFoldResult> sourceStridesB =
//         nextStridedOp.getSourceMixedStrides();
//     bool areSourcesCombinable = areAccessPatternsCombinable(
//         sourceOffsetsA, sourceSizesA, sourceStridesA, sourceOffsetsB,
//         sourceSizesB, sourceStridesB, sourceMaxNbDims);

//     SmallVector<OpFoldResult> targetOffsetsA = op.getTargetMixedOffsets();
//     SmallVector<OpFoldResult> targetSizesA = op.getTargetMixedSizes();
//     SmallVector<OpFoldResult> targetStridesA = op.getTargetMixedStrides();
//     SmallVector<OpFoldResult> targetOffsetsB =
//         nextStridedOp.getTargetMixedOffsets();
//     SmallVector<OpFoldResult> targetSizesB =
//         nextStridedOp.getTargetMixedSizes();
//     SmallVector<OpFoldResult> targetStridesB =
//         nextStridedOp.getTargetMixedStrides();
//     bool areTargetsCombinable = areAccessPatternsCombinable(
//         targetOffsetsA, targetSizesA, targetStridesA, targetOffsetsB,
//         targetSizesB, targetStridesB, targetMaxNbDims);

//     if (areSourcesCombinable && areTargetsCombinable) {
//       SmallVector<OpFoldResult> newSourceOffsets;
//       SmallVector<OpFoldResult> newSourceSizes;
//       SmallVector<OpFoldResult> newSourceStrides;
//       if (failed(combineAccessPatterns(
//               rewriter, sourceOffsetsA, sourceSizesA, sourceStridesA,
//               sourceOffsetsB, sourceSizesB, sourceStridesB, newSourceOffsets,
//               newSourceSizes, newSourceStrides, sourceMaxNbDims))) {
//         return failure();
//       }

//       SmallVector<OpFoldResult> newTargetOffsets;
//       SmallVector<OpFoldResult> newTargetSizes;
//       SmallVector<OpFoldResult> newTargetStrides;
//       if (failed(combineAccessPatterns(
//               rewriter, targetOffsetsA, targetSizesA, targetStridesA,
//               targetOffsetsB, targetSizesB, targetStridesB, newTargetOffsets,
//               newTargetSizes, newTargetStrides, targetMaxNbDims))) {
//         return failure();
//       }

//       rewriter.setInsertionPoint(op);
//       auto newDoublyStridedOp = nextStridedOp.createDoublyStridedOp(
//           rewriter, newTargetOffsets, newTargetSizes, newTargetStrides,
//           newSourceOffsets, newSourceSizes, newSourceStrides);
//       rewriter.replaceOp(nextStridedOp, newDoublyStridedOp.getOperation());

//       for (Operation *userOp : userOpsToBeErased) rewriter.eraseOp(userOp);
//       rewriter.eraseOp(op);
//       return success();
//     }
//     return failure();
//   }
// };

class AMDAIECombineDmaNpuPass
    : public impl::AMDAIECombineDmaNpuBase<AMDAIECombineDmaNpuPass> {
 public:
  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<AMDAIEDialect>();
  }

  AMDAIECombineDmaNpuPass() = default;
  AMDAIECombineDmaNpuPass(const AMDAIECombineDmaNpuPass &pass){};
  void runOnOperation() override;
};

void AMDAIECombineDmaNpuPass::runOnOperation() {
  ModuleOp moduleOp = getOperation();
  MLIRContext *context = &getContext();
  IRRewriter rewriter(context);

  moduleOp.walk([&](AMDAIE::ControlCodeOp controlCodeOp) {
    DenseSet<AMDAIE::CircularDmaCpyNdOp> uniqueCircularDmaCpyNdOps;
    // Step 1. Capture all unique amdaie.circular_dma_cpy_nd ops being used within amdaie.controlcode.
    controlCodeOp.walk([&](AMDAIE::NpuDmaCpyNdOp npuDmaCpyNdOp) {
      uniqueCircularDmaCpyNdOps.insert(npuDmaCpyNdOp.getDmaCpyNdOp());
      return WalkResult::advance();
    });
    // Step 2. For each of those amdaie.circular_dma_cpy_nd ops fetch the unique source amdaie.logicalobjectfifo.from_memref ops.
    DenseSet<AMDAIE::LogicalObjectFifoFromMemrefOp> uniqueLogicalObjectFifoFromMemrefOps;
    for (AMDAIE::CircularDmaCpyNdOp circularDmaCpyNdOp : uniqueCircularDmaCpyNdOps) {
      uniqueLogicalObjectFifoFromMemrefOps.insert(circularDmaCpyNdOp.getSourceObjectFifo());
    }
    // Step 3.
    for (auto logicalObjectFifo : uniqueLogicalObjectFifoFromMemrefOps) {
      llvm::outs()<<logicalObjectFifo<<" (L3 -> L2):-\n";
      llvm::outs().flush();
      for (AMDAIE::CircularDmaCpyNdOp circularDmaCpyNdOp : uniqueCircularDmaCpyNdOps) {
        if (circularDmaCpyNdOp.getSourceObjectFifo() == logicalObjectFifo) {
          llvm::outs()<<"\t"<<circularDmaCpyNdOp<<"\n";
          llvm::outs().flush();
          // Get the target
        }
      }
    }
    return WalkResult::advance();
  });
  // Operation *parentOp = getOperation();
  // MLIRContext *context = &getContext();
  // RewritePatternSet patterns(context);
  // patterns.insert<CombineDmaNpu>(context);
  // if (failed(applyPatternsAndFoldGreedily(parentOp, std::move(patterns)))) {
  //   parentOp->emitOpError("failed to combine strided operations");
  //   return signalPassFailure();
  // }
}

}  // namespace

std::unique_ptr<Pass> createAMDAIECombineDmaNpuPass() {
  return std::make_unique<AMDAIECombineDmaNpuPass>();
}

}  // namespace mlir::iree_compiler::AMDAIE
