function [Et, Ew] = multipulses(E0, t, T, I)
% MULTIPULSES generates multipulses.
%
%   [Et, Ew] = MULTIPULSES(E0, t, T, I) generates a multipulse train E-field from a
%   single pulse E0(t).  
%
%   Parameters T and I are the occurrence times and heights of the single
%   pulse replicas in the pulse train.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

error(nargchk(4, 4, nargin)); 

N = length(t);
if length(E0) ~= N
    error('Vectors t and E0 are not equal length.');
end

L = length(T);
if length(I) ~= L
    error('Vectors T and I are not equal length.');
end

Ew0 = fftc(E0(:));
w = t2w(t(:), inf);

F = exp(-i * w * T(:)') * I(:);      % Equivalent filter frequency response

Ew = Ew0 .* F;
Et = ifftc(Ew);

Et = reshape(Et, size(E0));
Ew = reshape(Ew, size(E0));