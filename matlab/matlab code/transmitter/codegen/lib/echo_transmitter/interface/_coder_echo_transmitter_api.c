/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_echo_transmitter_api.c
 *
 * Code generation for function 'echo_transmitter'
 *
 */

/* Include files */
#include "_coder_echo_transmitter_api.h"
#include "_coder_echo_transmitter_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;

emlrtContext emlrtContextGlobal = {
    true,                                                 /* bFirstTime */
    false,                                                /* bInitialized */
    131642U,                                              /* fVersionInfo */
    NULL,                                                 /* fErrorFunction */
    "echo_transmitter",                                   /* fFunctionName */
    NULL,                                                 /* fRTCallStack */
    false,                                                /* bDebugMode */
    {2045744189U, 2170104910U, 2743257031U, 4284093946U}, /* fSigWrd */
    NULL                                                  /* fSigMem */
};

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[32];

static const mxArray *b_emlrt_marshallOut(const real_T u[24576]);

static real_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[32];

static const mxArray *c_emlrt_marshallOut(const real_T u[16384]);

static const mxArray *d_emlrt_marshallOut(const real_T u[54000]);

static const mxArray *e_emlrt_marshallOut(const real_T u[108]);

static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *data_bits,
                                 const char_T *identifier))[32];

static const mxArray *emlrt_marshallOut(const real_T u[94960]);

static void f_emlrt_marshallOut(const real_T u[32], const mxArray *y);

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[32]
{
  real_T(*y)[32];
  y = c_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static const mxArray *b_emlrt_marshallOut(const real_T u[24576])
{
  static const int32_T iv[2] = {0, 0};
  static const int32_T iv1[2] = {1, 24576};
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

static real_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[32]
{
  static const int32_T dims = 32;
  real_T(*ret)[32];
  int32_T i;
  boolean_T b = false;
  emlrtCheckVsBuiltInR2012b((emlrtConstCTX)sp, msgId, src, "double", false, 1U,
                            (const void *)&dims, &b, &i);
  ret = (real_T(*)[32])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static const mxArray *c_emlrt_marshallOut(const real_T u[16384])
{
  static const int32_T iv[2] = {0, 0};
  static const int32_T iv1[2] = {1, 16384};
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

static const mxArray *d_emlrt_marshallOut(const real_T u[54000])
{
  static const int32_T iv[2] = {0, 0};
  static const int32_T iv1[2] = {1, 54000};
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

static const mxArray *e_emlrt_marshallOut(const real_T u[108])
{
  static const int32_T iv[2] = {0, 0};
  static const int32_T iv1[2] = {1, 108};
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *data_bits,
                                 const char_T *identifier))[32]
{
  emlrtMsgIdentifier thisId;
  real_T(*y)[32];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(data_bits), &thisId);
  emlrtDestroyArray(&data_bits);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u[94960])
{
  static const int32_T iv[2] = {0, 0};
  static const int32_T iv1[2] = {1, 94960};
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

static void f_emlrt_marshallOut(const real_T u[32], const mxArray *y)
{
  static const int32_T i = 32;
  emlrtMxSetData((mxArray *)y, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)y, &i, 1);
}

void echo_transmitter_api(const mxArray *prhs, int32_T nlhs,
                          const mxArray *plhs[6])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *prhs_copy_idx_0;
  real_T(*output_signal)[94960];
  real_T(*data_sig)[54000];
  real_T(*cw_sig)[24576];
  real_T(*sync_sig)[16384];
  real_T(*encoded_bits_coder)[108];
  real_T(*data_bits)[32];
  st.tls = emlrtRootTLSGlobal;
  output_signal = (real_T(*)[94960])mxMalloc(sizeof(real_T[94960]));
  cw_sig = (real_T(*)[24576])mxMalloc(sizeof(real_T[24576]));
  sync_sig = (real_T(*)[16384])mxMalloc(sizeof(real_T[16384]));
  data_sig = (real_T(*)[54000])mxMalloc(sizeof(real_T[54000]));
  encoded_bits_coder = (real_T(*)[108])mxMalloc(sizeof(real_T[108]));
  prhs_copy_idx_0 = emlrtProtectR2012b(prhs, 0, true, -1);
  /* Marshall function inputs */
  data_bits = emlrt_marshallIn(&st, emlrtAlias(prhs_copy_idx_0), "data_bits");
  /* Invoke the target function */
  echo_transmitter(*data_bits, *output_signal, *cw_sig, *sync_sig, *data_sig,
                   *encoded_bits_coder);
  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*output_signal);
  if (nlhs > 1) {
    plhs[1] = b_emlrt_marshallOut(*cw_sig);
  }
  if (nlhs > 2) {
    plhs[2] = c_emlrt_marshallOut(*sync_sig);
  }
  if (nlhs > 3) {
    plhs[3] = d_emlrt_marshallOut(*data_sig);
  }
  if (nlhs > 4) {
    plhs[4] = e_emlrt_marshallOut(*encoded_bits_coder);
  }
  if (nlhs > 5) {
    f_emlrt_marshallOut(*data_bits, prhs_copy_idx_0);
    plhs[5] = prhs_copy_idx_0;
  }
}

void echo_transmitter_atexit(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  echo_transmitter_xil_terminate();
  echo_transmitter_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void echo_transmitter_initialize(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, NULL);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

void echo_transmitter_terminate(void)
{
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (_coder_echo_transmitter_api.c) */
