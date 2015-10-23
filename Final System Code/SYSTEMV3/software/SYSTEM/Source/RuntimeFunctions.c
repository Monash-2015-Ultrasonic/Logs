/*
 * FILE: 				RuntimeFunctions.c
 * AUTHORS:				Catherine ATTARD & Ian HUA
 * DATE LAST MODIFIED:	23 October 2015
 *
 * DESCRIPTION:			Catherine: 	Initialisation sequence for linear system of equations, functions to find Determinant, Transpose, Matrix Multiplication
 * 						Catherine: 	Algorithm to determine R, Yaw and Elevation, Convert those results into CM DEG and integers
 *
 *						Ian:		Quadratic Interpolator to determine better arrival time from returned Absolute Peak from RTL
 *						Ian:		Channel Sampler and bit manipulation to retrieve 64-bit correlation data
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <math.h>

#include "config.h"
#include "LCD.h"
#include "RuntimeFunctions.h"

/* Global variables */
int Nreceivers=4; /* Number of receivers */
int calc_mode; /* Calculation mode */
float pi;
float y[5], z[5]; /* Receiver y- and z-coordinates (mm) */
float d_2[5]; /* Distance from transmitter to receivers */
float counter[5]; /* Path lengths (counts) */

float realR=0, realphi=0, realtheta=0;
float L, R, phi, theta;
int max_error=0, error=0, k=0;

alt_u64 CH0_nOut, CH1_nOut, CH2_nOut, CH3_nOut;


