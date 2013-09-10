/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#include "MinZerrKern_pg.h"

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
	if (nrhs < 3)
		mexErrMsgTxt("Too few arguments in MINZERRKERN_SHG.\n");

	if (nrhs > 3)
		mexErrMsgTxt("Too many arguments in MINZERRKERN_SHG.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in MINZERRKERN_SHG.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in MINZERRKERN_SHG.\n");

	const TmexArray Esig(prhs[0]);
	const TmexArray Et0(prhs[1]);
	const TmexArray dZ(prhs[2]);

	plhs[0] = mxCreateDoubleMatrix(1,7,mxREAL);

	TmexArray X(plhs[0]);

	for (size_t i = 0; i < X.size(); ++i)
		X[i] = 0.0;

//	printf("%g, %g, %g, %g\n", double(X(0)), double(X[1]), double(X[2]), double(X[3]));

	MinZerrKern_shg(Esig, Et0, dZ, X);

//	printf("%g, %g, %g, %g\n", double(X(0)), double(X[1]), double(X[2]), double(X[3]));
}

/*!	Calculates the coeficients of the Z(x) polynomial, where
 *	X is defined by:
 *	Et(t) = Et0(t) + x*dZ(t)
 *	
 *	\param	Esig	the signal field.
 *	\param	Et0		the electric field.
 *	\param	dZ		the gradient.
 *	\param	X		the coefficients.
 */
void MinZerrKern_shg(const TmexArray &Esig, const TmexArray &Et0, const TmexArray &dZ, TmexArray &X)
{
	int Nt		= Esig.size_M();
	int Ntau	= Esig.size_N();
	TReal mx	= 0.0;
	TReal T;
	
	for(int t = 0; t < Nt; ++t)
		for(int tau = 0; tau < Ntau; ++tau) {
			T = std::norm(Esig(t, tau));
			if (mx < T)
				mx = T;
			int tp = t - (tau - Ntau/2);
			if (tp >= 0 && tp < Nt) {
				TReal T1	= real(dZ[tp] * conj(Et0[tp]));

				TCmplx a	= Et0[t] * norm(Et0[tp]) - Esig(t,tau);
				TCmplx b	= 2.0 * Et0[t] * T1 +  dZ[t] * norm(Et0[tp]);
				TCmplx c	= 2.0 *  dZ[t] * T1 + Et0[t] * norm( dZ[tp]);
				TCmplx d	= dZ[t] * norm(dZ[tp]);

				X[6] = X[6] + norm(a);
				X[5] = X[5] + 2.0 * real(a * conj(b));
				X[4] = X[4] + 2.0 * real(a * conj(c)) + norm(b);
				X[3] = X[3] + 2.0 * real(a * conj(d) + b * conj(c));
				X[2] = X[2] + 2.0 * real(b * conj(d)) + norm(c);
				X[1] = X[1] + 2.0 * real(c * conj(d));
				X[0] = X[0] + norm(d);
			}
		}

	T = Esig.size() * mx;

	X[0] = X[0] / T;
	X[1] = X[1] / T;
	X[2] = X[2] / T;
	X[3] = X[3] / T;
	X[4] = X[4] / T;
	X[5] = X[5] / T;
	X[6] = X[6] / T;
}

