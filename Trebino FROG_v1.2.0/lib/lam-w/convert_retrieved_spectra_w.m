% this function converts the retrieved spectra to equally spaced wavelength
% Ew = equally spaced retrieved spectrum
% dl = wavelength calibration for the wavlength axis
% lam0 = center wavelength

function [Elam,lam]=convert_retrieved_spectra_w(Ew,w_eq)
N=size(Ew,1);
%Elam=zeros(size(Ew));
[seq1,lam]=equally_spaced_spectrum_lam(w_eq,abs(Ew));
[phase1,lam]=equally_spaced_spectrum_lam(w_eq,unwrap(angle(Ew)));
Elam=seq1.*exp(i*phase1);
