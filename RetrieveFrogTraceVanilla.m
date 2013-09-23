%*********************************************************
%	Retrieve the original pulse from a Frogtrace with the most simply
%	algorithm
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

indexForCircshift;

%% read the Frog trace
IFrog = double(imread('generated.tif')) + 0*random('Poisson',5,N,N) ;
IFrog = IFrog / max(max(IFrog));
sqrtIFrog = sqrt(IFrog);

%testspace***

%testspace***

figure(4);
imagesc(tau, frequency, IFrog)
colorbar
colormap(jet(256));
title('Original Frog')

%% make a guess for the E Field; in this case, put random noise
Efield = random('Poisson',50,1,N) + 1i*random('Poisson',50,1,N);
Efield = Efield/max(Efield);

figure(1);
plotyy(t, abs(Efield), t, angle(Efield) .* min(round(abs(Efield)*100),1))
title('retrieved Efield')

tStart = tic

mov = 1;
Egate = Efield ;
%% Loop!
for l = 1:100

    
    
%% In SHG Frog the gate is the Pulse itself


%% calculate the signal field
Esig = Efield.' * Egate;

%Esig=Esig-tril(Esig,-ceil(N/2))-triu(Esig,ceil(N/2));

Esig = Esig(indexforcircshift);


Esig = fliplr(fftshift(Esig,2));


%% calculate the theoretical Frog Trace
ICalcwphase = fftshift(fft((Esig),N,1),1);
ICalc = abs(ICalcwphase).^2;

if(mov)
figure(2);
imagesc(tau, frequency, abs(ICalc))
title('retrieved Frog Trace')
end

%% calculate the Frog Error

mu = sum(sum(IFrog.*ICalc))/sum(sum(ICalc.^2));
G = 1/N * sqrt( sum(sum(  (IFrog - mu * ICalc).^2 )))
if(G<0.001) 
%    break;
end


%% replace the magnitude of ICalcwphase with the one from the original
%  trace without altering the phase

%ICalcwphase = exp(i * angle(ICalcwphase)) .* sqrtIFrog ;
%ICalc = abs(ICalcwphase).^2;
ICalcwphase(ICalcwphase == 0) = NaN;
ICalcwphase = ICalcwphase ./abs(ICalcwphase) .* sqrtIFrog ;
ICalcwphase(isnan(ICalcwphase)) = 0;

%% do the inverse FT back to the time domain
Esig = ifft(ifftshift(ICalcwphase,1), N, 1);

if(mov)
figure(3);
imagesc(abs(Esig))
title('Esig')
end

%% Vanilla Algorith

Efield = sum(Esig, 2).';
Efield = Efield / max(abs(Efield));
Egate = Efield;

tToMove = -round(sum((-(N)/2:(N)/2-1) .* abs(Efield).^2)/sum(abs(Efield).^2)); %weighted average to find center of peak
Efield = circshift(Efield,[0 tToMove]);
Egate = circshift(Egate,[0 tToMove]);


end

toc(tStart)
figure(1);
plotyy(t, abs(Efield), t, unwrap(angle(Efield) .* min(round(abs(Efield)*300),1)))
title('retrieved Efield')

figure(12);
plotyy(t, abs(Efield).^2, t, unwrap(angle(Efield) .* min(round(abs(Efield)*300),1)))
title('retrieved Intensity')

figure(2);
imagesc(tau, frequency, abs(ICalc))
title('retrieved Frog Trace')

figure(3);
imagesc(abs(Esig))
title('Esig')

