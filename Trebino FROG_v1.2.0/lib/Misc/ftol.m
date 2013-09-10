function l=ftol(f, varargin)
% FTOL converts frequencies to wavelengths and vice versa
%	FTOL(F) converts frequency F to a wavelength.
%
%	FTOL(...,U) uses the units U for the conversion.
%	U defaults to nm/fs.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:34 $

l = ltof(f, varargin);