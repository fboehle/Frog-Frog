function angles = DegToRad(angles)
%DEGTORAD converts a set of ANGLES from degrees to radians.
%   DEGTORAD(ANGLES) converts ANGLES from degrees to radians.
%
%   See also UNITCONVERT.

%   $Revision: 1.1 $    $Date: 2007-05-01 15:34:37 $
%
%   $Log: degtorad.m,v $
%   Revision 1.1  2007-05-01 15:34:37  pablo
%   replaced with lowercase
%
%   Revision 1.1  2006-11-11 00:15:34  pablo
%   CVS server re-installation
%
%   Revision 1.2  2002/06/10 04:43:01  xg
%   Rewritten using newly created generic unitconvert function.
%

error(nargchk(1, 1, nargin))

angles = unitconvert(angles, 'deg', 'rad');