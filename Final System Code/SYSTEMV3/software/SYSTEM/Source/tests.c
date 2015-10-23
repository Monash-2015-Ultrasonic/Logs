/*
 * FILE: 				tests.c
 * AUTHORS:				Ian HUA
 * DATE LAST MODIFIED:	23 October 2015
 *
 * DESCRIPTION:			Functions that need to be paired with appropriate ifdef in Verilog
 * 						to verify the correct operation of the entire data flow
 *
 */

#include <unistd.h>

#include "alt_types.h"
#include "system.h"
#include "io.h"

#include "tests.h"
#include "config.h"
#include "RuntimeFunctions.h"

int i;

//===============================
// Verify that ADC is intialised, flushed and reading correctly
//===============================
#ifdef ADC_TEST
void ADC_test(void)
{
	*fifo_rst 	= 0x0;
	*data_valid = 0x0;
	*adc_on 	= 0x0;
	*sub_on		= 0x0;

	*adc_on 	= 0x1;
	usleep(1000);
	*adc_on 	= 0x0;
}
#endif

//===============================
// Verify FIFO that stores SAMPLES for FIR Input
//===============================
#ifdef FIFO_ADC_TEST
void FIFO_ADC_test(void)
{
	*fifo_rst 	= 0x0;
	*data_valid = 0x0;
	*adc_on 	= 0x0;
	*sub_on		= 0x0;

	for (i = 0; i < 15; i++) {
		*data = i+1;
		*data_valid = 0x1;
		*data_valid = 0x0;

		usleep(1000000);
	}
}
#endif

//===============================
// Verify FIR operation and Impulse Response, and verify FIFO for FIR Output
//===============================
#ifdef IMPULSE_RESPONSE_TEST
void IMPULSE_test(impulseMode mode)
{
	*fifo_rst 	= 0x0;
	*data_valid = 0x0;
	*adc_on 	= 0x0;
	*sub_on		= 0x0;
	*det_on 	= 0x0;

	*sub_on 	= 0x1;
	*det_on		= 0x1;
	usleep(0.1 seconds);

	*data 		= *sub_on ? 0x1 + SUBTRACTOR_OFFSET_CH0 : 0x1;
	*data_valid	= 0x1;
	*data_valid = 0x0;

	usleep(1 seconds);

	if (mode == ADC) {
		*adc_on = 0x1;
		//usleep(470);
		usleep(10000000);
		*adc_on = 0x0;
	}

	for (i = 0; i < 128; i++) {
		*data 		= *sub_on ? 0x0 + SUBTRACTOR_OFFSET_CH0 : 0x0;
		*data_valid = 0x1;
		*data_valid = 0x0;
		//usleep(0.1 seconds);
		usleep(1 seconds);
	}
}
#endif

//===============================
// Verify sum(X^2) of FIR, and verify FIFO that holds sum(X^2) matching to FIR Output order
//===============================
#ifdef SUMXSQ_TEST
void sumXsq_test(void)
{
	*fifo_rst 	= 0x0;
	*data_valid = 0x0;
	*adc_on 	= 0x0;
	*sub_on 	= 0x0;

	*sub_on 	= 0x1;
	*det_on		= 0x1;
	usleep(0.1 seconds);

	for (i = 0; i < 128; i++) {
		*data 		= *sub_on ? -1 + SUBTRACTOR_OFFSET_CH0 : -1;
		*data_valid	= 0x1;
		*data_valid = 0x0;

		usleep(1 seconds);
	}
}
#endif

//===============================
// Run a test vector to make sure Detection and Quadratic Interpolation are functioning
//===============================
#ifdef DETECTION_TEST
void DETECTION_test(void)
{
	*fifo_rst 	= 0x0;
	*data_valid = 0x0;
	*adc_on 	= 0x0;
	*sub_on		= 0x0;

	int X[128] = {3, 9, 9, 11, -31, -49, -32, 15, 80, 83, 34, -77, -116, -103, 49, 137, 129, 38, -128, -180, -142, 86, 211, 193, 38, -196, -261, -211, 116, 295, 263, 24, -260, -332, -240, 160, 364, 318, 31, -322, -404, -248, 205, 423, 362, 23, -372, -457, -260, 235, 462, 392, 6, -406, -480, -279, 263, 505, 403, -47, -428, -487, -238, 296, 511};

	*sub_on 	= 0x1;
	*det_on 	= 0x1;
	usleep(0.1 seconds);

	for (i = 0; i < 65 ; i++) {
		*data = *sub_on ? X[i] + SUBTRACTOR_OFFSET_CH0 : X[i];
		*data_valid = 0x1;
		*data_valid = 0x0;

		usleep(0.1 seconds);
	}

	for (i = 0; i < 128; i++) {
		*data 		= *sub_on ? 0x0 + SUBTRACTOR_OFFSET_CH0 : 0x0;
		*data_valid = 0x1;
		*data_valid = 0x0;

		usleep(0.1 seconds);
	}
}
#endif