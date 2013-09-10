/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#include "MinZerrKern2_blindpg.h"
using std::norm;
using std::conj;
using std::real;

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
		mexErrMsgTxt("Too few arguments in MinZerrKern2_BLINDPG.\n");

	if (nrhs > 6)
		mexErrMsgTxt("Too many arguments in MinZerrKern2_BLINDPG.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in MinZerrKern2_BLINDPG.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in MinZerrKern2_BLINDPG.\n");

	const TmexArray Esig1(prhs[0]);
	const TmexArray Esig2(prhs[1]);
	const TmexArray Et1(prhs[2]);
	const TmexArray Et2(prhs[3]);
	const TmexArray dZ1(prhs[4]);
	const TmexArray dZ2(prhs[5]);
	
	plhs[0] = mxCreateDoubleMatrix(5, 5, mxREAL);

	TmexArray X(plhs[0]);

	for (size_t i = 0; i < X.size(); ++i)
		X[i] = 0.0;

//	printf("%g, %g, %g, %g\n", double(X(0)), double(X[1]), double(X[2]), double(X[3]));

	MinZerrKern2_blindpg(Esig1, Esig2, Et1, Et2, dZ1, dZ2, X);

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
void MinZerrKern2_blindpg(const TmexArray &Esig1, const TmexArray &Esig2, const TmexArray &E1,
                    const TmexArray &E2, const TmexArray &dZ1, const TmexArray &dZ2, TmexArray &X)
{
	int Nt		= Esig1.size_M();
	int Ntau	= Esig2.size_N();
	TCmplx a[2][3], b[3][2];

	for(int t = 0; t < Nt; ++t)
		for(int tau = 0; tau < Ntau; ++tau) {
			int tp = t - (tau - Ntau/2);
			if (tp >= 0 && tp < Nt) {
                a[0][0]	= E1[t] * norm(E2[tp]) - Esig1(t, tau);
                a[1][0]	= norm(E2[tp]) * dZ1[t];
				a[0][1]	= 2. * E1[t] * real(conj(E2[tp]) * dZ2[tp]);
                a[1][1] = 2. * dZ1[t] * real(conj(E2[tp]) * dZ2[tp]);
				a[0][2] = E1[t] * norm(dZ2[tp]);
				a[1][2] = dZ1[t] * norm(dZ2[tp]);
                b[0][0] = E2[t] * norm(E1[tp]) - Esig2(t, tau);
                b[0][1] = norm(E1[tp]) * dZ2[t];
				b[1][0] = 2. * E2[t] * real(conj(E1[tp]) * dZ1[tp]);
                b[1][1] = 2. * dZ2[t] * real(conj(E1[tp]) * dZ1[tp]);
				b[2][0] = E2[t] * norm(dZ1[tp]);
                b[2][1] = dZ2[t] * norm(dZ1[tp]);

				X(0, 0)	= X(0, 0) + norm(a[0][0]) + norm(b[0][0]);
				X(0, 1) = X(0, 1) + 2. * real(a[0][0] * conj(a[0][1]) + b[0][0] * conj(b[0][1]));
				X(0, 2) = X(0, 2) + norm(a[0][1]) + 2. * real(a[0][0] * conj(a[0][2])) + norm(b[0][1]);
				X(0, 3) = X(0, 3) + 2. * real(a[0][1] * conj(a[0][2]));
				X(0, 4) = X(0, 4) + norm(a[0][2]);
				X(1, 0)	= X(1, 0) + 2. * real(a[0][0] * conj(a[1][0]) + b[0][0] * conj(b[1][0]));
				X(1, 1) = X(1, 1) + 2. * real(a[0][1] * conj(a[1][0]) + a[0][0] * conj(a[1][1]) + b[0][1] * conj(b[1][0]) + b[0][0] * conj(b[1][1]));
				X(1, 2) = X(1, 2) + 2. * real(a[0][2] * conj(a[1][0]) + a[0][1] * conj(a[1][1]) + a[0][0] * conj(a[1][2]) + b[0][1] * conj(b[1][1]));
				X(1, 3) = X(1, 3) + 2. * real(a[0][2] * conj(a[1][1]) + a[0][1] * conj(a[1][2]));
				X(1, 4) = X(1, 4) + 2. * real(a[0][2] * conj(a[1][2]));
				X(2, 0) = X(2, 0) + norm(a[1][0]) + norm(b[1][0]) + 2. * real(b[0][0] * conj(b[2][0]));
				X(2, 1) = X(2, 1) + 2. * real(a[1][0] * conj(a[1][1]) + b[1][0] * conj(b[1][1]) + b[0][1] * conj(b[2][0]) + b[0][0] * conj(b[2][1]));
				X(2, 2) = X(2, 2) + norm(a[1][1]) + norm(b[1][1]) + 2. * real(a[1][0] * conj(a[1][2]) + b[0][1] * conj(b[2][1]));
				X(2, 3) = X(2, 3) + 2. * real(a[1][1] * conj(a[1][2]));
				X(2, 4) = X(2, 4) + norm(a[1][2]);
				X(3, 0) = X(3, 0) + 2. * real(b[1][0] * conj(b[2][0]));
				X(3, 1) = X(3, 1) + 2. * real(b[1][1] * conj(b[2][0]) + b[1][0] * conj(b[2][1]));
				X(3, 2) = X(3, 2) + 2. * real(b[1][1] * conj(b[2][1]));
				//X(3, 3) = X(3, 3) + 0.;
				//X(3, 4) = X(3, 4) + 0.;
				X(4, 0) = X(4, 0) + norm(b[2][0]);
				X(4, 1) = X(4, 1) + 2. * real(b[2][0] * conj(b[2][1]));
				X(4, 2) = X(4, 2) + norm(b[2][1]);
				//X(4, 3) = X(4, 3) + 0.;
				//X(4, 4) = X(4, 4) + 0.;
			}
		}

	int N = Esig1.size();
	for (int i = 0; i < 5; ++i)
			for (int j = 0; j < 5; ++j)
                X(i, j) = X(i, j)/N;
}