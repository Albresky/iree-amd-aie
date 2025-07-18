// Copyright 2025 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include <stdint.h>

#include <aie_api/aie.hpp>

#define SM_VEC_LEN 16
#define log2e 1.44269504089

void softmax_simple_bf16(bfloat16 *restrict input_matrix,
                         bfloat16 *restrict output_matrix,
                         const int32_t num_rows, const int32_t num_cols) {
  event0();

  for (int row = 0; row < num_rows; row++) {
    int num_elems = num_cols;
    float accum_exp_val;

    bfloat16 *restrict input_vector = input_matrix + row * num_cols;
    bfloat16 *restrict output_vector = output_matrix + row * num_cols;
    auto it_exp_in = aie::cbegin_vector<16>((bfloat16 *)input_vector);
    auto it_exp_out = aie::begin_vector<16>((bfloat16 *)output_vector);
    auto it_scale = aie::cbegin_restrict_vector<16>((bfloat16 *)output_vector);
    auto it_soft_out =
        aie::begin_restrict_vector<16>((bfloat16 *)output_vector);

    bfloat16 col_sum_inv;
    aie::vector<bfloat16, 16> in_elems, va;
    aie::accum<accfloat, 16> out_vals;
    int col_iters = num_elems >> 4;
    accum_exp_val = 0;

    /////////////////////
    //// Compute exp ////
    /////////////////////
    aie::vector<bfloat16, SM_VEC_LEN> exp_val;
    aie::vector<float, SM_VEC_LEN> input_fp32;
    aie::vector<bfloat16, SM_VEC_LEN> log2e_vec =
        aie::broadcast<bfloat16, SM_VEC_LEN>(log2e);

    const int elem_iters = num_elems / SM_VEC_LEN;
    aie::vector<bfloat16, SM_VEC_LEN> input_bf16;
    aie::accum<accfloat, SM_VEC_LEN> exp_val_accum;
    exp_val_accum = aie::zeros<accfloat, SM_VEC_LEN>();
    for (int i = 0; i < elem_iters; i++) {
      input_bf16 = *it_exp_in++;
      aie::accum<accfloat, 16> exp_in;
      exp_in = aie::mul(input_bf16, log2e_vec);
      exp_val = aie::exp2<bfloat16>(exp_in.to_vector<float>());
      exp_val_accum = add(exp_val_accum, exp_val);
      *it_exp_out++ = exp_val;
    }
    aie::vector<float, SM_VEC_LEN> reduce = exp_val_accum.to_vector<float>();
    accum_exp_val = aie::reduce_add(reduce);
    /////////////////////

    col_sum_inv = (bfloat16)aie::inv(accum_exp_val);
    for (int c = 0; c < col_iters; c++) {
      in_elems = *it_scale++;
      out_vals = aie::mul(in_elems, col_sum_inv);
      *it_soft_out++ = out_vals.to_vector<bfloat16>();
    }
  }

  event1();

  return;
}

// clang-format off
extern "C" {

#define softmax_bf16_c_func(M, N)                                  \
  void softmax_bf16_##M##x##N(bfloat16 *input, bfloat16 *output) { \
    softmax_simple_bf16(input, output, M, N);                      \
  }

softmax_bf16_c_func(4, 1024)

}  // extern "C"
// clang-format on
