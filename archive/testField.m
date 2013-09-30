%*********************************************************
%	Title 
%	
%	Developement started: end 2012
%	Author: Frederik Böhle code@fboehle.de
%
%*********************************************************
%   
%   Description: 
%
%   Notes:
%
%   Changelog:
%
%*********************************************************


clear all

constants;
setup;


tw = 6*f; %half width
omega0 = 0 * 2 * pi * c /(2800 * n); %central wavelength
A0 = 1; %peak amplitude
a = 1; %chirp parameter
a2 = 0;
a3 = 0;
phi = 0 + 0 * t/tw + a * t.^2/tw.^2 + a2 * t.^3/tw.^3 + a3 * t.^4/tw.^4; %phase
A_1 = A0 * exp(-t.^2/(tw.^2)) .* exp( i * phi ); %complex amplitude

tshift = 30 * f;
tw_2 = 10*f; %half width
A0_2 = 0; %peak amplitude
a_2 = 0; %chirp parameter
a2_2 = 1;
a3_2 = 0;
phi_2 = 0 + 0 * t/tw_2 + a_2 * t.^2/tw_2.^2 + a2_2 * t.^3/tw_2.^3 + a3_2 * t.^4/tw_2.^4; %phase
A_2 = A0_2 * exp(-(t-tshift).^2/(tw_2.^2)) .* exp( i * phi_2 ); %complex amplitude
A = A_1 + A_2;
E = A .* exp(i * omega0 * t); %electromagnetic field

V = fftshift(fft(ifftshift(E)));
lambda = c ./ frequency;
lambdastep = (lambda(1)-lambda(2))/n


figure(1);
plotyy( t, abs(E), t, unwrap(angle(A) .* min(round(abs(A)*30),1)))
title('original Efield')
figure(2);
plotyy(frequency, abs(V), frequency, unwrap(angle(V)) )
title('original spectral intensity')