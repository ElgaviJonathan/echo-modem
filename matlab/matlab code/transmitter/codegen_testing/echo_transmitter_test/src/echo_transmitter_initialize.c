/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * echo_transmitter_initialize.c
 *
 * Code generation for function 'echo_transmitter_initialize'
 *
 */

/* Include files */
#include "echo_transmitter_initialize.h"
#include "echo_transmitter_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void echo_transmitter_initialize(void)
{
  rt_InitInfAndNaN();
  isInitialized_echo_transmitter = true;
}

/* End of code generation (echo_transmitter_initialize.c) */
