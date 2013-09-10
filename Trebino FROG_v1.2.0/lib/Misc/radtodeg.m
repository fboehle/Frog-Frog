function angles = RadToDeg(angles)
%RADTODEG converts a set of ANGLES from radians to degrees.
%   RADTODEG(ANGLES) converts ANGLES from radians to degrees.
%
%   See also UNITCONVERT.

%   $Revision: 1.1 $    $Date: 2007-01-05 19:05:31 $
%
%   $Log: radtodeg.m,v $
%   Revision 1.1  2007-01-05 19:05:31  pablo
%   lowercase
%
%   Revision 1.1  2006-11-11 00:15:34  pablo
%   CVS server re-installation
%
%   Revision 1.2  2002/06/10 04:43:01  xg
%   Rewritten using newly created generic unitconvert function.
%

error(nargchk(1, 1, nargin))

angles = unitconvert(angles, 'rad', 'deg');