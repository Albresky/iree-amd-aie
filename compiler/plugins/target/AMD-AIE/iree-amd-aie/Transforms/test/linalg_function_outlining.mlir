// RUN: iree-opt --split-input-file --iree-amdaie-linalg-function-outlining --verify-diagnostics --split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func private @generic_elementwise_0_outlined
// CHECK-SAME:  (%[[A:.*]]: memref<4x4xf32>,
// CHECK-SAME:   %[[B:.*]]: memref<4x4xbf16>) {
// CHECK:           linalg.generic
// CHECK-SAME:          ins(%[[A]] :
// CHECK-SAME:          outs(%[[B]] :
// CHECK:           return
// CHECK:        }
// CHECK-LABEL: func.func private @generic_matmul_0_outlined
// CHECK-SAME:  (%[[LHS:.*]]: memref<4x8xbf16>,
// CHECK-SAME:   %[[RHS:.*]]: memref<8x4xbf16>,
// CHECK-SAME:   %[[OUT:.*]]: memref<4x4xf32>) {
// CHECK:           linalg.generic
// CHECK-SAME:          ins(%[[LHS]], %[[RHS]] :
// CHECK-SAME:          outs(%[[OUT]] :
// CHECK:           return
// CHECK:        }
// CHECK-LABEL:  func.func @matmul_example
// CHECK-SAME:   (%[[A:.*]]: memref<4x8xbf16>,
// CHECK-SAME:    %[[B:.*]]: memref<8x4xbf16>,
// CHECK-SAME:    %[[C:.*]]: memref<4x4xf32>,
// CHECK-SAME:    %[[D:.*]]: memref<4x4xbf16>) {
// CHECK:            amdaie.core
// CHECK:               linalg.fill
// CHECK-NOT:           func.call @fill_elementwise
// CHECK:               linalg.copy
// CHECK-NOT:           func.call @copy_elementwise
// CHECK:               func.call @generic_matmul_0_outlined(%[[A]], %[[B]], %[[C]])
// CHECK-NOT:           linalg.generic
// CHECK:               amdaie.end
// CHECK:            }
// CHECK:            amdaie.core
// CHECK:               func.call @generic_matmul_0_outlined(%[[A]], %[[B]], %[[C]])
// CHECK-NOT:           linalg.generic
// CHECK:               amdaie.end
// CHECK:            }
// CHECK:            amdaie.core
// CHECK:               func.call @generic_matmul_0_outlined(%[[A]], %[[B]], %[[C]])
// CHECK-NOT:           linalg.generic
// CHECK:               func.call @generic_elementwise_0_outlined(%[[C]], %[[D]])
// CHECK-NOT:           linalg.generic
// CHECK:               amdaie.end
// CHECK:            }
// CHECK:            return
// CHECK:        }
func.func @matmul_example(%A: memref<4x8xbf16>, %B: memref<8x4xbf16>, %C: memref<4x4xf32>, %D: memref<4x4xbf16>) {
  %c2 = arith.constant 2 : index
  %c1 = arith.constant 1 : index
  %cst = arith.constant 0.0 : f32
  %tile = amdaie.tile(%c1, %c2)
  %0 = amdaie.core(%tile, in : [], out : []) {
    linalg.fill ins(%cst : f32) outs(%C : memref<4x4xf32>)
    linalg.copy ins(%C : memref<4x4xf32>) outs(%C : memref<4x4xf32>)
    linalg.generic {
      indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>,
                       affine_map<(d0, d1, d2) -> (d2, d1)>,
                       affine_map<(d0, d1, d2) -> (d0, d1)>
                      ],
      iterator_types = ["parallel", "parallel", "reduction"]
    } ins(%A, %B : memref<4x8xbf16>, memref<8x4xbf16>)
      outs(%C : memref<4x4xf32>) {
    ^bb0(%in: bf16, %in_17: bf16, %out: f32):
      %1 = arith.extf %in : bf16 to f32
      %2 = arith.extf %in_17 : bf16 to f32
      %3 = arith.mulf %1, %2 : f32
      %4 = arith.addf %out, %3 : f32
      linalg.yield %4  : f32
    }
    amdaie.end
  }
  %1 = amdaie.core(%tile, in : [], out : []) {
    linalg.generic {
      indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>,
                       affine_map<(d0, d1, d2) -> (d2, d1)>,
                       affine_map<(d0, d1, d2) -> (d0, d1)>
                      ],
      iterator_types = ["parallel", "parallel", "reduction"]
    } ins(%A, %B : memref<4x8xbf16>, memref<8x4xbf16>)
      outs(%C : memref<4x4xf32>) {
    ^bb0(%in: bf16, %in_17: bf16, %out: f32):
      %2 = arith.extf %in : bf16 to f32
      %3 = arith.extf %in_17 : bf16 to f32
      %4 = arith.mulf %2, %3 : f32
      %5 = arith.addf %out, %4 : f32
      linalg.yield %5  : f32
    }
    amdaie.end
  }
  %2 = amdaie.core(%tile, in : [], out : []) {
    linalg.generic {
      indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>,
                       affine_map<(d0, d1, d2) -> (d2, d1)>,
                       affine_map<(d0, d1, d2) -> (d0, d1)>
                      ],
      iterator_types = ["parallel", "parallel", "reduction"]
    } ins(%A, %B : memref<4x8xbf16>, memref<8x4xbf16>)
      outs(%C : memref<4x4xf32>) {
    ^bb0(%in: bf16, %in_17: bf16, %out: f32):
      %3 = arith.extf %in : bf16 to f32
      %4 = arith.extf %in_17 : bf16 to f32
      %5 = arith.mulf %3, %4 : f32
      %6 = arith.addf %out, %5 : f32
      linalg.yield %6  : f32
    }
    linalg.generic {
      indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0, d1)>],
      iterator_types = ["parallel","parallel"]
    } ins(%C : memref<4x4xf32>)
      outs(%D : memref<4x4xbf16>) {
    ^bb0(%in: f32, %out: bf16):
      %3 = arith.truncf %in : f32 to bf16
      linalg.yield %3 : bf16
    }
    amdaie.end
  }
  return
}

