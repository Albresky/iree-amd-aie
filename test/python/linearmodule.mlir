module @module {
  func.func @main(%arg0: !torch.vtensor<[4],f32>) -> !torch.vtensor<[3],f32> attributes {torch.assume_strict_symbolic_shapes} {
    %0 = torch.vtensor.literal(dense_resource<torch_tensor_4_3_torch.float32> : tensor<4x3xf32>) : !torch.vtensor<[4,3],f32>
    %1 = torch.aten.matmul %arg0, %0 : !torch.vtensor<[4],f32>, !torch.vtensor<[4,3],f32> -> !torch.vtensor<[3],f32>
    %2 = torch.vtensor.literal(dense_resource<torch_tensor_3_torch.float32> : tensor<3xf32>) : !torch.vtensor<[3],f32>
    %int1 = torch.constant.int 1
    %3 = torch.aten.add.Tensor %1, %2, %int1 : !torch.vtensor<[3],f32>, !torch.vtensor<[3],f32>, !torch.int -> !torch.vtensor<[3],f32>
    return %3 : !torch.vtensor<[3],f32>
  }
}

{-#
  dialect_resources: {
    builtin: {
      torch_tensor_4_3_torch.float32: "0x0400000046AEDF3FAFD9FC3E6483054045638C3F079D2CBFF3D3853FFB14C2BF66DC61BE044DD9BC67E663BEABBF9B3F7630C93E",
      torch_tensor_3_torch.float32: "0x04000000D5FAB5BDE3BA983F18381F3F"
    }
  }
#-}
