/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#ifndef _ZerrH_
#define _ZerrH_

#include "../Util/mexArray.h"

//! Calculate the Z FROG error.
TReal Zerr(const TmexArray &Esig, const TmexArray &Esigp);

#endif //_ZerrH_
