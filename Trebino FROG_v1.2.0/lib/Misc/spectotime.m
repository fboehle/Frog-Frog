function [T,Et,l0] = SpecToTime(L,El,u)

error(nargchk(2,3,nargin))

if nargin < 3 | isempty(u)
	u = 'nm/fs';
end

[W,Ew] = ToConstFreqSpc(L,El,u);

N = length(W);

dW = mean(diff(W));

dT = 2*pi / N / dW;

T = (-N/2:N/2-1) * dT;

Et = fftc(Ew);

l0 = ltow(W(end/2+1));
