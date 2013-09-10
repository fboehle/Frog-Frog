/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#ifndef _dZdE_blindpgH_
#define _dZdE_blindpgH_

#include "../Util/mexArray.h"

//! Calculate the gradient of the Z error.
void dZdE_blindpg(const TmexArray &Esig1, const TmexArray &Esig2, const TmexArray &E1, const TmexArray &E2, TmexArray &dZ);

#endif //_dZdE_blindpgH_
