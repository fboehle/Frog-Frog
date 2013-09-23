%*********************************************************
%	Convert the frog camera image to a calibrated frogtrace
%	
%	Developement started: end 2012
%	Author: Frederik Böhle code@fboehle.de
%
%*********************************************************
%   
%   Description: 
%
%   Notes:
%       the camera has a timespan from -100fs until 100fs: bandwidth 200fs
%       and a frequency range from about 
%
%   Changelog:
%
%*********************************************************
clear all

f = 10^(-15);
n = 10^(-9);
u = 10^(-6);
m = 10^(-3);
c = 299792458;
T = 10^(12);

N = 128;
delayRange = 350;
dt = delayRange/N*f;
t = (-(N)/2:(N)/2-1)*dt;
dOmega = 2 * pi * 1/(dt*N);
omega = (-N/2:N/2-1) * dOmega;

%read frogtrace
frog = imread('2013-02-14--15-48-32_visually_best_compression.tif')';

%read seperately recorded spectrum
spectrumIndependent = dlmread('2013-02-14--17-50-33-afterXPW+CMs+wedges(FROG)-inbeamwithpaper.csv', ',', [1 1 2048 1]);
spectrumIndependentLambda = dlmread('2013-02-14--17-48-33-afterXPW+CMs+wedges(FROG)-more.csv',',', [1 0 2048 0]);
spectrumIndependent = spectrumIndependent -  dlmread('2013-02-26_1018_darkref_30ms_fiber.csv', ',', [1 1 2048 1]);
spectrumIndependent(spectrumIndependent < 0 ) = 0;
spectrumIndependent =  spectrumIndependent .* dlmread('HamamatsuCalibrationwithfactor.txt', '\t', [1 8 2048 8]);
spectrumIndependentOmega = 2 * pi * c ./ spectrumIndependentLambda;
spectrumIndependent = spectrumIndependent .* spectrumIndependentLambda.^2 / 2 * pi * c;

figure(14)
plot(spectrumIndependentOmega, spectrumIndependent);

frog = double(frog);
frog = imrotate(frog, 1, 'bilinear','crop');

%place frog trace in the middle respect to delay
toMoveTime = -round(sum((1:1035) .* sum(uint16(frog) - 15).^2)/sum(sum(uint16(frog) - 15).^2)-1035/2); %weighted average to find center of peak

frog = circshift(frog,[0 toMoveTime]);

figure(11)
imagesc(frog);

dimensionL = 1376;
dimensionT = 1035;

pixell = 1:dimensionL;
pixelt = 1:dimensionT;

lambdalines = [302,313,365,405,436] * n;
lambdapixel = [245,352,680,934,1130];
fitLambda = polyfit(lambdapixel,lambdalines,1); %the spectrometer has alinear relation between the pixel and the wavelength
fitLambdaVal = polyval(fitLambda, pixell);

ccdOmega  = 2 * pi * c ./ polyval(fitLambda, pixell); 
ccdOmegaRange = ccdOmega(length(ccdOmega)) - ccdOmega(1);

figure(21)
plot(lambdapixel, lambdalines, pixell, fitLambdaVal);
title('calibration of spectrometer');


%old erroneous calculation
%frequencylines = c ./ lambdalines;
%fitFrequency = polyfit(lambdapixel,frequencylines,1);
%frequencyfit = polyval(fitFrequency, pixell);
%figure(20)
%plot(lambdapixel, frequencylines, pixell, frequencyfit, pixell, ccdOmega);
%\old erroneous calculation


delayfromposition = (-[-153.6,-145.8,-134.7,-119.6,-104.7,-94.3,-84.3]) * u * 2 / c; 
delaypixel = [983,883,731,526,329,190,56];
delayFit = polyfit(delaypixel, delayfromposition, 1);
delayFitVal = polyval(delayFit, pixelt);



ccd_dt = delayFit(1);
ccd_delay = (-(length(pixelt)/2)*ccd_dt:ccd_dt:(length(pixelt)/2 - 1) * ccd_dt);
ccd_delayRange = ccd_delay(length(ccd_delay)) - ccd_delay(1);

figure(22)
plot(delaypixel, delayfromposition, pixelt, delayFitVal);
title('calibration of delay');


timerange = t(N) - t(1);
omegaRange = omega(N) - omega(1);



figure(31)
contourf(ccd_delay,ccdOmega, frog)


%anti-alias



%background substraction
frog = frog - 11;
frog(frog < 0) = 0;


% convert the frog trace to be dependent of frequency instead of wavelength
% the intensities need to be corrected with a factor of lambda^2/ 2 pi c

frogConversionFactor = repmat((fitLambdaVal.'.^2 *2 * pi), 1, dimensionT);
frogOverTauAndOmega = frog .* frogConversionFactor;

figure(32)
contourf(ccd_delay,ccdOmega, frogOverTauAndOmega)

%calculate the frequency marginal
marginal_frequency = sum(frogOverTauAndOmega, 2);

figure(41)
plot(ccdOmega, marginal_frequency);


%do this only provisionally
frog = frogOverTauAndOmega;


N10 = 10*N;
t10 = (-(N10)/2:(N10)/2-1)*dt/10;


w10 = (-N10/2:N10/2-1) * dOmega/10 ; 

frogint = interp1(ccdOmega, frog, w10 + (2 * pi * c / 390 / n) );
frogint(isnan(frogint)) = 0;

frogint = frogint.';
frogint = interp1(ccd_delay, frogint, t10);
frogint = frogint.';
frogint(isnan(frogint)) = 0;
figure(60)
imagesc(frogint)
colormap(jet(256));
colorbar

tic;
frogint2 = zeros(N,N10);
for k = 1:N10
frogint2(:,k) = decimate(frogint(:,k), 10);
end
frogint3 = zeros(N,N);
for k = 1:N
frogint3(k,:) = decimate(frogint2(k,:), 10);
end
toc
figure(61)
imagesc(t, omega,frogint)
colormap(jet(256));
colorbar

figure(62)
imagesc(frogint3)
colormap(jet(256));
colorbar

saveimagedata = uint16(frogint3/max(max(frogint3))*65000);
imwrite(saveimagedata, 'generated.tif', 'tif')