function Y = iseven(X)
%ISEVEN True for odd elements.
%	ISEVEN(X) returns an array that contains 1's where
%	the elements of X are even and 0's where they are not.
%	For example, ISEVEN([2 5 0 22]) is [1 0 1 1].
%
%	See also ISODD.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $
%
%	$Log: iseven.m,v $
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.2  2001/07/13 20:44:15  zeekec
%	Added argument checks
%	
%	Revision 1.1  2001/07/13 19:53:03  zeekec
%	Add isodd and iseven.
%	

error(nargchk(1,1,nargin));
Y = ~mod(X,2);
