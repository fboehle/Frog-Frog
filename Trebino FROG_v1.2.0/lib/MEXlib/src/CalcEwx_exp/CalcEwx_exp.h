/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#ifndef _CalcEwx_expH_
#define _CalcEwx_expH_

#include "../Util/mexArray.h"

//! Calculate E(w, x) with spatial dispersion and angular dispersion, with a Gaussian spatial profile
void CalcEwx_exp(TmexArray &Ewx, const TmexArray &Ew, const double* w1, const double* x, const double zeta,
					  const double beta, const double theta, const double w0);


#endif //_CalcEwx_expH_