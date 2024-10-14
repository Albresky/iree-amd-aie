// Copyright 2024 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include "iree-amd-aie/IR/AMDAIEOps.h"
#include "iree-amd-aie/Transforms/AMDAIEUtils.h"
#include "iree-amd-aie/Transforms/Passes.h"
#include "mlir/Conversion/FuncToLLVM/ConvertFuncToLLVM.h"
#include "mlir/Conversion/FuncToLLVM/ConvertFuncToLLVMPass.h"
#include "mlir/Dialect/Linalg/IR/LinalgInterfaces.h"
#include "mlir/Dialect/Linalg/Transforms/Hoisting.h"
#include "mlir/Dialect/Linalg/Transforms/Transforms.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"

#define DEBUG_TYPE "iree-amdaie-function-outlining"

namespace mlir::iree_compiler::AMDAIE {

namespace {

class AMDAIEFunctionOutliningPass
    : public impl::AMDAIEFunctionOutliningBase<AMDAIEFunctionOutliningPass> {
 public:
  AMDAIEFunctionOutliningPass() = default;
  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<AMDAIEDialect, linalg::LinalgDialect, scf::SCFDialect,
                    vector::VectorDialect>();
  }

  void runOnOperation() override;
};

void AMDAIEFunctionOutliningPass::runOnOperation() {
  // mlir::FunctionOpInterface funcOp = getOperation();
  // // Block *parentFuncOpBlock = funcOp->getBlock();
  // ModuleOp moduleOp = funcOp->getParentOfType<ModuleOp>();
  ModuleOp moduleOp = getOperation();
  func::FuncOp funcOp;
  moduleOp.walk([&](func::FuncOp op) { funcOp = op; });
  MLIRContext *context = &getContext();
  IRRewriter rewriter(context);

  auto outlineToAFunction = [&](Operation *rootOp, std::string outlinedFuncName,
                                SmallVector<Value> &inputArgs) -> func::FuncOp {
    llvm::outs() << "Root op => " << (*rootOp) << "\n";
    llvm::outs().flush();
    if (auto outlinedFuncOp = dyn_cast_if_present<func::FuncOp>(
            moduleOp.lookupSymbol(outlinedFuncName)))
      return outlinedFuncOp;

    // Form outlined FunctionType.
    SmallVector<Type> inputTypes =
        llvm::map_to_vector(inputArgs, [](Value v) { return v.getType(); });
    auto outlinedFuncType =
        FunctionType::get(rewriter.getContext(), inputTypes, {});

    // Form outlined FuncSignature
    rewriter.setInsertionPointToStart(moduleOp.getBody());
    auto outlinedFunc = rewriter.create<func::FuncOp>(
        moduleOp.getLoc(), outlinedFuncName, outlinedFuncType);
    outlinedFunc.setPrivate();
    llvm::outs() << "Func signature = " << outlinedFunc << "\n";
    llvm::outs().flush();

    // Create an entry func block and map the original operands of the compute
    // op to the block arguments.
    Block *outlinedFuncBody = outlinedFunc.addEntryBlock();
    rewriter.setInsertionPointToStart(outlinedFuncBody);
    SmallVector<BlockArgument> outlinedFuncArgs =
        llvm::map_to_vector(outlinedFunc.getArguments(),
                            [&](BlockArgument bbArg) { return bbArg; });
    unsigned bbArgIndex = 0;
    IRMapping operandMap;
    for (Value origOperand : inputArgs) {
      operandMap.map(origOperand, outlinedFuncArgs[bbArgIndex++]);
    }
    // Find and clone the dependencies.
    for (Value operand : rootOp->getOperands()) {
      Operation *defOp = operand.getDefiningOp();
      if (isa_and_present<arith::ConstantOp>(defOp)) {
        llvm::outs() << "Found a constant\n";
        Value newOperand = rewriter.clone(*defOp, operandMap)->getResult(0);
        operandMap.map(operand, newOperand);
      }
    }
    rootOp->walk([&](Operation *innerOp) {
      for (Value operand : innerOp->getOperands()) {
        Operation *defOp = operand.getDefiningOp();
        if (isa_and_present<arith::ConstantOp>(defOp)) {
          llvm::outs() << "Found a constant\n";
          Value newOperand = rewriter.clone(*defOp, operandMap)->getResult(0);
          operandMap.map(operand, newOperand);
        }
      }
    });

    // Clone the compute op while mapping the operand to the function block
    // arguments.
    Operation *clonedRootOp = rewriter.clone(*rootOp, operandMap);

    // Create terminator op returning the cloned compute op's results.
    rewriter.setInsertionPointToEnd(outlinedFuncBody);
    // rewriter.create<func::ReturnOp>(clonedRootOp->getLoc(),
    //                                 clonedRootOp->getResult(0));
    rewriter.create<func::ReturnOp>(clonedRootOp->getLoc(), ValueRange({}));
    llvm::outs() << "OUTLINED :=>\n" << outlinedFunc << "\n\n";
    llvm::outs().flush();
    return outlinedFunc;
  };

  SmallVector<Operation *> toBeErased;
  funcOp.walk([&](AMDAIE::CoreOp coreOp) {
    coreOp.walk([&](vector::TransferWriteOp vectorTransferWriteOp) {
      Block *innerContainingBlock = vectorTransferWriteOp->getBlock();
      if (isa<AMDAIE::CoreOp>(vectorTransferWriteOp->getParentOp()))
        return WalkResult::advance();
      Operation *rootAncestorOp = vectorTransferWriteOp;
      // TODO(avarma): Use findAncestorOpInBlock.
      while (rootAncestorOp->getParentOp() != coreOp) {
        rootAncestorOp = rootAncestorOp->getParentOp();
      }
      SmallVector<Value> inputArgs;
      DenseSet<Value> inputArgsSet;
      std::string computeName = "elementwise";
      innerContainingBlock->walk([&](Operation *innerOps) {
        if (isa<vector::ContractionOp>(innerOps)) {
          computeName = "matmul";
        }
        for (Value val : innerOps->getOperands()) {
          // At this point in the IR the inputs to the computation would either
          // be AllocOp or Constants. The former is defined in the
          // `parentFuncOpBlock` and would be the actual input to the outlined
          // function. For constants, we can define them within the function
          // later when we create it.
          llvm::outs() << "Val = " << val << "\n";
          Operation *defOp = val.getDefiningOp();
          if (!defOp) {
            defOp = cast<BlockArgument>(val).getOwner()->getParentOp();
          }
          if (!coreOp->isAncestor(defOp) && !isa<arith::ConstantOp>(defOp)) {
            if (inputArgsSet.contains(val)) continue;
            inputArgs.push_back(val);
            inputArgsSet.insert(val);
          }
        }
      });
      std::string outlinedFuncName = computeName + "_outlined";
      // SmallVector<Value> inputArgs =
      //     llvm::map_to_vector(inputArgsSet, [&](Value val) { return val; });
      func::FuncOp outlinedFuncOp = outlineToAFunction(
          rootAncestorOp, outlinedFuncName, /*inputArgs=*/inputArgs);
      rewriter.setInsertionPoint(rootAncestorOp);
      rewriter.create<func::CallOp>(rootAncestorOp->getLoc(), outlinedFuncOp,
                                    inputArgs);
      // rewriter.replaceOp(vectorTransferWriteOp.getSource(),
      // callOp.getResults());
      toBeErased.push_back(rootAncestorOp);
      llvm::outs() << "========== DB ==========" << moduleOp << "\n\n";
      return WalkResult::advance();
    });
  });

  for (Operation *op : toBeErased) {
    op->dropAllUses();
    rewriter.eraseOp(op);
  }
}

}  // namespace

std::unique_ptr<Pass> createAMDAIEFunctionOutliningPass() {
  return std::make_unique<AMDAIEFunctionOutliningPass>();
}
}  // namespace mlir::iree_compiler::AMDAIE
