function [Isig, dt, l0, dl, T, L] = MakeIsig(P, G, T, lp, varargin)
%MAKEISIG Makes a FROG trace.
%  Takes the general case of SHG FROG and SFG-, DFG-XFROG.  By default lp=lg.


error(nargchk(4, 7, nargin));

[lg, plt, sve, u] = parsevarargin(varargin, lp, false, false, 'nm/fs');

dt = abs(mean(diff(T)));

Esig = CalcEsig(P, G);

Isig = abs(fft_FROG(Esig)) .^ 2;

dw = 2 * pi / (max(T) - min(T));

l0 = abs(1/((1/lp)+(1/lg)));
w0 = ltow(l0);

N = length(T);

W = ((-N/2:N/2-1) * dw + w0)';

[L,Isig] = ToConstWaveSpc(W,Isig);

Isig = nonegatives(Isig);

dl = mean(diff(L));

if plt
    clf
    plot_Isig(Isig,L,T);
end

if sve
    frogsave(Isig,dt,l0,dl);
end