function Isig_corr = ApplySpecEffCorr(Isig_raw, w2, varargin)
%APPLYSPECEFFCORR applies spectral efficiency correction for a FROG trace,
%allowing for different frequency scales
%
%   Isig_corr = FreqMargCorr_SHG(Isig_raw, w2, eff_f, l, filename, type),
%   where Isig_raw is the uncorrected FROG trace, w2 is the frequency scale
%   of the trace, eff_f is the spectral efficiency, l is the wavelength
%   scale.  The last two parameters are not used if S_f is given.
%
%   If S_f is not given, the program will use parameters filename and
%   type to open a spectrum file.  If filename is not given, a file
%   selection dialog will open.

[eff, l_f, filename, type] = parsevarargin(varargin, [], [], '', []);

if isempty(eff)
    [l_f, eff] = specload_all(filename, type, 'Select spectral efficiency file');
end

w_f = ltow(l_f);

eff_1 = interp1(w_f, eff, w2, 'cubic', 0);

warning('off', 'MATLAB:divideByZero');
Isig_corr = Isig_raw ./ repmat(eff_1, 1, size(Isig_raw, 2));
idx = isinf(Isig_corr) | isnan(Isig_corr);
Isig_corr(idx) = 0;
warning('on', 'MATLAB:divideByZero');