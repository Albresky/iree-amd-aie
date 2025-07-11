module @module {
  util.global private @__auto.weight = #stream.parameter.named<"model"::"weight"> : tensor<4x3xf32>
  util.global private @__auto.bias = #stream.parameter.named<"model"::"bias"> : tensor<3xf32>
  func.func @main(%arg0: !torch.vtensor<[4],f32>) -> !torch.vtensor<[3],f32> attributes {torch.assume_strict_symbolic_shapes} {
    %__auto.weight = util.global.load @__auto.weight : tensor<4x3xf32>
    %0 = torch_c.from_builtin_tensor %__auto.weight : tensor<4x3xf32> -> !torch.vtensor<[4,3],f32>
    %1 = torch.aten.matmul %arg0, %0 : !torch.vtensor<[4],f32>, !torch.vtensor<[4,3],f32> -> !torch.vtensor<[3],f32>
    %__auto.bias = util.global.load @__auto.bias : tensor<3xf32>
    %2 = torch_c.from_builtin_tensor %__auto.bias : tensor<3xf32> -> !torch.vtensor<[3],f32>
    %int1 = torch.constant.int 1
    %3 = torch.aten.add.Tensor %1, %2, %int1 : !torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>, !torch.int -> !torch.vtensor<[3],f32>
    return %3 : !torch.vtensor<[3],f32>
  }
}
