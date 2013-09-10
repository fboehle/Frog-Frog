/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#include "CalcEwx_exp.h" 

/**	\brief MATLAB entry point.
 *
 *	This is the function that MATLAB actually calls when executing the included
 *	functions.  This function checks the validity of the inputs and outputs,
 *	and calls the actual worker function.
 *
 *	\param nlhs the number of expected output arguments.
 *	\param plhs place holders for the output arguments.
 *	\param nrhs the number of input arguments.
 *	\param prhs the actual input arguments.
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	if (nrhs < 7)
		mexErrMsgTxt("Too few arguments in mexdGdzeta_gren.\n");

	if (nrhs > 7)
		mexErrMsgTxt("Too many arguments in mexdGdzeta_gren.\n");

	if (nlhs < 1)
		mexErrMsgTxt("Too few outputs in mexdGdzeta_gren.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in mexdGdzeta_gren.\n");
		
	const TmexArray Ew(prhs[0]);			// E(w)
	const double* w = mxGetPr(prhs[1]);				// vector w
	const double* x = mxGetPr(prhs[2]);				// vector x
	const double zeta = mxGetScalar(prhs[3]);		// spatial dispersion
	const double beta = mxGetScalar(prhs[4]);		// angular dispersion
	const double theta = mxGetScalar(prhs[5]);	// half crossing angle
	const double w0 = mxGetScalar(prhs[6]);		// 1/e-amplitude half width of the beam
	
	//int Nw = w.size();

	//if (Esigm.size_M() != Nw || Ew.size() != Nw || Esigm.size_N() != x.size())
	//	mexErrMsgTxt("Dimensions do not agree in mexdGdzeta_gren.\n");
		
	plhs[0] = mxCreateDoubleMatrix(static_cast<int>(mxGetNumberOfElements(prhs[1])), static_cast<int>(mxGetNumberOfElements(prhs[2])), mxCOMPLEX);
	
	TmexArray Ewx(plhs[0]);			// calculated Esig(w, x)
	
	CalcEwx_exp(Ewx, Ew, w, x, zeta, beta, theta, w0);
}

/**	\brief Calculates Esig.
 *
 *	Calculates Esig(t,tau) given the probe and gate pulses.
 *
 *	\param Esig	the array to store the calculation in.
 *	\param P	the probe pulse.
 *	\param G	the gate pulse.
 */
void CalcEwx_exp(TmexArray &Ewx, const TmexArray &Ew, const double* w1, const double* x, const double zeta,
					  const double beta, const double theta, const double w0)
{
	int M = Ewx.size_M();	// The number of time points.
	int N = Ewx.size_N();	// The number of delay points.

	const double c = 299.7925;
	
	double omega0 = w1[M / 2];
	
	for (int nw = 0; nw < M; ++nw)
	{
		double w = w1[nw] - omega0;
		for (int nx = 0; nx < N; ++nx)
		{
			double xw = (x[nx] - zeta * w) / w0;
			double Ewxi = (beta * omega0 - theta) * w * x[nx] / c;
			Ewx(nw, nx) = Ew[nw] * exp(-xw * xw) * TCmplx(cos(Ewxi), sin(Ewxi));
		}
	}
}
