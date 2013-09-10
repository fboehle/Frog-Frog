/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#include "MinGerr.h" 

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
		mexErrMsgTxt("Too few arguments in MINGERR.\n");

	if (nrhs > 2)
		mexErrMsgTxt("Too many arguments in MINGERR.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in MINGERR.\n");

	if (nlhs > 3)
		mexErrMsgTxt("Too many outputs in MINGERR.\n");

	TmexArray Esig(prhs[0]);
	TmexArray Asig(prhs[1]);

	plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
	TmexArray G(plhs[0]);
	
	TReal x = CalcGerrX(Esig, Asig);

	G[0] = Gerr(Esig, Asig, x);

	if (nlhs > 1) {
		plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
		TmexArray X(plhs[1]);
		X[0] = x;
	}

	if (nlhs > 2) {
		plhs[2] = mxCreateDoubleMatrix(1,1,mxREAL);
		TmexArray G0(plhs[2]);
		G0[0] = Gerr(Esig,Asig,1);
	}

}

/*!	Calculates the G error with Esig scales by X.  This
 *	function ignores points where Asig is less than zero.
 *	
 *	\param	Esig	the signal field
 *	\param	Asig	the amplitude
 *	\param	X		the scaling factor.
 *	
 *	\returns		the G error.
 */
TReal Gerr(const TmexArray Esig, const TmexArray Asig, const TReal X)
{
	TReal G = 0.0;
	TReal mx = 0.0;
	
	for (size_t i = 0; i < Esig.size(); ++i)
		if (IsComplex(Asig)||std::real(Asig[i]) >= 0)
		{
//			TReal T = (X * std::norm(Esig[i])) - std::norm(Asig[i]);
			TReal T = std::norm(Asig[i]);
			if (mx < T)
				mx = T;
			T -= X * std::norm(Esig[i]);
			G += T * T;
		}
	return sqrt(G / Esig.size()) / mx;
}

/*!	Calculates the scaling factor that minimizes the G error.  This
 *	function ignores points where Asig is less than zero.
 *	
 *	\param	Esig	the signal field.
 *	\param	Asig	the amplitude.
 *	
 *	\returns	
 *	\retval	
 */
TReal CalcGerrX(const TmexArray Esig, const TmexArray Asig)
{
	TReal a = 0.0;
	TReal b = 0.0;
	
	for (size_t i = 0; i < Esig.size(); ++i)
		if (IsComplex(Asig)||std::real(Asig[i]) >= 0)
		{
			TReal T = std::norm(Esig[i]);
			a += T * T;
			b += T * std::norm(Asig[i]);
		}
		
	return b/a;
}

