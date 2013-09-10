/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#include "dZdE_wWd_shg.h" 

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
	if (nrhs < 3)
		mexErrMsgTxt("Too few arguments in MEXCALCESIG.\n");

	if (nrhs > 3)
		mexErrMsgTxt("Too many arguments in MEXCALCESIG.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in MEXCALCESIG.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in MEXCALCESIG.\n");
		
	const TmexArray Esigp(prhs[0]); 
	const TmexArray Et(prhs[1]);
	const TmexArray D(prhs[2]);
	
	if (Esigp.size_M() != Et.size())
		mexErrMsgTxt("Size(ESIGP,1) must equal length(ET) in MEXCALCESIG.\n");
	
	if (IsComplex(Esigp) || IsComplex(Et))
		plhs[0] = mxCreateDoubleMatrix(Et.size_M(),Et.size_N(),mxCOMPLEX);
	else
		plhs[0] = mxCreateDoubleMatrix(Et.size_M(),Et.size_N(),mxREAL);
	
	TmexArray dZ(plhs[0]);
	
	dZdE_wWd_shg(Esigp, Et, D, dZ);
}

/**	Calculates the gradient of the Z error for SHG.
 *
 *	\param Esigp	the magnitude replaced Esig(w,W).
 *	\param Ew		the current best guess.
 *	\param D		the correction function.
 *	\param dZ		the gradient. 
 */
void dZdE_wWd_shg(const TmexArray &Esigp, const TmexArray &Ew, const TmexArray &D, TmexArray &dZ)
{
	int M = Esigp.size_M();	// The number of time points.
	int N = Esigp.size_N();	// The number of delay points.
	
	for(int w0 = 0; w0 < M; ++w0)
	{
		TCmplx T(0.0,0.0);
		for(int w = 0; w < N; ++w) {
			int wp = w - (w0 - N/2);
			if (wp >= 0 && wp < M) {
				T += (Ew[w0]*Ew[wp] * D(w,w0) - Esigp(w,w0)) * std::conj(Ew[wp] * D(w,w0));
				T += (Ew[w0]*Ew[wp] * D(w,wp) - Esigp(w,wp)) * std::conj(Ew[wp] * D(w,wp));
			}
		}
		dZ[w0] = T/static_cast<TReal>(Esigp.size());
	}
}
