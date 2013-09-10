function w_fwhm = re2fwhm(r_e)
%RE2FWHM(R_E) converts intensity 1/e^2 radius (or amplitude 1/e radius) to
%intensity fwhm.
%
%   See also FWHM2RE.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:35 $
%


error(nargchk(1, 1, nargin))

w_fwhm = r_e * 2 * sqrt(log(2) / 2);