function x = const_k(varargin)
%CONST_K  Boltzmann's constant
%	CONST_K returns Boltzmann's constant in J/K.
%	CONST_C(S) returns Boltzmann's constant in the specified SI units.

%	$Revision: 1.1 $  $Date: 2006-11-11 00:15:35 $
%
%	$Log: const_k.m,v $
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2006/05/02 16:27:57  xg
%	frogger/binner v. 3 updates
%	
%	Revision 1.1  2003/03/18 16:56:36  xg
%	*** empty log message ***
%	

error(nargchk(0,1,nargin));
s = parsevarargin(varargin, 'J/K');

x = 1.3807e-23;

[un, ud] = dualunits(s);

[n, bn] = units(un);
if bn ~= 'J'
    error(['The base unit of numerator should be J, not ' bn '.']);
end

[d, bd] = units(ud);
if bd ~= 'K'
    error(['The base unit of denominator should be K, not ' bd '.']);
end

x = x / n * d;