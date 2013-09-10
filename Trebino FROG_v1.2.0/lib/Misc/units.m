function [x,b] = units(u)
%UNITS handles unit.
%	[X,B] = UNITS(U)  returns the scale, X, and the base, B,
%	of the unit U.
%
%	Currently assumes that the base unit is a single character or 'rad'.
%
%	See also UNITSCALE.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $
%
%	$Log: units.m,v $
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.2  2001/09/20 19:37:56  xg
%	Added angle units
%	
%	Revision 1.1  2001/09/05 00:32:05  zeekec
%	New function
%	

error(nargchk(1,1,nargin))

if ~ischar(u)
    error('Units must be a string');
end

if (length(u) > 2)
    if (u(end - 2 : end) == 'rad')
        b = 'rad';
        x = unitscale(u(1 : end - 3));
        return
    elseif (u(end - 2 : end) == 'deg')
        b = 'rad';
        x = unitscale(u(1 : end - 3)) * pi / 180;
        return
    end
else
    b = u(end);
    x = unitscale(u(1 : end - 1));
end