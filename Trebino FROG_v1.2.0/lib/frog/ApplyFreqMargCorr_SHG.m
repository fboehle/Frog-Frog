function Isig_corr = ApplyFreqMargCorr_SHG(Isig_raw, w2, varargin)
%APPLYFREQMARGCORR applies frequency marginal correction of an SHG FROG trace
%using the fundamental spectrum, allowing for different frequency scales
%
%   Isig_corr = FreqMargCorr_SHG(Isig_raw, w2, S_f, l_f, filename, type),
%   where Isig_raw is the uncorrected but binned FROG trace, w2 is the
%   frequency scale of the trace, S_f is the fundamental spectrum, l_f is
%   the wavelength scale.  The last two parameters are not used if S_f is
%   given.
%
%   If S_f is not given, the program will use parameters filename and
%   type to open a spectrum file.  If filename is not given, a file
%   selection dialog will open.


[S_f, l_f, filename, type] = parsevarargin(varargin, [], [], '', []);

if isempty(S_f)
    [l_f, S_f] = specload_all(filename, type, 'Select fundamental spectrum');
end

w1 = w2 - w2(end / 2 + 1) / 2;
w_f = ltow(l_f);

S_f_1 = interp1(w_f, S_f .* dist_transform_to_linear(w_f), w1, 'cubic', 0);
Isig_corr = FreqMargCorr_SHG(Isig_raw, S_f_1);