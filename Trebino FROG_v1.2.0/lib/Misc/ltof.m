function f=ltof(l,u)
% LTOF converts wavelengths to frequencies and vice versa
%	LTOF(L) converts wavelength L to a frequency.
%
%	LTOF(F) converts frequency F to a wavelength.
%
%	LTOF(...,U) uses the units U for the conversion.
%	U defaults to nm/fs.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

error(nargchk(1,2,nargin));

if nargin < 2 | isempty(u)
	c = const_c;
else
	c = const_c(u);
end

f = c ./ l;