/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#include "dZdE_pg.h"

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
	if (nrhs < 2)
		mexErrMsgTxt("Too few arguments in dZdE_pg.\n");

	if (nrhs > 2)
		mexErrMsgTxt("Too many arguments in dZdE_pg.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in dZdE_pg.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in dZdE_pg.\n");
		
	const TmexArray Esigp(prhs[0]); 
	const TmexArray Et(prhs[1]);
	
	if (Esigp.size_M() != Et.size())
		mexErrMsgTxt("Size(ESIGP,1) must equal length(ET) in MEXCALCESIG.\n");
	
	if (IsComplex(Esigp) || IsComplex(Et))
		plhs[0] = mxCreateDoubleMatrix(Et.size_M(),Et.size_N(),mxCOMPLEX);
	else
		plhs[0] = mxCreateDoubleMatrix(Et.size_M(),Et.size_N(),mxCOMPLEX);
	
	TmexArray dZ(plhs[0]);
	
	dZdE_pg(Esigp, Et, dZ);
}

/**	Calculates the gradient of the Z error for SHG.
 *
 *	\param Esigp	the magnitude replaced Esig(t,tau).
 *	\param Et		the current best guess.
 *	\param dZ		the gradient. 
 */
void dZdE_pg(const TmexArray &Esigp, const TmexArray &Et, TmexArray &dZ)
{
	int M = Esigp.size_M();	// The number of time points.
	int N = Esigp.size_N();	// The number of delay points.
	TReal sz = Esigp.size();
	
	for(int t0 = 0; t0 < M; ++t0)
	{
		TCmplx T(0.0,0.0);
		for(int tau = 0; tau < N; ++tau) {
			int tp = t0 - (tau - N/2);
			if (tp >= 0 && tp < M) {
				T += (Et[t0] * norm(Et[tp]) - Esigp(t0,tau)) * norm(Et[tp]);
			}
			tp = t0 + (tau - N/2);
			if (tp >= 0 && tp < M) {
				T += 2.0 * (norm(Et[tp]) * norm(Et[t0]) - real(Esigp(tp,tau) * conj(Et[tp]))) * Et(t0);
			}
		}
		dZ[t0] = T/sz;
	}
}
