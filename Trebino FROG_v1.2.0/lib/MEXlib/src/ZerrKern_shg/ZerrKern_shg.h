/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:30 $
 *	$Revision: 1.1 $
 */

#ifndef _ZerrKern_shgH_
#define _ZerrKern_shgH_

#include "../Util/mexArray.h"

//!	The Z error.
TReal Zerr2(const TmexArray &Esig, const TmexArray Et);

//! The gradient of the Z error.
TReal Zerr2Grad(const TmexArray &Esig, const TmexArray &Et, const TmexArray &dZ, const TCmplx X);

//!	The second derivative of the Z error.
TReal Zerr2Hess(const TmexArray &Esig, const TmexArray &Et, const TmexArray &dZ, const TCmplx X);

#endif //_ZerrKern_shgH_
