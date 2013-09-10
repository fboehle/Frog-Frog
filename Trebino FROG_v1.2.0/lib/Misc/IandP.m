function [Intensity, Phase] = IandP(E,varargin)
% IANDP(E,WRAPPING) returns the intensity and phase of a
% complex field E, with WRAPPING of the phase either 'ON' or 'OFF'.

error(nargchk(1,3,nargin))

[wrapping] = parsevarargin(varargin,'ON');

[Amplitude, Phase] = aandp(E,wrapping);
Intensity = magsq(Amplitude);