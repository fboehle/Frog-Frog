/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#ifndef _dZdE_thgH_
#define _dZdE_thgH_

#include "../Util/mexArray.h"

//! Calculate the gradient of the Z error.
void dZdE_thg(const TmexArray &Esigp, const TmexArray &Et, TmexArray &dZ);

#endif //_dZdE_thgH_
