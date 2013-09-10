function dl = dw2dl(dw, l0, varargin)
% DW2DL(dw, l0, <U>) converts angular frequency increment dw to
%   wavelength increment dl at center wavelength l0.
%
%	U defaults to nm/fs.  It applies to both input and output units.
%

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:34 $

error(nargchk(2, 3, nargin));

u = parsevarargin(varargin, 'nm/fs');

dl = dw * l0 ^ 2 / (2 * pi * const_c(u));