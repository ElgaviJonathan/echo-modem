/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * sync_correlator.h
 *
 * Code generation for function 'sync_correlator'
 *
 */

#ifndef SYNC_CORRELATOR_H
#define SYNC_CORRELATOR_H

/* Include files */
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern void sync_correlator(const double input_signal[32768],
                            const double gold_code_signal[16384],
                            double threshold, double start_index,
                            double coherent_detection,
                            boolean_T *signal_detected, double *end_index);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (sync_correlator.h) */