//===============================
// Sample All Channel for a Detection:
//===============================
void sampleChannels(void)
{
	alt_u32 YnL;
	alt_u64 YnML, YnMU, YnU;

	if (*CH0_peakFound) {
		*CH0_RD = 0x1;
		*CH0_RD = 0x0;

		YnL				= *CH0_Yn1L;
		YnML 			= *CH0_Yn1ML;
		YnMU			= *CH0_Yn1MU;
		YnU 			= *CH0_Yn1U;
		alt_u64 Yn1DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn1NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		YnL				= *CH0_Yn2L;
		YnML 			= *CH0_Yn2ML;
		YnMU			= *CH0_Yn2MU;
		YnU 			= *CH0_Yn2U;
		alt_u64 Yn2DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn2NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		YnL				= *CH0_Yn3L;
		YnML 			= *CH0_Yn3ML;
		YnMU			= *CH0_Yn3MU;
		YnU 			= *CH0_Yn3U;
		alt_u64 Yn3DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn3NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		int n 			= *CH0_TIME;

		CH0_nOut = qInterp(1000000, n-2, Yn1NUM, Yn1DEN, Yn2NUM, Yn2DEN, Yn3NUM, Yn3DEN);
	} else {
		CH0_nOut = 0;
	}

	usleep(0.001 seconds);

	if (*CH1_peakFound) {
		*CH1_RD = 0x1;
		*CH1_RD = 0x0;

		YnL				= *CH1_Yn1L;
		YnML 			= *CH1_Yn1ML;
		YnMU			= *CH1_Yn1MU;
		YnU 			= *CH1_Yn1U;
		alt_u64 Yn1DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn1NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		YnL				= *CH1_Yn2L;
		YnML 			= *CH1_Yn2ML;
		YnMU			= *CH1_Yn2MU;
		YnU 			= *CH1_Yn2U;
		alt_u64 Yn2DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn2NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		YnL				= *CH1_Yn3L;
		YnML 			= *CH1_Yn3ML;
		YnMU			= *CH1_Yn3MU;
		YnU 			= *CH1_Yn3U;
		alt_u64 Yn3DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn3NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		int n 			= *CH1_TIME;

		CH1_nOut = qInterp(1000000, n-2, Yn1NUM, Yn1DEN, Yn2NUM, Yn2DEN, Yn3NUM, Yn3DEN);
	} else {
		CH1_nOut = 0;
	}

	usleep(0.001 seconds);

	if (*CH2_peakFound) {
		*CH2_RD = 0x1;
		*CH2_RD = 0x0;

		YnL				= *CH2_Yn1L;
		YnML 			= *CH2_Yn1ML;
		YnMU			= *CH2_Yn1MU;
		YnU 			= *CH2_Yn1U;
		alt_u64 Yn1DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn1NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		YnL				= *CH2_Yn2L;
		YnML 			= *CH2_Yn2ML;
		YnMU			= *CH2_Yn2MU;
		YnU 			= *CH2_Yn2U;
		alt_u64 Yn2DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn2NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		YnL				= *CH2_Yn3L;
		YnML 			= *CH2_Yn3ML;
		YnMU			= *CH2_Yn3MU;
		YnU 			= *CH2_Yn3U;
		alt_u64 Yn3DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn3NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		int n 			= *CH2_TIME;

		CH2_nOut = qInterp(1000000, n-2, Yn1NUM, Yn1DEN, Yn2NUM, Yn2DEN, Yn3NUM, Yn3DEN);
	} else {
		CH2_nOut = 0;
	}

	usleep(0.001 seconds);

	if (*CH3_peakFound) {
		*CH3_RD = 0x1;
		*CH3_RD = 0x0;

		YnL				= *CH3_Yn1L;
		YnML 			= *CH3_Yn1ML;
		YnMU			= *CH3_Yn1MU;
		YnU 			= *CH3_Yn1U;
		alt_u64 Yn1DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn1NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		YnL				= *CH3_Yn2L;
		YnML 			= *CH3_Yn2ML;
		YnMU			= *CH3_Yn2MU;
		YnU 			= *CH3_Yn2U;
		alt_u64 Yn2DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn2NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		YnL				= *CH3_Yn3L;
		YnML 			= *CH3_Yn3ML;
		YnMU			= *CH3_Yn3MU;
		YnU 			= *CH3_Yn3U;
		alt_u64 Yn3DEN 	= ((YnML & 0x3FFFF) << 32) + YnL;
		alt_u64 Yn3NUM 	= ((YnU & 0x3FFF) << 48) + (YnMU << 14) + ((YnML & 0xFFFC0000) >> 18);

		int n 			= *CH3_TIME;

		CH3_nOut = qInterp(1000000, n-2, Yn1NUM, Yn1DEN, Yn2NUM, Yn2DEN, Yn3NUM, Yn3DEN);
	} else {
		CH3_nOut = 0;
	}

	counter[0] = CH0_nOut / 1000000;
	counter[1] = CH1_nOut / 1000000;
	counter[2] = CH2_nOut / 1000000;
	counter[3] = ((CH3_nOut*4/5) + (CH1_nOut/5)) / 1000000;

#ifdef EVALUATE_PERCHANNEL
	printf("%3.3f\t", counter[0]);
	printf("%3.3f\t", counter[1]);
	printf("%3.3f\t", counter[2]);
	printf("%3.3f\n", counter[3]);
#endif
}


//===============================
// Quadratic Interpolator
//===============================
/*
 * Precise answer: 58.1; NIOS Answer: +0.0021566% Error
 * int n_test = qInterp(1000000, 57, 93, 100, 99, 100, 95, 100);
 *
 * Precise answer: 58.041958; NIOS Answer: +0.0222351% Error
 * int n_test = qInterp(1000000, 57, 4415676025201, 13660598848400, 14488231808281, 14775262118400, 6581528571601, 15485119375600);
 * printf("%d\n", n_test);
 *
 */
alt_u64 qInterp(int precision, int n1, alt_u64 Yn1num, alt_u64 Yn1den, alt_u64 Yn2num, alt_u64 Yn2den, alt_u64 Yn3num, alt_u64 Yn3den)
{
	float fYn1num = sqrt(Yn1num);
	float fYn1den = sqrt(Yn1den);
	float Yn1 = fYn1num / fYn1den;

	float fYn2num = sqrt(Yn2num);
	float fYn2den = sqrt(Yn2den);
	float Yn2 = fYn2num / fYn2den;

	float fYn3num = sqrt(Yn3num);
	float fYn3den = sqrt(Yn3den);
	float Yn3 = fYn3num / fYn3den;

	alt_64 fraction = ( (3*Yn1) - (4*Yn2) + Yn3 ) * precision;
	fraction /= ( 2*(Yn1 - (2*Yn2) + Yn3) );

	alt_u64 nTPT = (n1* precision) + fraction;
	return nTPT;
}

