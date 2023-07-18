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
#include "sync_correlator.h"
#include "sync_correlator_terminate.h"

/* Function Declarations */
static void argInit_1x16384_real_T(double result[16384]);

static void argInit_32768x1_real_T(double result[32768]);

static double argInit_real_T(void);

/* Function Definitions */
static void argInit_1x16384_real_T(double result[16384])
{
  int idx1;
  /* Loop over the array to initialize each element. */
  for (idx1 = 0; idx1 < 16384; idx1++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */
    result[idx1] = argInit_real_T();
  }
}

static void argInit_32768x1_real_T(double result[32768])
{
  int idx0;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 32768; idx0++) {
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
  main_sync_correlator();
  /* Terminate the application.
You do not need to do this more than one time. */
  sync_correlator_terminate();
  return 0;
}

void main_sync_correlator(void)
{
  static double dv[32768];
  double dv1[16384];
  double end_index;
  double threshold_tmp;
  boolean_T signal_detected;
  /* Initialize function 'sync_correlator' input arguments. */
  /* Initialize function input argument 'input_signal'. */
  /* Initialize function input argument 'gold_code_signal'. */
  threshold_tmp = argInit_real_T();
  /* Call the entry-point 'sync_correlator'. */
  argInit_32768x1_real_T(dv);
  argInit_1x16384_real_T(dv1);
  sync_correlator(dv, dv1, threshold_tmp, threshold_tmp, threshold_tmp,
                  &signal_detected, &end_index);
}

/* End of code generation (main.c) */
