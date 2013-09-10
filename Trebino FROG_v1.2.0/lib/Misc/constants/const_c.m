function x = const_c(s)
%CONST_C  The speed of light.
%	CONST_C returns the speed of light in nm/fs.
%	CONST_C(S) returns the speed of light in the specified SI units.

%	$Revision: 1.1 $  $Date: 2006-11-11 00:15:35 $
%
%	v1.0, 6/22/01, Erik Zeek, <zeekec@mad.scientist.com>
%	v1.1, 6/26/01, Erik Zeek, <zeekec@mad.scientist.com>
%
%	$Log: const_c.m,v $
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.2  2006/05/02 15:43:00  xg
%	*** empty log message ***
%	
%	Revision 1.1  2003/03/18 16:56:36  xg
%	*** empty log message ***
%	
%	Revision 1.5  2002/11/19 18:22:47  xg
%	Updated to use dualunits.
%	
%	Revision 1.4  2002/09/03 14:57:48  zeekec
%	Changed to return the default value without any calculation.
%	
%	Revision 1.3  2001/09/05 00:13:46  zeekec
%	Only accepts 1 '/' now.
%	
%	Revision 1.2  2001/07/06 15:27:32  zeekec
%	Removed ga_mathworks
%	

error(nargchk(0,1,nargin))

if nargin < 1
	x = 299.792458;
	return
end

x = 299792458;

[un, ud] = dualunits(s);

[n, bn] = units(un);
if bn ~= 'm'
    error(['The base unit of numerator should be m, not ' bn '.']);
end

[d, bd] = units(ud);
if bd ~= 's'
    error(['The base unit of denominator should be s, not ' bd '.']);
end

x = x / n * d;