module {
  func.func @main_graph(%arg0: !torch.vtensor<[1,10],f32>) -> !torch.vtensor<[1,5],f32> attributes {torch.onnx_meta.ir_version = 8 : si64, torch.onnx_meta.opset_version = 17 : si64, torch.onnx_meta.producer_name = "pytorch", torch.onnx_meta.producer_version = "2.7.1"} {
    %0 = torch.operator "onnx.Constant"() {torch.onnx.value = dense_resource<_linear.weight> : tensor<5x10xf32>} : () -> !torch.vtensor<[5,10],f32> 
    %1 = torch.operator "onnx.Constant"() {torch.onnx.value = dense_resource<_linear.bias> : tensor<5xf32>} : () -> !torch.vtensor<[5],f32> 
    %none = torch.constant.none
    %2 = torch.operator "onnx.Gemm"(%arg0, %0, %1) {torch.onnx.alpha = 1.000000e+00 : f32, torch.onnx.beta = 1.000000e+00 : f32, torch.onnx.transB = 1 : si64} : (!torch.vtensor<[1,10],f32>, !torch.vtensor<[5,10],f32>, !torch.vtensor<[5],f32>) -> !torch.vtensor<[1,5],f32> 
    %3 = torch.operator "onnx.Relu"(%2) : (!torch.vtensor<[1,5],f32>) -> !torch.vtensor<[1,5],f32> 
    return %3 : !torch.vtensor<[1,5],f32>
  }
}

{-#
  dialect_resources: {
    builtin: {
      _linear.weight: "0x08000000C28090BE8116163D5497D0BD422A2E3E4E45D63D64B03A3E8C81993EB58784BE88629E3EC6F6373D724577BD67101FBED0927CBE31816DBD5051D53D76D16E3D91B08EBE269E553EBBC332BEF8198CBECA36823E7B04133E3A58FB3DA486B2BD3AD041BE978667BE2FDE30BEE19432BE1D2F57BD5292423E61480E3E2A1D933D960CFEBD9DFF87BED7B335BE1938DFBD355BDA3DECEC5C3E4146013E32913F3D7A9E8B3EFC60903E6A7D143E6D3D6EBC6FE19BBD843C9FBEB72D703E8016793D60B9883E6AA900BD",
      _linear.bias: "0x08000000FB7C8D3E303798BD14AA17BE2DED93BE6612923E"
    }
  }
#-}

