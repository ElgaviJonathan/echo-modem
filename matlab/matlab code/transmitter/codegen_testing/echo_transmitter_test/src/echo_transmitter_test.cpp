//============================================================================
// Name        : echo_transmitter_test.cpp
// Author      : Jonathan
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
#include <fstream>
#include "main.h"
#include "echo_transmitter.h"
#include "echo_transmitter_terminate.h"
#include "rt_nonfinite.h"

using namespace std;



/* Function Declarations */
static void argInit_32x1_real_T(double result[32]);

//static double argInit_real_T(void);

/* Function Definitions */
static void argInit_32x1_real_T(double result[32])
{
	int data_bits_ref[32] =
	   {1, 0, 1, 0, 0, 0, 0, 0,
		1, 1, 1, 0, 0, 1, 0, 0,
		0, 1, 0, 0, 0, 0, 1, 0,
		1, 1, 0, 0, 1, 1, 1, 0};
  int idx0;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 32; idx0++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */

      result[idx0] = data_bits_ref[idx0];

//    result[idx0] = argInit_real_T();
  }
}



void main_echo_transmitter(void)
{
  static double output_signal[94960];
  static double data_sig[54000];
  static double cw_sig[24576];
  double sync_sig[16384];
  double encoded_bits_coder[108];
  double data_bits[32];

	ofstream tx_stream_file;
	tx_stream_file.open("tx_stream_file.txt");
	ofstream encoded_bits_file;
	encoded_bits_file.open("encoded_bits_file.txt");
	ofstream data_bits_file;
	data_bits_file.open("data_bits_file.txt");
//	ofstream data_stream_file;
//	tx_stream_file.open("data_stream_file.txt");

  /* Initialize function 'echo_transmitter' input arguments. */
  /* Initialize function input argument 'data_bits'. */
  /* Call the entry-point 'echo_transmitter'. */
  argInit_32x1_real_T(data_bits);
  echo_transmitter(data_bits, output_signal, cw_sig, sync_sig, data_sig,
                   encoded_bits_coder);
  cout << "output_signal write " << endl;
  for (int i =0; i<94960; i++){ // actual length 94960
//	  cout << *(output_signal->data+i) << endl;
	  tx_stream_file << output_signal[i] << ",";
  }
  cout << "encoded_bits write " << endl;
  for (int i =0; i<108; i++){
//	  cout << *(output_signal->data+i) << endl;
	  encoded_bits_file << encoded_bits_coder[i] << ",";
  }
  cout << "data_bits write " << endl;
  for (int i =0; i<32; i++){
	  cout << data_bits[i] << endl;
	  data_bits_file << data_bits[i] << ",";
  }

//  cout << "data_signal write " << endl;

//  for (int i =0; i<53999; i++){ // data length 54000
////	  cout << *(output_signal->data+i) << endl;
//	  data_stream_file << *(data_sig->data+i) << ",";
//  }
  tx_stream_file.close();
  encoded_bits_file.close();
  data_bits_file.close();
//  data_stream_file.close();

}

/* End of code generation (main.c) */




int main(int argc, char **argv)
{
	cout << "Program start" << endl; // prints !!!Hello World!!!

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
	cout << "Program end" << endl; // prints !!!Hello World!!!
  return 0;
}