// -----

// CHECK-LABEL: @elemwise_example
// CHECK-NOT:     func.call
func.func @elemwise_example(%A: memref<4xf32>, %C: memref<4xbf16>, %B: memref<4xf32>) {
  %c2 = arith.constant 2 : index
  %c1 = arith.constant 1 : index
  %tile = amdaie.tile(%c1, %c2)
  %0 = amdaie.core(%tile, in : [], out : []) {
    linalg.generic {
      indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>],
      iterator_types = ["parallel"]
    } ins(%A : memref<4xf32>)
      outs(%C : memref<4xbf16>) {
    ^bb0(%in: f32, %out: bf16):
      %1 = arith.truncf %in : f32 to bf16
      linalg.yield %1 : bf16
    }
    amdaie.end
  }
  %2 = amdaie.core(%tile, in : [], out : []) {
    linalg.generic {
      indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>],
      iterator_types = ["parallel"]
    } ins(%B : memref<4xf32>)
      outs(%C : memref<4xbf16>) {
    ^bb0(%in: f32, %out: bf16):
      %3 = arith.truncf %in : f32 to bf16
      linalg.yield %3 : bf16
    }
    amdaie.end
  }
  %4 = amdaie.core(%tile, in : [], out : []) {
    linalg.generic {
      indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>],
      iterator_types = ["parallel"]
    } ins(%A : memref<4xf32>)
      outs(%C : memref<4xbf16>) {
    ^bb0(%in: f32, %out: bf16):
      %5 = arith.truncf %in : f32 to bf16
      %6 = arith.addf %5, %out : bf16
      linalg.yield %6 : bf16
    }
    amdaie.end
  }
  return
}

// -----

// CHECK-LABEL: @unsupported_linalg_op
// CHECK-NOT:     func.call
func.func @unsupported_linalg_op(%A: memref<4x8xbf16>, %B: memref<8x4xbf16>, %C: memref<4x4xf32>) {
  %c2 = arith.constant 2 : index
  %c1 = arith.constant 1 : index
  %tile = amdaie.tile(%c1, %c2)
  %1 = amdaie.core(%tile, in : [], out : []) {
    linalg.generic {
      indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>,
                       affine_map<(d0, d1, d2) -> (d2, d1)>,
                       affine_map<(d0, d1, d2) -> (d0, d1)>
                      ],
      iterator_types = ["parallel", "parallel", "reduction"]
    } ins(%A, %B : memref<4x8xbf16>, memref<8x4xbf16>)
      outs(%C : memref<4x4xf32>) {
    ^bb0(%in: bf16, %in_17: bf16, %out: f32):
      %1 = arith.extf %in : bf16 to f32
      %2 = arith.extf %in_17 : bf16 to f32
      %3 = arith.mulf %1, %2 : f32
      %4 = arith.addf %out, %3 : f32
      %5 = arith.addf %4, %4 : f32
      linalg.yield %5  : f32
    }
    amdaie.end
  }
  return
}
