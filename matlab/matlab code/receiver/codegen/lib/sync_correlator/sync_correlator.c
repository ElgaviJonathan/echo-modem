/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * sync_correlator.c
 *
 * Code generation for function 'sync_correlator'
 *
 */

/* Include files */
#include "sync_correlator.h"
#include <math.h>

/* Function Definitions */
void sync_correlator(const double input_signal[32768],
                     const double gold_code_signal[16384], double threshold,
                     double start_index, double coherent_detection,
                     boolean_T *signal_detected, double *end_index)
{
  double b_i;
  double corr_test;
  double internal_threshold;
  double j;
  int c_i;
  int i;
  int i1;
  int i2;
  boolean_T exitg1;
  /* This funciton searches for a gold code signal in the input signal, using */
  /*  correlation */
  /*  The threshold is schaled by the length of the gold code signal */
  /*  the start index notes at what point the preamble could appeare in the */
  /*  input signal (based on external previos information) */
  *signal_detected = false;
  *end_index = 32768.0;
  internal_threshold = threshold * 16384.0;
  i = 0;
  exitg1 = false;
  while ((!exitg1) &&
         (i <= (int)((1.0 - ((start_index - 16384.0) + 1.0)) + 16384.0) - 1)) {
    b_i = ((start_index - 16384.0) + 1.0) + (double)i;
    /*  from possible start of seq to possible end */
    if (b_i > (b_i + 16384.0) - 1.0) {
      c_i = 1;
    } else {
      c_i = (int)b_i;
    }
    corr_test = 0.0;
    for (i1 = 0; i1 < 16384; i1++) {
      corr_test += gold_code_signal[i1] * input_signal[(c_i + i1) - 1];
    }
    if (!(coherent_detection == 1.0)) {
      corr_test = fabs(corr_test);
    }
    if (corr_test >= internal_threshold) {
      internal_threshold = corr_test;
      *signal_detected = true;
      *end_index = b_i + 16384.0;
      /*  Additional search to find peak (after threshold */
      /*  condition in met), in case first pass is not max value: */
      if (b_i + 2000.0 <= 16384.0) {
        corr_test = b_i + 2000.0;
      } else {
        corr_test = 16384.0;
      }
      c_i = (int)(corr_test + (1.0 - (b_i + 1.0)));
      for (i = 0; i < c_i; i++) {
        j = (b_i + 1.0) + (double)i;
        if (j > (j + 16384.0) - 1.0) {
          i1 = 1;
        } else {
          i1 = (int)j;
        }
        corr_test = 0.0;
        for (i2 = 0; i2 < 16384; i2++) {
          corr_test += gold_code_signal[i2] * input_signal[(i1 + i2) - 1];
        }
        if (!(coherent_detection == 1.0)) {
          corr_test = fabs(corr_test);
        }
        if (corr_test > internal_threshold) {
          internal_threshold = corr_test;
          *end_index = j + 16384.0;
        }
      }
      exitg1 = true;
    } else {
      i++;
    }
  }
}

/* End of code generation (sync_correlator.c) */
