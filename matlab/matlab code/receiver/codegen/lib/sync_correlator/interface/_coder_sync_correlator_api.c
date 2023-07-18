/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_sync_correlator_api.c
 *
 * Code generation for function 'sync_correlator'
 *
 */

/* Include files */
#include "_coder_sync_correlator_api.h"
#include "_coder_sync_correlator_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;

emlrtContext emlrtContextGlobal = {
    true,                                                 /* bFirstTime */
    false,                                                /* bInitialized */
    131642U,                                              /* fVersionInfo */
    NULL,                                                 /* fErrorFunction */
    "sync_correlator",                                    /* fFunctionName */
    NULL,                                                 /* fRTCallStack */
    false,                                                /* bDebugMode */
    {2045744189U, 2170104910U, 2743257031U, 4284093946U}, /* fSigWrd */
    NULL                                                  /* fSigMem */
};

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[32768];

static const mxArray *b_emlrt_marshallOut(const real_T u);

static real_T (*c_emlrt_marshallIn(const emlrtStack *sp,
                                   const mxArray *gold_code_signal,
                                   const char_T *identifier))[16384];

static real_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[16384];

static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *threshold,
                                 const char_T *identifier);

static real_T (*emlrt_marshallIn(const emlrtStack *sp,
                                 const mxArray *input_signal,
                                 const char_T *identifier))[32768];

static const mxArray *emlrt_marshallOut(const boolean_T u);

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId);

static real_T (*g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[32768];

static real_T (*h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[16384];

static real_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[32768]
{
  real_T(*y)[32768];
  y = g_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static const mxArray *b_emlrt_marshallOut(const real_T u)
{
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m);
  return y;
}

static real_T (*c_emlrt_marshallIn(const emlrtStack *sp,
                                   const mxArray *gold_code_signal,
                                   const char_T *identifier))[16384]
{
  emlrtMsgIdentifier thisId;
  real_T(*y)[16384];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(gold_code_signal), &thisId);
  emlrtDestroyArray(&gold_code_signal);
  return y;
}

static real_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[16384]
{
  real_T(*y)[16384];
  y = h_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *threshold,
                                 const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = f_emlrt_marshallIn(sp, emlrtAlias(threshold), &thisId);
  emlrtDestroyArray(&threshold);
  return y;
}

static real_T (*emlrt_marshallIn(const emlrtStack *sp,
                                 const mxArray *input_signal,
                                 const char_T *identifier))[32768]
{
  emlrtMsgIdentifier thisId;
  real_T(*y)[32768];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(input_signal), &thisId);
  emlrtDestroyArray(&input_signal);
  return y;
}

static const mxArray *emlrt_marshallOut(const boolean_T u)
{
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateLogicalScalar(u);
  emlrtAssign(&y, m);
  return y;
}

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = i_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T (*g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[32768]
{
  static const int32_T dims = 32768;
  real_T(*ret)[32768];
  int32_T i;
  boolean_T b = false;
  emlrtCheckVsBuiltInR2012b((emlrtConstCTX)sp, msgId, src, "double", false, 1U,
                            (const void *)&dims, &b, &i);
  ret = (real_T(*)[32768])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T (*h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[16384]
{
  static const int32_T dims[2] = {1, 16384};
  real_T(*ret)[16384];
  int32_T iv[2];
  boolean_T bv[2] = {false, false};
  emlrtCheckVsBuiltInR2012b((emlrtConstCTX)sp, msgId, src, "double", false, 2U,
                            (const void *)&dims[0], &bv[0], &iv[0]);
  ret = (real_T(*)[16384])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId)
{
  static const int32_T dims = 0;
  real_T ret;
  emlrtCheckBuiltInR2012b((emlrtConstCTX)sp, msgId, src, "double", false, 0U,
                          (const void *)&dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void sync_correlator_api(const mxArray *const prhs[5], int32_T nlhs,
                         const mxArray *plhs[2])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  real_T(*input_signal)[32768];
  real_T(*gold_code_signal)[16384];
  real_T coherent_detection;
  real_T end_index;
  real_T start_index;
  real_T threshold;
  boolean_T signal_detected;
  st.tls = emlrtRootTLSGlobal;
  /* Marshall function inputs */
  input_signal = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "input_signal");
  gold_code_signal =
      c_emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "gold_code_signal");
  threshold = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "threshold");
  start_index = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[3]), "start_index");
  coherent_detection =
      e_emlrt_marshallIn(&st, emlrtAliasP(prhs[4]), "coherent_detection");
  /* Invoke the target function */
  sync_correlator(*input_signal, *gold_code_signal, threshold, start_index,
                  coherent_detection, &signal_detected, &end_index);
  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(signal_detected);
  if (nlhs > 1) {
    plhs[1] = b_emlrt_marshallOut(end_index);
  }
}

void sync_correlator_atexit(void)
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
  sync_correlator_xil_terminate();
  sync_correlator_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void sync_correlator_initialize(void)
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

void sync_correlator_terminate(void)
{
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (_coder_sync_correlator_api.c) */
