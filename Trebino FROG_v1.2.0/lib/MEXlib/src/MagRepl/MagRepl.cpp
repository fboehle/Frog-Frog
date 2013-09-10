/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#include "MagRepl.h" 

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
		mexErrMsgTxt("Too few arguments in MEXMAGREPL.\n");

	if (nrhs > 2)
		mexErrMsgTxt("Too many arguments in MEXMAGREPL.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in MEXMAGREPL.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in MEXMAGREPL.\n");

	plhs[0] = mxDuplicateArray(prhs[0]);
	
	TmexArray Esig(plhs[0]);
	const TmexArray Asig(prhs[1]);
	
	MagRepl(Esig, Asig);
}

/*!	Replaces the magnitude of Esig with the magnitude of Asig.
 *	This preserves the phase of Esig.
 *	Does not replace Esig's magnitude where Asig is less than
 *	zero.
 *	
 *	\param	Esig	the input array.
 *	\param	Asig	the amplitude array.
 */
void MagRepl(TmexArray &Esig, const TmexArray &Asig)
{
	for (size_t i = 0; i < Esig.size(); ++i) {
		if (std::real<TReal>(Asig[i]) >= 0)
			if (std::norm<TReal>(Esig[i]) != 0.0)
				Esig[i] = Asig[i] * TCmplx(Esig[i]) / std::abs<TReal>(Esig[i]);
			else
				Esig[i] = Asig[i];
	}
}
