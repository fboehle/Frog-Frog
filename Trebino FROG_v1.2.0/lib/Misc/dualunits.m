function [un, ud] = dualunits(u)
%DUALUNITS breaks dual units which are of the fraction form into
%numerator and denominator.
%   [un, ud] = dualunits(u)
%   un is the numerator unit.
%   ud is the denominator unit.
%
%   See also UNIT, UNITSCALE.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:34 $

i = find(u == '/');

if length(i)~=1
	error(['Units should be of the form x/y, not ' u '.']);
end

un = u(1:i-1);
ud = u(i+1:length(u));