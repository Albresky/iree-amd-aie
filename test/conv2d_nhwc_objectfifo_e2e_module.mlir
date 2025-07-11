module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #hal.device.target<"xrt-lite", [#hal.executable.target<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>]> : !hal.device
  hal.executable private @conv_2d_nhwc_hwcf_dispatch_0 {
    hal.executable.variant public @amdaie_pdi_fb target(<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>) {
      hal.executable.export public @conv_2d_nhwc_hwcf_dispatch_0_conv_2d_nhwc_hwcf_2x12x12x64x3x3x32_i32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice 
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @conv_2d_nhwc_hwcf_dispatch_0_conv_2d_nhwc_hwcf_2x12x12x64x3x3x32_i32() {
          %c0_i32 = arith.constant 0 : i32
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<2x14x14x32xi32>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x3x32x64xi32>>
          %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<2x12x12x64xi32>>
          %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0, 0], sizes = [2, 14, 14, 32], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<2x14x14x32xi32>> -> tensor<2x14x14x32xi32>
          %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0, 0], sizes = [3, 3, 32, 64], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x3x32x64xi32>> -> tensor<3x3x32x64xi32>
          %5 = tensor.empty() : tensor<2x12x12x64xi32>
          %6 = linalg.fill ins(%c0_i32 : i32) outs(%5 : tensor<2x12x12x64xi32>) -> tensor<2x12x12x64xi32>
          %7 = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : vector<2xi64>, strides = dense<1> : vector<2xi64>} ins(%3, %4 : tensor<2x14x14x32xi32>, tensor<3x3x32x64xi32>) outs(%6 : tensor<2x12x12x64xi32>) -> tensor<2x12x12x64xi32>
          iree_tensor_ext.dispatch.tensor.store %7, %2, offsets = [0, 0, 0, 0], sizes = [2, 12, 12, 64], strides = [1, 1, 1, 1] : tensor<2x12x12x64xi32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<2x12x12x64xi32>>
          return
        }
      }
    }
  }
  util.func public @conv_2d_nhwc_hwcf(%arg0: !hal.buffer_view, %arg1: !hal.buffer_view) -> !hal.buffer_view attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @conv_2d_nhwc_hwcf(%input0: tensor<2x14x14x32xi32>, %input1: tensor<3x3x32x64xi32>) -> (%output0: tensor<2x12x12x64xi32>)"}} {
    %c0 = arith.constant 0 : index
    %c73728 = arith.constant 73728 : index
    %c50176 = arith.constant 50176 : index
    %c64 = arith.constant 64 : index
    %c3 = arith.constant 3 : index
    %c32 = arith.constant 32 : index
    %c14 = arith.constant 14 : index
    %c2 = arith.constant 2 : index
    %element_type_i32 = hal.element_type<i32> : i32
    %dense_row_major = hal.encoding_type<dense_row_major> : i32
    hal.buffer_view.assert<%arg0 : !hal.buffer_view> message("input0") shape([%c2, %c14, %c14, %c32]) type(%element_type_i32) encoding(%dense_row_major)
    %0 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg0 : !hal.buffer_view -> tensor<2x14x14x32xi32> in !stream.resource<external>{%c50176}
    hal.buffer_view.assert<%arg1 : !hal.buffer_view> message("input1") shape([%c3, %c3, %c32, %c64]) type(%element_type_i32) encoding(%dense_row_major)
    %1 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg1 : !hal.buffer_view -> tensor<3x3x32x64xi32> in !stream.resource<external>{%c73728}
    %result, %result_timepoint = stream.resource.alloca uninitialized on(#hal.device.affinity<@__device_0>) : !stream.resource<external>{%c73728} => !stream.timepoint
    %2 = stream.cmd.execute on(#hal.device.affinity<@__device_0>) await(%result_timepoint) => with(%0 as %arg2: !stream.resource<external>{%c50176}, %1 as %arg3: !stream.resource<external>{%c73728}, %result as %arg4: !stream.resource<external>{%c73728}) {
      stream.cmd.dispatch @conv_2d_nhwc_hwcf_dispatch_0::@amdaie_pdi_fb::@conv_2d_nhwc_hwcf_dispatch_0_conv_2d_nhwc_hwcf_2x12x12x64x3x3x32_i32 {
        ro %arg2[%c0 for %c50176] : !stream.resource<external>{%c50176},
        ro %arg3[%c0 for %c73728] : !stream.resource<external>{%c73728},
        wo %arg4[%c0 for %c73728] : !stream.resource<external>{%c73728}
      }
    } => !stream.timepoint
    %3 = stream.timepoint.await %2 => %result : !stream.resource<external>{%c73728}
    %4 = stream.tensor.export on(#hal.device.affinity<@__device_0>) %3 : tensor<2x12x12x64xi32> in !stream.resource<external>{%c73728} -> !hal.buffer_view
    util.return %4 : !hal.buffer_view
  }
  hal.executable private @conv_2d_nhwc_hwcf_q_dispatch_0 {
    hal.executable.variant public @amdaie_pdi_fb target(<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>) {
      hal.executable.export public @conv_2d_nhwc_hwcf_q_dispatch_0_conv_2d_nhwc_hwcf_2x12x12x64x3x3x32_i8xi8xi32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice 
        hal.return %x, %y, %z : index, index, index
      }
      builtin.module {
        func.func @conv_2d_nhwc_hwcf_q_dispatch_0_conv_2d_nhwc_hwcf_2x12x12x64x3x3x32_i8xi8xi32() {
          %c0_i32 = arith.constant 0 : i32
          %c0 = arith.constant 0 : index
          %0 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<2x14x14x32xi8>>
          %1 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%c0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x3x32x64xi8>>
          %2 = hal.interface.binding.subspan layout(<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(2) alignment(64) offset(%c0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<writeonly:tensor<2x12x12x64xi32>>
          %3 = iree_tensor_ext.dispatch.tensor.load %0, offsets = [0, 0, 0, 0], sizes = [2, 14, 14, 32], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<2x14x14x32xi8>> -> tensor<2x14x14x32xi8>
          %4 = iree_tensor_ext.dispatch.tensor.load %1, offsets = [0, 0, 0, 0], sizes = [3, 3, 32, 64], strides = [1, 1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<3x3x32x64xi8>> -> tensor<3x3x32x64xi8>
          %5 = tensor.empty() : tensor<2x12x12x64xi32>
          %6 = linalg.fill ins(%c0_i32 : i32) outs(%5 : tensor<2x12x12x64xi32>) -> tensor<2x12x12x64xi32>
          %7 = linalg.conv_2d_nhwc_hwcf {dilations = dense<1> : vector<2xi64>, strides = dense<1> : vector<2xi64>} ins(%3, %4 : tensor<2x14x14x32xi8>, tensor<3x3x32x64xi8>) outs(%6 : tensor<2x12x12x64xi32>) -> tensor<2x12x12x64xi32>
          iree_tensor_ext.dispatch.tensor.store %7, %2, offsets = [0, 0, 0, 0], sizes = [2, 12, 12, 64], strides = [1, 1, 1, 1] : tensor<2x12x12x64xi32> -> !iree_tensor_ext.dispatch.tensor<writeonly:tensor<2x12x12x64xi32>>
          return
        }
      }
    }
  }
  util.func public @conv_2d_nhwc_hwcf_q(%arg0: !hal.buffer_view, %arg1: !hal.buffer_view) -> !hal.buffer_view attributes {iree.abi.stub, iree.reflection = {iree.abi.declaration = "sync func @conv_2d_nhwc_hwcf_q(%input0: tensor<2x14x14x32xi8>, %input1: tensor<3x3x32x64xi8>) -> (%output0: tensor<2x12x12x64xi32>)"}} {
    %c0 = arith.constant 0 : index
    %c73728 = arith.constant 73728 : index
    %c18432 = arith.constant 18432 : index
    %c12544 = arith.constant 12544 : index
    %c64 = arith.constant 64 : index
    %c3 = arith.constant 3 : index
    %c32 = arith.constant 32 : index
    %c14 = arith.constant 14 : index
    %c2 = arith.constant 2 : index
    %element_type_i8 = hal.element_type<i8> : i32
    %dense_row_major = hal.encoding_type<dense_row_major> : i32
    hal.buffer_view.assert<%arg0 : !hal.buffer_view> message("input0") shape([%c2, %c14, %c14, %c32]) type(%element_type_i8) encoding(%dense_row_major)
    %0 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg0 : !hal.buffer_view -> tensor<2x14x14x32xi8> in !stream.resource<external>{%c12544}
    hal.buffer_view.assert<%arg1 : !hal.buffer_view> message("input1") shape([%c3, %c3, %c32, %c64]) type(%element_type_i8) encoding(%dense_row_major)
    %1 = stream.tensor.import on(#hal.device.affinity<@__device_0>) %arg1 : !hal.buffer_view -> tensor<3x3x32x64xi8> in !stream.resource<external>{%c18432}
    %result, %result_timepoint = stream.resource.alloca uninitialized on(#hal.device.affinity<@__device_0>) : !stream.resource<external>{%c73728} => !stream.timepoint
    %2 = stream.cmd.execute on(#hal.device.affinity<@__device_0>) await(%result_timepoint) => with(%0 as %arg2: !stream.resource<external>{%c12544}, %1 as %arg3: !stream.resource<external>{%c18432}, %result as %arg4: !stream.resource<external>{%c73728}) {
      stream.cmd.dispatch @conv_2d_nhwc_hwcf_q_dispatch_0::@amdaie_pdi_fb::@conv_2d_nhwc_hwcf_q_dispatch_0_conv_2d_nhwc_hwcf_2x12x12x64x3x3x32_i8xi8xi32 {
        ro %arg2[%c0 for %c12544] : !stream.resource<external>{%c12544},
        ro %arg3[%c0 for %c18432] : !stream.resource<external>{%c18432},
        wo %arg4[%c0 for %c73728] : !stream.resource<external>{%c73728}
      }
    } => !stream.timepoint
    %3 = stream.timepoint.await %2 => %result : !stream.resource<external>{%c73728}
    %4 = stream.tensor.export on(#hal.device.affinity<@__device_0>) %3 : tensor<2x12x12x64xi32> in !stream.resource<external>{%c73728} -> !hal.buffer_view
    util.return %4 : !hal.buffer_view
  }
}