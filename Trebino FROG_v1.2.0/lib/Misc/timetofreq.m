function [W,Ew] = TimeToFreq(T,Et,L0,u)
%TIMETOFREQ converts a temporal pulse to the frequency domain.
%   [w, Ew] = timetofreq(t, Et, l0, u)
%   where l0 is the center wavelength


error(nargchk(3,4,nargin))

if nargin < 4 | isempty(u)
	u = 'nm/fs';
end

N = length(T);

dT = mean(diff(T));

dW = 2 * pi / N / dT;

W = (-N/2 : N/2-1) * dW + ltow(L0,u);

Ew = fftc(Et);

W = reshape(W, size(T));
