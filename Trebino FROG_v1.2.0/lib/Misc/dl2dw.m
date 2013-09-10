function dw = dl2dw(dl, l0, varargin)
% DL2DW(dl, l0, <U>) converts wavelength increment dl to angular
%   frequency increment dw at center wavelength l0.
%
%	U defaults to nm/fs.  It applies to both input and output units.
%

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:34 $

error(nargchk(2, 3, nargin));

u = parsevarargin(varargin, 'nm/fs');

dw = dl * 2 * pi * const_c(u) / l0 ^ 2;