// Copyright 2024 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include <filesystem>
#include <iostream>
#include <string>

#include "aie/AIEDialect.h"
#include "aie/AIEXDialect.h"
#include "aie/Passes.h"
#include "iree-amd-aie/Target/XCLBinGen.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"
#include "mlir/Parser/Parser.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Support/FileUtilities.h"

using namespace mlir;
using namespace mlir::iree_compiler::AMDAIE;
using namespace llvm;
using Path = std::filesystem::path;

// Command line options
static cl::OptionCategory aie2xclbinCategory("aie2xclbin options");

static cl::opt<std::string> inputFilename(cl::Positional,
                                          cl::desc("<input .mlir file>"),
                                          cl::Required,
                                          cl::cat(aie2xclbinCategory));

static cl::opt<std::string> outputFile("o",
                                       cl::desc("Output file path (XCLBin or PDI)"),
                                       cl::value_desc("filename"),
                                       cl::Required,
                                       cl::cat(aie2xclbinCategory));

static cl::opt<std::string> tempDir("temp-dir",
                                    cl::desc("Temporary directory for intermediate files"),
                                    cl::value_desc("directory"),
                                    cl::init("./temp"),
                                    cl::cat(aie2xclbinCategory));

static cl::opt<std::string> npuVersion("npu-version",
                                       cl::desc("NPU version (npu1, npu4)"),
                                       cl::value_desc("version"),
                                       cl::init("npu4"),
                                       cl::cat(aie2xclbinCategory));

static cl::opt<std::string> targetArch("target-arch",
                                       cl::desc("Target architecture"),
                                       cl::value_desc("arch"),
                                       cl::init("AIE2"),
                                       cl::cat(aie2xclbinCategory));

static cl::opt<std::string> peanoDir("peano-dir",
                                     cl::desc("Peano installation directory"),
                                     cl::value_desc("directory"),
                                     cl::init("/opt/xaiengine"),
                                     cl::cat(aie2xclbinCategory));

static cl::opt<std::string> vitisDir("vitis-dir",
                                     cl::desc("Vitis installation directory"),
                                     cl::value_desc("directory"),
                                     cl::cat(aie2xclbinCategory));

static cl::opt<std::string> amdaieInstallDir("amdaie-install-dir",
                                             cl::desc("AMD AIE installation directory"),
                                             cl::value_desc("directory"),
                                             cl::cat(aie2xclbinCategory));

static cl::opt<bool> useChess("use-chess",
                              cl::desc("Use Chess compiler instead of Peano"),
                              cl::init(false),
                              cl::cat(aie2xclbinCategory));

static cl::opt<bool> useChessForUKernel("use-chess-ukernel",
                                        cl::desc("Use Chess for microkernel compilation"),
                                        cl::init(false),
                                        cl::cat(aie2xclbinCategory));

static cl::opt<bool> verbose("v",
                             cl::desc("Enable verbose output"),
                             cl::init(false),
                             cl::cat(aie2xclbinCategory));

static cl::opt<bool> enableCtrlPkt("enable-ctrl-packet",
                                   cl::desc("Enable control packet generation"),
                                   cl::init(false),
                                   cl::cat(aie2xclbinCategory));

static cl::opt<std::string> deviceHalStr("device-hal",
                                         cl::desc("Device HAL (xrt, xrt_lite)"),
                                         cl::value_desc("hal"),
                                         cl::init("xrt"),
                                         cl::cat(aie2xclbinCategory));

static cl::opt<std::string> xclbinKernelId("xclbin-kernel-id",
                                          cl::desc("XCLBin kernel ID"),
                                          cl::value_desc("id"),
                                          cl::init("0x901"),
                                          cl::cat(aie2xclbinCategory));

static cl::opt<std::string> xclbinKernelName("xclbin-kernel-name",
                                            cl::desc("XCLBin kernel name"),
                                            cl::value_desc("name"),
                                            cl::init("MLIR_AIE"),
                                            cl::cat(aie2xclbinCategory));

static cl::opt<std::string> xclbinInstanceName("xclbin-instance-name",
                                              cl::desc("XCLBin instance name"),
                                              cl::value_desc("name"),
                                              cl::init("MLIR_AIE"),
                                              cl::cat(aie2xclbinCategory));

static cl::opt<std::string> inputXclbin("input-xclbin",
                                        cl::desc("Input XCLBin file to extend"),
                                        cl::value_desc("filename"),
                                        cl::cat(aie2xclbinCategory));

