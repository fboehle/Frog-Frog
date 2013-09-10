function [Et, Ew] = etalonpulse(E0, t, tau, r)
% ETALONPULSE generates an etalon pulse.
%
%   [Et, Ew] = ETALONPULSE(E0, t, tau, r) generates an etalon pulse train E-field from a
%   single pulse E0(t).  
%
%   Parameters tau and r are the relative delay and complex amplitude ratio
%   between two adjacent pulses in the pulse train

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

error(nargchk(4, 4, nargin)); 

Ew0 = fftc(E0(:));
w = t2w(t(:), inf);

F = 1 ./ (1 - r * exp(-i * w * tau));      % Equivalent filter frequency response

Ew = Ew0 .* F;
Et = ifftc(Ew);

Et = reshape(Et, size(E0));
Ew = reshape(Ew, size(E0));