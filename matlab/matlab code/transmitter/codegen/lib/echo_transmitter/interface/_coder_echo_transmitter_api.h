/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_echo_transmitter_api.h
 *
 * Code generation for function 'echo_transmitter'
 *
 */

#ifndef _CODER_ECHO_TRANSMITTER_API_H
#define _CODER_ECHO_TRANSMITTER_API_H

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
void echo_transmitter(real_T data_bits[32], real_T output_signal[94960],
                      real_T cw_sig[24576], real_T sync_sig[16384],
                      real_T data_sig[54000], real_T encoded_bits_coder[108]);

void echo_transmitter_api(const mxArray *prhs, int32_T nlhs,
                          const mxArray *plhs[6]);

void echo_transmitter_atexit(void);

void echo_transmitter_initialize(void);

void echo_transmitter_terminate(void);

void echo_transmitter_xil_shutdown(void);

void echo_transmitter_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (_coder_echo_transmitter_api.h) */
