/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#ifndef _MagSqH_
#define _MagSqH_

#include "../Util/mexArray.h"

void MagSqR(const double *x, const int N, double *y);

void MagSqC(const double *xr, const double *xi, const int N, double *y);

#endif //_MagSqH_