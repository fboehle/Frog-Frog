% the camera has a timespan from -100fs until 100fs: bandwidth 200fs
%            and a frequency range from about 
%

clear all

constants; %load physical, mathematical and numerical constants
setup; %initilized values

%read frogtrace
frog = imread('2013-02-14--15-48-32_visually_best_compression.tif')';

%read seperately recorded spectrum
spectrumIndependent = dlmread('2013-02-14--17-50-33-afterXPW+CMs+wedges(FROG)-inbeamwithpaper.csv', ',', [1 1 2048 1]);
spectrumIndependentLambda = n * dlmread('2013-02-14--17-48-33-afterXPW+CMs+wedges(FROG)-more.csv',',', [1 0 2048 0]);
spectrumIndependent = spectrumIndependent -  dlmread('2013-02-26_1018_darkref_30ms_fiber.csv', ',', [1 1 2048 1]);
spectrumIndependent(spectrumIndependent < 0 ) = 0;
spectrumIndependent =  spectrumIndependent .* dlmread('HamamatsuCalibrationwithfactor.txt', '\t', [1 8 2048 8]);
spectrumIndependentFrequency = c ./ spectrumIndependentLambda;
spectrumIndependent = spectrumIndependent .* (spectrumIndependentLambda * 100000000).^2 / c;

figure(14)
plot(spectrumIndependentFrequency, spectrumIndependent);


spectrumAutoconvolution = ifft(fft(spectrumIndependent) .*  fft(spectrumIndependent));
%spectrumAutoconvolutionFrequency = 

%figure(15)
%plot(spectrumIndependentFrequency, spectrumAutoconvolution);


frog = double(frog);
frog = imrotate(frog, 1, 'bilinear','crop');

%place frog trace in the middle respect to delay
toMoveTime = -round(sum((-(1035/2):(1035/2)-1) .* sum(uint16(frog) - 15).^2)/sum(sum(uint16(frog) - 15).^2)); %weighted average to find center of peak
frog = circshift(frog,[0 toMoveTime]);

myfigure('Original Frogtrace')
imagesc(frog);
title('Original Frogtrace')

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

figure(21)
plot(lambdapixel, lambdalines, pixell, fitLambdaVal);
title('calibration of spectrometer');


%old erroneous calculation
frequencylines = c ./ lambdalines;
fitFrequency = polyfit(lambdapixel,frequencylines,1);
frequencyfit = polyval(fitFrequency, pixell);
figure(20)
plot(lambdapixel, frequencylines, pixell, frequencyfit, pixell, ccd_frequency);
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


tauRange = tau(N) - tau(1);
frequencyRange = frequency(N) - frequency(1);



figure(31)
contourf(ccd_delay,ccd_frequency, frog)


%anti-alias



%background substraction
frog = frog - 11;
frog(frog < 0) = 0;


% convert the frog trace to be dependent of frequency instead of wavelength
% the intensities need to be corrected with a factor of lambda^2/c

frogConversionFactor = repmat((fitLambdaVal.'.^2 * 10^13), 1, dimensionT);
frogOverTauAndF = frog .* frogConversionFactor;

figure(32)
contourf(ccd_delay,ccd_frequency, frogOverTauAndF)

%calculate the frequency marginal
marginal_frequency = sum(frogOverTauAndF, 2);

figure(41)
plot(ccd_frequency, marginal_frequency);


%do this only provisionally
frog = frogOverTauAndF;

decimateFactor = 10;
N10 = decimateFactor*N;
tau10 = (-(N10)/2:(N10)/2-1)*dtau/10;
w10 = (-N10/2:N10/2-1) * dfrequency/10;

frogint = interp1(ccd_frequency, frog, w10 + ( c / 390 / n));
frogint(isnan(frogint)) = 0;

frogint = frogint.';
frogint = interp1(ccd_delay, frogint, tau10);
frogint = frogint.';
frogint(isnan(frogint)) = 0;
tic;
frogint2 = zeros(N,N10);
for k = 1:N10
frogint2(:,k) = decimate(frogint(:,k), decimateFactor);
end
frogint3 = zeros(N,N);
for k = 1:N
frogint3(k,:) = decimate(frogint2(k,:), decimateFactor);
end
toc
figure(61)
imagesc(t, frequency,frogint)
colormap(jet(256));
colorbar

figure(62)
imagesc(frogint3)
colormap(jet(256));
colorbar

figure(63)
contourf(t,frequency, frogint3)

saveimagedata = uint16(frogint3/max(max(frogint3))*65000);
imwrite(saveimagedata, 'generated.tif', 'tif')