static cl::opt<std::string> ukernel("ukernel",
                                    cl::desc("Microkernel to include (mm, all)"),
                                    cl::value_desc("kernel"),
                                    cl::cat(aie2xclbinCategory));

static cl::opt<std::string> additionalPeanoOptFlags("additional-peano-opt-flags",
                                                    cl::desc("Additional Peano optimization flags"),
                                                    cl::value_desc("flags"),
                                                    cl::init(""),
                                                    cl::cat(aie2xclbinCategory));

static cl::opt<std::string> outputNpuInst("output-npu-instr",
                                          cl::desc("Output NPU instructions file"),
                                          cl::value_desc("filename"),
                                          cl::cat(aie2xclbinCategory));

static cl::opt<std::string> outputCtrlPktInst("output-ctrl-packet-instr",
                                              cl::desc("Output control packet instructions file"),
                                              cl::value_desc("filename"),
                                              cl::cat(aie2xclbinCategory));

static cl::opt<std::string> outputCtrlPktSeq("output-ctrl-packet-seq",
                                             cl::desc("Output control packet sequence file"),
                                             cl::value_desc("filename"),
                                             cl::cat(aie2xclbinCategory));

// Pass manager options
static cl::opt<bool> printIRBeforeAll("print-ir-before-all",
                                      cl::desc("Print IR before all passes"),
                                      cl::init(false),
                                      cl::cat(aie2xclbinCategory));

static cl::opt<bool> printIRAfterAll("print-ir-after-all",
                                     cl::desc("Print IR after all passes"),
                                     cl::init(false),
                                     cl::cat(aie2xclbinCategory));

static cl::opt<bool> printIRModuleScope("print-ir-module-scope",
                                        cl::desc("Print IR at module scope"),
                                        cl::init(false),
                                        cl::cat(aie2xclbinCategory));

static cl::opt<bool> timing("timing",
                            cl::desc("Enable pass timing"),
                            cl::init(false),
                            cl::cat(aie2xclbinCategory));

void registerDialects(DialectRegistry &registry) {
  registry.insert<xilinx::AIE::AIEDialect>();
  registry.insert<xilinx::AIEX::AIEXDialect>();
  registry.insert<func::FuncDialect>();
  registry.insert<scf::SCFDialect>();
  registry.insert<cf::ControlFlowDialect>();
  registry.insert<arith::ArithDialect>();
  registry.insert<mlir::vector::VectorDialect>();
  registry.insert<memref::MemRefDialect>();
  registry.insert<LLVM::LLVMDialect>();
}

