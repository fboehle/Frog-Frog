function y = lin2dB(x, varargin)
%LIN2DB converts from linear units to dB.
%   LIN2DB(X, LINUNIT, DBUNIT) converts quantity X in linear unit LINUNIT to DBUNIT.
%   Specify DBUNIT as 'dB', 'dBm', 'dBk', etc.
%
%   It is common practice to define power or energy dB units as x_dB = 10 * log10(x),
%   but voltage or current dB units as x_dB = 20 * log10(x).  This is consistent with
%   the fact that electric power is proportional to the square of voltage or current.
%
%   LINUNIT defaults to 'W', and DBUNIT dafaults to 'dB'.
%
%   See also UNITCONVERT, UNITSCALE.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:35 $
%
%   $Log: lin2dB.m,v $
%   Revision 1.1  2006-11-11 00:15:35  pablo
%   CVS server re-installation
%
%   Revision 1.1  2002/06/11 03:53:52  xg
%   Created.
%

error(nargchk(1, 3, nargin));

[LinUnit, dBUnit] = parsevarargin(varargin, 'W', 'dB');

if (length(dBUnit) < 2)
    error('Incorrect dB unit.')
else
    if (~strcmp(upper(dBUnit(1 : 2)), 'DB'))
        error('Incorrect dB unit.');
    else
        sd = unitscale(dBUnit(3 : end));
    end
end

[sl, bl] = units(LinUnit);

switch bl
case {'W', 'J'}
    y = 10 * log10(x * sl / sd);
case {'A', 'V'}
    y = 20 * log10(x * sl / sd);
otherwise
    y = 10 * log10(x * sl / sd);
end