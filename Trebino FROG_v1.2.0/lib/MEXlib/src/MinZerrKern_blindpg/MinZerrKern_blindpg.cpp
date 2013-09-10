/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#include "MinZerrKern_blindpg.h"

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
	if (nrhs < 6)
		mexErrMsgTxt("Too few arguments in MINZERRKERN_BLINDPG.\n");

	if (nrhs > 6)
		mexErrMsgTxt("Too many arguments in MINZERRKERN_BLINDPG.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in MINZERRKERN_BLINDPG.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in MINZERRKERN_BLINDPG.\n");

	const TmexArray Esig1(prhs[0]);
	const TmexArray Esig2(prhs[1]);
	const TmexArray Et1(prhs[2]);
	const TmexArray Et2(prhs[3]);
	const TmexArray dZ1(prhs[4]);
	const TmexArray dZ2(prhs[5]);
	
	plhs[0] = mxCreateDoubleMatrix(1, 7, mxREAL);

	TmexArray X(plhs[0]);

	for (size_t i = 0; i < X.size(); ++i)
		X[i] = 0.0;

//	printf("%g, %g, %g, %g\n", double(X(0)), double(X[1]), double(X[2]), double(X[3]));

	MinZerrKern_blindpg(Esig1, Esig2, Et1, Et2, dZ1, dZ2, X);

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
void MinZerrKern_blindpg(const TmexArray &Esig1, const TmexArray &Esig2, const TmexArray &E1,
                    const TmexArray &E2, const TmexArray &dZ1, const TmexArray &dZ2, TmexArray &X)
{
	int Nt		= Esig1.size_M();
	int Ntau	= Esig2.size_N();
	TCmplx a1, b1, c1, d1, a2, b2, c2, d2;

	for(int t = 0; t < Nt; ++t)
		for(int tau = 0; tau < Ntau; ++tau) {
			int tp = t - (tau - Ntau/2);
			if (tp >= 0 && tp < Nt) {
                a1  = E1[t] * std::norm(E2[tp]) - Esig1(t, tau);
                b1  = std::norm(E2[tp]) * dZ1[t] + 2. * E1[t] * std::real(std::conj(E2[tp]) * dZ2[tp]);
                c1  = 2. * dZ1[t] * std::real(std::conj(E2[tp]) * dZ2[tp]) + E1[t] * std::norm(dZ2[tp]);
                d1  = dZ1[t] * std::norm(dZ2[tp]);
                a2  = E2[t] * std::norm(E1[tp]) - Esig2(t, tau);
                b2  = std::norm(E1[tp]) * dZ2[t] + 2. * E2[t] * std::real(std::conj(E1[tp]) * dZ1[tp]);
                c2  = 2. * dZ2[t] * std::real(std::conj(E1[tp]) * dZ1[tp]) + E2[t] * std::norm(dZ1[tp]);
                d2  = dZ2[t] * std::norm(dZ1[tp]);
				X[6] = X[6] + std::norm(a1) + std::norm(a2);
				X[5] = X[5] + 2. * std::real(a1 * std::conj(b1) + a2 * std::conj(b2));
				X[4] = X[4] + 2. * std::real(a1 * std::conj(c1) + a2 * std::conj(c2)) + std::norm(b1) + std::norm(b2);
				X[3] = X[3] + 2. * std::real(a1 * std::conj(d1) + a2 * std::conj(d2) + b1 * std::conj(c1) + b2 * std::conj(c2));
				X[2] = X[2] + 2. * std::real(b1 * std::conj(d1) + b2 * std::conj(d2)) + std::norm(c1) + std::norm(c2);
				X[1] = X[1] + 2. * std::real(c1 * std::conj(d1) + c2 * std::conj(d2));
				X[0] = X[0] + std::norm(d1) + std::norm(d2);
			}
		}

	X[0] = X[0]/Esig1.size();
	X[1] = X[1]/Esig1.size();
	X[2] = X[2]/Esig1.size();
	X[3] = X[3]/Esig1.size();
	X[4] = X[4]/Esig1.size();
	X[5] = X[5]/Esig1.size();
	X[6] = X[6]/Esig1.size();
}