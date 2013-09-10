/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#ifndef _MinGerrH_
#define _MinGerrH_

#include "../Util/mexArray.h"

//!	Calculates the G error.
TReal Gerr(const TmexArray Esig, const TmexArray Asig, const TReal X = 1.0);

//!	Minimizes the G error.
TReal CalcGerrX(const TmexArray Esig, const TmexArray Asig);

#endif //_MinGerrH_
