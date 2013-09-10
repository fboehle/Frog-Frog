function w=ltow(l,u)

% LTOW Convert wavelengths to angular frequencies
%
%	W = LTOW(L) converts the wavelength L to an angular frequency W.
%
%	W = LTOW(L,U) uses the units U for the conversion.
%	U defaults to 'nm/fs'.


%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

error(nargchk(1,2,nargin));

if nargin < 2 || isempty(u)
	c = const_c;
else
	c = const_c(u);
end

w = c ./ l * 2 * pi;
