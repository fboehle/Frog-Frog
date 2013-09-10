/*
 * =============================================================
 * MagSq.c
 * Calculates the magnitude square of a complex trace/vector.
 *
 * Result equivalent to abs(x).^2 in MatLab, but faster.
 * =============================================================
 */

//  $Revision: 1.1 $     $Date: 2006-11-11 00:15:29 $
//
//  $Log: MagSq.c,v $
//  Revision 1.1  2006-11-11 00:15:29  pablo
//  CVS server re-installation
//
//  Revision 1.3  2002/09/29 01:26:39  zeekec
//  *** empty log message ***
//
//  Revision 1.2  2002/09/29 01:18:30  zeekec
//  *** empty log message ***
//
//  Revision 1.1  2002/09/09 21:52:21  xg
//  *** empty log message ***
//

#include "mex.h"


void MagSqR(const double *x, const int N, double *y)
// Real parameter version
{
	int i;
	double k;

	for (i = 0; i < N; i++) {
		k = *(x + i);
		*(y + i) = k * k;
	}
}	

void MagSqC(const double *xr, const double *xi, const int N, double *y)
// Complex parameter version
{
    int i;
    double kr, ki;
	
	for (i = 0; i < N; i++) {
		kr = *(xr + i);
		ki = *(xi + i);
		*(y + i) = kr * kr + ki * ki;
	}
}



void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	int     N;
    
	/* Check for the proper number of arguments. */
	if (nrhs > 1)
		mexErrMsgTxt("Too many input arguments.");

	plhs[0] = mxCreateNumericArray(mxGetNumberOfDimensions(prhs[0]),
								   mxGetDimensions(prhs[0]),
								   mxDOUBLE_CLASS,
								   mxREAL);
	
	N = mxGetNumberOfElements(prhs[0]);
	
	if (mxIsComplex(prhs[0]))
   		MagSqC(mxGetPr(prhs[0]), mxGetPi(prhs[0]), N, mxGetPr(plhs[0]));
   	else 
    	MagSqR(mxGetPr(prhs[0]), N, mxGetPr(plhs[0]));

	return;
}