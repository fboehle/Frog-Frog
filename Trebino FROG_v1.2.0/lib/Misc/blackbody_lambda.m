function S_l = Blackbody_lambda(l, T, varargin)
%BLACKBODY_LAMBDA calculates the blackbody irradiance curve using Planck's
%formala per unit wavelength.
%
%Spec_l = Blackbody_lambda(l, T, l_unit, T_unit) calculates the blackbody
%radiation spectrum in uniform-spaced wavelength scale.  The arguments l is
%wavelength, T is temperature.  Units l_unit and T_unit are optional.

error(nargchk(2, 4, nargin))
[u_lambda, u_T] = parsevarargin(varargin, 'nm', 'K');

l = unitconvert(l, u_lambda, 'm');
h = const_h;
c = const_c('m/s');
k = const_k;

S_l = 8 * pi * h * c ./ (l .^ 5) ./ (exp(h * c / k / T ./ l) - 1);