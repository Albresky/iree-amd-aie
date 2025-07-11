module attributes {stream.affinity.default = #hal.device.affinity<@__device_0>} {
  util.global private @__device_0 = #hal.device.target<"xrt-lite", [#hal.executable.target<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>]> : !hal.device
  hal.executable private @conv_2d_nhwc_hwcf_dispatch_0 {
    hal.executable.variant public @amdaie_pdi_fb target(<"amd-aie", "amdaie-pdi-fb", {num_cols = 4 : i32, num_rows = 4 : i32, target_device = "npu1_4col", ukernels = "none"}>) {
      hal.executable.export public @conv_2d_nhwc_hwcf_dispatch_0_conv_2d_nhwc_hwcf_2x12x12x64x3x3x32_i32 ordinal(0) layout(#hal.pipeline.layout<bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device) -> (index, index, index) {
        %c1 = arith.constant 1 : index
        %c1_0 = arith.constant 1 : index
        %c1_1 = arith.constant 1 : index
        hal.return %c1, %c1_0, %c1_1 : index, index, index
      } attributes {workgroup_size = [1 : index, 1 : index, 1 : index]}
      builtin.module {
        aie.device(npu1_4col) {
          memref.global "public" @shim_2 : memref<2x12x12x64xi32>
          %tile_0_2 = aie.tile(0, 2)
          %switchbox_0_2 = aie.switchbox(%tile_0_2) {
            aie.connect<SOUTH : 0, DMA : 0>
            aie.connect<SOUTH : 0, NORTH : 0>
            aie.connect<SOUTH : 5, DMA : 1>
            aie.connect<DMA : 0, SOUTH : 2>
            aie.connect<SOUTH : 4, NORTH : 2>
            aie.connect<NORTH : 0, SOUTH : 0>
            aie.connect<SOUTH : 2, NORTH : 5>
            aie.connect<NORTH : 2, SOUTH : 1>
            aie.connect<SOUTH : 1, NORTH : 4>
            aie.connect<NORTH : 1, SOUTH : 3>
          }
          %tile_0_5 = aie.tile(0, 5)
          %switchbox_0_5 = aie.switchbox(%tile_0_5) {
            aie.connect<SOUTH : 4, DMA : 0>
            aie.connect<SOUTH : 1, DMA : 1>
            aie.connect<DMA : 0, SOUTH : 0>
          }
          %tile_0_4 = aie.tile(0, 4)
          %switchbox_0_4 = aie.switchbox(%tile_0_4) {
            aie.connect<SOUTH : 4, DMA : 0>
            aie.connect<SOUTH : 4, NORTH : 4>
            aie.connect<SOUTH : 5, DMA : 1>
            aie.connect<DMA : 0, SOUTH : 0>
            aie.connect<SOUTH : 1, NORTH : 1>
            aie.connect<NORTH : 0, SOUTH : 2>
          }
          %tile_0_3 = aie.tile(0, 3)
          %switchbox_0_3 = aie.switchbox(%tile_0_3) {
            aie.connect<SOUTH : 0, DMA : 0>
            aie.connect<SOUTH : 0, NORTH : 4>
            aie.connect<SOUTH : 2, DMA : 1>
            aie.connect<DMA : 0, SOUTH : 0>
            aie.connect<SOUTH : 5, NORTH : 5>
            aie.connect<NORTH : 0, SOUTH : 2>
            aie.connect<SOUTH : 4, NORTH : 1>
            aie.connect<NORTH : 2, SOUTH : 1>
          }
          memref.global "public" @shim_1 : memref<3x3x32x64xi32>
          memref.global "public" @shim_0 : memref<2x14x14x32xi32>
          %tile_0_0 = aie.tile(0, 0)
          %shim_mux_0_0 = aie.shim_mux(%tile_0_0) {
            aie.connect<DMA : 0, NORTH : 3>
            aie.connect<DMA : 1, NORTH : 7>
            aie.connect<NORTH : 2, DMA : 0>
          }
          %tile_0_1 = aie.tile(0, 1)
          %switchbox_0_1 = aie.switchbox(%tile_0_1) {
            aie.connect<SOUTH : 4, DMA : 0>
            aie.connect<SOUTH : 1, DMA : 1>
            aie.connect<DMA : 0, NORTH : 0>
            aie.connect<DMA : 1, NORTH : 5>
            aie.connect<NORTH : 2, DMA : 2>
            aie.connect<DMA : 2, NORTH : 4>
            aie.connect<NORTH : 0, DMA : 3>
            aie.connect<DMA : 3, NORTH : 2>
            aie.connect<NORTH : 1, DMA : 4>
            aie.connect<DMA : 4, NORTH : 1>
            aie.connect<NORTH : 3, DMA : 5>
            aie.connect<DMA : 5, SOUTH : 1>
          }
          %buffer_0_1 = aie.buffer(%tile_0_1) {address = 0 : i32, sym_name = "buff_0"} : memref<1152xi32>
          %buffer_0_1_0 = aie.buffer(%tile_0_1) {address = 4608 : i32, sym_name = "buff_1"} : memref<1152xi32>
          %lock_0_1 = aie.lock(%tile_0_1, 4) {init = 8 : i8, sym_name = "lock_0"}
          %lock_0_1_1 = aie.lock(%tile_0_1, 5) {init = 0 : i8, sym_name = "lock_1"}
          %buffer_0_1_2 = aie.buffer(%tile_0_1) {address = 9216 : i32, sym_name = "buff_2"} : memref<1152xi32>
          %buffer_0_1_3 = aie.buffer(%tile_0_1) {address = 13824 : i32, sym_name = "buff_3"} : memref<1152xi32>
          %lock_0_1_4 = aie.lock(%tile_0_1, 2) {init = 2 : i8, sym_name = "lock_2"}
          %lock_0_1_5 = aie.lock(%tile_0_1, 3) {init = 0 : i8, sym_name = "lock_3"}
          %buffer_0_1_6 = aie.buffer(%tile_0_1) {address = 18432 : i32, sym_name = "buff_4"} : memref<64xi32>
          %buffer_0_1_7 = aie.buffer(%tile_0_1) {address = 18688 : i32, sym_name = "buff_5"} : memref<64xi32>
          %lock_0_1_8 = aie.lock(%tile_0_1, 0) {init = 8 : i8, sym_name = "lock_4"}
          %lock_0_1_9 = aie.lock(%tile_0_1, 1) {init = 0 : i8, sym_name = "lock_5"}
          aie.shim_dma_allocation @shim_0(MM2S, 0, 0)
          aie.shim_dma_allocation @shim_1(MM2S, 1, 0)
          %buffer_0_3 = aie.buffer(%tile_0_3) {address = 1024 : i32, sym_name = "buff_6"} : memref<576xi32>
          %buffer_0_3_10 = aie.buffer(%tile_0_3) {address = 3328 : i32, sym_name = "buff_7"} : memref<576xi32>
          %lock_0_3 = aie.lock(%tile_0_3, 4) {init = 2 : i8, sym_name = "lock_6"}
          %lock_0_3_11 = aie.lock(%tile_0_3, 5) {init = 0 : i8, sym_name = "lock_7"}
          %buffer_0_3_12 = aie.buffer(%tile_0_3) {address = 5632 : i32, sym_name = "buff_8"} : memref<1152xi32>
          %buffer_0_3_13 = aie.buffer(%tile_0_3) {address = 10240 : i32, sym_name = "buff_9"} : memref<1152xi32>
          %lock_0_3_14 = aie.lock(%tile_0_3, 2) {init = 2 : i8, sym_name = "lock_8"}
          %lock_0_3_15 = aie.lock(%tile_0_3, 3) {init = 0 : i8, sym_name = "lock_9"}
          %buffer_0_3_16 = aie.buffer(%tile_0_3) {address = 14848 : i32, sym_name = "buff_10"} : memref<16xi32>
          %0 = builtin.unrealized_conversion_cast %buffer_0_3_16 : memref<16xi32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
          %buffer_0_3_17 = aie.buffer(%tile_0_3) {address = 14912 : i32, sym_name = "buff_11"} : memref<16xi32>
          %1 = builtin.unrealized_conversion_cast %buffer_0_3_17 : memref<16xi32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
          %lock_0_3_18 = aie.lock(%tile_0_3, 0) {init = 2 : i8, sym_name = "lock_10"}
          %lock_0_3_19 = aie.lock(%tile_0_3, 1) {init = 0 : i8, sym_name = "lock_11"}
          %buffer_0_4 = aie.buffer(%tile_0_4) {address = 1024 : i32, sym_name = "buff_12"} : memref<576xi32>
          %buffer_0_4_20 = aie.buffer(%tile_0_4) {address = 3328 : i32, sym_name = "buff_13"} : memref<576xi32>
          %lock_0_4 = aie.lock(%tile_0_4, 4) {init = 2 : i8, sym_name = "lock_12"}
          %lock_0_4_21 = aie.lock(%tile_0_4, 5) {init = 0 : i8, sym_name = "lock_13"}
          %buffer_0_4_22 = aie.buffer(%tile_0_4) {address = 5632 : i32, sym_name = "buff_14"} : memref<1152xi32>
          %buffer_0_4_23 = aie.buffer(%tile_0_4) {address = 10240 : i32, sym_name = "buff_15"} : memref<1152xi32>
          %lock_0_4_24 = aie.lock(%tile_0_4, 2) {init = 2 : i8, sym_name = "lock_14"}
          %lock_0_4_25 = aie.lock(%tile_0_4, 3) {init = 0 : i8, sym_name = "lock_15"}
          %buffer_0_4_26 = aie.buffer(%tile_0_4) {address = 14848 : i32, sym_name = "buff_16"} : memref<16xi32>
          %2 = builtin.unrealized_conversion_cast %buffer_0_4_26 : memref<16xi32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
          %buffer_0_4_27 = aie.buffer(%tile_0_4) {address = 14912 : i32, sym_name = "buff_17"} : memref<16xi32>
          %3 = builtin.unrealized_conversion_cast %buffer_0_4_27 : memref<16xi32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
          %lock_0_4_28 = aie.lock(%tile_0_4, 0) {init = 2 : i8, sym_name = "lock_16"}
          %lock_0_4_29 = aie.lock(%tile_0_4, 1) {init = 0 : i8, sym_name = "lock_17"}
          %buffer_0_5 = aie.buffer(%tile_0_5) {address = 1024 : i32, sym_name = "buff_18"} : memref<576xi32>
          %buffer_0_5_30 = aie.buffer(%tile_0_5) {address = 3328 : i32, sym_name = "buff_19"} : memref<576xi32>
          %lock_0_5 = aie.lock(%tile_0_5, 4) {init = 2 : i8, sym_name = "lock_18"}
          %lock_0_5_31 = aie.lock(%tile_0_5, 5) {init = 0 : i8, sym_name = "lock_19"}
          %buffer_0_5_32 = aie.buffer(%tile_0_5) {address = 5632 : i32, sym_name = "buff_20"} : memref<1152xi32>
          %buffer_0_5_33 = aie.buffer(%tile_0_5) {address = 10240 : i32, sym_name = "buff_21"} : memref<1152xi32>
          %lock_0_5_34 = aie.lock(%tile_0_5, 2) {init = 2 : i8, sym_name = "lock_20"}
          %lock_0_5_35 = aie.lock(%tile_0_5, 3) {init = 0 : i8, sym_name = "lock_21"}
          %buffer_0_5_36 = aie.buffer(%tile_0_5) {address = 14848 : i32, sym_name = "buff_22"} : memref<16xi32>
          %4 = builtin.unrealized_conversion_cast %buffer_0_5_36 : memref<16xi32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
          %buffer_0_5_37 = aie.buffer(%tile_0_5) {address = 14912 : i32, sym_name = "buff_23"} : memref<16xi32>
          %5 = builtin.unrealized_conversion_cast %buffer_0_5_37 : memref<16xi32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
          %lock_0_5_38 = aie.lock(%tile_0_5, 0) {init = 2 : i8, sym_name = "lock_22"}
          %lock_0_5_39 = aie.lock(%tile_0_5, 1) {init = 0 : i8, sym_name = "lock_23"}
          %buffer_0_2 = aie.buffer(%tile_0_2) {address = 1024 : i32, sym_name = "buff_24"} : memref<576xi32>
          %buffer_0_2_40 = aie.buffer(%tile_0_2) {address = 3328 : i32, sym_name = "buff_25"} : memref<576xi32>
          %lock_0_2 = aie.lock(%tile_0_2, 4) {init = 2 : i8, sym_name = "lock_24"}
          %lock_0_2_41 = aie.lock(%tile_0_2, 5) {init = 0 : i8, sym_name = "lock_25"}
          %buffer_0_2_42 = aie.buffer(%tile_0_2) {address = 5632 : i32, sym_name = "buff_26"} : memref<1152xi32>
          %buffer_0_2_43 = aie.buffer(%tile_0_2) {address = 10240 : i32, sym_name = "buff_27"} : memref<1152xi32>
          %lock_0_2_44 = aie.lock(%tile_0_2, 2) {init = 2 : i8, sym_name = "lock_26"}
          %lock_0_2_45 = aie.lock(%tile_0_2, 3) {init = 0 : i8, sym_name = "lock_27"}
          %buffer_0_2_46 = aie.buffer(%tile_0_2) {address = 14848 : i32, sym_name = "buff_28"} : memref<16xi32>
          %6 = builtin.unrealized_conversion_cast %buffer_0_2_46 : memref<16xi32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
          %buffer_0_2_47 = aie.buffer(%tile_0_2) {address = 14912 : i32, sym_name = "buff_29"} : memref<16xi32>
          %7 = builtin.unrealized_conversion_cast %buffer_0_2_47 : memref<16xi32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
          %lock_0_2_48 = aie.lock(%tile_0_2, 0) {init = 2 : i8, sym_name = "lock_28"}
          %lock_0_2_49 = aie.lock(%tile_0_2, 1) {init = 0 : i8, sym_name = "lock_29"}
          %mem_0_2 = aie.mem(%tile_0_2) {
            %8 = aie.dma_start(S2MM, 0, ^bb1, ^bb3)
          ^bb1:  // 2 preds: ^bb0, ^bb2
            aie.use_lock(%lock_0_2_44, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_2_42 : memref<1152xi32>) {bd_id = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 9, stride = 128>, <size = 128, stride = 1>]>, len = 1152 : i32, next_bd_id = 1 : i32}
            aie.use_lock(%lock_0_2_45, Release, 1)
            aie.next_bd ^bb2
          ^bb2:  // pred: ^bb1
            aie.use_lock(%lock_0_2_44, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_2_43 : memref<1152xi32>) {bd_id = 1 : i32, dimensions = #aie<bd_dim_layout_array[<size = 9, stride = 128>, <size = 128, stride = 1>]>, len = 1152 : i32, next_bd_id = 0 : i32}
            aie.use_lock(%lock_0_2_45, Release, 1)
            aie.next_bd ^bb1
          ^bb3:  // pred: ^bb0
            %9 = aie.dma_start(S2MM, 1, ^bb4, ^bb6)
          ^bb4:  // 2 preds: ^bb3, ^bb5
            aie.use_lock(%lock_0_2, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_2 : memref<576xi32>) {bd_id = 2 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 192, stride = 1>]>, len = 576 : i32, next_bd_id = 3 : i32}
            aie.use_lock(%lock_0_2_41, Release, 1)
            aie.next_bd ^bb5
          ^bb5:  // pred: ^bb4
            aie.use_lock(%lock_0_2, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_2_40 : memref<576xi32>) {bd_id = 3 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 192, stride = 1>]>, len = 576 : i32, next_bd_id = 2 : i32}
            aie.use_lock(%lock_0_2_41, Release, 1)
            aie.next_bd ^bb4
          ^bb6:  // pred: ^bb3
            %10 = aie.dma_start(MM2S, 0, ^bb7, ^bb9)
          ^bb7:  // 2 preds: ^bb6, ^bb8
            aie.use_lock(%lock_0_2_49, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_2_46 : memref<16xi32>) {bd_id = 4 : i32, len = 16 : i32, next_bd_id = 5 : i32}
            aie.use_lock(%lock_0_2_48, Release, 1)
            aie.next_bd ^bb8
          ^bb8:  // pred: ^bb7
            aie.use_lock(%lock_0_2_49, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_2_47 : memref<16xi32>) {bd_id = 5 : i32, len = 16 : i32, next_bd_id = 4 : i32}
            aie.use_lock(%lock_0_2_48, Release, 1)
            aie.next_bd ^bb7
          ^bb9:  // pred: ^bb6
            aie.end
          }
          %mem_0_3 = aie.mem(%tile_0_3) {
            %8 = aie.dma_start(S2MM, 0, ^bb1, ^bb3)
          ^bb1:  // 2 preds: ^bb0, ^bb2
            aie.use_lock(%lock_0_3_14, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_3_12 : memref<1152xi32>) {bd_id = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 9, stride = 128>, <size = 128, stride = 1>]>, len = 1152 : i32, next_bd_id = 1 : i32}
            aie.use_lock(%lock_0_3_15, Release, 1)
            aie.next_bd ^bb2
          ^bb2:  // pred: ^bb1
            aie.use_lock(%lock_0_3_14, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_3_13 : memref<1152xi32>) {bd_id = 1 : i32, dimensions = #aie<bd_dim_layout_array[<size = 9, stride = 128>, <size = 128, stride = 1>]>, len = 1152 : i32, next_bd_id = 0 : i32}
            aie.use_lock(%lock_0_3_15, Release, 1)
            aie.next_bd ^bb1
          ^bb3:  // pred: ^bb0
            %9 = aie.dma_start(S2MM, 1, ^bb4, ^bb6)
          ^bb4:  // 2 preds: ^bb3, ^bb5
            aie.use_lock(%lock_0_3, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_3 : memref<576xi32>) {bd_id = 2 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 192, stride = 1>]>, len = 576 : i32, next_bd_id = 3 : i32}
            aie.use_lock(%lock_0_3_11, Release, 1)
            aie.next_bd ^bb5
          ^bb5:  // pred: ^bb4
            aie.use_lock(%lock_0_3, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_3_10 : memref<576xi32>) {bd_id = 3 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 192, stride = 1>]>, len = 576 : i32, next_bd_id = 2 : i32}
            aie.use_lock(%lock_0_3_11, Release, 1)
            aie.next_bd ^bb4
          ^bb6:  // pred: ^bb3
            %10 = aie.dma_start(MM2S, 0, ^bb7, ^bb9)
          ^bb7:  // 2 preds: ^bb6, ^bb8
            aie.use_lock(%lock_0_3_19, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_3_16 : memref<16xi32>) {bd_id = 4 : i32, len = 16 : i32, next_bd_id = 5 : i32}
            aie.use_lock(%lock_0_3_18, Release, 1)
            aie.next_bd ^bb8
          ^bb8:  // pred: ^bb7
            aie.use_lock(%lock_0_3_19, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_3_17 : memref<16xi32>) {bd_id = 5 : i32, len = 16 : i32, next_bd_id = 4 : i32}
            aie.use_lock(%lock_0_3_18, Release, 1)
            aie.next_bd ^bb7
          ^bb9:  // pred: ^bb6
            aie.end
          }
          %mem_0_4 = aie.mem(%tile_0_4) {
            %8 = aie.dma_start(S2MM, 0, ^bb1, ^bb3)
          ^bb1:  // 2 preds: ^bb0, ^bb2
            aie.use_lock(%lock_0_4_24, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_4_22 : memref<1152xi32>) {bd_id = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 9, stride = 128>, <size = 128, stride = 1>]>, len = 1152 : i32, next_bd_id = 1 : i32}
            aie.use_lock(%lock_0_4_25, Release, 1)
            aie.next_bd ^bb2
          ^bb2:  // pred: ^bb1
            aie.use_lock(%lock_0_4_24, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_4_23 : memref<1152xi32>) {bd_id = 1 : i32, dimensions = #aie<bd_dim_layout_array[<size = 9, stride = 128>, <size = 128, stride = 1>]>, len = 1152 : i32, next_bd_id = 0 : i32}
            aie.use_lock(%lock_0_4_25, Release, 1)
            aie.next_bd ^bb1
          ^bb3:  // pred: ^bb0
            %9 = aie.dma_start(S2MM, 1, ^bb4, ^bb6)
          ^bb4:  // 2 preds: ^bb3, ^bb5
            aie.use_lock(%lock_0_4, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_4 : memref<576xi32>) {bd_id = 2 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 192, stride = 1>]>, len = 576 : i32, next_bd_id = 3 : i32}
            aie.use_lock(%lock_0_4_21, Release, 1)
            aie.next_bd ^bb5
          ^bb5:  // pred: ^bb4
            aie.use_lock(%lock_0_4, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_4_20 : memref<576xi32>) {bd_id = 3 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 192, stride = 1>]>, len = 576 : i32, next_bd_id = 2 : i32}
            aie.use_lock(%lock_0_4_21, Release, 1)
            aie.next_bd ^bb4
          ^bb6:  // pred: ^bb3
            %10 = aie.dma_start(MM2S, 0, ^bb7, ^bb9)
          ^bb7:  // 2 preds: ^bb6, ^bb8
            aie.use_lock(%lock_0_4_29, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_4_26 : memref<16xi32>) {bd_id = 4 : i32, len = 16 : i32, next_bd_id = 5 : i32}
            aie.use_lock(%lock_0_4_28, Release, 1)
            aie.next_bd ^bb8
          ^bb8:  // pred: ^bb7
            aie.use_lock(%lock_0_4_29, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_4_27 : memref<16xi32>) {bd_id = 5 : i32, len = 16 : i32, next_bd_id = 4 : i32}
            aie.use_lock(%lock_0_4_28, Release, 1)
            aie.next_bd ^bb7
          ^bb9:  // pred: ^bb6
            aie.end
          }
          %mem_0_5 = aie.mem(%tile_0_5) {
            %8 = aie.dma_start(S2MM, 0, ^bb1, ^bb3)
          ^bb1:  // 2 preds: ^bb0, ^bb2
            aie.use_lock(%lock_0_5_34, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_5_32 : memref<1152xi32>) {bd_id = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 9, stride = 128>, <size = 128, stride = 1>]>, len = 1152 : i32, next_bd_id = 1 : i32}
            aie.use_lock(%lock_0_5_35, Release, 1)
            aie.next_bd ^bb2
          ^bb2:  // pred: ^bb1
            aie.use_lock(%lock_0_5_34, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_5_33 : memref<1152xi32>) {bd_id = 1 : i32, dimensions = #aie<bd_dim_layout_array[<size = 9, stride = 128>, <size = 128, stride = 1>]>, len = 1152 : i32, next_bd_id = 0 : i32}
            aie.use_lock(%lock_0_5_35, Release, 1)
            aie.next_bd ^bb1
          ^bb3:  // pred: ^bb0
            %9 = aie.dma_start(S2MM, 1, ^bb4, ^bb6)
          ^bb4:  // 2 preds: ^bb3, ^bb5
            aie.use_lock(%lock_0_5, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_5 : memref<576xi32>) {bd_id = 2 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 192, stride = 1>]>, len = 576 : i32, next_bd_id = 3 : i32}
            aie.use_lock(%lock_0_5_31, Release, 1)
            aie.next_bd ^bb5
          ^bb5:  // pred: ^bb4
            aie.use_lock(%lock_0_5, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_5_30 : memref<576xi32>) {bd_id = 3 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 192, stride = 1>]>, len = 576 : i32, next_bd_id = 2 : i32}
            aie.use_lock(%lock_0_5_31, Release, 1)
            aie.next_bd ^bb4
          ^bb6:  // pred: ^bb3
            %10 = aie.dma_start(MM2S, 0, ^bb7, ^bb9)
          ^bb7:  // 2 preds: ^bb6, ^bb8
            aie.use_lock(%lock_0_5_39, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_5_36 : memref<16xi32>) {bd_id = 4 : i32, len = 16 : i32, next_bd_id = 5 : i32}
            aie.use_lock(%lock_0_5_38, Release, 1)
            aie.next_bd ^bb8
          ^bb8:  // pred: ^bb7
            aie.use_lock(%lock_0_5_39, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_5_37 : memref<16xi32>) {bd_id = 5 : i32, len = 16 : i32, next_bd_id = 4 : i32}
            aie.use_lock(%lock_0_5_38, Release, 1)
            aie.next_bd ^bb7
          ^bb9:  // pred: ^bb6
            aie.end
          }
          %memtile_dma_0_1 = aie.memtile_dma(%tile_0_1) {
            %8 = aie.dma_start(S2MM, 0, ^bb1, ^bb3)
          ^bb1:  // 2 preds: ^bb0, ^bb2
            aie.use_lock(%lock_0_1, AcquireGreaterEqual, 4)
            aie.dma_bd(%buffer_0_1 : memref<1152xi32>) {bd_id = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 6, stride = 192>, <size = 192, stride = 1>]>, len = 1152 : i32, next_bd_id = 1 : i32}
            aie.use_lock(%lock_0_1_1, Release, 4)
            aie.next_bd ^bb2
          ^bb2:  // pred: ^bb1
            aie.use_lock(%lock_0_1, AcquireGreaterEqual, 4)
            aie.dma_bd(%buffer_0_1_0 : memref<1152xi32>) {bd_id = 1 : i32, dimensions = #aie<bd_dim_layout_array[<size = 6, stride = 192>, <size = 192, stride = 1>]>, len = 1152 : i32, next_bd_id = 0 : i32}
            aie.use_lock(%lock_0_1_1, Release, 4)
            aie.next_bd ^bb1
          ^bb3:  // pred: ^bb0
            %9 = aie.dma_start(S2MM, 1, ^bb4, ^bb6)
          ^bb4:  // 2 preds: ^bb3, ^bb5
            aie.use_lock(%lock_0_1_4, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_2 : memref<1152xi32>) {bd_id = 24 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 384>, <size = 384, stride = 1>]>, len = 1152 : i32, next_bd_id = 25 : i32}
            aie.use_lock(%lock_0_1_5, Release, 1)
            aie.next_bd ^bb5
          ^bb5:  // pred: ^bb4
            aie.use_lock(%lock_0_1_4, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_3 : memref<1152xi32>) {bd_id = 25 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 384>, <size = 384, stride = 1>]>, len = 1152 : i32, next_bd_id = 24 : i32}
            aie.use_lock(%lock_0_1_5, Release, 1)
            aie.next_bd ^bb4
          ^bb6:  // pred: ^bb3
            %10 = aie.dma_start(MM2S, 0, ^bb7, ^bb9)
          ^bb7:  // 2 preds: ^bb6, ^bb8
            aie.use_lock(%lock_0_1_5, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_2 : memref<1152xi32>) {bd_id = 2 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 384>, <size = 384, stride = 1>]>, len = 1152 : i32, next_bd_id = 3 : i32}
            aie.use_lock(%lock_0_1_4, Release, 1)
            aie.next_bd ^bb8
          ^bb8:  // pred: ^bb7
            aie.use_lock(%lock_0_1_5, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_3 : memref<1152xi32>) {bd_id = 3 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 384>, <size = 384, stride = 1>]>, len = 1152 : i32, next_bd_id = 2 : i32}
            aie.use_lock(%lock_0_1_4, Release, 1)
            aie.next_bd ^bb7
          ^bb9:  // pred: ^bb6
            %11 = aie.dma_start(MM2S, 1, ^bb10, ^bb12)
          ^bb10:  // 2 preds: ^bb9, ^bb11
            aie.use_lock(%lock_0_1_1, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1 : memref<1152xi32>) {bd_id = 26 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 4, stride = 8>, <size = 6, stride = 32>, <size = 8, stride = 1>]>, len = 576 : i32, next_bd_id = 27 : i32}
            aie.use_lock(%lock_0_1, Release, 1)
            aie.next_bd ^bb11
          ^bb11:  // pred: ^bb10
            aie.use_lock(%lock_0_1_1, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_0 : memref<1152xi32>) {bd_id = 27 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 4, stride = 8>, <size = 6, stride = 32>, <size = 8, stride = 1>]>, len = 576 : i32, next_bd_id = 26 : i32}
            aie.use_lock(%lock_0_1, Release, 1)
            aie.next_bd ^bb10
          ^bb12:  // pred: ^bb9
            %12 = aie.dma_start(S2MM, 2, ^bb13, ^bb15)
          ^bb13:  // 2 preds: ^bb12, ^bb14
            aie.use_lock(%lock_0_1_8, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_6 : memref<64xi32>) {bd_id = 4 : i32, len = 16 : i32, next_bd_id = 5 : i32}
            aie.use_lock(%lock_0_1_9, Release, 1)
            aie.next_bd ^bb14
          ^bb14:  // pred: ^bb13
            aie.use_lock(%lock_0_1_8, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_7 : memref<64xi32>) {bd_id = 5 : i32, len = 16 : i32, next_bd_id = 4 : i32}
            aie.use_lock(%lock_0_1_9, Release, 1)
            aie.next_bd ^bb13
          ^bb15:  // pred: ^bb12
            %13 = aie.dma_start(MM2S, 2, ^bb16, ^bb18)
          ^bb16:  // 2 preds: ^bb15, ^bb17
            aie.use_lock(%lock_0_1_1, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1 : memref<1152xi32>) {bd_id = 6 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 4, stride = 8>, <size = 6, stride = 32>, <size = 8, stride = 1>]>, len = 576 : i32, next_bd_id = 7 : i32, offset = 192 : i32}
            aie.use_lock(%lock_0_1, Release, 1)
            aie.next_bd ^bb17
          ^bb17:  // pred: ^bb16
            aie.use_lock(%lock_0_1_1, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_0 : memref<1152xi32>) {bd_id = 7 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 4, stride = 8>, <size = 6, stride = 32>, <size = 8, stride = 1>]>, len = 576 : i32, next_bd_id = 6 : i32, offset = 192 : i32}
            aie.use_lock(%lock_0_1, Release, 1)
            aie.next_bd ^bb16
          ^bb18:  // pred: ^bb15
            %14 = aie.dma_start(S2MM, 3, ^bb19, ^bb21)
          ^bb19:  // 2 preds: ^bb18, ^bb20
            aie.use_lock(%lock_0_1_8, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_6 : memref<64xi32>) {bd_id = 28 : i32, len = 16 : i32, next_bd_id = 29 : i32, offset = 16 : i32}
            aie.use_lock(%lock_0_1_9, Release, 1)
            aie.next_bd ^bb20
          ^bb20:  // pred: ^bb19
            aie.use_lock(%lock_0_1_8, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_7 : memref<64xi32>) {bd_id = 29 : i32, len = 16 : i32, next_bd_id = 28 : i32, offset = 16 : i32}
            aie.use_lock(%lock_0_1_9, Release, 1)
            aie.next_bd ^bb19
          ^bb21:  // pred: ^bb18
            %15 = aie.dma_start(MM2S, 3, ^bb22, ^bb24)
          ^bb22:  // 2 preds: ^bb21, ^bb23
            aie.use_lock(%lock_0_1_1, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1 : memref<1152xi32>) {bd_id = 30 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 4, stride = 8>, <size = 6, stride = 32>, <size = 8, stride = 1>]>, len = 576 : i32, next_bd_id = 31 : i32, offset = 384 : i32}
            aie.use_lock(%lock_0_1, Release, 1)
            aie.next_bd ^bb23
          ^bb23:  // pred: ^bb22
            aie.use_lock(%lock_0_1_1, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_0 : memref<1152xi32>) {bd_id = 31 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 4, stride = 8>, <size = 6, stride = 32>, <size = 8, stride = 1>]>, len = 576 : i32, next_bd_id = 30 : i32, offset = 384 : i32}
            aie.use_lock(%lock_0_1, Release, 1)
            aie.next_bd ^bb22
          ^bb24:  // pred: ^bb21
            %16 = aie.dma_start(S2MM, 4, ^bb25, ^bb27)
          ^bb25:  // 2 preds: ^bb24, ^bb26
            aie.use_lock(%lock_0_1_8, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_6 : memref<64xi32>) {bd_id = 8 : i32, len = 16 : i32, next_bd_id = 9 : i32, offset = 32 : i32}
            aie.use_lock(%lock_0_1_9, Release, 1)
            aie.next_bd ^bb26
          ^bb26:  // pred: ^bb25
            aie.use_lock(%lock_0_1_8, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_7 : memref<64xi32>) {bd_id = 9 : i32, len = 16 : i32, next_bd_id = 8 : i32, offset = 32 : i32}
            aie.use_lock(%lock_0_1_9, Release, 1)
            aie.next_bd ^bb25
          ^bb27:  // pred: ^bb24
            %17 = aie.dma_start(MM2S, 4, ^bb28, ^bb30)
          ^bb28:  // 2 preds: ^bb27, ^bb29
            aie.use_lock(%lock_0_1_1, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1 : memref<1152xi32>) {bd_id = 10 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 4, stride = 8>, <size = 6, stride = 32>, <size = 8, stride = 1>]>, len = 576 : i32, next_bd_id = 11 : i32, offset = 576 : i32}
            aie.use_lock(%lock_0_1, Release, 1)
            aie.next_bd ^bb29
          ^bb29:  // pred: ^bb28
            aie.use_lock(%lock_0_1_1, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_0 : memref<1152xi32>) {bd_id = 11 : i32, dimensions = #aie<bd_dim_layout_array[<size = 3, stride = 192>, <size = 4, stride = 8>, <size = 6, stride = 32>, <size = 8, stride = 1>]>, len = 576 : i32, next_bd_id = 10 : i32, offset = 576 : i32}
            aie.use_lock(%lock_0_1, Release, 1)
            aie.next_bd ^bb28
          ^bb30:  // pred: ^bb27
            %18 = aie.dma_start(S2MM, 5, ^bb31, ^bb33)
          ^bb31:  // 2 preds: ^bb30, ^bb32
            aie.use_lock(%lock_0_1_8, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_6 : memref<64xi32>) {bd_id = 32 : i32, len = 16 : i32, next_bd_id = 33 : i32, offset = 48 : i32}
            aie.use_lock(%lock_0_1_9, Release, 1)
            aie.next_bd ^bb32
          ^bb32:  // pred: ^bb31
            aie.use_lock(%lock_0_1_8, AcquireGreaterEqual, 1)
            aie.dma_bd(%buffer_0_1_7 : memref<64xi32>) {bd_id = 33 : i32, len = 16 : i32, next_bd_id = 32 : i32, offset = 48 : i32}
            aie.use_lock(%lock_0_1_9, Release, 1)
            aie.next_bd ^bb31
          ^bb33:  // pred: ^bb30
            %19 = aie.dma_start(MM2S, 5, ^bb34, ^bb36)
          ^bb34:  // 2 preds: ^bb33, ^bb35
            aie.use_lock(%lock_0_1_9, AcquireGreaterEqual, 4)
            aie.dma_bd(%buffer_0_1_6 : memref<64xi32>) {bd_id = 34 : i32, len = 64 : i32, next_bd_id = 35 : i32}
            aie.use_lock(%lock_0_1_8, Release, 4)
            aie.next_bd ^bb35
          ^bb35:  // pred: ^bb34
            aie.use_lock(%lock_0_1_9, AcquireGreaterEqual, 4)
            aie.dma_bd(%buffer_0_1_7 : memref<64xi32>) {bd_id = 35 : i32, len = 64 : i32, next_bd_id = 34 : i32}
            aie.use_lock(%lock_0_1_8, Release, 4)
            aie.next_bd ^bb34
          ^bb36:  // pred: ^bb33
            aie.end
          }
          aie.shim_dma_allocation @shim_2(S2MM, 0, 0)
          %switchbox_0_0 = aie.switchbox(%tile_0_0) {
            aie.connect<CTRL : 0, SOUTH : 0>
            aie.connect<SOUTH : 3, NORTH : 4>
            aie.connect<SOUTH : 7, NORTH : 1>
            aie.connect<NORTH : 1, SOUTH : 2>
          }
          %core_0_2 = aie.core(%tile_0_2) {
            %8 = llvm.mlir.constant(192 : index) : i64
            %9 = llvm.mlir.constant(32 : index) : i64
            %10 = llvm.mlir.constant(128 : index) : i64
            %11 = llvm.mlir.constant(384 : index) : i64
            %12 = llvm.mlir.constant(0 : index) : i64
            %13 = llvm.mlir.constant(4 : index) : i64
            %14 = llvm.mlir.constant(1 : index) : i64
            %15 = llvm.mlir.constant(3 : index) : i64
            %16 = llvm.mlir.constant(dense<0> : vector<16xi32>) : vector<16xi32>
            %17 = llvm.mlir.constant(8 : index) : i64
            %18 = llvm.mlir.constant(49 : index) : i64
            %19 = llvm.mlir.constant(48 : index) : i64
            %20 = llvm.mlir.constant(51 : index) : i64
            %21 = llvm.mlir.constant(50 : index) : i64
            %22 = llvm.mlir.constant(53 : index) : i64
            %23 = llvm.mlir.constant(2 : index) : i64
            %24 = llvm.mlir.constant(288 : index) : i64
            %25 = llvm.mlir.constant(52 : index) : i64
            %26 = builtin.unrealized_conversion_cast %25 : i64 to index
            %27 = builtin.unrealized_conversion_cast %22 : i64 to index
            %28 = builtin.unrealized_conversion_cast %21 : i64 to index
            %29 = builtin.unrealized_conversion_cast %20 : i64 to index
            %30 = builtin.unrealized_conversion_cast %19 : i64 to index
            %31 = builtin.unrealized_conversion_cast %18 : i64 to index
            %32 = builtin.unrealized_conversion_cast %12 : i64 to index
            %reinterpret_cast = memref.reinterpret_cast %buffer_0_2_46 to offset: [0], sizes: [4, 4], strides: [4, 1] : memref<16xi32> to memref<4x4xi32, strided<[4, 1]>>
            %reinterpret_cast_50 = memref.reinterpret_cast %buffer_0_2_47 to offset: [0], sizes: [4, 4], strides: [4, 1] : memref<16xi32> to memref<4x4xi32, strided<[4, 1]>>
            cf.br ^bb1(%32 : index)
          ^bb1(%33: index):  // 2 preds: ^bb0, ^bb30
            %34 = builtin.unrealized_conversion_cast %33 : index to i64
            %35 = llvm.icmp "slt" %34, %24 : i64
            cf.cond_br %35, ^bb2, ^bb31
          ^bb2:  // pred: ^bb1
            aie.use_lock(%30, AcquireGreaterEqual, 1)
            %36 = llvm.extractvalue %6[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
            llvm.store %16, %36 : vector<16xi32>, !llvm.ptr
            aie.use_lock(%29, AcquireGreaterEqual, 1)
            aie.use_lock(%27, AcquireGreaterEqual, 1)
            cf.br ^bb3(%32 : index)
          ^bb3(%37: index):  // 2 preds: ^bb2, ^bb15
            %38 = builtin.unrealized_conversion_cast %37 : index to i64
            %39 = llvm.icmp "slt" %38, %15 : i64
            cf.cond_br %39, ^bb4(%32 : index), ^bb16
          ^bb4(%40: index):  // 2 preds: ^bb3, ^bb14
            %41 = builtin.unrealized_conversion_cast %40 : index to i64
            %42 = llvm.icmp "slt" %41, %15 : i64
            cf.cond_br %42, ^bb5(%32 : index), ^bb15
          ^bb5(%43: index):  // 2 preds: ^bb4, ^bb13
            %44 = builtin.unrealized_conversion_cast %43 : index to i64
            %45 = llvm.icmp "slt" %44, %13 : i64
            cf.cond_br %45, ^bb6, ^bb14
          ^bb6:  // pred: ^bb5
            %46 = llvm.mul %38, %11 overflow<nsw> : i64
            %47 = llvm.mul %41, %10 overflow<nsw> : i64
            %48 = llvm.add %46, %47 : i64
            %49 = llvm.mul %44, %9 overflow<nsw> : i64
            %50 = llvm.add %48, %49 : i64
            %51 = builtin.unrealized_conversion_cast %50 : i64 to index
            %reinterpret_cast_51 = memref.reinterpret_cast %buffer_0_2_42 to offset: [%51], sizes: [8, 4], strides: [4, 1] : memref<1152xi32> to memref<8x4xi32, strided<[4, 1], offset: ?>>
            %52 = llvm.mul %38, %8 overflow<nsw> : i64
            %53 = llvm.mul %44, %19 overflow<nsw> : i64
            %54 = llvm.add %52, %53 : i64
            %55 = llvm.mul %41, %17 overflow<nsw> : i64
            %56 = llvm.add %54, %55 : i64
            %57 = builtin.unrealized_conversion_cast %56 : i64 to index
            %reinterpret_cast_52 = memref.reinterpret_cast %buffer_0_2 to offset: [%57], sizes: [4, 8], strides: [8, 1] : memref<576xi32> to memref<4x8xi32, strided<[8, 1], offset: ?>>
            cf.br ^bb7(%32 : index)
          ^bb7(%58: index):  // 2 preds: ^bb6, ^bb12
            %59 = builtin.unrealized_conversion_cast %58 : index to i64
            %60 = llvm.icmp "slt" %59, %13 : i64
            cf.cond_br %60, ^bb8(%32 : index), ^bb13
          ^bb8(%61: index):  // 2 preds: ^bb7, ^bb11
            %62 = builtin.unrealized_conversion_cast %61 : index to i64
            %63 = llvm.icmp "slt" %62, %13 : i64
            cf.cond_br %63, ^bb9(%32 : index), ^bb12
          ^bb9(%64: index):  // 2 preds: ^bb8, ^bb10
            %65 = builtin.unrealized_conversion_cast %64 : index to i64
            %66 = llvm.icmp "slt" %65, %17 : i64
            cf.cond_br %66, ^bb10, ^bb11
          ^bb10:  // pred: ^bb9
            %67 = memref.load %reinterpret_cast_52[%58, %64] : memref<4x8xi32, strided<[8, 1], offset: ?>>
            %68 = memref.load %reinterpret_cast_51[%64, %61] : memref<8x4xi32, strided<[4, 1], offset: ?>>
            %69 = memref.load %reinterpret_cast[%58, %61] : memref<4x4xi32, strided<[4, 1]>>
            %70 = llvm.mul %67, %68 : i32
            %71 = llvm.add %69, %70 : i32
            memref.store %71, %reinterpret_cast[%58, %61] : memref<4x4xi32, strided<[4, 1]>>
            %72 = llvm.add %65, %14 : i64
            %73 = builtin.unrealized_conversion_cast %72 : i64 to index
            cf.br ^bb9(%73 : index)
          ^bb11:  // pred: ^bb9
            %74 = llvm.add %62, %14 : i64
            %75 = builtin.unrealized_conversion_cast %74 : i64 to index
            cf.br ^bb8(%75 : index)
          ^bb12:  // pred: ^bb8
            %76 = llvm.add %59, %14 : i64
            %77 = builtin.unrealized_conversion_cast %76 : i64 to index
            cf.br ^bb7(%77 : index)
          ^bb13:  // pred: ^bb7
            %78 = llvm.add %44, %14 : i64
            %79 = builtin.unrealized_conversion_cast %78 : i64 to index
            cf.br ^bb5(%79 : index)
          ^bb14:  // pred: ^bb5
            %80 = llvm.add %41, %14 : i64
            %81 = builtin.unrealized_conversion_cast %80 : i64 to index
            cf.br ^bb4(%81 : index)
          ^bb15:  // pred: ^bb4
            %82 = llvm.add %38, %14 : i64
            %83 = builtin.unrealized_conversion_cast %82 : i64 to index
            cf.br ^bb3(%83 : index)
          ^bb16:  // pred: ^bb3
            aie.use_lock(%28, Release, 1)
            aie.use_lock(%26, Release, 1)
            aie.use_lock(%31, Release, 1)
            aie.use_lock(%30, AcquireGreaterEqual, 1)
            %84 = llvm.extractvalue %7[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
            llvm.store %16, %84 : vector<16xi32>, !llvm.ptr
            aie.use_lock(%29, AcquireGreaterEqual, 1)
            aie.use_lock(%27, AcquireGreaterEqual, 1)
            cf.br ^bb17(%32 : index)
          ^bb17(%85: index):  // 2 preds: ^bb16, ^bb29
            %86 = builtin.unrealized_conversion_cast %85 : index to i64
            %87 = llvm.icmp "slt" %86, %15 : i64
            cf.cond_br %87, ^bb18(%32 : index), ^bb30
          ^bb18(%88: index):  // 2 preds: ^bb17, ^bb28
            %89 = builtin.unrealized_conversion_cast %88 : index to i64
            %90 = llvm.icmp "slt" %89, %15 : i64
            cf.cond_br %90, ^bb19(%32 : index), ^bb29
          ^bb19(%91: index):  // 2 preds: ^bb18, ^bb27
            %92 = builtin.unrealized_conversion_cast %91 : index to i64
            %93 = llvm.icmp "slt" %92, %13 : i64
            cf.cond_br %93, ^bb20, ^bb28
          ^bb20:  // pred: ^bb19
            %94 = llvm.mul %86, %11 overflow<nsw> : i64
            %95 = llvm.mul %89, %10 overflow<nsw> : i64
            %96 = llvm.add %94, %95 : i64
            %97 = llvm.mul %92, %9 overflow<nsw> : i64
            %98 = llvm.add %96, %97 : i64
            %99 = builtin.unrealized_conversion_cast %98 : i64 to index
            %reinterpret_cast_53 = memref.reinterpret_cast %buffer_0_2_43 to offset: [%99], sizes: [8, 4], strides: [4, 1] : memref<1152xi32> to memref<8x4xi32, strided<[4, 1], offset: ?>>
            %100 = llvm.mul %86, %8 overflow<nsw> : i64
            %101 = llvm.mul %92, %19 overflow<nsw> : i64
            %102 = llvm.add %100, %101 : i64
            %103 = llvm.mul %89, %17 overflow<nsw> : i64
            %104 = llvm.add %102, %103 : i64
            %105 = builtin.unrealized_conversion_cast %104 : i64 to index
            %reinterpret_cast_54 = memref.reinterpret_cast %buffer_0_2_40 to offset: [%105], sizes: [4, 8], strides: [8, 1] : memref<576xi32> to memref<4x8xi32, strided<[8, 1], offset: ?>>
            cf.br ^bb21(%32 : index)
          ^bb21(%106: index):  // 2 preds: ^bb20, ^bb26
            %107 = builtin.unrealized_conversion_cast %106 : index to i64
            %108 = llvm.icmp "slt" %107, %13 : i64
            cf.cond_br %108, ^bb22(%32 : index), ^bb27
          ^bb22(%109: index):  // 2 preds: ^bb21, ^bb25
            %110 = builtin.unrealized_conversion_cast %109 : index to i64
            %111 = llvm.icmp "slt" %110, %13 : i64
            cf.cond_br %111, ^bb23(%32 : index), ^bb26
          ^bb23(%112: index):  // 2 preds: ^bb22, ^bb24
            %113 = builtin.unrealized_conversion_cast %112 : index to i64
            %114 = llvm.icmp "slt" %113, %17 : i64
            cf.cond_br %114, ^bb24, ^bb25
          ^bb24:  // pred: ^bb23
            %115 = memref.load %reinterpret_cast_54[%106, %112] : memref<4x8xi32, strided<[8, 1], offset: ?>>
            %116 = memref.load %reinterpret_cast_53[%112, %109] : memref<8x4xi32, strided<[4, 1], offset: ?>>
            %117 = memref.load %reinterpret_cast_50[%106, %109] : memref<4x4xi32, strided<[4, 1]>>
            %118 = llvm.mul %115, %116 : i32
            %119 = llvm.add %117, %118 : i32
            memref.store %119, %reinterpret_cast_50[%106, %109] : memref<4x4xi32, strided<[4, 1]>>
            %120 = llvm.add %113, %14 : i64
            %121 = builtin.unrealized_conversion_cast %120 : i64 to index
            cf.br ^bb23(%121 : index)
          ^bb25:  // pred: ^bb23
            %122 = llvm.add %110, %14 : i64
            %123 = builtin.unrealized_conversion_cast %122 : i64 to index
            cf.br ^bb22(%123 : index)
          ^bb26:  // pred: ^bb22
            %124 = llvm.add %107, %14 : i64
            %125 = builtin.unrealized_conversion_cast %124 : i64 to index
            cf.br ^bb21(%125 : index)
          ^bb27:  // pred: ^bb21
            %126 = llvm.add %92, %14 : i64
            %127 = builtin.unrealized_conversion_cast %126 : i64 to index
            cf.br ^bb19(%127 : index)
          ^bb28:  // pred: ^bb19
            %128 = llvm.add %89, %14 : i64
            %129 = builtin.unrealized_conversion_cast %128 : i64 to index
            cf.br ^bb18(%129 : index)
          ^bb29:  // pred: ^bb18
            %130 = llvm.add %86, %14 : i64
            %131 = builtin.unrealized_conversion_cast %130 : i64 to index
            cf.br ^bb17(%131 : index)
          ^bb30:  // pred: ^bb17
            aie.use_lock(%28, Release, 1)
            aie.use_lock(%26, Release, 1)
            aie.use_lock(%31, Release, 1)
            %132 = llvm.add %34, %23 : i64
            %133 = builtin.unrealized_conversion_cast %132 : i64 to index
            cf.br ^bb1(%133 : index)
          ^bb31:  // pred: ^bb1
            aie.end
          }
          %core_0_3 = aie.core(%tile_0_3) {
            %8 = llvm.mlir.constant(192 : index) : i64
            %9 = llvm.mlir.constant(32 : index) : i64
            %10 = llvm.mlir.constant(128 : index) : i64
            %11 = llvm.mlir.constant(384 : index) : i64
            %12 = llvm.mlir.constant(0 : index) : i64
            %13 = llvm.mlir.constant(3 : index) : i64
            %14 = llvm.mlir.constant(2 : index) : i64
            %15 = llvm.mlir.constant(4 : index) : i64
            %16 = llvm.mlir.constant(49 : index) : i64
            %17 = llvm.mlir.constant(48 : index) : i64
            %18 = llvm.mlir.constant(51 : index) : i64
            %19 = llvm.mlir.constant(50 : index) : i64
            %20 = llvm.mlir.constant(53 : index) : i64
            %21 = llvm.mlir.constant(288 : index) : i64
            %22 = llvm.mlir.constant(dense<0> : vector<16xi32>) : vector<16xi32>
            %23 = llvm.mlir.constant(8 : index) : i64
            %24 = llvm.mlir.constant(1 : index) : i64
            %25 = llvm.mlir.constant(52 : index) : i64
            %26 = builtin.unrealized_conversion_cast %25 : i64 to index
            %27 = builtin.unrealized_conversion_cast %20 : i64 to index
            %28 = builtin.unrealized_conversion_cast %19 : i64 to index
            %29 = builtin.unrealized_conversion_cast %18 : i64 to index
            %30 = builtin.unrealized_conversion_cast %17 : i64 to index
            %31 = builtin.unrealized_conversion_cast %16 : i64 to index
            %32 = builtin.unrealized_conversion_cast %12 : i64 to index
            %reinterpret_cast = memref.reinterpret_cast %buffer_0_3_16 to offset: [0], sizes: [4, 4], strides: [4, 1] : memref<16xi32> to memref<4x4xi32, strided<[4, 1]>>
            %reinterpret_cast_50 = memref.reinterpret_cast %buffer_0_3_17 to offset: [0], sizes: [4, 4], strides: [4, 1] : memref<16xi32> to memref<4x4xi32, strided<[4, 1]>>
            cf.br ^bb1(%32 : index)
          ^bb1(%33: index):  // 2 preds: ^bb0, ^bb30
            %34 = builtin.unrealized_conversion_cast %33 : index to i64
            %35 = llvm.icmp "slt" %34, %21 : i64
            cf.cond_br %35, ^bb2, ^bb31
          ^bb2:  // pred: ^bb1
            aie.use_lock(%30, AcquireGreaterEqual, 1)
            %36 = llvm.extractvalue %0[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
            llvm.store %22, %36 : vector<16xi32>, !llvm.ptr
            aie.use_lock(%29, AcquireGreaterEqual, 1)
            aie.use_lock(%27, AcquireGreaterEqual, 1)
            cf.br ^bb3(%32 : index)
          ^bb3(%37: index):  // 2 preds: ^bb2, ^bb15
            %38 = builtin.unrealized_conversion_cast %37 : index to i64
            %39 = llvm.icmp "slt" %38, %13 : i64
            cf.cond_br %39, ^bb4(%32 : index), ^bb16
          ^bb4(%40: index):  // 2 preds: ^bb3, ^bb14
            %41 = builtin.unrealized_conversion_cast %40 : index to i64
            %42 = llvm.icmp "slt" %41, %13 : i64
            cf.cond_br %42, ^bb5(%32 : index), ^bb15
          ^bb5(%43: index):  // 2 preds: ^bb4, ^bb13
            %44 = builtin.unrealized_conversion_cast %43 : index to i64
            %45 = llvm.icmp "slt" %44, %15 : i64
            cf.cond_br %45, ^bb6, ^bb14
          ^bb6:  // pred: ^bb5
            %46 = llvm.mul %38, %11 overflow<nsw> : i64
            %47 = llvm.mul %41, %10 overflow<nsw> : i64
            %48 = llvm.add %46, %47 : i64
            %49 = llvm.mul %44, %9 overflow<nsw> : i64
            %50 = llvm.add %48, %49 : i64
            %51 = builtin.unrealized_conversion_cast %50 : i64 to index
            %reinterpret_cast_51 = memref.reinterpret_cast %buffer_0_3_12 to offset: [%51], sizes: [8, 4], strides: [4, 1] : memref<1152xi32> to memref<8x4xi32, strided<[4, 1], offset: ?>>
            %52 = llvm.mul %38, %8 overflow<nsw> : i64
            %53 = llvm.mul %44, %17 overflow<nsw> : i64
            %54 = llvm.add %52, %53 : i64
            %55 = llvm.mul %41, %23 overflow<nsw> : i64
            %56 = llvm.add %54, %55 : i64
            %57 = builtin.unrealized_conversion_cast %56 : i64 to index
            %reinterpret_cast_52 = memref.reinterpret_cast %buffer_0_3 to offset: [%57], sizes: [4, 8], strides: [8, 1] : memref<576xi32> to memref<4x8xi32, strided<[8, 1], offset: ?>>
            cf.br ^bb7(%32 : index)
          ^bb7(%58: index):  // 2 preds: ^bb6, ^bb12
            %59 = builtin.unrealized_conversion_cast %58 : index to i64
            %60 = llvm.icmp "slt" %59, %15 : i64
            cf.cond_br %60, ^bb8(%32 : index), ^bb13
          ^bb8(%61: index):  // 2 preds: ^bb7, ^bb11
            %62 = builtin.unrealized_conversion_cast %61 : index to i64
            %63 = llvm.icmp "slt" %62, %15 : i64
            cf.cond_br %63, ^bb9(%32 : index), ^bb12
          ^bb9(%64: index):  // 2 preds: ^bb8, ^bb10
            %65 = builtin.unrealized_conversion_cast %64 : index to i64
            %66 = llvm.icmp "slt" %65, %23 : i64
            cf.cond_br %66, ^bb10, ^bb11
          ^bb10:  // pred: ^bb9
            %67 = memref.load %reinterpret_cast_52[%58, %64] : memref<4x8xi32, strided<[8, 1], offset: ?>>
            %68 = memref.load %reinterpret_cast_51[%64, %61] : memref<8x4xi32, strided<[4, 1], offset: ?>>
            %69 = memref.load %reinterpret_cast[%58, %61] : memref<4x4xi32, strided<[4, 1]>>
            %70 = llvm.mul %67, %68 : i32
            %71 = llvm.add %69, %70 : i32
            memref.store %71, %reinterpret_cast[%58, %61] : memref<4x4xi32, strided<[4, 1]>>
            %72 = llvm.add %65, %24 : i64
            %73 = builtin.unrealized_conversion_cast %72 : i64 to index
            cf.br ^bb9(%73 : index)
          ^bb11:  // pred: ^bb9
            %74 = llvm.add %62, %24 : i64
            %75 = builtin.unrealized_conversion_cast %74 : i64 to index
            cf.br ^bb8(%75 : index)
          ^bb12:  // pred: ^bb8
            %76 = llvm.add %59, %24 : i64
            %77 = builtin.unrealized_conversion_cast %76 : i64 to index
            cf.br ^bb7(%77 : index)
          ^bb13:  // pred: ^bb7
            %78 = llvm.add %44, %24 : i64
            %79 = builtin.unrealized_conversion_cast %78 : i64 to index
            cf.br ^bb5(%79 : index)
          ^bb14:  // pred: ^bb5
            %80 = llvm.add %41, %24 : i64
            %81 = builtin.unrealized_conversion_cast %80 : i64 to index
            cf.br ^bb4(%81 : index)
          ^bb15:  // pred: ^bb4
            %82 = llvm.add %38, %24 : i64
            %83 = builtin.unrealized_conversion_cast %82 : i64 to index
            cf.br ^bb3(%83 : index)
          ^bb16:  // pred: ^bb3
            aie.use_lock(%28, Release, 1)
            aie.use_lock(%26, Release, 1)
            aie.use_lock(%31, Release, 1)
            aie.use_lock(%30, AcquireGreaterEqual, 1)
            %84 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
            llvm.store %22, %84 : vector<16xi32>, !llvm.ptr
            aie.use_lock(%29, AcquireGreaterEqual, 1)
            aie.use_lock(%27, AcquireGreaterEqual, 1)
            cf.br ^bb17(%32 : index)
          ^bb17(%85: index):  // 2 preds: ^bb16, ^bb29
            %86 = builtin.unrealized_conversion_cast %85 : index to i64
            %87 = llvm.icmp "slt" %86, %13 : i64
            cf.cond_br %87, ^bb18(%32 : index), ^bb30
          ^bb18(%88: index):  // 2 preds: ^bb17, ^bb28
            %89 = builtin.unrealized_conversion_cast %88 : index to i64
            %90 = llvm.icmp "slt" %89, %13 : i64
            cf.cond_br %90, ^bb19(%32 : index), ^bb29
          ^bb19(%91: index):  // 2 preds: ^bb18, ^bb27
            %92 = builtin.unrealized_conversion_cast %91 : index to i64
            %93 = llvm.icmp "slt" %92, %15 : i64
            cf.cond_br %93, ^bb20, ^bb28
          ^bb20:  // pred: ^bb19
            %94 = llvm.mul %86, %11 overflow<nsw> : i64
            %95 = llvm.mul %89, %10 overflow<nsw> : i64
            %96 = llvm.add %94, %95 : i64
            %97 = llvm.mul %92, %9 overflow<nsw> : i64
            %98 = llvm.add %96, %97 : i64
            %99 = builtin.unrealized_conversion_cast %98 : i64 to index
            %reinterpret_cast_53 = memref.reinterpret_cast %buffer_0_3_13 to offset: [%99], sizes: [8, 4], strides: [4, 1] : memref<1152xi32> to memref<8x4xi32, strided<[4, 1], offset: ?>>
            %100 = llvm.mul %86, %8 overflow<nsw> : i64
            %101 = llvm.mul %92, %17 overflow<nsw> : i64
            %102 = llvm.add %100, %101 : i64
            %103 = llvm.mul %89, %23 overflow<nsw> : i64
            %104 = llvm.add %102, %103 : i64
            %105 = builtin.unrealized_conversion_cast %104 : i64 to index
            %reinterpret_cast_54 = memref.reinterpret_cast %buffer_0_3_10 to offset: [%105], sizes: [4, 8], strides: [8, 1] : memref<576xi32> to memref<4x8xi32, strided<[8, 1], offset: ?>>
            cf.br ^bb21(%32 : index)
          ^bb21(%106: index):  // 2 preds: ^bb20, ^bb26
            %107 = builtin.unrealized_conversion_cast %106 : index to i64
            %108 = llvm.icmp "slt" %107, %15 : i64
            cf.cond_br %108, ^bb22(%32 : index), ^bb27
          ^bb22(%109: index):  // 2 preds: ^bb21, ^bb25
            %110 = builtin.unrealized_conversion_cast %109 : index to i64
            %111 = llvm.icmp "slt" %110, %15 : i64
            cf.cond_br %111, ^bb23(%32 : index), ^bb26
          ^bb23(%112: index):  // 2 preds: ^bb22, ^bb24
            %113 = builtin.unrealized_conversion_cast %112 : index to i64
            %114 = llvm.icmp "slt" %113, %23 : i64
            cf.cond_br %114, ^bb24, ^bb25
          ^bb24:  // pred: ^bb23
            %115 = memref.load %reinterpret_cast_54[%106, %112] : memref<4x8xi32, strided<[8, 1], offset: ?>>
            %116 = memref.load %reinterpret_cast_53[%112, %109] : memref<8x4xi32, strided<[4, 1], offset: ?>>
            %117 = memref.load %reinterpret_cast_50[%106, %109] : memref<4x4xi32, strided<[4, 1]>>
            %118 = llvm.mul %115, %116 : i32
            %119 = llvm.add %117, %118 : i32
            memref.store %119, %reinterpret_cast_50[%106, %109] : memref<4x4xi32, strided<[4, 1]>>
            %120 = llvm.add %113, %24 : i64
            %121 = builtin.unrealized_conversion_cast %120 : i64 to index
            cf.br ^bb23(%121 : index)
          ^bb25:  // pred: ^bb23
            %122 = llvm.add %110, %24 : i64
            %123 = builtin.unrealized_conversion_cast %122 : i64 to index
            cf.br ^bb22(%123 : index)
          ^bb26:  // pred: ^bb22
            %124 = llvm.add %107, %24 : i64
            %125 = builtin.unrealized_conversion_cast %124 : i64 to index
            cf.br ^bb21(%125 : index)
          ^bb27:  // pred: ^bb21
            %126 = llvm.add %92, %24 : i64
            %127 = builtin.unrealized_conversion_cast %126 : i64 to index
            cf.br ^bb19(%127 : index)
          ^bb28:  // pred: ^bb19
            %128 = llvm.add %89, %24 : i64
            %129 = builtin.unrealized_conversion_cast %128 : i64 to index
            cf.br ^bb18(%129 : index)
          ^bb29:  // pred: ^bb18
            %130 = llvm.add %86, %24 : i64
            %131 = builtin.unrealized_conversion_cast %130 : i64 to index
            cf.br ^bb17(%131 : index)
          ^bb30:  // pred: ^bb17
            aie.use_lock(%28, Release, 1)
            aie.use_lock(%26, Release, 1)
            aie.use_lock(%31, Release, 1)
            %132 = llvm.add %34, %14 : i64
            %133 = builtin.unrealized_conversion_cast %132 : i64 to index
            cf.br ^bb1(%133 : index)
          ^bb31:  // pred: ^bb1
            aie.end
          }
          %core_0_4 = aie.core(%tile_0_4) {
            %8 = llvm.mlir.constant(192 : index) : i64
            %9 = llvm.mlir.constant(32 : index) : i64
            %10 = llvm.mlir.constant(128 : index) : i64
            %11 = llvm.mlir.constant(384 : index) : i64
            %12 = llvm.mlir.constant(0 : index) : i64
            %13 = llvm.mlir.constant(3 : index) : i64
            %14 = llvm.mlir.constant(2 : index) : i64
            %15 = llvm.mlir.constant(4 : index) : i64
            %16 = llvm.mlir.constant(1 : index) : i64
            %17 = llvm.mlir.constant(52 : index) : i64
            %18 = llvm.mlir.constant(53 : index) : i64
            %19 = llvm.mlir.constant(50 : index) : i64
            %20 = llvm.mlir.constant(51 : index) : i64
            %21 = llvm.mlir.constant(48 : index) : i64
            %22 = llvm.mlir.constant(288 : index) : i64
            %23 = llvm.mlir.constant(dense<0> : vector<16xi32>) : vector<16xi32>
            %24 = llvm.mlir.constant(8 : index) : i64
            %25 = llvm.mlir.constant(49 : index) : i64
            %26 = builtin.unrealized_conversion_cast %25 : i64 to index
            %27 = builtin.unrealized_conversion_cast %21 : i64 to index
            %28 = builtin.unrealized_conversion_cast %20 : i64 to index
            %29 = builtin.unrealized_conversion_cast %19 : i64 to index
            %30 = builtin.unrealized_conversion_cast %18 : i64 to index
            %31 = builtin.unrealized_conversion_cast %17 : i64 to index
            %32 = builtin.unrealized_conversion_cast %12 : i64 to index
            %reinterpret_cast = memref.reinterpret_cast %buffer_0_4_26 to offset: [0], sizes: [4, 4], strides: [4, 1] : memref<16xi32> to memref<4x4xi32, strided<[4, 1]>>
            %reinterpret_cast_50 = memref.reinterpret_cast %buffer_0_4_27 to offset: [0], sizes: [4, 4], strides: [4, 1] : memref<16xi32> to memref<4x4xi32, strided<[4, 1]>>
            cf.br ^bb1(%32 : index)
          ^bb1(%33: index):  // 2 preds: ^bb0, ^bb30
            %34 = builtin.unrealized_conversion_cast %33 : index to i64
            %35 = llvm.icmp "slt" %34, %22 : i64
            cf.cond_br %35, ^bb2, ^bb31
          ^bb2:  // pred: ^bb1
            aie.use_lock(%27, AcquireGreaterEqual, 1)
            %36 = llvm.extractvalue %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
            llvm.store %23, %36 : vector<16xi32>, !llvm.ptr
            aie.use_lock(%28, AcquireGreaterEqual, 1)
            aie.use_lock(%30, AcquireGreaterEqual, 1)
            cf.br ^bb3(%32 : index)
          ^bb3(%37: index):  // 2 preds: ^bb2, ^bb15
            %38 = builtin.unrealized_conversion_cast %37 : index to i64
            %39 = llvm.icmp "slt" %38, %13 : i64
            cf.cond_br %39, ^bb4(%32 : index), ^bb16
          ^bb4(%40: index):  // 2 preds: ^bb3, ^bb14
            %41 = builtin.unrealized_conversion_cast %40 : index to i64
            %42 = llvm.icmp "slt" %41, %13 : i64
            cf.cond_br %42, ^bb5(%32 : index), ^bb15
          ^bb5(%43: index):  // 2 preds: ^bb4, ^bb13
            %44 = builtin.unrealized_conversion_cast %43 : index to i64
            %45 = llvm.icmp "slt" %44, %15 : i64
            cf.cond_br %45, ^bb6, ^bb14
          ^bb6:  // pred: ^bb5
            %46 = llvm.mul %38, %11 overflow<nsw> : i64
            %47 = llvm.mul %41, %10 overflow<nsw> : i64
            %48 = llvm.add %46, %47 : i64
            %49 = llvm.mul %44, %9 overflow<nsw> : i64
            %50 = llvm.add %48, %49 : i64
            %51 = builtin.unrealized_conversion_cast %50 : i64 to index
            %reinterpret_cast_51 = memref.reinterpret_cast %buffer_0_4_22 to offset: [%51], sizes: [8, 4], strides: [4, 1] : memref<1152xi32> to memref<8x4xi32, strided<[4, 1], offset: ?>>
            %52 = llvm.mul %38, %8 overflow<nsw> : i64
            %53 = llvm.mul %44, %21 overflow<nsw> : i64
            %54 = llvm.add %52, %53 : i64
            %55 = llvm.mul %41, %24 overflow<nsw> : i64
            %56 = llvm.add %54, %55 : i64
            %57 = builtin.unrealized_conversion_cast %56 : i64 to index
            %reinterpret_cast_52 = memref.reinterpret_cast %buffer_0_4 to offset: [%57], sizes: [4, 8], strides: [8, 1] : memref<576xi32> to memref<4x8xi32, strided<[8, 1], offset: ?>>
            cf.br ^bb7(%32 : index)
          ^bb7(%58: index):  // 2 preds: ^bb6, ^bb12
            %59 = builtin.unrealized_conversion_cast %58 : index to i64
            %60 = llvm.icmp "slt" %59, %15 : i64
            cf.cond_br %60, ^bb8(%32 : index), ^bb13
          ^bb8(%61: index):  // 2 preds: ^bb7, ^bb11
            %62 = builtin.unrealized_conversion_cast %61 : index to i64
            %63 = llvm.icmp "slt" %62, %15 : i64
            cf.cond_br %63, ^bb9(%32 : index), ^bb12
          ^bb9(%64: index):  // 2 preds: ^bb8, ^bb10
            %65 = builtin.unrealized_conversion_cast %64 : index to i64
            %66 = llvm.icmp "slt" %65, %24 : i64
            cf.cond_br %66, ^bb10, ^bb11
          ^bb10:  // pred: ^bb9
            %67 = memref.load %reinterpret_cast_52[%58, %64] : memref<4x8xi32, strided<[8, 1], offset: ?>>
            %68 = memref.load %reinterpret_cast_51[%64, %61] : memref<8x4xi32, strided<[4, 1], offset: ?>>
            %69 = memref.load %reinterpret_cast[%58, %61] : memref<4x4xi32, strided<[4, 1]>>
            %70 = llvm.mul %67, %68 : i32
            %71 = llvm.add %69, %70 : i32
            memref.store %71, %reinterpret_cast[%58, %61] : memref<4x4xi32, strided<[4, 1]>>
            %72 = llvm.add %65, %16 : i64
            %73 = builtin.unrealized_conversion_cast %72 : i64 to index
            cf.br ^bb9(%73 : index)
          ^bb11:  // pred: ^bb9
            %74 = llvm.add %62, %16 : i64
            %75 = builtin.unrealized_conversion_cast %74 : i64 to index
            cf.br ^bb8(%75 : index)
          ^bb12:  // pred: ^bb8
            %76 = llvm.add %59, %16 : i64
            %77 = builtin.unrealized_conversion_cast %76 : i64 to index
            cf.br ^bb7(%77 : index)
          ^bb13:  // pred: ^bb7
            %78 = llvm.add %44, %16 : i64
            %79 = builtin.unrealized_conversion_cast %78 : i64 to index
            cf.br ^bb5(%79 : index)
          ^bb14:  // pred: ^bb5
            %80 = llvm.add %41, %16 : i64
            %81 = builtin.unrealized_conversion_cast %80 : i64 to index
            cf.br ^bb4(%81 : index)
          ^bb15:  // pred: ^bb4
            %82 = llvm.add %38, %16 : i64
            %83 = builtin.unrealized_conversion_cast %82 : i64 to index
            cf.br ^bb3(%83 : index)
          ^bb16:  // pred: ^bb3
            aie.use_lock(%29, Release, 1)
            aie.use_lock(%31, Release, 1)
            aie.use_lock(%26, Release, 1)
            aie.use_lock(%27, AcquireGreaterEqual, 1)
            %84 = llvm.extractvalue %3[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
            llvm.store %23, %84 : vector<16xi32>, !llvm.ptr
            aie.use_lock(%28, AcquireGreaterEqual, 1)
            aie.use_lock(%30, AcquireGreaterEqual, 1)
            cf.br ^bb17(%32 : index)
          ^bb17(%85: index):  // 2 preds: ^bb16, ^bb29
            %86 = builtin.unrealized_conversion_cast %85 : index to i64
            %87 = llvm.icmp "slt" %86, %13 : i64
            cf.cond_br %87, ^bb18(%32 : index), ^bb30
          ^bb18(%88: index):  // 2 preds: ^bb17, ^bb28
            %89 = builtin.unrealized_conversion_cast %88 : index to i64
            %90 = llvm.icmp "slt" %89, %13 : i64
            cf.cond_br %90, ^bb19(%32 : index), ^bb29
          ^bb19(%91: index):  // 2 preds: ^bb18, ^bb27
            %92 = builtin.unrealized_conversion_cast %91 : index to i64
            %93 = llvm.icmp "slt" %92, %15 : i64
            cf.cond_br %93, ^bb20, ^bb28
          ^bb20:  // pred: ^bb19
            %94 = llvm.mul %86, %11 overflow<nsw> : i64
            %95 = llvm.mul %89, %10 overflow<nsw> : i64
            %96 = llvm.add %94, %95 : i64
            %97 = llvm.mul %92, %9 overflow<nsw> : i64
            %98 = llvm.add %96, %97 : i64
            %99 = builtin.unrealized_conversion_cast %98 : i64 to index
            %reinterpret_cast_53 = memref.reinterpret_cast %buffer_0_4_23 to offset: [%99], sizes: [8, 4], strides: [4, 1] : memref<1152xi32> to memref<8x4xi32, strided<[4, 1], offset: ?>>
            %100 = llvm.mul %86, %8 overflow<nsw> : i64
            %101 = llvm.mul %92, %21 overflow<nsw> : i64
            %102 = llvm.add %100, %101 : i64
            %103 = llvm.mul %89, %24 overflow<nsw> : i64
            %104 = llvm.add %102, %103 : i64
            %105 = builtin.unrealized_conversion_cast %104 : i64 to index
            %reinterpret_cast_54 = memref.reinterpret_cast %buffer_0_4_20 to offset: [%105], sizes: [4, 8], strides: [8, 1] : memref<576xi32> to memref<4x8xi32, strided<[8, 1], offset: ?>>
            cf.br ^bb21(%32 : index)
          ^bb21(%106: index):  // 2 preds: ^bb20, ^bb26
            %107 = builtin.unrealized_conversion_cast %106 : index to i64
            %108 = llvm.icmp "slt" %107, %15 : i64
            cf.cond_br %108, ^bb22(%32 : index), ^bb27
          ^bb22(%109: index):  // 2 preds: ^bb21, ^bb25
            %110 = builtin.unrealized_conversion_cast %109 : index to i64
            %111 = llvm.icmp "slt" %110, %15 : i64
            cf.cond_br %111, ^bb23(%32 : index), ^bb26
          ^bb23(%112: index):  // 2 preds: ^bb22, ^bb24
            %113 = builtin.unrealized_conversion_cast %112 : index to i64
            %114 = llvm.icmp "slt" %113, %24 : i64
            cf.cond_br %114, ^bb24, ^bb25
          ^bb24:  // pred: ^bb23
            %115 = memref.load %reinterpret_cast_54[%106, %112] : memref<4x8xi32, strided<[8, 1], offset: ?>>
            %116 = memref.load %reinterpret_cast_53[%112, %109] : memref<8x4xi32, strided<[4, 1], offset: ?>>
            %117 = memref.load %reinterpret_cast_50[%106, %109] : memref<4x4xi32, strided<[4, 1]>>
            %118 = llvm.mul %115, %116 : i32
            %119 = llvm.add %117, %118 : i32
            memref.store %119, %reinterpret_cast_50[%106, %109] : memref<4x4xi32, strided<[4, 1]>>
            %120 = llvm.add %113, %16 : i64
            %121 = builtin.unrealized_conversion_cast %120 : i64 to index
            cf.br ^bb23(%121 : index)
          ^bb25:  // pred: ^bb23
            %122 = llvm.add %110, %16 : i64
            %123 = builtin.unrealized_conversion_cast %122 : i64 to index
            cf.br ^bb22(%123 : index)
          ^bb26:  // pred: ^bb22
            %124 = llvm.add %107, %16 : i64
            %125 = builtin.unrealized_conversion_cast %124 : i64 to index
            cf.br ^bb21(%125 : index)
          ^bb27:  // pred: ^bb21
            %126 = llvm.add %92, %16 : i64
            %127 = builtin.unrealized_conversion_cast %126 : i64 to index
            cf.br ^bb19(%127 : index)
          ^bb28:  // pred: ^bb19
            %128 = llvm.add %89, %16 : i64
            %129 = builtin.unrealized_conversion_cast %128 : i64 to index
            cf.br ^bb18(%129 : index)
          ^bb29:  // pred: ^bb18
            %130 = llvm.add %86, %16 : i64
            %131 = builtin.unrealized_conversion_cast %130 : i64 to index
            cf.br ^bb17(%131 : index)
          ^bb30:  // pred: ^bb17
            aie.use_lock(%29, Release, 1)
            aie.use_lock(%31, Release, 1)
            aie.use_lock(%26, Release, 1)
            %132 = llvm.add %34, %14 : i64
            %133 = builtin.unrealized_conversion_cast %132 : i64 to index
            cf.br ^bb1(%133 : index)
          ^bb31:  // pred: ^bb1
            aie.end
          }
          %core_0_5 = aie.core(%tile_0_5) {
            %8 = llvm.mlir.constant(192 : index) : i64
            %9 = llvm.mlir.constant(32 : index) : i64
            %10 = llvm.mlir.constant(128 : index) : i64
            %11 = llvm.mlir.constant(384 : index) : i64
            %12 = llvm.mlir.constant(0 : index) : i64
            %13 = llvm.mlir.constant(3 : index) : i64
            %14 = llvm.mlir.constant(2 : index) : i64
            %15 = llvm.mlir.constant(4 : index) : i64
            %16 = llvm.mlir.constant(1 : index) : i64
            %17 = llvm.mlir.constant(52 : index) : i64
            %18 = llvm.mlir.constant(53 : index) : i64
            %19 = llvm.mlir.constant(50 : index) : i64
            %20 = llvm.mlir.constant(51 : index) : i64
            %21 = llvm.mlir.constant(48 : index) : i64
            %22 = llvm.mlir.constant(288 : index) : i64
            %23 = llvm.mlir.constant(dense<0> : vector<16xi32>) : vector<16xi32>
            %24 = llvm.mlir.constant(8 : index) : i64
            %25 = llvm.mlir.constant(49 : index) : i64
            %26 = builtin.unrealized_conversion_cast %25 : i64 to index
            %27 = builtin.unrealized_conversion_cast %21 : i64 to index
            %28 = builtin.unrealized_conversion_cast %20 : i64 to index
            %29 = builtin.unrealized_conversion_cast %19 : i64 to index
            %30 = builtin.unrealized_conversion_cast %18 : i64 to index
            %31 = builtin.unrealized_conversion_cast %17 : i64 to index
            %32 = builtin.unrealized_conversion_cast %12 : i64 to index
            %reinterpret_cast = memref.reinterpret_cast %buffer_0_5_36 to offset: [0], sizes: [4, 4], strides: [4, 1] : memref<16xi32> to memref<4x4xi32, strided<[4, 1]>>
            %reinterpret_cast_50 = memref.reinterpret_cast %buffer_0_5_37 to offset: [0], sizes: [4, 4], strides: [4, 1] : memref<16xi32> to memref<4x4xi32, strided<[4, 1]>>
            cf.br ^bb1(%32 : index)
          ^bb1(%33: index):  // 2 preds: ^bb0, ^bb30
            %34 = builtin.unrealized_conversion_cast %33 : index to i64
            %35 = llvm.icmp "slt" %34, %22 : i64
            cf.cond_br %35, ^bb2, ^bb31
          ^bb2:  // pred: ^bb1
            aie.use_lock(%27, AcquireGreaterEqual, 1)
            %36 = llvm.extractvalue %4[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
            llvm.store %23, %36 : vector<16xi32>, !llvm.ptr
            aie.use_lock(%28, AcquireGreaterEqual, 1)
            aie.use_lock(%30, AcquireGreaterEqual, 1)
            cf.br ^bb3(%32 : index)
          ^bb3(%37: index):  // 2 preds: ^bb2, ^bb15
            %38 = builtin.unrealized_conversion_cast %37 : index to i64
            %39 = llvm.icmp "slt" %38, %13 : i64
            cf.cond_br %39, ^bb4(%32 : index), ^bb16
          ^bb4(%40: index):  // 2 preds: ^bb3, ^bb14
            %41 = builtin.unrealized_conversion_cast %40 : index to i64
            %42 = llvm.icmp "slt" %41, %13 : i64
            cf.cond_br %42, ^bb5(%32 : index), ^bb15
          ^bb5(%43: index):  // 2 preds: ^bb4, ^bb13
            %44 = builtin.unrealized_conversion_cast %43 : index to i64
            %45 = llvm.icmp "slt" %44, %15 : i64
            cf.cond_br %45, ^bb6, ^bb14
          ^bb6:  // pred: ^bb5
            %46 = llvm.mul %38, %11 overflow<nsw> : i64
            %47 = llvm.mul %41, %10 overflow<nsw> : i64
            %48 = llvm.add %46, %47 : i64
            %49 = llvm.mul %44, %9 overflow<nsw> : i64
            %50 = llvm.add %48, %49 : i64
            %51 = builtin.unrealized_conversion_cast %50 : i64 to index
            %reinterpret_cast_51 = memref.reinterpret_cast %buffer_0_5_32 to offset: [%51], sizes: [8, 4], strides: [4, 1] : memref<1152xi32> to memref<8x4xi32, strided<[4, 1], offset: ?>>
            %52 = llvm.mul %38, %8 overflow<nsw> : i64
            %53 = llvm.mul %44, %21 overflow<nsw> : i64
            %54 = llvm.add %52, %53 : i64
            %55 = llvm.mul %41, %24 overflow<nsw> : i64
            %56 = llvm.add %54, %55 : i64
            %57 = builtin.unrealized_conversion_cast %56 : i64 to index
            %reinterpret_cast_52 = memref.reinterpret_cast %buffer_0_5 to offset: [%57], sizes: [4, 8], strides: [8, 1] : memref<576xi32> to memref<4x8xi32, strided<[8, 1], offset: ?>>
            cf.br ^bb7(%32 : index)
          ^bb7(%58: index):  // 2 preds: ^bb6, ^bb12
            %59 = builtin.unrealized_conversion_cast %58 : index to i64
            %60 = llvm.icmp "slt" %59, %15 : i64
            cf.cond_br %60, ^bb8(%32 : index), ^bb13
          ^bb8(%61: index):  // 2 preds: ^bb7, ^bb11
            %62 = builtin.unrealized_conversion_cast %61 : index to i64
            %63 = llvm.icmp "slt" %62, %15 : i64
            cf.cond_br %63, ^bb9(%32 : index), ^bb12
          ^bb9(%64: index):  // 2 preds: ^bb8, ^bb10
            %65 = builtin.unrealized_conversion_cast %64 : index to i64
            %66 = llvm.icmp "slt" %65, %24 : i64
            cf.cond_br %66, ^bb10, ^bb11
          ^bb10:  // pred: ^bb9
            %67 = memref.load %reinterpret_cast_52[%58, %64] : memref<4x8xi32, strided<[8, 1], offset: ?>>
            %68 = memref.load %reinterpret_cast_51[%64, %61] : memref<8x4xi32, strided<[4, 1], offset: ?>>
            %69 = memref.load %reinterpret_cast[%58, %61] : memref<4x4xi32, strided<[4, 1]>>
            %70 = llvm.mul %67, %68 : i32
            %71 = llvm.add %69, %70 : i32
            memref.store %71, %reinterpret_cast[%58, %61] : memref<4x4xi32, strided<[4, 1]>>
            %72 = llvm.add %65, %16 : i64
            %73 = builtin.unrealized_conversion_cast %72 : i64 to index
            cf.br ^bb9(%73 : index)
          ^bb11:  // pred: ^bb9
            %74 = llvm.add %62, %16 : i64
            %75 = builtin.unrealized_conversion_cast %74 : i64 to index
            cf.br ^bb8(%75 : index)
          ^bb12:  // pred: ^bb8
            %76 = llvm.add %59, %16 : i64
            %77 = builtin.unrealized_conversion_cast %76 : i64 to index
            cf.br ^bb7(%77 : index)
          ^bb13:  // pred: ^bb7
            %78 = llvm.add %44, %16 : i64
            %79 = builtin.unrealized_conversion_cast %78 : i64 to index
            cf.br ^bb5(%79 : index)
          ^bb14:  // pred: ^bb5
            %80 = llvm.add %41, %16 : i64
            %81 = builtin.unrealized_conversion_cast %80 : i64 to index
            cf.br ^bb4(%81 : index)
          ^bb15:  // pred: ^bb4
            %82 = llvm.add %38, %16 : i64
            %83 = builtin.unrealized_conversion_cast %82 : i64 to index
            cf.br ^bb3(%83 : index)
          ^bb16:  // pred: ^bb3
            aie.use_lock(%29, Release, 1)
            aie.use_lock(%31, Release, 1)
            aie.use_lock(%26, Release, 1)
            aie.use_lock(%27, AcquireGreaterEqual, 1)
            %84 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
            llvm.store %23, %84 : vector<16xi32>, !llvm.ptr
            aie.use_lock(%28, AcquireGreaterEqual, 1)
            aie.use_lock(%30, AcquireGreaterEqual, 1)
            cf.br ^bb17(%32 : index)
          ^bb17(%85: index):  // 2 preds: ^bb16, ^bb29
            %86 = builtin.unrealized_conversion_cast %85 : index to i64
            %87 = llvm.icmp "slt" %86, %13 : i64
            cf.cond_br %87, ^bb18(%32 : index), ^bb30
          ^bb18(%88: index):  // 2 preds: ^bb17, ^bb28
            %89 = builtin.unrealized_conversion_cast %88 : index to i64
            %90 = llvm.icmp "slt" %89, %13 : i64
            cf.cond_br %90, ^bb19(%32 : index), ^bb29
          ^bb19(%91: index):  // 2 preds: ^bb18, ^bb27
            %92 = builtin.unrealized_conversion_cast %91 : index to i64
            %93 = llvm.icmp "slt" %92, %15 : i64
            cf.cond_br %93, ^bb20, ^bb28
          ^bb20:  // pred: ^bb19
            %94 = llvm.mul %86, %11 overflow<nsw> : i64
            %95 = llvm.mul %89, %10 overflow<nsw> : i64
            %96 = llvm.add %94, %95 : i64
            %97 = llvm.mul %92, %9 overflow<nsw> : i64
            %98 = llvm.add %96, %97 : i64
            %99 = builtin.unrealized_conversion_cast %98 : i64 to index
            %reinterpret_cast_53 = memref.reinterpret_cast %buffer_0_5_33 to offset: [%99], sizes: [8, 4], strides: [4, 1] : memref<1152xi32> to memref<8x4xi32, strided<[4, 1], offset: ?>>
            %100 = llvm.mul %86, %8 overflow<nsw> : i64
            %101 = llvm.mul %92, %21 overflow<nsw> : i64
            %102 = llvm.add %100, %101 : i64
            %103 = llvm.mul %89, %24 overflow<nsw> : i64
            %104 = llvm.add %102, %103 : i64
            %105 = builtin.unrealized_conversion_cast %104 : i64 to index
            %reinterpret_cast_54 = memref.reinterpret_cast %buffer_0_5_30 to offset: [%105], sizes: [4, 8], strides: [8, 1] : memref<576xi32> to memref<4x8xi32, strided<[8, 1], offset: ?>>
            cf.br ^bb21(%32 : index)
          ^bb21(%106: index):  // 2 preds: ^bb20, ^bb26
            %107 = builtin.unrealized_conversion_cast %106 : index to i64
            %108 = llvm.icmp "slt" %107, %15 : i64
            cf.cond_br %108, ^bb22(%32 : index), ^bb27
          ^bb22(%109: index):  // 2 preds: ^bb21, ^bb25
            %110 = builtin.unrealized_conversion_cast %109 : index to i64
            %111 = llvm.icmp "slt" %110, %15 : i64
            cf.cond_br %111, ^bb23(%32 : index), ^bb26
          ^bb23(%112: index):  // 2 preds: ^bb22, ^bb24
            %113 = builtin.unrealized_conversion_cast %112 : index to i64
            %114 = llvm.icmp "slt" %113, %24 : i64
            cf.cond_br %114, ^bb24, ^bb25
          ^bb24:  // pred: ^bb23
            %115 = memref.load %reinterpret_cast_54[%106, %112] : memref<4x8xi32, strided<[8, 1], offset: ?>>
            %116 = memref.load %reinterpret_cast_53[%112, %109] : memref<8x4xi32, strided<[4, 1], offset: ?>>
            %117 = memref.load %reinterpret_cast_50[%106, %109] : memref<4x4xi32, strided<[4, 1]>>
            %118 = llvm.mul %115, %116 : i32
            %119 = llvm.add %117, %118 : i32
            memref.store %119, %reinterpret_cast_50[%106, %109] : memref<4x4xi32, strided<[4, 1]>>
            %120 = llvm.add %113, %16 : i64
            %121 = builtin.unrealized_conversion_cast %120 : i64 to index
            cf.br ^bb23(%121 : index)
          ^bb25:  // pred: ^bb23
            %122 = llvm.add %110, %16 : i64
            %123 = builtin.unrealized_conversion_cast %122 : i64 to index
            cf.br ^bb22(%123 : index)
          ^bb26:  // pred: ^bb22
            %124 = llvm.add %107, %16 : i64
            %125 = builtin.unrealized_conversion_cast %124 : i64 to index
            cf.br ^bb21(%125 : index)
          ^bb27:  // pred: ^bb21
            %126 = llvm.add %92, %16 : i64
            %127 = builtin.unrealized_conversion_cast %126 : i64 to index
            cf.br ^bb19(%127 : index)
          ^bb28:  // pred: ^bb19
            %128 = llvm.add %89, %16 : i64
            %129 = builtin.unrealized_conversion_cast %128 : i64 to index
            cf.br ^bb18(%129 : index)
          ^bb29:  // pred: ^bb18
            %130 = llvm.add %86, %16 : i64
            %131 = builtin.unrealized_conversion_cast %130 : i64 to index
            cf.br ^bb17(%131 : index)
          ^bb30:  // pred: ^bb17
            aie.use_lock(%29, Release, 1)
            aie.use_lock(%31, Release, 1)
            aie.use_lock(%26, Release, 1)
            %132 = llvm.add %34, %14 : i64
            %133 = builtin.unrealized_conversion_cast %132 : i64 to index
            cf.br ^bb1(%133 : index)
          ^bb31:  // pred: ^bb1
            aie.end
          }
          aiex.runtime_sequence @conv_2d_nhwc_hwcf_dispatch_0_conv_2d_nhwc_hwcf_2x12x12x64x3x3x32_i32() {
          }
        } {npu_instructions = dense_resource<npu_instructions> : tensor<1320xui32>, runtime_sequence_name = "conv_2d_nhwc_hwcf_dispatch_0_conv_2d_nhwc_hwcf_2x12x12x64x3x3x32_i32"}
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
}