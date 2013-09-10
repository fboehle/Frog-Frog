function y = dB2lin(x, varargin)
%DB2LIN converts from dB units to linear units.
%   DB2LIN(X, LINUNIT, DBUNIT) converts quantity X in DBUNIT to LINUNIT.
%   Specify DBUNIT as 'dB', 'dBm', 'dBk', etc.
%
%   It is common practice to define power or energy dB units as x_dB = 10 * log10(x),
%   but voltage or current dB units as x_dB = 20 * log10(x).  This is consistent with
%   the fact that electric power is proportional to the square of voltage or current.
%
%   LINUNIT defaults to 'W', and DBUNIT dafaults to 'dB'.
%
%   See also LIN2DB, UNITCONVERT, UNITSCALE.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:34 $
%
%   $Log: dB2lin.m,v $
%   Revision 1.1  2006-11-11 00:15:34  pablo
%   CVS server re-installation
%
%   Revision 1.1  2002/06/18 14:03:03  xg
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
    y = 10 .^ (x / 10) * sd / sl;
case {'A', 'V'}
    y = 10 .^ (x / 20) * sd / sl;
otherwise
    y = 10 .^ (x / 10) * sd / sl;
end