/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_sync_correlator_api.h
 *
 * Code generation for function 'sync_correlator'
 *
 */

#ifndef _CODER_SYNC_CORRELATOR_API_H
#define _CODER_SYNC_CORRELATOR_API_H

/* Include files */
#include "emlrt.h"
#include "tmwtypes.h"
#include <string.h>

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void sync_correlator(real_T input_signal[32768], real_T gold_code_signal[16384],
                     real_T threshold, real_T start_index,
                     real_T coherent_detection, boolean_T *signal_detected,
                     real_T *end_index);

void sync_correlator_api(const mxArray *const prhs[5], int32_T nlhs,
                         const mxArray *plhs[2]);

void sync_correlator_atexit(void);

void sync_correlator_initialize(void);

void sync_correlator_terminate(void);

void sync_correlator_xil_shutdown(void);

void sync_correlator_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (_coder_sync_correlator_api.h) */
