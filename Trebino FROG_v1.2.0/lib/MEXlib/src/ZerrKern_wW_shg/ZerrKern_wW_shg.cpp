/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#include "ZerrKern_wW_shg.h"

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
	if (nrhs < 4)
		mexErrMsgTxt("Too few arguments in ZERRKERN_SHG.\n");

	if (nrhs > 4)
		mexErrMsgTxt("Too many arguments in ZERRKERN_SHG.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in ZERRKERN_SHG.\n");

	if (nlhs > 3)
		mexErrMsgTxt("Too many outputs in ZERRKERN_SHG.\n");

	const TmexArray Xa(prhs[0]);
	const TmexArray Esig(prhs[1]);
	const TmexArray Etemp(prhs[2]);
	const TmexArray dY(prhs[3]);

	TCmplx X = Xa[0];

	mxArray *Temp =
		mxCreateDoubleMatrix(Etemp.size_M(), Etemp.size_N(), mxCOMPLEX);
	TmexArray Ew(Temp);

	for (size_t i = 0; i < Ew.size(); ++i)
		Ew[i] = Etemp[i] + (X * dY[i]);

	plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);

	TmexArray Y(plhs[0]);

	Y[0] = Zerr2_wW(Esig, Ew);
}

/**	Calculates the Y error.
 *
 *	\param	Esig	the FROG signal field.
 *	\param	Ew		the electric field.
 *	\returns	the Y error.
 */
TReal Zerr2_wW(const TmexArray &Esig, const TmexArray Ew)
{
	TReal Z = 0.0;
	for(size_t w = 0; w<Esig.size_M(); ++w)
		for(size_t W = 0; W<Esig.size_N(); ++W) {
			int wp = w - (W - Esig.size_N()/2);
			if (wp >= 0 && wp < static_cast<int>(Ew.size())) {
				Z += std::norm((Ew(W) * Ew(wp)) - Esig(w,W));
			}
		}
	return Z/Esig.size();
}
