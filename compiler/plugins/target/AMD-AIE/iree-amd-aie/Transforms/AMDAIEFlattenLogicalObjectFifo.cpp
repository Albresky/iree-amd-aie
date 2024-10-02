// Copyright 2024 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include "iree-amd-aie/IR/AMDAIEOps.h"
#include "iree-amd-aie/Transforms/Passes.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/Iterators.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"

#define DEBUG_TYPE "iree-amdaie-flatten-logicalobjectfifo"

namespace mlir::iree_compiler::AMDAIE {

namespace {

class AMDAIEFlattenLogicalObjectFifoPass
    : public impl::AMDAIEFlattenLogicalObjectFifoBase<
          AMDAIEFlattenLogicalObjectFifoPass> {
 public:
  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<AMDAIEDialect, memref::MemRefDialect>();
  }

  AMDAIEFlattenLogicalObjectFifoPass() = default;
  AMDAIEFlattenLogicalObjectFifoPass(
      const AMDAIEFlattenLogicalObjectFifoPass &pass){};
  void runOnOperation() override;
};

void AMDAIEFlattenLogicalObjectFifoPass::runOnOperation() {
  MLIRContext *context = &getContext();
  ModuleOp moduleOp = getOperation();
  IRRewriter rewriter(context);

  moduleOp->walk([&](AMDAIE::LogicalObjectFifoFromMemrefOp op) {
    // Get linearized size and new type.
    MemRefType oldType = op.getMemrefType();
    uint64_t linearizedSize = oldType.getNumElements();
    MemRefType newType =
        MemRefType::get(linearizedSize, oldType.getElementType(),
                        MemRefLayoutAttrInterface{}, oldType.getMemorySpace());

    rewriter.setInsertionPoint(op);
    auto newLogicalObjectFifo =
        rewriter.create<AMDAIE::LogicalObjectFifoFromMemrefOp>(
            rewriter.getUnknownLoc(), LogicalObjectFifoType::get(newType),
            op.getMemref(), op.getTiles());
    rewriter.replaceOp(op, newLogicalObjectFifo);

    // Replace the access op and insert `memref.reinterpret_cast` to get to the
    // original local shape as the objectfifo has a single type, while the DMA
    // operations converted into objectfifos can have a different source and
    // target type.
    for (Operation *user : newLogicalObjectFifo->getUsers()) {
      if (auto accessOp = dyn_cast<AMDAIE::LogicalObjectFifoAccessOp>(user)) {
        rewriter.setInsertionPoint(accessOp);
        auto newAccessOp = rewriter.create<AMDAIE::LogicalObjectFifoAccessOp>(
            rewriter.getUnknownLoc(), newLogicalObjectFifo.getOutput(),
            accessOp.getAccessType());

        auto [strides, baseOffset] = getStridesAndOffset(oldType);
        auto reinterpretOp = rewriter.create<memref::ReinterpretCastOp>(
            rewriter.getUnknownLoc(), oldType, newAccessOp.getOutput(),
            baseOffset, oldType.getShape(), strides);
        rewriter.replaceAllUsesWith(accessOp, reinterpretOp);
      }
    }
  });

  auto truncF = [](IRRewriter& rewriter, arith::TruncFOp &op) -> Value {
    // moduleOp->walk([&](arith::TruncFOp op) {
      // Get old type.
      OpBuilder::InsertionGuard g(rewriter);
      rewriter.setInsertionPoint(op);
      auto oldShapedType = cast<ShapedType>(op.getType());
      llvm::outs()<<"Old shape = "<<oldShapedType<<"\n";
      llvm::outs().flush();
      // Linearize the shape.
      int64_t linearizedSize = oldShapedType.getNumElements();
      // Input of arith.truncf.
      Value origInputOfTruncFOp = op.getIn();
      // Form new vector type for input and output.
      VectorType newVectorTypeForInput =
          VectorType::get({linearizedSize}, cast<ShapedType>(origInputOfTruncFOp.getType()).getElementType());
      VectorType newVectorTypeForOutput =
          VectorType::get({linearizedSize}, oldShapedType.getElementType());
      
      llvm::outs()<<"New input type = "<<newVectorTypeForInput<<"\n";
      Value newInputVector = rewriter.create<vector::ShapeCastOp>(
          op.getLoc(), newVectorTypeForInput, origInputOfTruncFOp);
      Value newTruncFOp = rewriter.create<arith::TruncFOp>(op.getLoc(), newVectorTypeForOutput, newInputVector);
      // Value newOutputVector = rewriter.create<vector::ShapeCastOp>(
      //     op.getLoc(), op.getType(), newTruncFOp);
      // rewriter.replaceOp(op, newOutputVector);
      return newTruncFOp;

      // llvm::outs()<<"New input vector = "<<newVector<<"\n";
    // });
  };

  moduleOp->walk([&](arith::MaximumFOp op) {
    // Get old type.
    OpBuilder::InsertionGuard g(rewriter);
    rewriter.setInsertionPoint(op);
    auto oldShapedType = cast<ShapedType>(op.getType());
    llvm::outs()<<"Old shape = "<<oldShapedType<<"\n";
    llvm::outs().flush();
    // Linearize the shape.
    int64_t linearizedSize = oldShapedType.getNumElements();
    // Input of arith.max.
    Value oldLhs = op.getLhs();
    Value oldRhs = op.getRhs();
    // Form Lhs/TruncF
    auto oldTruncFOp = cast<arith::TruncFOp>(oldLhs.getDefiningOp());
    Value newLhs = truncF(rewriter, oldTruncFOp);
    // Form Rhs.
    VectorType newVectorTypeForLhsAndRhs =
        VectorType::get({linearizedSize}, oldShapedType.getElementType());
    Value newRhs = rewriter.create<vector::ShapeCastOp>(
        op.getLoc(), newVectorTypeForLhsAndRhs, oldRhs);
    // Value origInputOfTruncFOp = op.getIn();
    
    Value newMaximumFOp = rewriter.create<arith::MaximumFOp>(op.getLoc(),
        newVectorTypeForLhsAndRhs, newLhs, newRhs);

    Value newOutputVector = rewriter.create<vector::ShapeCastOp>(
        op.getLoc(), op.getType(), newMaximumFOp);
    rewriter.replaceOp(op, newOutputVector);

    // llvm::outs()<<"New input vector = "<<newVector<<"\n";
  });

  // Erase old access operations.
  moduleOp->walk([&](AMDAIE::LogicalObjectFifoAccessOp accessOp) {
    if (accessOp->getUses().empty()) {
      rewriter.eraseOp(accessOp);
    }
  });
}

}  // namespace

std::unique_ptr<Pass> createAMDAIEFlattenLogicalObjectFifoPass() {
  return std::make_unique<AMDAIEFlattenLogicalObjectFifoPass>();
}
}  // namespace mlir::iree_compiler::AMDAIE
