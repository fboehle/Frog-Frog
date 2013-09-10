/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#ifndef _MinZerrKern_shgH_
#define _MinZerrKern_shgH_

#include "../Util/mexArray.h"

//!	Calculates the coefficients.
void MinZerrKern_shg(const TmexArray &Esig, const TmexArray &Et, const TmexArray &dZ, TmexArray &X);

#endif //_MinZerrKern_shgH_
