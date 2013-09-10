/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#include "Gerr.h"

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
		mexErrMsgTxt("Too few arguments in GERR.\n");

	if (nrhs > 2)
		mexErrMsgTxt("Too many arguments in GERR.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in GERR.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in GERR.\n");
		
	TmexArray Esig(prhs[0]), Asig(prhs[1]);
	
	if (IsComplex(Asig))
		mexErrMsgTxt("Asig must be real in GERR.\n");
	
	TReal G = Gerr(Esig, Asig);
	
	plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
	
	TmexArray Out(plhs[0]);
	
	Out[0] = G;

}

/**	This function returns the G error of the given FROG traces.
 *
 *	\param Esig the current signal field.
 *	\param Asig the amplitude of the measured FROG trace.
 *
 *	\returns The G error between Asig and Esig.
 */
TReal Gerr(const TmexArray &Esig, const TmexArray &Asig)
{
	TReal G = 0.0;
	
	for (size_t i = 0; i < Esig.size(); ++i)
		if (std::real(Asig[i]) >= 0)
		{
			TReal T = std::norm(Asig[i]) - std::norm(Esig[i]);
			G += T*T;
		}
		
	return sqrt(G/Esig.size());
} 
