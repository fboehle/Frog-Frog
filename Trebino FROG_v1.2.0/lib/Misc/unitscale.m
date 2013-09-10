function x = unitscale(c)
%UNITSCALE Returns the scale of an SI prefix
%	UNITSCALE(C) returns the scale of the unit prefix represented by
%	C.  (i.e. 'f' = 1E-15, 'c' = 1E-2, etc.)

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $
%
%	v1.0, 6/22/01, Erik Zeek, <zeekec@mad.scientist.com>
%
%	$Log: unitscale.m,v $
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.3  2001/09/05 00:22:34  zeekec
%	Handled empty string case.
%	
%	Revision 1.2  2001/07/10 01:10:00  zeekec
%	Library cleanup.  Added, deleted, and moved files.
%	
%

error(nargchk(1,1,nargin))

if length(c) < 1
	x = 1;
	return
end

switch c
case 'Y'
	x = 1E24;
case 'Z'
	x = 1E21;
case 'E'
	x = 1E18;
case 'P'
	x = 1E15;
case 'T'
	x = 1E12;
case 'G'
	x = 1E9;
case 'M'
	x = 1E6;
case 'k'
	x = 1E3;
case 'h'
	x = 1E2;
case 'da'
	x = 1E1;
case {'',[]}
	x = 1E0;
case 'd'
	x = 1E-1;
case 'c'
	x = 1E-2;
case 'm'
	x = 1E-3;
case 'u'
	x = 1E-6;
case 'n'
	x = 1E-9;
case 'p'
	x = 1E-12;
case 'f'
	x = 1E-15;
case 'a'
	x = 1E-18;
case 'z'
	x = 1E-21;
case 'y'
	x = 1E-24;

% Unofficial binary multiples.
case 'Ki'
	x = 2^10;
case 'Mi'
	x = 2^20;
case 'Gi'
	x = 2^30;
case 'Ti'
	x = 2^40;
case 'Pi'
	x = 2^50;
case 'Ei'
	x = 2^60;
otherwise
	error(['Unknown SI prefix: ' c '.'])
end
