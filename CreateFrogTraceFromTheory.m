%*********************************************************
%	Create a Frogtrace from a give pulse
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

constants; %load physical, mathematical and numerical constants
setup; %initilized values
indexForCircshift;

mov = 0;


FWHM = 7 * f;
tw = FWHM / 2.3548;
omega0 = 0* 2 * pi * c /(800 * n); %central wavelength
A0 = 1; %peak amplitude
a = 0.00 / f^2 ; %chirp parameter
a2 = 0.0;
a3 = 0;
phi = 0 + 0 * t/tw +  t.^2 * a + a2 * t.^3/tw.^3 + a3 * t.^4/tw.^4; %phase
A = A0 * exp(-t.^2/(4 * tw.^2)) .* exp( 1i * phi ); %complex amplitude
E = A .* exp(1i * omega0 * t); %electromagnetic field


V = fftshift(fft(ifftshift(E)));



myfigure('original Efield')
plotyy( t, abs(E), t, unwrap(angle(A) .* min(round(abs(A)*30),1)))
title('original Efield')

myfigure('original spectral intensity')
plotyy(frequency, abs(V), frequency, angle(V) )
title('original spectral intensity')

Esig = E.' * E;
%Esig=Esig-tril(Esig,-ceil(N/2))-triu(Esig,ceil(N/2));

for l = 1:N
    Esig(l,:) = circshift(Esig(l,:), [0 -l]);
end

Esig = fliplr(fftshift(Esig,2));

IFrogwphase = fftshift(fft((Esig),N,1),1);
IFrog = abs(IFrogwphase).^2;

myfigure('Original Frog')
imagesc(tau,frequency,IFrog)
colorbar
colormap(mycolormap);
title('Original Frogtrace')

myfigure('Esig')
imagesc(tau, t, abs(Esig))
colorbar
colormap(mycolormap);
title('Esig')


saveimagedata = uint16(IFrog/max(max(IFrog))*65000);
imwrite(saveimagedata, 'generated.tif', 'tif')


%% from Trebino
n = length(E);
tic
P = E(:);
G = E(:);

A = [G(n / 2 + 1 : +1 : end); zeros(n / 2 - 0, 1)];
B = [G(n / 2 + 1 : -1 :   1); zeros(n / 2 - 1, 1)];

% mEg = toeplitz(A, B);
% 
% mE = P * ones(1, n);
% 
% E = mE .* mEg;

Esig = (P * ones(1, n)) .* toeplitz(A, B);
toc
myfigure('Trebino Esig');
imagesc(abs(Esig));
colorbar;
