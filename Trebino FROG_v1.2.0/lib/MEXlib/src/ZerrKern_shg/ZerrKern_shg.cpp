/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#include "ZerrKern_shg.h"

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
		mexErrMsgTxt("Too few arguments in ZERRKERN_SHG.\n");

	if (nrhs > 4)
		mexErrMsgTxt("Too many arguments in ZERRKERN_SHG.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few outputs in ZERRKERN_SHG.\n");

	if (nlhs > 3)
		mexErrMsgTxt("Too many outputs in ZERRKERN_SHG.\n");

	const TmexArray Xa(prhs[0]);
	const TmexArray Esig(prhs[1]);
	const TmexArray Etemp(prhs[2]);
	const TmexArray dZ(prhs[3]);

	TCmplx X = Xa[0];

	mxArray *Temp =
		mxCreateDoubleMatrix(Etemp.size_M(), Etemp.size_N(), mxCOMPLEX);
	TmexArray Et(Temp);

	for (size_t i = 0; i < Et.size(); ++i)
		Et[i] = Etemp[i] + (X * dZ[i]);

	plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);

	TmexArray Z(plhs[0]);

	Z[0] = Zerr2(Esig, Et);

	if (nlhs > 1) {
		plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
		TmexArray dX(plhs[1]);

		dX[0] = Zerr2Grad(Esig, Et, dZ, X);
	}

	if (nlhs > 2){
		plhs[2] = mxCreateDoubleMatrix(1,1,mxREAL);
		TmexArray Hess(plhs[2]);
	
		Hess[0] = Zerr2Hess(Esig, Et, dZ, X);
	}
}

/**	Calculates the Z error.
 *
 *	\param	Esig	the FROG signal field.
 *	\param	Et		the electric field.
 *	\returns	the Z error.
 */
TReal Zerr2(const TmexArray &Esig, const TmexArray Et)
{
	TReal Z = 0.0;
	for(size_t t = 0; t<Esig.size_M(); ++t)
		for(size_t tau = 0; tau<Esig.size_N(); ++tau) {
			int tp = t - (tau - Esig.size_N()/2);
			if (tp >= 0 && tp < static_cast<int>(Et.size())) {
				Z += std::norm((Et(t) * Et(tp)) - Esig(t,tau));
			}
		}
	return Z/Esig.size();
}

/**	Calculates the gradient of the Z error with
 *	respect to the parameter X.
 *
 *	Et = Et(0) + X x dZ
 *
 *	\param	Esig	the FROG signal field.
 *	\param	Et		the electric field.
 *	\param	dZ		the direction of X.
 *	\param	X		the size of the current step.
 *	\returns	the derivative of Z wrt X.
 */
TReal Zerr2Grad(const TmexArray &Esig, const TmexArray &Et,
	const TmexArray &dZ, const TCmplx X)
{
	TReal dX = 0.0;
	for(size_t t = 0; t<Esig.size_M(); ++t)
		for(size_t tau = 0; tau<Esig.size_N(); ++tau) {
			int tp = t - (tau - Esig.size_N()/2);
			if (tp >= 0 && tp < static_cast<int>(Et.size())) {
				dX += 2 * std::real(
					(Et(t) * Et(tp) - Esig(t,tau)) *
					std::conj(Et[t] * dZ[tp] + Et[tp] * dZ[t])
					);
			}
		}
	return dX/Esig.size();
}

/**	Calculates the second derivative of the Z error with
 *	respect to the parameter X.
 *
 *	Et = Et(0) + X x dZ
 *
 *	\param	Esig	the FROG signal field.
 *	\param	Et		the electric field.
 *	\param	dZ		the direction of X.
 *	\param	X		the size of the current step.
 *	\returns	the second derivative of Z wrt X.
 */
TReal Zerr2Hess(const TmexArray &Esig, const TmexArray &Et,
	const TmexArray &dZ, const TCmplx X)
{
	TReal ddX = 0.0;
	for(size_t t = 0; t<Esig.size_M(); ++t)
		for(size_t tau = 0; tau<Esig.size_N(); ++tau) {
			int tp = t - (tau - Esig.size_N()/2);
			if (tp >= 0 && tp < static_cast<int>(Et.size())) {
				ddX += 2 * std::norm(Et[t] * dZ[tp] + Et[tp] * dZ[t])
					+ 4 * std::real(
					(Et(t) * Et(tp) - Esig(t,tau)) *
					std::conj( dZ[tp] * dZ[t])
					);
			}
		}
	return ddX/Esig.size();
}
 