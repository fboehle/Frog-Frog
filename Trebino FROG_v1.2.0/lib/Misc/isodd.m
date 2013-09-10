function Y = isodd(X)
%ISODD True for odd elements.
%	ISODD(X) returns an array that contains 1's where
%	the elements of X are odd and 0's where they are not.
%	For example, ISODD([2 5 0 22]) is [0 1 0 0].
%
%	See also ISEVEN.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $
%
%	$Log: isodd.m,v $
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
Y = mod(X,2);
