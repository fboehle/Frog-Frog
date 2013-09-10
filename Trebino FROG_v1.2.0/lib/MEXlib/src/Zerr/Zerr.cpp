/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#include "Zerr.h"

using std::norm;

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
		mexErrMsgTxt("Too few arguments in ZERR.\n");

	if (nrhs > 2)
		mexErrMsgTxt("Too many arguments in ZERR.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in ZERR.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in ZERR.\n");
		
	const TmexArray Esig(prhs[0]);
	const TmexArray Esigp(prhs[1]);
	
	plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);

	TmexArray Z(plhs[0]);
	
	Z[0] = Zerr(Esig, Esigp);
}

/**	This function returns the Z error of the given FROG traces.
 *
 *	\param Esig the current signal field.
 *	\param Esigp the last signal field.
 *
 *	\returns The Z error between Esigp and Esig.
 */
TReal Zerr(const TmexArray &Esig, const TmexArray &Esigp)
{
	TReal Z = 0.0;
	
	for (size_t i = 0; i < Esig.size(); ++i)
		Z += norm(Esig[i] - Esigp[i]);
		
	return (Z/Esig.size());
} 
