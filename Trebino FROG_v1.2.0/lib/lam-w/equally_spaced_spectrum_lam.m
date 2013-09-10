% this function recalibrates the retrieved spectrum in wavelength
% to make it evenly spaced in anglular frequency
% spectrum = evenly spaced spectrum
% w = evenly spaced freq axis (rad/fs)

function [seq,lam_eq]=equally_spaced_spectrum_lam(spectrum,w)
c=300;
lam=2*pi*c./w;
lam_eq = equally_spaced_lam(w);
seq =interp1(lam, spectrum, lam_eq, 'cubic');
% cutting off some inf terms
% seq=seq(5:end-5);
% lam_eq=lam_eq(5:end-5);