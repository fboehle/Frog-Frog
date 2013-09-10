/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#ifndef _RealFunctionH_
#define _RealFunctionH_

#include "mexArray.h"

/**	\brief	Wraps a MATLAB function call.
 *
 *	This function wraps a call to a MATLAB function taking
 *	at least one, real parameter and returning a single, real
 *	number.
 *
 *	\param x	the real parameter.
 *	\param func	the MATLAB function to call.
 *	\param nrhs	the number of additional parameters.
 *	\param prhs	the extra paramters to pass to func.
 *
 *	\returns the value of the function at x.
 */
TReal RealFunction(TReal x, const std::string &func, const int nrhs,
					const mxArray *prhs[])
{
	mxArray **rhs = (mxArray **)mxCalloc(nrhs+1, sizeof(mxArray *));

	if (nrhs > 0)
		for (int i = 0; i < nrhs; ++i) 
			rhs[i+1] = mxDuplicateArray(prhs[i]);
	
	rhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	
	TmexArray X(rhs[0]);
	
	X[0] = x;
	
	mxArray **plhs = (mxArray **)mxCalloc(1, sizeof(mxArray *));
	
	mexCallMATLAB(1, plhs, nrhs+1, rhs, func.c_str());
	
	TReal out = mxGetPr(plhs[0])[0];
	
	mxDestroyArray(plhs[0]);
	
	for (int i = 0; i < nrhs+1; ++i)
		mxDestroyArray(rhs[i]);
	
	mxFree(rhs);
	
	return out;	
}

#endif //_RealFunctionH_
