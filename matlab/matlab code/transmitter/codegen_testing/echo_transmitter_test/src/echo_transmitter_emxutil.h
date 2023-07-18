/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * echo_transmitter_emxutil.h
 *
 * Code generation for function 'echo_transmitter_emxutil'
 *
 */

#ifndef ECHO_TRANSMITTER_EMXUTIL_H
#define ECHO_TRANSMITTER_EMXUTIL_H

/* Include files */
#include "echo_transmitter_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern void emxEnsureCapacity_real_T(emxArray_real_T *emxArray, int oldNumel);

extern void emxFree_real_T(emxArray_real_T **pEmxArray);

extern void emxInit_real_T(emxArray_real_T **pEmxArray);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (echo_transmitter_emxutil.h) */
