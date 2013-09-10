/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#include "dZdE_blindpg.h"

using std::norm;
using std::real;
using std::conj;

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
		mexErrMsgTxt("Too few arguments in dZdE_blindpg.\n");

	if (nrhs > 4)
		mexErrMsgTxt("Too many arguments in dZdE_blindpg.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in dZdE_blindpg.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in dZdE_blindpg.\n");
		
	const TmexArray Esig1(prhs[0]);
	const TmexArray Esig2(prhs[1]);
	const TmexArray E1(prhs[2]);
	const TmexArray E2(prhs[3]);
	
	if (Esig1.size_M() != E1.size() || Esig2.size_M() != E2.size() || E1.size() != E2.size() || Esig1.size_N() != Esig2.size_N())
		mexErrMsgTxt("Size(Esig1, 1) and size(Esig2, 1) must equal length(E1) and length(E2) in dZdE_blindpg.\n");
	
	if (IsComplex(Esig1) || IsComplex(Esig2) || IsComplex(E1) || IsComplex(E2))
		plhs[0] = mxCreateDoubleMatrix(E1.size_M(), E1.size_N(), mxCOMPLEX);
	else
		plhs[0] = mxCreateDoubleMatrix(E1.size_M(), E1.size_N(), mxCOMPLEX);
	
	TmexArray dZ(plhs[0]);
	
	dZdE_blindpg(Esig1, Esig2, E1, E2, dZ);
}

/**	Calculates the gradient of the Z error for SHG.
 *
 *	\param Esigp	the magnitude replaced Esig(t,tau).
 *	\param Et		the current best guess.
 *	\param dZ		the gradient. 
 */
void dZdE_blindpg(const TmexArray &Esig1, const TmexArray &Esig2, const TmexArray &E1, const TmexArray &E2, TmexArray &dZ)
{
	int M = Esig1.size_M();	// The number of time points.
	int N = Esig1.size_N();	// The number of delay points.
	TReal sz = Esig1.size();
	
	for(int t0 = 0; t0 < M; ++t0)
	{
		TCmplx T(0.0,0.0);
		for(int tau = 0; tau < N; ++tau) {
			int tp = t0 - (tau - N/2);
			if (tp >= 0 && tp < M) {
				T += (E1[t0] * norm(E2[tp]) - Esig1(t0, tau)) * norm(E2[tp]);
			}
			tp = t0 + (tau - N/2);
			if (tp >= 0 && tp < M) {
				T += 2. * real(conj(E2[tp]) * (E2[tp] * norm(E1[t0]) - Esig2(tp, tau))) * E1(t0);
			}
		}
		dZ[t0] = T/sz;
	}
}