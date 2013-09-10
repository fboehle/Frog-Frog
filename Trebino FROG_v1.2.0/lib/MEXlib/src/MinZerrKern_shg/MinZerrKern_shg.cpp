/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#include "MinZerrKern_shg.h"

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

	plhs[0] = mxCreateDoubleMatrix(1,5,mxREAL);

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
				TCmplx dZdZ		= dZ[t] * dZ[tp];
				TCmplx dZE		= dZ[t] * Et0[tp] + dZ[tp] * Et0[t];
				TCmplx DEsig	= Et0[t] * Et0[tp] - Esig(t,tau);

				X[0] = X[0] + std::norm(dZdZ);
				X[1] = X[1] + 2.0 * std::real(dZE * std::conj(dZdZ));
				X[2] = X[2] + 2.0 * std::real(DEsig * std::conj(dZdZ)) + std::norm(dZE);
				X[3] = X[3] + 2.0 * std::real(DEsig * std::conj(dZE));
				X[4] = X[4] + std::norm(DEsig);
			}
		}

	T = Esig.size() * mx;
	X[0] = X[0] / T;
	X[1] = X[1] / T;
	X[2] = X[2] / T;
	X[3] = X[3] / T;
	X[4] = X[4] / T;
}
