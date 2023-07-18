/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * SystemCore.c
 *
 * Code generation for function 'SystemCore'
 *
 */

/* Include files */
#include "SystemCore.h"
#include "echo_transmitter_internal_types.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Declarations */
static double rt_roundd_snf(double u);

/* Function Definitions */
static double rt_roundd_snf(double u)
{
  double y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = u * 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }
  return y;
}

void SystemCore_step(comm_RSEncoder *obj, const double varargin_1[36],
                     double varargout_1[108])
{
  static const signed char iv[63] = {
      2,  4,  8,  16, 32, 3,  6,  12, 24, 48, 35, 5,  10, 20, 40, 19,
      38, 15, 30, 60, 59, 53, 41, 17, 34, 7,  14, 28, 56, 51, 37, 9,
      18, 36, 11, 22, 44, 27, 54, 47, 29, 58, 55, 45, 25, 50, 39, 13,
      26, 52, 43, 21, 42, 23, 46, 31, 62, 63, 61, 57, 49, 33, 1};
  static const signed char iv1[63] = {
      0,  1,  6,  2,  12, 7,  26, 3,  32, 13, 35, 8,  48, 27, 18, 4,
      24, 33, 16, 14, 52, 36, 54, 9,  45, 49, 38, 28, 41, 19, 56, 5,
      62, 25, 11, 34, 31, 17, 47, 15, 23, 53, 51, 37, 44, 55, 40, 10,
      61, 46, 30, 50, 22, 39, 43, 29, 60, 42, 21, 20, 59, 57, 58};
  static const signed char iv2[12] = {57, 5, 45, 3, 57, 28,
                                      48, 9, 60, 2, 33, 40};
  static const signed char a[6] = {32, 16, 8, 4, 2, 1};
  c_comm_internal_IntegerRSEncode *b_obj;
  double d;
  unsigned int intOutput[18];
  unsigned int intInput[6];
  int colIdx;
  int i;
  int iIdx;
  unsigned int u;
  signed char y[108];
  if (obj->isInitialized != 1) {
    obj->isSetupComplete = false;
    obj->isInitialized = 1;
    obj->cIntRSEnc.isInitialized = 0;
    obj->cIntRSEnc.isInitialized = 0;
    /* System object Constructor function: comm.internal.IntegerRSEncoder */
    obj->cIntRSEnc.cSFunObject.S0_isInitialized = 0;
    for (i = 0; i < 63; i++) {
      obj->cIntRSEnc.cSFunObject.P0_table1[i] = iv[i];
    }
    for (i = 0; i < 63; i++) {
      obj->cIntRSEnc.cSFunObject.P1_table2[i] = iv1[i];
    }
    for (i = 0; i < 12; i++) {
      obj->cIntRSEnc.cSFunObject.P2_Polynomial[i] = iv2[i];
    }
    obj->cIntRSEnc.matlabCodegenIsDeleted = false;
    for (i = 0; i < 108; i++) {
      obj->pYAttributes[i] = 0.0;
    }
    obj->isSetupComplete = true;
  }
  for (i = 0; i < 6; i++) {
    d = 0.0;
    for (iIdx = 0; iIdx < 6; iIdx++) {
      d += (double)a[iIdx] * varargin_1[iIdx + 6 * i];
    }
    d = rt_roundd_snf(d);
    if (d < 4.294967296E+9) {
      if (d >= 0.0) {
        u = (unsigned int)d;
      } else {
        u = 0U;
      }
    } else if (d >= 4.294967296E+9) {
      u = MAX_uint32_T;
    } else {
      u = 0U;
    }
    intInput[i] = u;
  }
  if (obj->cIntRSEnc.isInitialized != 1) {
    obj->cIntRSEnc.isSetupComplete = false;
    obj->cIntRSEnc.isInitialized = 1;
    obj->cIntRSEnc.isSetupComplete = true;
  }
  b_obj = &obj->cIntRSEnc.cSFunObject;
  /* System object Outputs function: comm.internal.IntegerRSEncoder */
  for (iIdx = 0; iIdx < 45; iIdx++) {
    b_obj->W3_MessagePAD[iIdx] = 0;
  }
  for (iIdx = 0; iIdx < 6; iIdx++) {
    b_obj->W3_MessagePAD[iIdx + 45] = (int)intInput[iIdx];
  }
  for (iIdx = 0; iIdx < 12; iIdx++) {
    b_obj->W2_B[iIdx] = 0;
  }
  for (colIdx = 0; colIdx < 51; colIdx++) {
    for (iIdx = 0; iIdx < 12; iIdx++) {
      b_obj->W1_currentMessage[iIdx] = b_obj->W3_MessagePAD[colIdx];
    }
    for (iIdx = 0; iIdx < 12; iIdx++) {
      b_obj->W0_firstParity[iIdx] = b_obj->W2_B[0];
    }
    for (iIdx = 0; iIdx < 11; iIdx++) {
      b_obj->W2_B[iIdx] = b_obj->W2_B[iIdx + 1];
    }
    b_obj->W2_B[11U] = 0;
    for (iIdx = 0; iIdx < 12; iIdx++) {
      i = b_obj->W1_currentMessage[iIdx] ^ b_obj->W0_firstParity[iIdx];
      if ((i == 0) || (b_obj->P2_Polynomial[iIdx] == 0)) {
        i = 0;
      } else {
        i = (b_obj->P1_table2[i - 1] +
             b_obj->P1_table2[b_obj->P2_Polynomial[iIdx] - 1]) %
            63;
        if (i == 0) {
          i = 63;
        }
        i = b_obj->P0_table1[i - 1];
      }
      b_obj->W2_B[iIdx] ^= i;
    }
  }
  for (iIdx = 0; iIdx < 6; iIdx++) {
    intOutput[iIdx] = intInput[iIdx];
  }
  for (iIdx = 0; iIdx < 12; iIdx++) {
    intOutput[iIdx + 6] = (unsigned int)b_obj->W2_B[iIdx];
  }
  for (iIdx = 0; iIdx < 6; iIdx++) {
    for (i = 0; i < 18; i++) {
      y[((i + 1) * 6 - iIdx) - 1] =
          (signed char)((intOutput[i] & 1LL << iIdx) != 0LL);
    }
  }
  for (i = 0; i < 108; i++) {
    obj->pYAttributes[i] = y[i];
  }
  for (i = 0; i < 108; i++) {
    varargout_1[i] = obj->pYAttributes[i];
  }
}

/* End of code generation (SystemCore.c) */
