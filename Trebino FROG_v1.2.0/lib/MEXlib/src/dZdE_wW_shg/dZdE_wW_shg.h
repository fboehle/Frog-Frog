/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#ifndef _dZdE_wW_shgH_
#define _dZdE_wW_shgH_

#include "../Util/mexArray.h"

//! Calculate the gradient of the Z error.
void dZdE_wW_shg(const TmexArray &Esigp, const TmexArray &Ew, TmexArray &dZ);

#endif //_dZdE_wW_shgH_
