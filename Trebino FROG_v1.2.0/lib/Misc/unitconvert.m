function x = unitconvert(x, UnitFrom, UnitTo)
%UNITCONVERT converts a quantity from one unit to another.
%   UNITCONVERT(X, UNITFROM, UNITTO) converts a physical quantity X from UNITFROM to UNITTO.
%
%   Incompatible units will generate an error.
%
%   See also UNITS, UNITSCALE.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:35 $
%
%   $Log: unitconvert.m,v $
%   Revision 1.1  2006-11-11 00:15:35  pablo
%   CVS server re-installation
%
%   Revision 1.2  2002/09/05 15:55:09  zeekec
%   *** empty log message ***
%
%   Revision 1.1  2002/06/10 04:41:50  xg
%   Created.
%

error(nargchk(3, 3, nargin))

[sf, bf] = units(UnitFrom);
[st, bt] = units(UnitTo);

if (~strcmp(bf, bt))
    error('Incompatible units.');
end

x = x .* sf ./ st;