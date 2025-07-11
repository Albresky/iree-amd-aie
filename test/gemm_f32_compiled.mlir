module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #hal.device.target<"xrt-lite", [#hal.executable.target<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>]> : !hal.device
  hal.executable private @matmul_transpose_static_8x2048x2048_f32_dispatch_0 {
    hal.executable.variant public @amdaie_pdi_fb target(<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>) {
      hal.executable.export public @matmul_transpose_static_8x2048x2048_f32_dispatch_0_matmul_like_8x2048x2048_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice 
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @matmul_transpose_static_8x2048x2048_f32_dispatch_0_matmul_like_8x2048x2048_f32() {
          %cst = arith.constant 0.000000e+00 : f32
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8x2048xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<2048x2048xf32>>
          %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<8x2048xf32>>
          %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [8, 2048], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8x2048xf32>> -> tensor<8x2048xf32>
          %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [2048, 2048], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<2048x2048xf32>> -> tensor<2048x2048xf32>
          %5 = tensor.empty() : tensor<8x2048xf32>
          %6 = linalg.fill ins(%cst : f32) outs(%5 : tensor<8x2048xf32>) -> tensor<8x2048xf32>
          %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%3, %4 : tensor<8x2048xf32>, tensor<2048x2048xf32>) outs(%6 : tensor<8x2048xf32>) {
          ^bb0(%in: f32, %in_0: f32, %out: f32):
            %8 = arith.mulf %in, %in_0 : f32
            %9 = arith.addf %out, %8 : f32
            linalg.yield %9 : f32
          } -> tensor<8x2048xf32>
          iree_tensor_ext.dispatch.tensor.store %7, %2, offsets = [0, 0], sizes = [8, 2048], strides = [1, 1] : tensor<8x2048xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<8x2048xf32>>
          return
        }
      }
    }
  }
  util.func public @matmul_transpose_static_8x2048x2048_f32(%arg0: !hal.buffer_view, %arg1: !hal.buffer_view) -> !hal.buffer_view attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @matmul_transpose_static_8x2048x2048_f32(%input0: tensor<8x2048xf32>, %input1: tensor<2048x2048xf32>) -> (%output0: tensor<8x2048xf32>)"}} {
    %c0 = arith.constant 0 : index
    %c16777216 = arith.constant 16777216 : index
    %c65536 = arith.constant 65536 : index
    %c2048 = arith.constant 2048 : index
    %c8 = arith.constant 8 : index
    %element_type_f32 = hal.element_type<f32> : i32
    %dense_row_major = hal.encoding_type<dense_row_major> : i32
    hal.buffer_view.assert<%arg0 : !hal.buffer_view> message("input0") shape([%c8, %c2048]) type(%element_type_f32) encoding(%dense_row_major)
    %0 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg0 : !hal.buffer_view -> tensor<8x2048xf32> in !stream.resource<external>{%c65536}
    hal.buffer_view.assert<%arg1 : !hal.buffer_view> message("input1") shape([%c2048, %c2048]) type(%element_type_f32) encoding(%dense_row_major)
    %1 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg1 : !hal.buffer_view -> tensor<2048x2048xf32> in !stream.resource<external>{%c16777216}
    %result, %result_timepoint = stream.resource.alloca uninitialized on(#hal.device.affinity<@__device_0>) : !stream.resource<external>{%c65536} => !stream.timepoint
    %2 = stream.cmd.execute on(#hal.device.affinity<@__device_0>) await(%result_timepoint) => with(%0 as %arg2: !stream.resource<external>{%c65536}, %1 as %arg3: !stream.resource<external>{%c16777216}, %result as %arg4: !stream.resource<external>{%c65536}) {
      stream.cmd.dispatch @matmul_transpose_static_8x2048x2048_f32_dispatch_0::@amdaie_pdi_fb::@matmul_transpose_static_8x2048x2048_f32_dispatch_0_matmul_like_8x2048x2048_f32 {
        ro %arg2[%c0 for %c65536] : !stream.resource<external>{%c65536},
        ro %arg3[%c0 for %c16777216] : !stream.resource<external>{%c16777216},
        wo %arg4[%c0 for %c65536] : !stream.resource<external>{%c65536}
      }
    } => !stream.timepoint
    %3 = stream.timepoint.await %2 => %result : !stream.resource<external>{%c65536}
    %4 = stream.tensor.export on(#hal.device.affinity<@__device_0>) %3 : tensor<8x2048xf32> in !stream.resource<external>{%c65536} -> !hal.buffer_view
    util.return %4 : !hal.buffer_view
  }
  hal.executable private @matmul_transpose_static_8x2048x8192_f32_dispatch_0 {
    hal.executable.variant public @amdaie_pdi_fb target(<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>) {
      hal.executable.export public @matmul_transpose_static_8x2048x8192_f32_dispatch_0_matmul_like_8x2048x8192_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice 
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @matmul_transpose_static_8x2048x8192_f32_dispatch_0_matmul_like_8x2048x8192_f32() {
          %cst = arith.constant 0.000000e+00 : f32
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8x8192xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<2048x8192xf32>>
          %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<8x2048xf32>>
          %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [8, 8192], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8x8192xf32>> -> tensor<8x8192xf32>
          %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [2048, 8192], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<2048x8192xf32>> -> tensor<2048x8192xf32>
          %5 = tensor.empty() : tensor<8x2048xf32>
          %6 = linalg.fill ins(%cst : f32) outs(%5 : tensor<8x2048xf32>) -> tensor<8x2048xf32>
          %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%3, %4 : tensor<8x8192xf32>, tensor<2048x8192xf32>) outs(%6 : tensor<8x2048xf32>) {
          ^bb0(%in: f32, %in_0: f32, %out: f32):
            %8 = arith.mulf %in, %in_0 : f32
            %9 = arith.addf %out, %8 : f32
            linalg.yield %9 : f32
          } -> tensor<8x2048xf32>
          iree_tensor_ext.dispatch.tensor.store %7, %2, offsets = [0, 0], sizes = [8, 2048], strides = [1, 1] : tensor<8x2048xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<8x2048xf32>>
          return
        }
      }
    }
  }
  util.func public @matmul_transpose_static_8x2048x8192_f32(%arg0: !hal.buffer_view, %arg1: !hal.buffer_view) -> !hal.buffer_view attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @matmul_transpose_static_8x2048x8192_f32(%input0: tensor<8x8192xf32>, %input1: tensor<2048x8192xf32>) -> (%output0: tensor<8x2048xf32>)"}} {
    %c0 = arith.constant 0 : index
    %c65536 = arith.constant 65536 : index
    %c67108864 = arith.constant 67108864 : index
    %c262144 = arith.constant 262144 : index
    %c2048 = arith.constant 2048 : index
    %c8192 = arith.constant 8192 : index
    %c8 = arith.constant 8 : index
    %element_type_f32 = hal.element_type<f32> : i32
    %dense_row_major = hal.encoding_type<dense_row_major> : i32
    hal.buffer_view.assert<%arg0 : !hal.buffer_view> message("input0") shape([%c8, %c8192]) type(%element_type_f32) encoding(%dense_row_major)
    %0 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg0 : !hal.buffer_view -> tensor<8x8192xf32> in !stream.resource<external>{%c262144}
    hal.buffer_view.assert<%arg1 : !hal.buffer_view> message("input1") shape([%c2048, %c8192]) type(%element_type_f32) encoding(%dense_row_major)
    %1 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg1 : !hal.buffer_view -> tensor<2048x8192xf32> in !stream.resource<external>{%c67108864}
    %result, %result_timepoint = stream.resource.alloca uninitialized on(#hal.device.affinity<@__device_0>) : !stream.resource<external>{%c65536} => !stream.timepoint
    %2 = stream.cmd.execute on(#hal.device.affinity<@__device_0>) await(%result_timepoint) => with(%0 as %arg2: !stream.resource<external>{%c262144}, %1 as %arg3: !stream.resource<external>{%c67108864}, %result as %arg4: !stream.resource<external>{%c65536}) {
      stream.cmd.dispatch @matmul_transpose_static_8x2048x8192_f32_dispatch_0::@amdaie_pdi_fb::@matmul_transpose_static_8x2048x8192_f32_dispatch_0_matmul_like_8x2048x8192_f32 {
        ro %arg2[%c0 for %c262144] : !stream.resource<external>{%c262144},
        ro %arg3[%c0 for %c67108864] : !stream.resource<external>{%c67108864},
        wo %arg4[%c0 for %c65536] : !stream.resource<external>{%c65536}
      }
    } => !stream.timepoint
    %3 = stream.timepoint.await %2 => %result : !stream.resource<external>{%c65536}
    %4 = stream.tensor.export on(#hal.device.affinity<@__device_0>) %3 : tensor<8x2048xf32> in !stream.resource<external>{%c65536} -> !hal.buffer_view
    util.return %4 : !hal.buffer_view
  }
  hal.executable private @matmul_transpose_static_8x8192x2048_f32_dispatch_0 {
    hal.executable.variant public @amdaie_pdi_fb target(<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>) {
      hal.executable.export public @matmul_transpose_static_8x8192x2048_f32_dispatch_0_matmul_like_8x8192x2048_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice 
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @matmul_transpose_static_8x8192x2048_f32_dispatch_0_matmul_like_8x8192x2048_f32() {
          %cst = arith.constant 0.000000e+00 : f32
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8x2048xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8192x2048xf32>>
          %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<8x8192xf32>>
          %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [8, 2048], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8x2048xf32>> -> tensor<8x2048xf32>
          %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [8192, 2048], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8192x2048xf32>> -> tensor<8192x2048xf32>
          %5 = tensor.empty() : tensor<8x8192xf32>
          %6 = linalg.fill ins(%cst : f32) outs(%5 : tensor<8x8192xf32>) -> tensor<8x8192xf32>
          %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%3, %4 : tensor<8x2048xf32>, tensor<8192x2048xf32>) outs(%6 : tensor<8x8192xf32>) {
          ^bb0(%in: f32, %in_0: f32, %out: f32):
            %8 = arith.mulf %in, %in_0 : f32
            %9 = arith.addf %out, %8 : f32
            linalg.yield %9 : f32
          } -> tensor<8x8192xf32>
          iree_tensor_ext.dispatch.tensor.store %7, %2, offsets = [0, 0], sizes = [8, 8192], strides = [1, 1] : tensor<8x8192xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<8x8192xf32>>
          return
        }
      }
    }
  }
  util.func public @matmul_transpose_static_8x8192x2048_f32(%arg0: !hal.buffer_view, %arg1: !hal.buffer_view) -> !hal.buffer_view attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @matmul_transpose_static_8x8192x2048_f32(%input0: tensor<8x2048xf32>, %input1: tensor<8192x2048xf32>) -> (%output0: tensor<8x8192xf32>)"}} {
    %c0 = arith.constant 0 : index
    %c262144 = arith.constant 262144 : index
    %c67108864 = arith.constant 67108864 : index
    %c65536 = arith.constant 65536 : index
    %c8192 = arith.constant 8192 : index
    %c2048 = arith.constant 2048 : index
    %c8 = arith.constant 8 : index
    %element_type_f32 = hal.element_type<f32> : i32
    %dense_row_major = hal.encoding_type<dense_row_major> : i32
    hal.buffer_view.assert<%arg0 : !hal.buffer_view> message("input0") shape([%c8, %c2048]) type(%element_type_f32) encoding(%dense_row_major)
    %0 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg0 : !hal.buffer_view -> tensor<8x2048xf32> in !stream.resource<external>{%c65536}
    hal.buffer_view.assert<%arg1 : !hal.buffer_view> message("input1") shape([%c8192, %c2048]) type(%element_type_f32) encoding(%dense_row_major)
    %1 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg1 : !hal.buffer_view -> tensor<8192x2048xf32> in !stream.resource<external>{%c67108864}
    %result, %result_timepoint = stream.resource.alloca uninitialized on(#hal.device.affinity<@__device_0>) : !stream.resource<external>{%c262144} => !stream.timepoint
    %2 = stream.cmd.execute on(#hal.device.affinity<@__device_0>) await(%result_timepoint) => with(%0 as %arg2: !stream.resource<external>{%c65536}, %1 as %arg3: !stream.resource<external>{%c67108864}, %result as %arg4: !stream.resource<external>{%c262144}) {
      stream.cmd.dispatch @matmul_transpose_static_8x8192x2048_f32_dispatch_0::@amdaie_pdi_fb::@matmul_transpose_static_8x8192x2048_f32_dispatch_0_matmul_like_8x8192x2048_f32 {
        ro %arg2[%c0 for %c65536] : !stream.resource<external>{%c65536},
        ro %arg3[%c0 for %c67108864] : !stream.resource<external>{%c67108864},
        wo %arg4[%c0 for %c262144] : !stream.resource<external>{%c262144}
      }
    } => !stream.timepoint
    %3 = stream.timepoint.await %2 => %result : !stream.resource<external>{%c262144}
    %4 = stream.tensor.export on(#hal.device.affinity<@__device_0>) %3 : tensor<8x8192xf32> in !stream.resource<external>{%c262144} -> !hal.buffer_view
    util.return %4 : !hal.buffer_view
  }
  hal.executable private @matmul_transpose_static_8x50272x2048_f32_dispatch_0 {
    hal.executable.variant public @amdaie_pdi_fb target(<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>) {
      hal.executable.export public @matmul_transpose_static_8x50272x2048_f32_dispatch_0_matmul_like_8x50272x2048_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice 
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @matmul_transpose_static_8x50272x2048_f32_dispatch_0_matmul_like_8x50272x2048_f32() {
          %cst = arith.constant 0.000000e+00 : f32
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8x2048xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<50272x2048xf32>>
          %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<8x50272xf32>>
          %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0], sizes = [8, 2048], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<8x2048xf32>> -> tensor<8x2048xf32>
          %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0], sizes = [50272, 2048], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<50272x2048xf32>> -> tensor<50272x2048xf32>
          %5 = tensor.empty() : tensor<8x50272xf32>
          %6 = linalg.fill ins(%cst : f32) outs(%5 : tensor<8x50272xf32>) -> tensor<8x50272xf32>
          %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"]} ins(%3, %4 : tensor<8x2048xf32>, tensor<50272x2048xf32>) outs(%6 : tensor<8x50272xf32>) {
          ^bb0(%in: f32, %in_0: f32, %out: f32):
            %8 = arith.mulf %in, %in_0 : f32
            %9 = arith.addf %out, %8 : f32
            linalg.yield %9 : f32
          } -> tensor<8x50272xf32>
          iree_tensor_ext.dispatch.tensor.store %7, %2, offsets = [0, 0], sizes = [8, 50272], strides = [1, 1] : tensor<8x50272xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<8x50272xf32>>
          return
        }
      }
    }
  }
  util.func public @matmul_transpose_static_8x50272x2048_f32(%arg0: !hal.buffer_view, %arg1: !hal.buffer_view) -> !hal.buffer_view attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @matmul_transpose_static_8x50272x2048_f32(%input0: tensor<8x2048xf32>, %input1: tensor<50272x2048xf32>) -> (%output0: tensor<8x50272xf32>)"}} {
    %c0 = arith.constant 0 : index
    %c1608704 = arith.constant 1608704 : index
    %c411828224 = arith.constant 411828224 : index
    %c65536 = arith.constant 65536 : index
    %c50272 = arith.constant 50272 : index
    %c2048 = arith.constant 2048 : index
    %c8 = arith.constant 8 : index
    %element_type_f32 = hal.element_type<f32> : i32
    %dense_row_major = hal.encoding_type<dense_row_major> : i32
    hal.buffer_view.assert<%arg0 : !hal.buffer_view> message("input0") shape([%c8, %c2048]) type(%element_type_f32) encoding(%dense_row_major)
    %0 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg0 : !hal.buffer_view -> tensor<8x2048xf32> in !stream.resource<external>{%c65536}
    hal.buffer_view.assert<%arg1 : !hal.buffer_view> message("input1") shape([%c50272, %c2048]) type(%element_type_f32) encoding(%dense_row_major)
    %1 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg1 : !hal.buffer_view -> tensor<50272x2048xf32> in !stream.resource<external>{%c411828224}
    %result, %result_timepoint = stream.resource.alloca uninitialized on(#hal.device.affinity<@__device_0>) : !stream.resource<external>{%c1608704} => !stream.timepoint
    %2 = stream.cmd.execute on(#hal.device.affinity<@__device_0>) await(%result_timepoint) => with(%0 as %arg2: !stream.resource<external>{%c65536}, %1 as %arg3: !stream.resource<external>{%c411828224}, %result as %arg4: !stream.resource<external>{%c1608704}) {
      stream.cmd.dispatch @matmul_transpose_static_8x50272x2048_f32_dispatch_0::@amdaie_pdi_fb::@matmul_transpose_static_8x50272x2048_f32_dispatch_0_matmul_like_8x50272x2048_f32 {
        ro %arg2[%c0 for %c65536] : !stream.resource<external>{%c65536},
        ro %arg3[%c0 for %c411828224] : !stream.resource<external>{%c411828224},
        wo %arg4[%c0 for %c1608704] : !stream.resource<external>{%c1608704}
      }
    } => !stream.timepoint
    %3 = stream.timepoint.await %2 => %result : !stream.resource<external>{%c1608704}
    %4 = stream.tensor.export on(#hal.device.affinity<@__device_0>) %3 : tensor<8x50272xf32> in !stream.resource<external>{%c1608704} -> !hal.buffer_view
    util.return %4 : !hal.buffer_view
  }
  hal.executable private @batch_matmul_transpose_static_32x8x8x64_f32_dispatch_0 {
    hal.executable.variant public @amdaie_pdi_fb target(<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>) {
      hal.executable.export public @batch_matmul_transpose_static_32x8x8x64_f32_dispatch_0_matmul_like_32x8x8x64_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice 
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @batch_matmul_transpose_static_32x8x8x64_f32_dispatch_0_matmul_like_32x8x8x64_f32() {
          %cst = arith.constant 0.000000e+00 : f32
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x8x64xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x8x64xf32>>
          %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<32x8x8xf32>>
          %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [32, 8, 64], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x8x64xf32>> -> tensor<32x8x64xf32>
          %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0], sizes = [32, 8, 64], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x8x64xf32>> -> tensor<32x8x64xf32>
          %5 = tensor.empty() : tensor<32x8x8xf32>
          %6 = linalg.fill ins(%cst : f32) outs(%5 : tensor<32x8x8xf32>) -> tensor<32x8x8xf32>
          %7 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3) -> (d0, d1, d3)>, affine_map<(d0, d1, d2, d3) -> (d0, d2, d3)>, affine_map<(d0, d1, d2, d3) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%3, %4 : tensor<32x8x64xf32>, tensor<32x8x64xf32>) outs(%6 : tensor<32x8x8xf32>) {
          ^bb0(%in: f32, %in_0: f32, %out: f32):
            %8 = arith.mulf %in, %in_0 : f32
            %9 = arith.addf %out, %8 : f32
            linalg.yield %9 : f32
          } -> tensor<32x8x8xf32>
          iree_tensor_ext.dispatch.tensor.store %7, %2, offsets = [0, 0, 0], sizes = [32, 8, 8], strides = [1, 1, 1] : tensor<32x8x8xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<32x8x8xf32>>
          return
        }
      }
    }
  }
  util.func public @batch_matmul_transpose_static_32x8x8x64_f32(%arg0: !hal.buffer_view, %arg1: !hal.buffer_view) -> !hal.buffer_view attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @batch_matmul_transpose_static_32x8x8x64_f32(%input0: tensor<32x8x64xf32>, %input1: tensor<32x8x64xf32>) -> (%output0: tensor<32x8x8xf32>)"}} {
    %c0 = arith.constant 0 : index
    %c8192 = arith.constant 8192 : index
    %c65536 = arith.constant 65536 : index
    %c64 = arith.constant 64 : index
    %c8 = arith.constant 8 : index
    %c32 = arith.constant 32 : index
    %element_type_f32 = hal.element_type<f32> : i32
    %dense_row_major = hal.encoding_type<dense_row_major> : i32
    hal.buffer_view.assert<%arg0 : !hal.buffer_view> message("input0") shape([%c32, %c8, %c64]) type(%element_type_f32) encoding(%dense_row_major)
    %0 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg0 : !hal.buffer_view -> tensor<32x8x64xf32> in !stream.resource<external>{%c65536}
    hal.buffer_view.assert<%arg1 : !hal.buffer_view> message("input1") shape([%c32, %c8, %c64]) type(%element_type_f32) encoding(%dense_row_major)
    %1 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg1 : !hal.buffer_view -> tensor<32x8x64xf32> in !stream.resource<external>{%c65536}
    %result, %result_timepoint = stream.resource.alloca uninitialized on(#hal.device.affinity<@__device_0>) : !stream.resource<external>{%c8192} => !stream.timepoint
    %2 = stream.cmd.execute on(#hal.device.affinity<@__device_0>) await(%result_timepoint) => with(%0 as %arg2: !stream.resource<external>{%c65536}, %1 as %arg3: !stream.resource<external>{%c65536}, %result as %arg4: !stream.resource<external>{%c8192}) {
      stream.cmd.dispatch @batch_matmul_transpose_static_32x8x8x64_f32_dispatch_0::@amdaie_pdi_fb::@batch_matmul_transpose_static_32x8x8x64_f32_dispatch_0_matmul_like_32x8x8x64_f32 {
        ro %arg2[%c0 for %c65536] : !stream.resource<external>{%c65536},
        ro %arg3[%c0 for %c65536] : !stream.resource<external>{%c65536},
        wo %arg4[%c0 for %c8192] : !stream.resource<external>{%c8192}
      }
    } => !stream.timepoint
    %3 = stream.timepoint.await %2 => %result : !stream.resource<external>{%c8192}
    %4 = stream.tensor.export on(#hal.device.affinity<@__device_0>) %3 : tensor<32x8x8xf32> in !stream.resource<external>{%c8192} -> !hal.buffer_view
    util.return %4 : !hal.buffer_view
  }
  hal.executable private @batch_matmul_static_32x8x64x8_f32_dispatch_0 {
    hal.executable.variant public @amdaie_pdi_fb target(<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>) {
      hal.executable.export public @batch_matmul_static_32x8x64x8_f32_dispatch_0_batch_matmul_32x8x64x8_f32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice 
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @batch_matmul_static_32x8x64x8_f32_dispatch_0_batch_matmul_32x8x64x8_f32() {
          %cst = arith.constant 0.000000e+00 : f32
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x8x8xf32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x8x64xf32>>
          %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<32x8x64xf32>>
          %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0], sizes = [32, 8, 8], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x8x8xf32>> -> tensor<32x8x8xf32>
          %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0], sizes = [32, 8, 64], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<32x8x64xf32>> -> tensor<32x8x64xf32>
          %5 = tensor.empty() : tensor<32x8x64xf32>
          %6 = linalg.fill ins(%cst : f32) outs(%5 : tensor<32x8x64xf32>) -> tensor<32x8x64xf32>
          %7 = linalg.batch_matmul ins(%3, %4 : tensor<32x8x8xf32>, tensor<32x8x64xf32>) outs(%6 : tensor<32x8x64xf32>) -> tensor<32x8x64xf32>
          iree_tensor_ext.dispatch.tensor.store %7, %2, offsets = [0, 0, 0], sizes = [32, 8, 64], strides = [1, 1, 1] : tensor<32x8x64xf32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<32x8x64xf32>>
          return
        }
      }
    }
  }
  util.func public @batch_matmul_static_32x8x64x8_f32(%arg0: !hal.buffer_view, %arg1: !hal.buffer_view) -> !hal.buffer_view attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @batch_matmul_static_32x8x64x8_f32(%input0: tensor<32x8x8xf32>, %input1: tensor<32x8x64xf32>) -> (%output0: tensor<32x8x64xf32>)"}} {
    %c0 = arith.constant 0 : index
    %c65536 = arith.constant 65536 : index
    %c8192 = arith.constant 8192 : index
    %c64 = arith.constant 64 : index
    %c8 = arith.constant 8 : index
    %c32 = arith.constant 32 : index
    %element_type_f32 = hal.element_type<f32> : i32
    %dense_row_major = hal.encoding_type<dense_row_major> : i32
    hal.buffer_view.assert<%arg0 : !hal.buffer_view> message("input0") shape([%c32, %c8, %c8]) type(%element_type_f32) encoding(%dense_row_major)
    %0 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg0 : !hal.buffer_view -> tensor<32x8x8xf32> in !stream.resource<external>{%c8192}
    hal.buffer_view.assert<%arg1 : !hal.buffer_view> message("input1") shape([%c32, %c8, %c64]) type(%element_type_f32) encoding(%dense_row_major)
    %1 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg1 : !hal.buffer_view -> tensor<32x8x64xf32> in !stream.resource<external>{%c65536}
    %result, %result_timepoint = stream.resource.alloca uninitialized on(#hal.device.affinity<@__device_0>) : !stream.resource<external>{%c65536} => !stream.timepoint
    %2 = stream.cmd.execute on(#hal.device.affinity<@__device_0>) await(%result_timepoint) => with(%0 as %arg2: !stream.resource<external>{%c8192}, %1 as %arg3: !stream.resource<external>{%c65536}, %result as %arg4: !stream.resource<external>{%c65536}) {
      stream.cmd.dispatch @batch_matmul_static_32x8x64x8_f32_dispatch_0::@amdaie_pdi_fb::@batch_matmul_static_32x8x64x8_f32_dispatch_0_batch_matmul_32x8x64x8_f32 {
        ro %arg2[%c0 for %c8192] : !stream.resource<external>{%c8192},
        ro %arg3[%c0 for %c65536] : !stream.resource<external>{%c65536},
        wo %arg4[%c0 for %c65536] : !stream.resource<external>{%c65536}
      }
    } => !stream.timepoint
    %3 = stream.timepoint.await %2 => %result : !stream.resource<external>{%c65536}
    %4 = stream.tensor.export on(#hal.device.affinity<@__device_0>) %3 : tensor<32x8x64xf32> in !stream.resource<external>{%c65536} -> !hal.buffer_view
    util.return %4 : !hal.buffer_view
  }
}