//===============================
// Output Results to LCD/PC
//===============================
void Display_Results(int mode, float Rfloat, float phifloat, float thetafloat)
{
	int R 		= float2int(Rfloat);
	int phi 	= float2int(phifloat);
	int theta	= float2int(thetafloat);

	if(R<0)	{	}
	else {
#ifdef EVALUATE_3D
       printf("%d\t%d\t%d\n", R, phi, theta);
#endif
		/* Print results */
		line1[7]=(R/100)%10+0x30;
		line1[8]=(R/10)%10+0x30;
		line1[9]=R%10+0x30;

		LCD_Display(line1, 1);

		if(mode==3) {
			if (phi < 0) {
				line2[7]=0x2D; /*-*/
				phi=-phi;
			} else {
				line2[7]=0x20;
			}

			line2[8]=(phi/100)%10+0x30;
			line2[9]=(phi/10)%10+0x30;
			line2[10]=phi%10+0x30;


			if(theta<0) {
				line2[13]=0x2D; /*-*/
				theta=-theta;
			} else {
				line2[13]=(theta/100)%10+0x30;
			}

			line2[14]=(theta/10)%10+0x30;
			line2[15]=theta%10+0x30;

			LCD_Display(line2, 2);
		}
	}
}




//===============================
// ALGORITHM TO SOLVE R, YAW, ELEVATION:
//===============================
/* Runs once on startup */
void find_constants()
{
	int k;

	/* Calculate pi */
	pi=(float)acos(-1.0);

	/* Set initial mode */
	calc_mode=3;

	/* Initialise counters */

	for(k=0;k<5;k++)
	{
		counter[k]=0;
	}

	/* Set receiver coordinates (mm) */
	y[0]=25+7;
	y[1]=33+7;
	y[2]=40+7;
	y[3]=25+7;
	y[4]=35+7;
	z[0]=0;
	z[1]=3;
	z[2]=5;
	z[3]=10;
	z[4]=10;

	for(k=0;k<5;k++)
	{
		/*y[k]=y[k]*count_rate/v/1000;
		z[k]=z[k]*count_rate/v/1000;*/
		y[k]=y[k]*625/784;
		z[k]=z[k]*625/784;

		d_2[k]=y[k]*y[k]+z[k]*z[k]; /* Square of distance from transmitter to receiver */
	}
}

/* Runs after each detection cycle */
void find_coordinates(float L[5], int N, int mode, float *R, float *phi, float *theta)
{
	float BT[3][5], BTB[3][3], BTb[3][3], b[5][3], A1[3][3];
	float x[3];
	float ave_pl, max_diff, detBTB, detA1;
	int i,j,k,n;
	int k_valid[5];

	/* Maximum difference between path lengths (mm to counts)*/
	max_diff=MAX_DIFF;

	ave_pl=0;

	for(k=0;k<N;k++)
	{
		ave_pl+=L[k];
	}

	ave_pl/=N;

	/* Check for missed and false detections */
	n=N;
	i=0;

	for(k=0;k<N;k++)
	{
		if((L[k]-ave_pl)*(L[k]-ave_pl)>max_diff*max_diff) /* Check for false detections */
		{
			n-=1;
		}
		else
		{
			k_valid[i]=k;
			i++;
		}
	}

	if(n<mode)
	{
		/* Underdetermined system */
		*R=-1;
		*phi=0;
		*theta=0;

	}
	else
	{

		for(k=0;k<n;k++)
		{
			b[k][0]=L[k_valid[k]]*L[k_valid[k]]-d_2[k_valid[k]];
		}


		find_denominator(k_valid,n,mode,&BT,&BTB,&detBTB);

		if(detBTB==0)
		{
			*R=-1;
			*phi=0;
			*theta=0;
		}
		else
		{
			matrix_multiply(BT,mode,n,b,1,&BTb);

			/* Find numerators */

			for(k=0;k<mode;k++)
			{
				/* Use column substitution to solve for x */
				for(i=0;i<mode;i++)
				{
					for(j=0;j<mode;j++)
					{
						if(j==k)
						{
							A1[i][j]=BTb[i][0];
						}
						else
						{
							A1[i][j]=BTB[i][j];
						}
					}
				}

				detA1=determinant(A1,mode);

				/* Solve linear system */
				x[k]=detA1/detBTB;
			}

			/* Use x to find coordinates */
			*R=sqrt(x[0])/2;
			*phi=0;
			*theta=pi/2;

			if(mode==2)
			{
				*phi=(float)asin(-x[1]/(*R*4));
			}

			if(mode==3)
			{
				*theta=(float)acos(-x[2]/(*R*4));
				*phi=(float)asin(-x[1]/(*R*4*sin(*theta)));
			}

			convert_results(R,phi,theta); /* Convert results to correct units */
		}


	}

}


