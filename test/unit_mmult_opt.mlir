module @aie.herd_0 {
  aie.device(xcvc1902) {
    %tile_7_1 = aie.tile(7, 1)
    %tile_7_0 = aie.tile(7, 0)
    %tile_1_1 = aie.tile(1, 1)
    %switchbox_1_1 = aie.switchbox(%tile_1_1) {
    }
    %tile_8_3 = aie.tile(8, 3)
    %lock_8_3 = aie.lock(%tile_8_3, 1)
    %lock_8_3_0 = aie.lock(%tile_8_3, 3)
    %buffer_8_3 = aie.buffer(%tile_8_3) {sym_name = "buf11"} : memref<16x16xf32, 2>
    %lock_8_3_1 = aie.lock(%tile_8_3, 2)
    %buffer_8_3_2 = aie.buffer(%tile_8_3) {sym_name = "buf10"} : memref<16x16xf32, 2>
    %lock_8_3_3 = aie.lock(%tile_8_3, 0)
    %buffer_8_3_4 = aie.buffer(%tile_8_3) {sym_name = "buf9"} : memref<16x16xf32, 2>
    %mem_8_3 = aie.mem(%tile_8_3) {
      %0 = aie.dma_start(S2MM, 0, ^bb1, ^bb5)
    ^bb1:  // 2 preds: ^bb0, ^bb2
      aie.use_lock(%lock_8_3_3, Acquire, 0)
      aie.dma_bd(%buffer_8_3_4 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_8_3_3, Release, 1)
      aie.next_bd ^bb2
    ^bb2:  // pred: ^bb1
      aie.use_lock(%lock_8_3, Acquire, 0)
      aie.dma_bd(%buffer_8_3 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_8_3, Release, 1)
      aie.next_bd ^bb1
    ^bb3:  // pred: ^bb5
      %1 = aie.dma_start(S2MM, 1, ^bb4, ^bb7)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_8_3_1, Acquire, 0)
      aie.dma_bd(%buffer_8_3_2 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_8_3_1, Release, 1)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb0
      %2 = aie.dma_start(MM2S, 0, ^bb6, ^bb3)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_8_3_0, Acquire, 1)
      aie.dma_bd(%buffer_8_3 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_8_3_0, Release, 0)
      aie.next_bd ^bb6
    ^bb7:  // pred: ^bb3
      aie.end
    }
    %tile_6_2 = aie.tile(6, 2)
    %tile_6_1 = aie.tile(6, 1)
    %tile_6_0 = aie.tile(6, 0)
    %tile_0_1 = aie.tile(0, 1)
    %switchbox_0_1 = aie.switchbox(%tile_0_1) {
    }
    %tile_7_3 = aie.tile(7, 3)
    %lock_7_3 = aie.lock(%tile_7_3, 1)
    %lock_7_3_5 = aie.lock(%tile_7_3, 3)
    %buffer_7_3 = aie.buffer(%tile_7_3) {sym_name = "buf8"} : memref<16x16xf32, 2>
    %lock_7_3_6 = aie.lock(%tile_7_3, 2)
    %buffer_7_3_7 = aie.buffer(%tile_7_3) {sym_name = "buf7"} : memref<16x16xf32, 2>
    %lock_7_3_8 = aie.lock(%tile_7_3, 0)
    %buffer_7_3_9 = aie.buffer(%tile_7_3) {sym_name = "buf6"} : memref<16x16xf32, 2>
    %mem_7_3 = aie.mem(%tile_7_3) {
      %0 = aie.dma_start(S2MM, 0, ^bb1, ^bb5)
    ^bb1:  // 2 preds: ^bb0, ^bb2
      aie.use_lock(%lock_7_3_8, Acquire, 0)
      aie.dma_bd(%buffer_7_3_9 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_7_3_8, Release, 1)
      aie.next_bd ^bb2
    ^bb2:  // pred: ^bb1
      aie.use_lock(%lock_7_3, Acquire, 0)
      aie.dma_bd(%buffer_7_3 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_7_3, Release, 1)
      aie.next_bd ^bb1
    ^bb3:  // pred: ^bb5
      %1 = aie.dma_start(S2MM, 1, ^bb4, ^bb7)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_7_3_6, Acquire, 0)
      aie.dma_bd(%buffer_7_3_7 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_7_3_6, Release, 1)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb0
      %2 = aie.dma_start(MM2S, 0, ^bb6, ^bb3)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_7_3_5, Acquire, 1)
      aie.dma_bd(%buffer_7_3 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_7_3_5, Release, 0)
      aie.next_bd ^bb6
    ^bb7:  // pred: ^bb3
      aie.end
    }
    %tile_3_2 = aie.tile(3, 2)
    %tile_3_1 = aie.tile(3, 1)
    %tile_3_0 = aie.tile(3, 0)
    %tile_1_0 = aie.tile(1, 0)
    %switchbox_1_0 = aie.switchbox(%tile_1_0) {
    }
    %tile_8_2 = aie.tile(8, 2)
    %lock_8_2 = aie.lock(%tile_8_2, 1)
    %lock_8_2_10 = aie.lock(%tile_8_2, 3)
    %buffer_8_2 = aie.buffer(%tile_8_2) {sym_name = "buf5"} : memref<16x16xf32, 2>
    %lock_8_2_11 = aie.lock(%tile_8_2, 2)
    %buffer_8_2_12 = aie.buffer(%tile_8_2) {sym_name = "buf4"} : memref<16x16xf32, 2>
    %lock_8_2_13 = aie.lock(%tile_8_2, 0)
    %buffer_8_2_14 = aie.buffer(%tile_8_2) {sym_name = "buf3"} : memref<16x16xf32, 2>
    %mem_8_2 = aie.mem(%tile_8_2) {
      %0 = aie.dma_start(S2MM, 0, ^bb1, ^bb5)
    ^bb1:  // 2 preds: ^bb0, ^bb2
      aie.use_lock(%lock_8_2_13, Acquire, 0)
      aie.dma_bd(%buffer_8_2_14 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_8_2_13, Release, 1)
      aie.next_bd ^bb2
    ^bb2:  // pred: ^bb1
      aie.use_lock(%lock_8_2, Acquire, 0)
      aie.dma_bd(%buffer_8_2 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_8_2, Release, 1)
      aie.next_bd ^bb1
    ^bb3:  // pred: ^bb5
      %1 = aie.dma_start(S2MM, 1, ^bb4, ^bb7)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_8_2_11, Acquire, 0)
      aie.dma_bd(%buffer_8_2_12 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_8_2_11, Release, 1)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb0
      %2 = aie.dma_start(MM2S, 0, ^bb6, ^bb3)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_8_2_10, Acquire, 1)
      aie.dma_bd(%buffer_8_2 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_8_2_10, Release, 0)
      aie.next_bd ^bb6
    ^bb7:  // pred: ^bb3
      aie.end
    }
    %tile_2_2 = aie.tile(2, 2)
    %tile_2_1 = aie.tile(2, 1)
    %tile_2_0 = aie.tile(2, 0)
    %tile_0_0 = aie.tile(0, 0)
    %switchbox_0_0 = aie.switchbox(%tile_0_0) {
    }
    %tile_7_2 = aie.tile(7, 2)
    %lock_7_2 = aie.lock(%tile_7_2, 1)
    %lock_7_2_15 = aie.lock(%tile_7_2, 3)
    %buffer_7_2 = aie.buffer(%tile_7_2) {sym_name = "buf2"} : memref<16x16xf32, 2>
    %lock_7_2_16 = aie.lock(%tile_7_2, 2)
    %buffer_7_2_17 = aie.buffer(%tile_7_2) {sym_name = "buf1"} : memref<16x16xf32, 2>
    %lock_7_2_18 = aie.lock(%tile_7_2, 0)
    %buffer_7_2_19 = aie.buffer(%tile_7_2) {sym_name = "buf0"} : memref<16x16xf32, 2>
    %mem_7_2 = aie.mem(%tile_7_2) {
      %0 = aie.dma_start(S2MM, 0, ^bb1, ^bb5)
    ^bb1:  // 2 preds: ^bb0, ^bb2
      aie.use_lock(%lock_7_2_18, Acquire, 0)
      aie.dma_bd(%buffer_7_2_19 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_7_2_18, Release, 1)
      aie.next_bd ^bb2
    ^bb2:  // pred: ^bb1
      aie.use_lock(%lock_7_2, Acquire, 0)
      aie.dma_bd(%buffer_7_2 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_7_2, Release, 1)
      aie.next_bd ^bb1
    ^bb3:  // pred: ^bb5
      %1 = aie.dma_start(S2MM, 1, ^bb4, ^bb7)
    ^bb4:  // 2 preds: ^bb3, ^bb4
      aie.use_lock(%lock_7_2_16, Acquire, 0)
      aie.dma_bd(%buffer_7_2_17 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_7_2_16, Release, 1)
      aie.next_bd ^bb4
    ^bb5:  // pred: ^bb0
      %2 = aie.dma_start(MM2S, 0, ^bb6, ^bb3)
    ^bb6:  // 2 preds: ^bb5, ^bb6
      aie.use_lock(%lock_7_2_15, Acquire, 1)
      aie.dma_bd(%buffer_7_2 : memref<16x16xf32, 2>) {len = 256 : i32}
      aie.use_lock(%lock_7_2_15, Release, 0)
      aie.next_bd ^bb6
    ^bb7:  // pred: ^bb3
      aie.end
    }
    %switchbox_2_0 = aie.switchbox(%tile_2_0) {
      aie.connect<SOUTH : 3, NORTH : 0>
      aie.connect<SOUTH : 7, NORTH : 1>
      aie.connect<NORTH : 0, SOUTH : 2>
      aie.connect<NORTH : 1, SOUTH : 3>
    }
    %switchbox_2_1 = aie.switchbox(%tile_2_1) {
      aie.connect<SOUTH : 0, EAST : 3>
      aie.connect<SOUTH : 1, EAST : 0>
      aie.connect<NORTH : 3, SOUTH : 0>
      aie.connect<EAST : 0, SOUTH : 1>
    }
    %switchbox_3_1 = aie.switchbox(%tile_3_1) {
      aie.connect<WEST : 3, EAST : 3>
      aie.connect<WEST : 0, EAST : 2>
      aie.connect<SOUTH : 0, EAST : 0>
      aie.connect<SOUTH : 1, NORTH : 3>
      aie.connect<EAST : 0, WEST : 0>
      aie.connect<NORTH : 3, SOUTH : 0>
      aie.connect<EAST : 3, SOUTH : 1>
    }
    %tile_4_1 = aie.tile(4, 1)
    %switchbox_4_1 = aie.switchbox(%tile_4_1) {
      aie.connect<WEST : 3, EAST : 2>
      aie.connect<WEST : 2, EAST : 3>
      aie.connect<WEST : 0, EAST : 1>
      aie.connect<EAST : 3, WEST : 0>
      aie.connect<EAST : 2, WEST : 3>
    }
    %tile_5_1 = aie.tile(5, 1)
    %switchbox_5_1 = aie.switchbox(%tile_5_1) {
      aie.connect<WEST : 2, EAST : 1>
      aie.connect<WEST : 3, EAST : 3>
      aie.connect<WEST : 1, EAST : 0>
      aie.connect<NORTH : 3, WEST : 3>
      aie.connect<NORTH : 0, WEST : 2>
    }
    %switchbox_6_1 = aie.switchbox(%tile_6_1) {
      aie.connect<WEST : 1, NORTH : 4>
      aie.connect<WEST : 3, NORTH : 0>
      aie.connect<WEST : 0, EAST : 1>
      aie.connect<SOUTH : 0, EAST : 3>
      aie.connect<SOUTH : 1, EAST : 0>
    }
    %switchbox_6_2 = aie.switchbox(%tile_6_2) {
      aie.connect<SOUTH : 4, EAST : 3>
      aie.connect<SOUTH : 0, EAST : 2>
      aie.connect<EAST : 3, WEST : 2>
      aie.connect<WEST : 3, EAST : 1>
      aie.connect<EAST : 0, WEST : 1>
    }
    %switchbox_7_2 = aie.switchbox(%tile_7_2) {
      aie.connect<WEST : 3, DMA : 0>
      aie.connect<WEST : 2, DMA : 1>
      aie.connect<DMA : 0, WEST : 3>
      aie.connect<WEST : 1, EAST : 0>
      aie.connect<EAST : 3, WEST : 0>
      aie.connect<SOUTH : 1, NORTH : 1>
      aie.connect<SOUTH : 2, NORTH : 2>
      aie.connect<SOUTH : 3, EAST : 3>
      aie.connect<SOUTH : 4, EAST : 2>
    }
    %switchbox_2_2 = aie.switchbox(%tile_2_2) {
      aie.connect<EAST : 1, SOUTH : 3>
    }
    %switchbox_3_2 = aie.switchbox(%tile_3_2) {
      aie.connect<EAST : 3, WEST : 1>
      aie.connect<SOUTH : 3, EAST : 3>
      aie.connect<NORTH : 0, SOUTH : 3>
    }
    %tile_4_2 = aie.tile(4, 2)
    %switchbox_4_2 = aie.switchbox(%tile_4_2) {
      aie.connect<EAST : 1, WEST : 3>
      aie.connect<WEST : 3, EAST : 2>
    }
    %tile_5_2 = aie.tile(5, 2)
    %switchbox_5_2 = aie.switchbox(%tile_5_2) {
      aie.connect<EAST : 2, WEST : 1>
      aie.connect<WEST : 2, EAST : 3>
      aie.connect<EAST : 1, SOUTH : 3>
      aie.connect<NORTH : 3, SOUTH : 0>
    }
    %switchbox_3_0 = aie.switchbox(%tile_3_0) {
      aie.connect<SOUTH : 3, NORTH : 0>
      aie.connect<SOUTH : 7, NORTH : 1>
      aie.connect<NORTH : 0, SOUTH : 2>
      aie.connect<NORTH : 1, SOUTH : 3>
    }
    %switchbox_7_1 = aie.switchbox(%tile_7_1) {
      aie.connect<WEST : 1, EAST : 2>
      aie.connect<WEST : 3, NORTH : 1>
      aie.connect<WEST : 0, NORTH : 2>
      aie.connect<SOUTH : 0, NORTH : 3>
      aie.connect<SOUTH : 1, NORTH : 4>
    }
    %tile_8_1 = aie.tile(8, 1)
    %switchbox_8_1 = aie.switchbox(%tile_8_1) {
      aie.connect<WEST : 2, NORTH : 1>
    }
    %switchbox_8_2 = aie.switchbox(%tile_8_2) {
      aie.connect<SOUTH : 1, DMA : 0>
      aie.connect<WEST : 0, DMA : 1>
      aie.connect<DMA : 0, WEST : 3>
      aie.connect<WEST : 3, NORTH : 3>
      aie.connect<WEST : 2, NORTH : 4>
    }
    %switchbox_6_0 = aie.switchbox(%tile_6_0) {
      aie.connect<SOUTH : 3, NORTH : 0>
      aie.connect<SOUTH : 7, NORTH : 1>
      aie.connect<NORTH : 0, SOUTH : 2>
      aie.connect<NORTH : 1, SOUTH : 3>
    }
    %switchbox_7_3 = aie.switchbox(%tile_7_3) {
      aie.connect<SOUTH : 1, DMA : 0>
      aie.connect<SOUTH : 2, DMA : 1>
      aie.connect<DMA : 0, WEST : 2>
      aie.connect<EAST : 0, WEST : 3>
    }
    %tile_3_3 = aie.tile(3, 3)
    %switchbox_3_3 = aie.switchbox(%tile_3_3) {
      aie.connect<EAST : 2, SOUTH : 0>
    }
    %tile_4_3 = aie.tile(4, 3)
    %switchbox_4_3 = aie.switchbox(%tile_4_3) {
      aie.connect<EAST : 1, WEST : 2>
    }
    %tile_5_3 = aie.tile(5, 3)
    %switchbox_5_3 = aie.switchbox(%tile_5_3) {
      aie.connect<EAST : 2, WEST : 1>
      aie.connect<EAST : 1, SOUTH : 3>
    }
    %tile_6_3 = aie.tile(6, 3)
    %switchbox_6_3 = aie.switchbox(%tile_6_3) {
      aie.connect<EAST : 2, WEST : 2>
      aie.connect<EAST : 3, WEST : 1>
    }
    %switchbox_7_0 = aie.switchbox(%tile_7_0) {
      aie.connect<SOUTH : 3, NORTH : 0>
      aie.connect<SOUTH : 7, NORTH : 1>
      aie.connect<NORTH : 0, SOUTH : 2>
      aie.connect<NORTH : 1, SOUTH : 3>
    }
    %switchbox_8_3 = aie.switchbox(%tile_8_3) {
      aie.connect<SOUTH : 3, DMA : 0>
      aie.connect<SOUTH : 4, DMA : 1>
      aie.connect<DMA : 0, WEST : 0>
    }
    %shim_mux_2_0 = aie.shim_mux(%tile_2_0) {
      aie.connect<DMA : 0, NORTH : 3>
      aie.connect<DMA : 1, NORTH : 7>
      aie.connect<NORTH : 2, DMA : 0>
      aie.connect<NORTH : 3, DMA : 1>
    }
    %shim_mux_3_0 = aie.shim_mux(%tile_3_0) {
      aie.connect<DMA : 0, NORTH : 3>
      aie.connect<DMA : 1, NORTH : 7>
      aie.connect<NORTH : 2, DMA : 0>
      aie.connect<NORTH : 3, DMA : 1>
    }
    %shim_mux_6_0 = aie.shim_mux(%tile_6_0) {
      aie.connect<DMA : 0, NORTH : 3>
      aie.connect<DMA : 1, NORTH : 7>
      aie.connect<NORTH : 2, DMA : 0>
      aie.connect<NORTH : 3, DMA : 1>
    }
    %shim_mux_7_0 = aie.shim_mux(%tile_7_0) {
      aie.connect<DMA : 0, NORTH : 3>
      aie.connect<DMA : 1, NORTH : 7>
      aie.connect<NORTH : 2, DMA : 0>
      aie.connect<NORTH : 3, DMA : 1>
    }
  }
}

