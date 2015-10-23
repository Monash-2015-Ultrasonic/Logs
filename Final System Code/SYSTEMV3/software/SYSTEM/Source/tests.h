/*
 * FILE: 				tests.h
 * AUTHORS:				Ian HUA
 * DATE LAST MODIFIED:	23 October 2015
 *
 * DESCRIPTION:			Functions that need to be paired with appropriate ifdef in Verilog
 * 						to verify the correct operation of the entire data flow
 *
 */

#ifndef _TEST_H_
#define _TEST_H_

typedef enum FIRMODES {MANUAL, AUTO, ADC} impulseMode;

#ifdef ADC_TEST
void ADC_test(void);
#endif
#ifdef FIFO_ADC_TEST
void FIFO_ADC_test(void);
#endif
#ifdef IMPULSE_RESPONSE_TEST
void IMPULSE_test(impulseMode mode);
#endif
#ifdef SUMXSQ_TEST
void sumXsq_test(void);
#endif
#ifdef DETECTION_TEST
void DETECTION_test(void);
#endif

#endif
