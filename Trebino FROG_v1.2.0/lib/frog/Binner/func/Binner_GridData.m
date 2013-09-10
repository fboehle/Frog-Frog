function [Isig2, tau2, f2] = Binner_GridData(Isig, tau, lam, tau2, f2)

error(nargchk(5,5,nargin))

lam2 = ltof(f2);

Isig2 = interp2(tau, lam, Isig, tau2, lam2, 'cubic');

dl_dw = lam2.^2;    % d_l / d_w = l .^ 2 / (2 * pi * c)

Isig2 = Isig2 .* repmat(dl_dw, 1, length(tau2));    % correction for d_l / d_w

Isig2(find(~isfinite(Isig2))) = 0;

Isig2 = nonegatives(Isig2);