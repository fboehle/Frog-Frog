function Isig_corr = FreqMargCorr_SHG(Isig_raw, S_f)
%FREQMARGCORR applies frequency marginal correction of an SHG FROG trace
%using the fundamental spectrum.
%
%   Isig_corr = FreqMargCorr_SHG(Isig_raw, S_f), where S_f is the
%   fundamental spectrum.  Both the FROG traces and the fundamental
%   spectrum are measured in the binned frequency scale.

S_f = S_f(:);
marg = conv(S_f, S_f);
N = length(S_f);
marg = marg(N / 2 : N / 2 * 3 - 1);
marg_raw = sum(Isig_raw, 2);

warning('off', 'MATLAB:divideByZero');
f_scale = marg ./ marg_raw;
idx = isinf(f_scale) | isnan(f_scale);
f_scale(idx) = 0;
warning('on', 'MATLAB:divideByZero');

Isig_corr = Isig_raw .* repmat(f_scale, 1, size(Isig_raw, 2));