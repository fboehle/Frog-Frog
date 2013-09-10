function W = TtoW(T, W0)
%TTOW(T,W0) returns the frequency array corresponding T and W0
%	W = TTOW(T, WO) uses the time array, T, and center angular frequency,
%	W0, to calculate the angular frequency array, W, for the Fourier domain
%	of T.

%	$Id: ttow.m,v 1.1 2006-11-11 00:15:35 pablo Exp $

error(nargchk(2, 2, nargin));

N = length(T);

dT = mean(diff(T));

dW = 2 * pi / N / dT;

W = (-floor(N/2):floor(N/2)-1) * dW + W0;

W = reshape(W, size(T));