/* Converts coordinates to correct units */
void convert_results(float *Rptr, float *phiptr, float *thetaptr)
{
	float R, phi, theta;
	int dist_prec=1, angle_prec=5; /* Precision*/

	R=*Rptr;
	phi=*phiptr;
	theta=*thetaptr;

	R*=0.12544; /* Convert to cm */

	/* Convert to degrees */
	phi=phi*180/pi;
	theta=theta*180/pi-90; /* Convert azimuth to elevation */

	/* Round results */
	R=dist_prec*floor(R/dist_prec+0.5);
	phi=angle_prec*floor(phi/angle_prec+0.5);
	theta=angle_prec*floor(theta/angle_prec+0.5);

	*Rptr=R;
	*phiptr=phi;
	*thetaptr=theta;
}


/* Finds denominator matrix */
void find_denominator(int *k_valid, int n, int mode, float (*MTptr)[3][5], float (*MTMptr)[3][3], float *detMTMptr)
{
	float M[5][3];
	int k;

	/* Initial matrix */

	for(k=0;k<n;k++)
	{

		M[k][0]=1;
		if(mode>1)
		{
			M[k][1]=y[k_valid[k]];
		}
		if(mode>2)
		{
			M[k][2]=z[k_valid[k]];
		}
	}

	/* Output matrices */
	transpose(M,MTptr,n,mode);
	matrix_multiply(*MTptr,mode,n,M,mode,MTMptr);

	*detMTMptr=determinant(*MTMptr,mode);
}


/* Finds determinant of nxn matrix M
n can be equal to 1, 2 or 3 */
float determinant(float M[3][3], int n)
{
	if(n==1)
	{
		return M[0][0];
	}
	else if(n==2)
	{
		return M[0][0]*M[1][1]-M[0][1]*M[1][0];
	}
	else if(n==3)
	{
		return M[0][0]*(M[1][1]*M[2][2]-M[1][2]*M[2][1])-M[0][1]*(M[1][0]*M[2][2]-M[1][2]*M[2][0])+M[0][2]*(M[1][0]*M[2][1]-M[1][1]*M[2][0]);
	}
	else
	{
		return 0;
	}
}

/* Finds transpose of mxn matrix M */
void transpose(float M[5][3], float (*MTptr)[3][5], int m, int n)
{
	int i,j;

	for(i=0;i<n;i++)
	{
		for(j=0;j<m;j++)
		{
			(*MTptr)[i][j]=M[j][i];
		}
	}

}

/* Multiplies mxn matrix B with nxp matrix C */
void matrix_multiply(float B[3][5], int m, int n, float C[5][3], int p, float (*BCptr)[3][3])
{
	float bc;
	int i, j, k;

	for(i=0;i<m;i++)
	{

		for(k=0;k<p;k++)
		{
			bc=0;

			for(j=0;j<n;j++)
			{
				bc+=B[i][j]*C[j][k];
			}

			(*BCptr)[i][k]=bc;
		}
	}

}


/* Converts 3 digit float to int */
int float2int(float r)
{
	int n=0;

	if(r==0)
	{
		n=0;
	}
	else if(r<0)
	{
		n=(int)(r-0.5);
	}
	else if(r>0)
	{
		n=(int)(r+0.5);

	}

	return n;
}

