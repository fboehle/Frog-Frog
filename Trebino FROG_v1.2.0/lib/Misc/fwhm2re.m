function r_e = fwhm2re(w_fwhm)
%FWHM2RE(W_FWHM) converts intensity fwhm to intensity 1/e^2 radius (or amplitude 1/e radius).
%
%   See also RE2FWHM.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:34 $
%


error(nargchk(1, 1, nargin))

r_e = w_fwhm / 2 / sqrt(log(2) / 2);