/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#ifndef _MnbrakH_
#define _MnbrakH_

#include "../Util/mexArray.h"

//! Gets the initial bracket of a minimum.
void mnbrak(TReal *ax, TReal *bx, TReal *cx, TReal *fa, TReal *fb, TReal *fc,
			const std::string &func, const int nrhs, const mxArray *prhs[]);

#endif //_MnbrakH_
