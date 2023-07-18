/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

/* Include files */
#include "main.h"
#include "echo_transmitter.h"
#include "echo_transmitter_terminate.h"

/* Function Declarations */
static void argInit_32x1_real_T(double result[32]);

static double argInit_real_T(void);

/* Function Definitions */
static void argInit_32x1_real_T(double result[32])
{
  int idx0;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 32; idx0++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */
    result[idx0] = argInit_real_T();
  }
}

static double argInit_real_T(void)
{
  return 0.0;
}

int main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
  /* The initialize function is being called automatically from your entry-point
   * function. So, a call to initialize is not included here. */
  /* Invoke the entry-point functions.
You can call entry-point functions multiple times. */
  main_echo_transmitter();
  /* Terminate the application.
You do not need to do this more than one time. */
  echo_transmitter_terminate();
  return 0;
}

void main_echo_transmitter(void)
{
  static double output_signal[94960];
  static double data_sig[54000];
  static double cw_sig[24576];
  double sync_sig[16384];
  double encoded_bits_coder[108];
  double data_bits[32];
  /* Initialize function 'echo_transmitter' input arguments. */
  /* Initialize function input argument 'data_bits'. */
  /* Call the entry-point 'echo_transmitter'. */
  argInit_32x1_real_T(data_bits);
  echo_transmitter(data_bits, output_signal, cw_sig, sync_sig, data_sig,
                   encoded_bits_coder);
}

/* End of code generation (main.c) */
