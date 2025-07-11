## AMDAIEOps 操作定义表格

### 1. 工作组相关操作

| 操作名称 | 助记符 | 特征 | 操作数 | 结果 | 描述 |
|---------|--------|------|--------|------|-------|
| AMDAIE_ControlCodeOp | controlcode | HasParent<"WorkgroupOp">, SingleBlock, Terminator | - | - | 包含主机控制代码指令的操作。控制代码操作包含工作组在单个块中的主机代码指令。因此，此操作预期始终具有工作组父级，并且预期是此父级的终结符。 |
| AMDAIE_CoreOp | core | SingleBlock, AttrSizedOperandSegments | tile(Index), input_dmas(Variadic<Index>), output_dmas(Variadic<Index>), stack_size(DefaultValuedAttr<I32Attr, "1024">), link_with(OptionalAttr<StrAttr>) | Index | AIE核心操作符。表示一个AIE核心操作，在其主体中包含要在此核心上执行的操作序列。核心通过瓦片指定，指示AIE阵列中的位置。具有可选的link_with属性和stack_size属性。 |
| AMDAIE_EndOp | end | Terminator | - | - | AMDAIE操作区域的通用终结符。 |
| AMDAIE_FlowOp | flow | AttrSizedOperandSegments | sources(Variadic<Index>), targets(Variadic<Index>), is_packet_flow(BoolAttr), packet_id(OptionalAttr<UI8Attr>) | Index | 源和目标通道集合之间的数据连接。表示源和目标通道之间的连接，用于描述通道之间的逻辑数据路由配置。支持单源多目标（广播）和多源单目标（合并）模式。 |
| AMDAIE_TileOp | tile | Pure, DeclareOpInterfaceMethods<OpAsmOpInterface> | col(Index), row(Index) | Index | 指示AIE阵列上位置的AIE瓦片操作符。通过坐标(col, row)指定瓦片，指示AIE阵列中的位置。与AIE方言中定义的TileOp不同，它接受列和行作为索引而不是整数。 |
| AMDAIE_WorkgroupOp | workgroup | SingleBlock | npu_instructions(OptionalAttr), ctrlpkt_sequence(OptionalAttr) | - | AIE工作组区域。工作组包含：1.一组带有GPU并行映射属性的forall循环；2.表示内存层次结构中不同内存之间数据移动的DmaCpyNdOps；3.计算操作（linalg）；4.新插入的ControlCodeOp。 |

### 2. 缓冲区和锁操作

| 操作名称 | 助记符 | 特征 | 操作数 | 结果 | 描述 |
|---------|--------|------|--------|------|-------|
| AMDAIE_BufferOp | buffer | DeclareOpInterfaceMethods<OpAsmOpInterface> | tile(Index), address(OptionalAttr<UI32Attr>) | AnyMemRef | 表示AIE瓦片上的缓冲区。缓冲区可以有可选的地址，指示缓冲区在瓦片上的位置。 |
| AMDAIE_LockOp | lock | Pure, DeclareOpInterfaceMethods<OpAsmOpInterface> | tile(Index), value(ConfinedAttr<I8Attr>), init_value(OptionalAttr<I8Attr>) | Index | 表示AIE瓦片上的物理锁。通过瓦片和锁ID值完全指定，指定要使用的确切物理锁。接受可选的初始化值。 |
| AMDAIE_UseLockOp | use_lock | - | lock(Index), action(AMDAIE_LockAction), value(I8Attr) | - | 表示使用具有指定动作（获取/释放）的信号量锁。锁动作可以是Acquire、AcquireGreaterOrEqual或Release。 |

### 3. DMA实用操作

| 操作名称 | 助记符 | 特征 | 操作数 | 结果 | 描述 |
|---------|--------|------|--------|------|-------|
| AMDAIE_BdIdOp | bd_id | Pure, DeclareOpInterfaceMethods<OpAsmOpInterface> | tile(Index), value(Index) | Index | 表示AIE瓦片上的物理缓冲区描述符ID。通过瓦片和ID值指定，指定要在瓦片上使用的确切本地缓冲区描述符。 |
| AMDAIE_ChannelOp | channel | Pure, DeclareOpInterfaceMethods<OpAsmOpInterface> | tile(Index), value(ConfinedAttr<I8Attr>), port_type(StrmSwPortTypeAttr), direction(DMAChannelDir) | Index | 表示AIE瓦片上的物理输入或输出通道/端口。通过瓦片和通道ID值完全指定，指定要使用的确切物理DMA通道/端口。 |

### 4. NPU操作

