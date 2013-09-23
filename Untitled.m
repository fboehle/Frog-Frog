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

%play with this: fftw('planner', 'exhaustive')

constants; %load physical, mathematical and numerical constants
setup; %initilized values
tTotal = tic;
%read frogtrace
frogRaw = imread('2013-02-14--15-48-32_visually_best_compression.tif')';
%{
%read seperately recorded spectrum
spectrumIndependent = dlmread('2013-02-14--17-50-33-afterXPW+CMs+wedges(FROG)-inbeamwithpaper.csv', ',', [1 1 2048 1]);
spectrumIndependentLambda = n * dlmread('2013-02-14--17-48-33-afterXPW+CMs+wedges(FROG)-more.csv',',', [1 0 2048 0]);
spectrumIndependent = spectrumIndependent -  dlmread('2013-02-26_1018_darkref_30ms_fiber.csv', ',', [1 1 2048 1]);
spectrumIndependent(spectrumIndependent < 0 ) = 0;
spectrumIndependent =  spectrumIndependent .* dlmread('HamamatsuCalibrationwithfactor.txt', '\t', [1 8 2048 8]);
spectrumIndependentFrequency = c ./ spectrumIndependentLambda;
spectrumIndependent = spectrumIndependent .* (spectrumIndependentLambda * 100000000).^2 / c;

myfigure('Independent Spectrum');
plot(spectrumIndependentFrequency, spectrumIndependent);


spectrumAutoconvolution = ifft(fft(spectrumIndependent) .*  fft(spectrumIndependent));
%spectrumAutoconvolutionFrequency = 

%figure(15)
%plot(spectrumIndependentFrequency, spectrumAutoconvolution);
%}

frogRaw = double(frogRaw);
frogRaw = imrotate(frogRaw, 1, 'bilinear','crop');

%place frog trace in the middle respect to delay
toMoveTime = -round(sum((-(1035/2):(1035/2)-1) .* sum(uint16(frogRaw) - 15).^2)/sum(sum(uint16(frogRaw) - 15).^2)); %weighted average to find center of peak
frogRaw = circshift(frogRaw,[0 toMoveTime - 4]);

dimensionL = 1376;
dimensionT = 1035;

pixell = 1:dimensionL;
pixelt = 1:dimensionT;

lambdalines = [302,313,365,405,436] * n;
lambdapixel = [256,361,693,945,1143];
%lambdapixel = [245,352,680,934,1130];
fitLambda = polyfit(lambdapixel,lambdalines,1); %the spectrometer has alinear relation between the pixel and the wavelength
fitLambdaVal = polyval(fitLambda, pixell);

ccd_frequency  = c ./ polyval(fitLambda, pixell);
ccd_frequencyRange = ccd_frequency(length(ccd_frequency)) - ccd_frequency(1);

myfigure('calibration of spectrometer')
plot(lambdapixel, lambdalines, pixell, fitLambdaVal);
title('calibration of spectrometer');

%{
%old erroneous calculation
frequencylines = c ./ lambdalines;
fitFrequency = polyfit(lambdapixel,frequencylines,1);
frequencyfit = polyval(fitFrequency, pixell);
figure(20)
plot(lambdapixel, frequencylines, pixell, frequencyfit, pixell, ccd_frequency);
%\old erroneous calculation
%}


delayfromposition = (-[-153.6,-145.8,-134.7,-119.6,-104.7,-94.3,-84.3]) * u * 2 / c; 
delaypixel = [983,883,731,526,329,190,56];
delayFit = polyfit(delaypixel, delayfromposition, 1);
delayFitVal = polyval(delayFit, pixelt);

ccd_dt = delayFit(1);
ccd_delay = (-(length(pixelt)/2)*ccd_dt:ccd_dt:(length(pixelt)/2 - 1) * ccd_dt);
ccd_delayRange = ccd_delay(length(ccd_delay)) - ccd_delay(1);

myfigure('calibration of delay');
plot(delaypixel, delayfromposition, pixelt, delayFitVal);
title('calibration of delay');


tauRange = tau(N) - tau(1);
frequencyRange = frequency(N) - frequency(1);





%background substraction


histogram = histc(frogRaw(:), 1:255);
[dontneedyou,maxIndex] = max(histogram);
background = histogram(maxIndex) * maxIndex + histogram(maxIndex + 1) * (maxIndex + 1) + histogram(maxIndex - 1) * (maxIndex - 1);
background = background / (histogram(maxIndex) + histogram(maxIndex + 1) + histogram(maxIndex - 1));
frogRaw = frogRaw - background - 2;


%% noise reduction

noiseReduction = 1;
fftFrog = fftshift(fft2(frogRaw));
fftFrog_Delay = 1 / ccd_delayRange * (-dimensionT/2:dimensionT/2-1);
fftFrog_Frequency = 1 / ccd_frequencyRange * (-dimensionL/2:dimensionL/2-1);%this is only an approximation as the frog trace is still in the wavelength domain
NyquistDelay = N / delayRange / 2;
NyquistFrequency = N / frequencyRange / 2; 
[fftFrog_DelayMesh,fftFrog_FrequencyMesh] = meshgrid(fftFrog_Delay,fftFrog_Frequency); 
filterMatrix = ( (fftFrog_DelayMesh/NyquistDelay).^2 + (fftFrog_FrequencyMesh/NyquistFrequency).^2 <= 1/noiseReduction^2);
frogFiltered = real(ifft2(ifftshift(fftFrog .* filterMatrix)));
frogFiltered(frogFiltered < 0) = 0;


