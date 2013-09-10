function [Y,T] = constrain(X,lo,hi)
%CONSTRAIN Constrains the value.
%	Y=CONSTRAIN(X,LO,HI) returns X constrained to being
%	greater than or equal to LO and lower than or
%	equal to HI.  X, LO, and HI must be the same size.
%
%	[Y,T]=CONSTRAIN(X,LO,HI) Same as above, and returns
%	true in T for the elements where X was within the limits.
%
%	See also MIN, MAX.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:34 $
%
%	$Log: constrain.m,v $
%	Revision 1.1  2006-11-11 00:15:34  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2001/08/13 20:42:05  zeekec
%	Added
%	

error(nargchk(3,3,nargin));

Y = min(hi,max(lo,X));

T = (Y == X);