int main(int argc, char **argv) {
  InitLLVM y(argc, argv);

  cl::HideUnrelatedOptions(aie2xclbinCategory);
  cl::ParseCommandLineOptions(argc, argv, 
    "aie2xclbin - Generate XCLBin or PDI files from AIE MLIR\n\n"
    "This tool converts AIE dialect MLIR files into executable formats:\n"
    "- XCLBin files for XRT runtime\n"
    "- PDI files for XRT-Lite runtime\n\n"
    "The tool performs the following steps:\n"
    "1. Lower AIE dialect to LLVM IR\n"
    "2. Compile cores using Chess or Peano\n"
    "3. Generate ELF files for each core\n"
    "4. Generate CDO (Configuration Data Object)\n"
    "5. Create PDI (Partial Device Image)\n"
    "6. Package into XCLBin (if using XRT HAL)\n");

  // Validate required directories exist
  if (!std::filesystem::exists(peanoDir)) {
    llvm::errs() << "Error: Peano directory does not exist: " << peanoDir << "\n";
    return 1;
  }

  if (!vitisDir.empty() && !std::filesystem::exists(vitisDir)) {
    llvm::errs() << "Error: Vitis directory does not exist: " << vitisDir << "\n";
    return 1;
  }

  // Create temp directory if it doesn't exist
  std::error_code ec;
  std::filesystem::create_directories(tempDir, ec);
  if (ec) {
    llvm::errs() << "Error: Failed to create temp directory: " << ec.message() << "\n";
    return 1;
  }

  // Parse device HAL
  AMDAIEOptions::DeviceHAL deviceHal;
  if (deviceHalStr == "xrt") {
    deviceHal = AMDAIEOptions::DeviceHAL::XRT;
  } else if (deviceHalStr == "xrt_lite") {
    deviceHal = AMDAIEOptions::DeviceHAL::XRT_LITE;
  } else {
    llvm::errs() << "Error: Invalid device HAL: " << deviceHalStr << "\n";
    llvm::errs() << "Valid options: xrt, xrt_lite\n";
    return 1;
  }

  // Validate control packet options
  if (enableCtrlPkt && (outputCtrlPktInst.empty() || outputCtrlPktSeq.empty())) {
    llvm::errs() << "Error: When --enable-ctrl-packet is used, both "
                 << "--output-ctrl-packet-instr and --output-ctrl-packet-seq must be specified\n";
    return 1;
  }

  // Setup MLIR context and parse input file
  DialectRegistry registry;
  registerDialects(registry);
  MLIRContext context(registry);

  if (!std::filesystem::exists(inputFilename)) {
    llvm::errs() << "Error: Input file does not exist: " << inputFilename << "\n";
    return 1;
  }

  mlir::ParserConfig parserConfig(&context);
  auto moduleOp = llvm::cast<ModuleOp>(
      mlir::parseSourceFile(inputFilename, parserConfig).release());

  if (!moduleOp) {
    llvm::errs() << "Error: Failed to parse input MLIR file\n";
    return 1;
  }

  // Find the AIE device operation
  auto deviceOps = moduleOp.getOps<xilinx::AIE::DeviceOp>();
  auto nDeviceOps = std::distance(deviceOps.begin(), deviceOps.end());
  if (nDeviceOps != 1) {
    llvm::errs() << "Error: Expected exactly one xilinx.aie.device op, found " 
                 << nDeviceOps << "\n";
    return 1;
  }
  auto deviceOp = *deviceOps.begin();

  // Run DMA to NPU pass
  PassManager pm(&context, xilinx::AIE::DeviceOp::getOperationName());
  pm.addPass(createAMDAIEDmaToNpuPass());
  if (failed(pm.run(deviceOp))) {
    llvm::errs() << "Error: Failed to run AMDAIEDmaToNpuPass\n";
    return 1;
  }

  // Prepare optional parameters
  std::optional<std::string> outputNpuInstOpt = 
      outputNpuInst.empty() ? std::nullopt : std::make_optional(outputNpuInst);
  std::optional<std::string> outputCtrlPktInstOpt = 
      outputCtrlPktInst.empty() ? std::nullopt : std::make_optional(outputCtrlPktInst);
  std::optional<std::string> outputCtrlPktSeqOpt = 
      outputCtrlPktSeq.empty() ? std::nullopt : std::make_optional(outputCtrlPktSeq);
  std::optional<std::string> vitisDirOpt = 
      vitisDir.empty() ? std::nullopt : std::make_optional(vitisDir);
  std::optional<std::string> inputXclbinOpt = 
      inputXclbin.empty() ? std::nullopt : std::make_optional(inputXclbin);
  std::optional<std::string> ukernelOpt = 
      ukernel.empty() ? std::nullopt : std::make_optional(ukernel);

  // Call the main aie2xclbin function
  std::vector<std::string> diagnostics;
  ScopedDiagnosticHandler handler(moduleOp.getContext(), [&](Diagnostic &d) {
    llvm::raw_string_ostream(diagnostics.emplace_back())
        << d.getLocation() << ": " << d;
  });

  if (verbose) {
    llvm::outs() << "Converting AIE MLIR to " 
                 << (deviceHal == AMDAIEOptions::DeviceHAL::XRT ? "XCLBin" : "PDI") 
                 << "...\n";
  }

  LogicalResult result = aie2xclbin(
      &context, deviceOp, outputNpuInstOpt, outputCtrlPktInstOpt, 
      outputCtrlPktSeqOpt, outputFile, printIRBeforeAll, printIRAfterAll,
      printIRModuleScope, timing, tempDir, useChess, useChessForUKernel,
      verbose, vitisDirOpt, targetArch, npuVersion, peanoDir, deviceHal,
      xclbinKernelId, xclbinKernelName, xclbinInstanceName, amdaieInstallDir,
      inputXclbinOpt, ukernelOpt, additionalPeanoOptFlags, enableCtrlPkt);

  if (failed(result)) {
    llvm::errs() << "Error: aie2xclbin failed\n";
    for (const auto &diagnostic : diagnostics) {
      llvm::errs() << diagnostic << "\n";
    }
    return 1;
  }

  if (verbose) {
    llvm::outs() << "Successfully generated: " << outputFile << "\n";
  }

  return 0;
}
