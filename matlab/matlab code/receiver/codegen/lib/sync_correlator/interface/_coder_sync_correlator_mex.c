/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_sync_correlator_mex.c
 *
 * Code generation for function 'sync_correlator'
 *
 */

/* Include files */
#include "_coder_sync_correlator_mex.h"
#include "_coder_sync_correlator_api.h"

/* Function Definitions */
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&sync_correlator_atexit);
  /* Module initialization. */
  sync_correlator_initialize();
  /* Dispatch the entry-point. */
  unsafe_sync_correlator_mexFunction(nlhs, plhs, nrhs, prhs);
  /* Module termination. */
  sync_correlator_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL, "windows-1252", true);
  return emlrtRootTLSGlobal;
}

void unsafe_sync_correlator_mexFunction(int32_T nlhs, mxArray *plhs[2],
                                        int32_T nrhs, const mxArray *prhs[5])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *b_prhs[5];
  const mxArray *outputs[2];
  int32_T i;
  int32_T i1;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 5) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 5, 4,
                        15, "sync_correlator");
  }
  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 15,
                        "sync_correlator");
  }
  /* Call the function. */
  for (i = 0; i < 5; i++) {
    b_prhs[i] = prhs[i];
  }
  sync_correlator_api(b_prhs, nlhs, outputs);
  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    i1 = 1;
  } else {
    i1 = nlhs;
  }
  emlrtReturnArrays(i1, &plhs[0], &outputs[0]);
}

/* End of code generation (_coder_sync_correlator_mex.c) */
