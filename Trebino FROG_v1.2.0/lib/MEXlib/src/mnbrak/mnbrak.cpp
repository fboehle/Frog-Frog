/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#include "mnbrak.h" 
#include "../Util/RealFunction.h"
#include "../Util/Utility.h"

/**	\brief MATLAB entry point.
 *
 *	This is the function that MATLAB actually calls when executing the included
 *	functions.  This function checks the validity of the inputs and outputs,
 *	and calls the actual worker function.
 *
 *	\param nlhs the number of expected output arguments.
 *	\param plhs placeholders for the output arguments.
 *	\param nrhs the number of input arguments.
 *	\param prhs the actual input arguments.
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if (nrhs < 2)
		mexErrMsgTxt("Too few arguments in MNBRAK.\n");

	if (nlhs > 2)
		mexErrMsgTxt("Too many outputs in MNBRAK.\n");
		
	if (!mxIsChar(prhs[0]))
		mexErrMsgTxt("First argument must be a fuction name (string) in MNBRAK.\n");
	
	std::string func = MakeString(prhs[0]);
	
	TmexArray X(prhs[1]);
	
	if (X.size() != 3)		
		mexErrMsgTxt("Second argument must be a 3 element array in MNBRAK.\n");
		
	if (IsComplex(X))
		mexErrMsgTxt("Second argument must be real in MNBRAK.\n");
		
	TReal ax = X[0];
	TReal bx = X[1];
	TReal cx = X[2];
	TReal fa=0, fb=0, fc=0;
	
	mnbrak(&ax, &bx, &cx, &fa, &fb, &fc, func, nrhs-2, prhs+2);
	
	plhs[0] = mxDuplicateArray(prhs[1]);
	
	TmexArray Y1(plhs[0]);
	
	Y1[0] = ax;
	Y1[1] = bx;
	Y1[2] = cx;
	
	if (nlhs > 0) {
		plhs[1] = mxDuplicateArray(prhs[1]);

		TmexArray Y2(plhs[1]);

		Y2[0] = fa;
		Y2[1] = fb;
		Y2[2] = fc;
	}
}

//! The golden mean.
const double GOLD	= 1.618034;

//!	Maximum step size.
const double GLIMIT	= 100.0;

//!	Prevents division by zero.
const double TINY	= 1.0E-20;

/**	Brackets the minimum of the supplied function.
 *
 *	\param ax	the lower bound.
 *	\param bx	the middle.
 *	\param cx	the upper bound.
 *	\param fa	the value of the function at ax.
 *	\param fb	the value of the function at bx.
 *	\param fc	the value of the function at cx.
 *	\param func	the function to bracket.
 *	\param nrhs	the number of additional parameters in prhs.
 *	\param prhs	the additional parameters for func.
 */
void mnbrak(TReal *ax, TReal *bx, TReal *cx, TReal *fa, TReal *fb, TReal *fc,
			const std::string &func, const int nrhs, const mxArray *prhs[])
{
	TReal ulim, u, r, q, fu;

	*fa=RealFunction(*ax, func, nrhs, prhs);
	*fb=RealFunction(*bx, func, nrhs, prhs);

	if (*fb > *fa) {
		std::swap(*ax,*bx);
		std::swap(*fa,*fb);
	}
	*cx = *bx + GOLD * (*bx - *ax);
	*fc = RealFunction(*cx, func, nrhs, prhs);
	while (*fb > *fc) {
		r = (*bx - *ax) * (*fb - *fc);
		q = (*bx - *cx) * (*fb - *fa);
		u = *bx - ((*bx - *cx) * q - (*bx - *ax) * r)/
			(2.0 * SIGN(max(fabs(q - r),TINY),q - r));
		ulim = (*bx) + GLIMIT * (*cx - *bx);
		if ((*bx - u) * (u - *cx) > 0.0) {
			fu=RealFunction(u, func, nrhs, prhs);
			if (fu < *fc) {
				*ax = *bx;
				*bx = u;
				*fa = *fb;
				*fb = fu;
				return;
			} else if (fu > *fb) {
				*cx = u;
				*fc = fu;
				return;
			}
			u = *cx + GOLD * (*cx - *bx);
			fu = RealFunction(u, func, nrhs, prhs);
		} else if ((*cx - u) * (u - ulim) > 0.0) {
			fu = RealFunction(u, func, nrhs, prhs);
			if (fu < *fc) {
				SHFT(*bx, *cx, u, u + GOLD * (u - *cx));
				SHFT(*fb, *fc, fu, RealFunction(u, func, nrhs, prhs));
			}
		} else if ((u - ulim) * (ulim - *cx) >= 0.0) {
			u = ulim;
			fu = RealFunction(u, func, nrhs, prhs);
		} else {
			u = *cx + GOLD * (*cx - *bx);
			fu = RealFunction(u, func, nrhs, prhs);
		}
		SHFT(*ax, *bx, *cx, u);
		SHFT(*fa, *fb, *fc, fu);
	}
}


