/**	\file
 *
 *	$Author: pablo $
 *	$Date: 2006-11-11 00:15:29 $
 *	$Revision: 1.1 $
 */

#ifndef _MinZerrKern_blindpgH_
#define _MinZerrKern_blindpgH_

#include "../Util/mexArray.h"

//!	Calculates the coefficients.
void MinZerrKern_blindpg(const TmexArray &Esig1, const TmexArray &Esig2, const TmexArray &Et1,
                    const TmexArray &Et2, const TmexArray &dZ1, const TmexArray &dZ2, TmexArray &X);

#endif //_MinZerrKern_blindpgH_
