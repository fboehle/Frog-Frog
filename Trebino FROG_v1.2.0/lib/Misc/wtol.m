function l=wtol(w,u)
% WTOL Convert angular frequencies to wavelengths.
%
%	L = WTOL(W) converts the angular frequency W to a wavelength L.
%
%	L = WTOL(W, U) uses the units U for the conversion.
%	U defaults to nm/fs.
%

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

error(nargchk(1,2,nargin));

if nargin < 2 | isempty(u)
    u = 'nm/fs';
end
l = ltow(w, u);