/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_echo_transmitter_mex.c
 *
 * Code generation for function 'echo_transmitter'
 *
 */

/* Include files */
#include "_coder_echo_transmitter_mex.h"
#include "_coder_echo_transmitter_api.h"

/* Function Definitions */
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&echo_transmitter_atexit);
  /* Module initialization. */
  echo_transmitter_initialize();
  /* Dispatch the entry-point. */
  unsafe_echo_transmitter_mexFunction(nlhs, plhs, nrhs, prhs);
  /* Module termination. */
  echo_transmitter_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL, "windows-1252", true);
  return emlrtRootTLSGlobal;
}

void unsafe_echo_transmitter_mexFunction(int32_T nlhs, mxArray *plhs[6],
                                         int32_T nrhs, const mxArray *prhs[1])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *outputs[6];
  int32_T i;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 1, 4,
                        16, "echo_transmitter");
  }
  if (nlhs > 6) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 16,
                        "echo_transmitter");
  }
  /* Call the function. */
  echo_transmitter_api(prhs[0], nlhs, outputs);
  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    i = 1;
  } else {
    i = nlhs;
  }
  emlrtReturnArrays(i, &plhs[0], &outputs[0]);
}

/* End of code generation (_coder_echo_transmitter_mex.c) */
