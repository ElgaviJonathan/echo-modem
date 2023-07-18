/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * echo_transmitter_internal_types.h
 *
 * Code generation for function 'echo_transmitter'
 *
 */

#ifndef ECHO_TRANSMITTER_INTERNAL_TYPES_H
#define ECHO_TRANSMITTER_INTERNAL_TYPES_H

/* Include files */
#include "echo_transmitter_types.h"
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_c_comm_internal_IntegerRSEncode
#define typedef_c_comm_internal_IntegerRSEncode
typedef struct {
  int S0_isInitialized;
  int W0_firstParity[12];
  int W1_currentMessage[12];
  int W2_B[12];
  int W3_MessagePAD[51];
  int P0_table1[63];
  int P1_table2[63];
  int P2_Polynomial[12];
} c_comm_internal_IntegerRSEncode;
#endif /* typedef_c_comm_internal_IntegerRSEncode */

#ifndef typedef_c_comm_internalcodegen_IntegerR
#define typedef_c_comm_internalcodegen_IntegerR
typedef struct {
  boolean_T matlabCodegenIsDeleted;
  int isInitialized;
  boolean_T isSetupComplete;
  c_comm_internal_IntegerRSEncode cSFunObject;
} c_comm_internalcodegen_IntegerR;
#endif /* typedef_c_comm_internalcodegen_IntegerR */

#ifndef typedef_comm_RSEncoder
#define typedef_comm_RSEncoder
typedef struct {
  boolean_T matlabCodegenIsDeleted;
  int isInitialized;
  boolean_T isSetupComplete;
  c_comm_internalcodegen_IntegerR cIntRSEnc;
  double pYAttributes[108];
} comm_RSEncoder;
#endif /* typedef_comm_RSEncoder */

#endif
/* End of code generation (echo_transmitter_internal_types.h) */