myfigure('filterMatrix');
imagesc(abs(filterMatrix));

myfigure('fftFrog');
imagesc(abs(fftFrog));

myfigure('Original Frogtrace');
imagesc(frogRaw);
colormap(lines(64));

myfigure('frogFiltered');
imagesc(frogFiltered);
colormap(lines(64));

diff = frogRaw - abs(frogFiltered);
H = fspecial('average', [5 5 ]);
filt_image = imfilter(diff,H);

myfigure('filter difference');
imagesc(filt_image);

myfigure('corrected hist')
hist(frogFiltered(:), -255:0.025:255)
frogRaw(frogRaw < 0) = 0;


%% convert the frog trace to be dependent of frequency instead of wavelength
% the intensities need to be corrected with a factor of lambda^2/c

frogConversionFactor = repmat((fitLambdaVal.'.^2 * 10^13), 1, dimensionT);
frogOverTauAndF = frogFiltered .* frogConversionFactor;

myfigure('frogOverTauAndF');
imagesc(frogOverTauAndF);
colormap(lines(64));

%figure(32)
%contourf(ccd_delay,ccd_frequency, frogOverTauAndF)

%calculate the frequency marginal
marginal_frequency = sum(frogOverTauAndF, 2);

myfigure('frequency marginal')
plot(ccd_frequency, marginal_frequency);


[ccdDelayMesh, ccdFrequencyMesh] = meshgrid(ccd_delay, ccd_frequency);

finalFrog = interp2(ccdDelayMesh, ccdFrequencyMesh, frogOverTauAndF, tau, frequency.' + ( c / (390 * n)));
finalFrog(isnan(finalFrog)) = 0;
myfigure('finalFrog')
imagesc(finalFrog);
colormap(hsv(32));



%% old method
tIntegration = tic;

decimateFactor = 1;
N10 = decimateFactor*N;
tau10 = (-(N10)/2:(N10)/2-1)*dtau/decimateFactor;
w10 = (-N10/2:N10/2-1) * dfrequency/decimateFactor;

frogint = interp1(ccd_frequency, frogOverTauAndF, w10 + ( c / 390 / n));
frogint(isnan(frogint)) = 0;

frogint = frogint.';
frogint = interp1(ccd_delay, frogint, tau10);
froginttotest = frogint.';
froginttotest(isnan(froginttotest)) = 0;






decimateFactor = 7;
N10 = decimateFactor*N;
tau10 = (-(N10)/2:(N10)/2-1)*dtau/decimateFactor;
w10 = (-N10/2:N10/2-1) * dfrequency/decimateFactor;

frogint = interp1(ccd_frequency, frogOverTauAndF, w10 + ( c / 390 / n));
frogint(isnan(frogint)) = 0;

frogint = frogint.';
frogint = interp1(ccd_delay, frogint, tau10);
frogint = frogint.';
frogint(isnan(frogint)) = 0;

fprintf('tIntegration: %f seconds \n', toc(tIntegration));

tDecimate = tic
frogint2 = zeros(N10,N);
for k = 1:N10
frogint2(k,:) = decimate(frogint(k,:), decimateFactor);
end
frogint3 = zeros(N,N);
for k = 1:N
frogint3(:,k) = decimate(frogint2(:,k), decimateFactor);
end
toc(tDecimate)
myfigure('difference in old method')
imagesc(t, frequency,frogint3 -  froginttotest)
colormap(hsv(32));
colorbar

myfigure('difference in left and right side of raw')
imagesc(t, frequency,fliplr(froginttotest) -  froginttotest)
colormap(hsv(32));
colorbar

myfigure('difference in left and right side of decimated')
imagesc(t, frequency,fliplr(frogint3) -  frogint3)
colormap(hsv(32));
colorbar

%tDecimateNew = tic;
%frogint2 = downsample(frogint, decimateFactor);
%frogint3 = downsample(frogint2.', decimateFactor);
%frogint3 = frogint3.';
%fprintf('tDecimateNew: %f seconds \n', toc(tDecimateNew));



myfigure('frogint3');
imagesc(t, frequency,frogint3)
colormap(hsv(32));
colorbar

myfigure('difference in methods');
imagesc(frogint3 - finalFrog)
colormap(jet(256));
colorbar
myfigure('difference in methods cut');
plot(t,frogint3(:,128), t,  finalFrog(:,128))

%figure(63)
%contourf(t,frequency, frogint3)

fprintf('tTotal: %f seconds \n', toc(tTotal));



saveimagedata = uint16(finalFrog/max(max(finalFrog))*65000);
imwrite(saveimagedata, 'generated.tif', 'tif')