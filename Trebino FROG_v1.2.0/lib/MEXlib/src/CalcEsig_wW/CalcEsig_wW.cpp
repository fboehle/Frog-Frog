/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#include "CalcEsig_wW.h" 

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
	if (nrhs < 2)
		mexErrMsgTxt("Too few arguments in MEXCALCESIG.\n");

	if (nrhs > 3)
		mexErrMsgTxt("Too many arguments in MEXCALCESIG.\n");

	if (nrhs < 0)
		mexErrMsgTxt("Too few arguments in MEXCALCESIG.\n");

	if (nlhs > 1)
		mexErrMsgTxt("Too many outputs in MEXCALCESIG.\n");
		
	TmexArray P(prhs[0]), G(prhs[1]);

	if (P.size() != G.size())
		mexErrMsgTxt("P and G must be the same size in MEXCALCESIG.\n");

	double size_mult = 1;

	if (nrhs > 2) {
		TmexArray S(prhs[2]);
		if (S.size() == 1) {
			size_mult = S[0];
		}
	}
	
	if(!IsComplex(P) && !IsComplex(G) )
		plhs[0] = mxCreateDoubleMatrix(P.size(),static_cast<int>(size_mult*P.size()),mxREAL);
	else
		plhs[0] = mxCreateDoubleMatrix(P.size(),static_cast<int>(size_mult*P.size()),mxCOMPLEX);
	
	TmexArray Esig(plhs[0]);
		
	CalcEsig_wW(Esig, P, G);
}

/**	\brief Calculates Esig.
 *
 *	Calculates Esig(w,W) given the probe and gate pulses.
 *
 *	\param Esig	the array to store the calculation in.
 *	\param P	the probe pulse.
 *	\param G	the gate pulse.
 */
void CalcEsig_wW(TmexArray &Esig, const TmexArray &P, const TmexArray &G)
{
	for(size_t w = 0; w < Esig.size_M(); ++w)
		for(size_t W = 0; W < Esig.size_N(); ++W) {
			int wp = w - (W - Esig.size_N()/2);
			if (wp >= 0 && wp < static_cast<int>(P.size())) {
				Esig(w,W) = P[wp] * G[W];
			}
		}
}
