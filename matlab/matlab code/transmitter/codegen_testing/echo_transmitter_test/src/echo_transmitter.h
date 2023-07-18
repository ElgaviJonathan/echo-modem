/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * echo_transmitter.h
 *
 * Code generation for function 'echo_transmitter'
 *
 */

#ifndef ECHO_TRANSMITTER_H
#define ECHO_TRANSMITTER_H

/* Include files */
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern void echo_transmitter(const double data_bits[32],
                             double output_signal[94960], double cw_sig[24576],
                             double sync_sig[16384], double data_sig[54000],
                             double encoded_bits_coder[108]);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (echo_transmitter.h) */