| 操作名称 | 助记符 | 特征 | 操作数 | 结果 | 描述 |
|---------|--------|------|--------|------|-------|
| AMDAIE_NpuAddressPatchOp | npu.address_patch | - | col(UI32Attr), bd_id(UI32Attr), arg_idx(UI32Attr), offset(UI32Attr) | - | 修补缓冲区描述符内地址的操作。使编译时能够提供参数索引和偏移量，然后在运行时由固件转换为物理地址。 |
| AMDAIE_NpuDmaCpyNdOp | npu.dma_cpy_nd | AttrSizedOperandSegments, DoublyStridedOpInterface | connection(Index), target相关参数, source相关参数 | Variadic<AMDAIE_AnyAsyncTokenType> | NPU微控制器的DMA操作符。表示由NPU微控制器执行的具有无限维数的跨步复制操作。支持部分静态表示和异步执行。 |
| AMDAIE_NpuDmaPlaceHolderOp | npu.dma_placeholder | - | connection(Index) | - | 表示DMA操作的占位符。作为amdaie.connection操作的占位符用户，防止它们被死代码消除。 |
| AMDAIE_NpuHalfDmaCpyNdOp | npu.half_dma_cpy_nd | AttrSizedOperandSegments, OffsetSizeAndStrideOpInterface | connection(Index), input(LogicalObjectFifo), offsets/sizes/strides, bd_id等 | Optional<AsyncTokenType> | NPU微控制器的DMA操作，在单个端口上操作。支持BD链接功能。 |
| AMDAIE_NpuCircularDmaCpyNdOp | npu.circular_dma_cpy_nd | AMDAIE_CircularDmaOp, AttrSizedOperandSegments, DoublyStridedOpInterface | connection(Index), target/source offsets/sizes/strides | Index | NPU微控制器的循环DMA操作符。表示将无限期持续的跨步复制操作。 |
| AMDAIE_NpuDmaWaitOp | npu.dma_wait | - | async_tokens(Variadic<AMDAIE_AnyAsyncTokenType>) | - | 等待NPU DMA操作完成。将阻塞引用的依赖操作。 |
| AMDAIE_NpuBarrierOp | npu.barrier | - | - | - | NPU控制器中停止等待/同步优化的边界。 |
| AMDAIE_NpuPushToQueueOp | npu.push_to_queue | - | col等属性 | Optional<AsyncTokenType> | 将提供的BD推送到指定通道的队列。 |
| AMDAIE_NpuWriteBdOp | npu.write_bd | - | 多个配置属性 | - | 使用指定ID初始化缓冲区描述符。 |
| AMDAIE_NpuTctSyncOp | npu.tct_sync | - | col等属性 | - | 等待TCT被发射。 |
| AMDAIE_NpuControlPacketOp | npu.control_packet | - | address等属性 | - | AIE控制数据包。表示AIE控制数据包头和可选负载。 |

### 5. 逻辑对象FIFO操作

| 操作名称 | 助记符 | 特征 | 操作数 | 结果 | 描述 |
|---------|--------|------|--------|------|-------|
| AMDAIE_ConnectionOp | connection | Pure, CopyOpInterface, AttrSizedOperandSegments | target(LogicalObjectFifo), source(LogicalObjectFifo), channels, flow等 | Index | 两个逻辑对象FIFO之间的连接。表示逻辑对象FIFO之间的连接，可被DMA操作引用。 |
| AMDAIE_LogicalObjectFifoAccessOp | logicalobjectfifo.access | - | input(LogicalObjectFifo), access_type(MemoryAccess) | AnyMemRef | 从逻辑对象FIFO访问封装的memref的操作。返回逻辑对象FIFO中封装的memref。 |
| AMDAIE_LogicalObjectFifoAcquire | logicalobjectfifo.acquire | - | dma(Index), port(LogicalObjectFifoPort), size(OptionalAttr<I32Attr>) | LogicalObjectFifoType | 从逻辑对象FIFO DMA操作获取对象的信号量操作。 |
| AMDAIE_LogicalObjectFifoFromBuffersOp | logicalobjectfifo.from_buffers | LogicalObjFifoOpInterface, Pure, AttrSizedOperandSegments | buffers(Variadic<AnyMemRef>), producerLocks等 | LogicalObjectFifoType | 从一组缓冲区创建逻辑对象FIFO。封装一组memref缓冲区，通过生产者和消费者锁添加同步功能。 |
| AMDAIE_LogicalObjectFifoFromMemrefOp | logicalobjectfifo.from_memref | LogicalObjFifoOpInterface等 | memref(AnyMemRef), tiles(Variadic<Index>) | LogicalObjectFifoType | 从memref创建逻辑对象FIFO。封装一个memref，添加同步功能。 |
| AMDAIE_LogicalObjectFifoPlaceholderOp | logicalobjectfifo.placeholder | LogicalObjFifoOpInterface, Pure | tiles(Variadic<Index>) | LogicalObjectFifoType | 逻辑对象FIFO的占位符。表示逻辑对象FIFO的占位符，实际的逻辑对象FIFO可以稍后提供。 |
| AMDAIE_LogicalObjectFifoRelease | logicalobjectfifo.release | - | dma等参数 | - | 从逻辑对象FIFO DMA操作释放对象的信号量操作。 |

### 6. DMA复制操作基类

| 操作名称 | 助记符 | 特征 | 操作数 | 结果 | 描述 |
|---------|--------|------|--------|------|-------|
| AMDAIE_DmaCpyNdOp | dma_cpy_nd | DoublyStridedCopyOpInterface等 | target/source LogicalObjectFifo及相关参数 | Index | DMA复制操作符。表示从源到目标逻辑对象FIFO的具有无限维数的跨步复制操作。 |
| AMDAIE_CircularDmaCpyNdOp | circular_dma_cpy_nd | Pure等 | 同上 | Index | 循环DMA复制操作符。无限期地复制数据，等待在源逻辑对象FIFO上产生数据并产生到目标逻辑对象FIFO中。 |
| AMDAIE_ReferenceToOp | reference_to | SameOperandsAndResultType | memref(AnyMemRef) | AnyMemRef | 创建对memref分配引用的操作。创建对全局memref分配的引用，具有不可跨越scf.forall/scf.for循环提升的本地作用域。 |

这个表格展示了AMD AIE方言中定义的所有操作，包括它们的功能、参数和用途。每个操作都有详细的中文描述，说明了它们在AIE硬件编程模型中的作用。