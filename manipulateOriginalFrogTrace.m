%*********************************************************
%	Convert the frog camera image to a calibrated frogtrace
%	
%	Developement started: end 2012
%	Author: Frederik B�hle code@fboehle.de
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

%play with this: fftw('planner', 'exhaustive')

constants; %load physical, mathematical and numerical constants
setup; %initilized values

showAdvancedFigures = 1;


%read frogtrace
%frogRaw = imread('2013-05-29--16-37-49 wedges optimized, 2bar He.frogtrace.tif')';
%frogRaw = double(frogRaw);
load('lastDir.mat');
if(frogRawDIRname == 0) 
    frogRawDIRname = pwd;
end
[frogRawFilename, frogRawDIRname] = uigetfile('*.frogtrace', 'Select the raw FROG trace', frogRawDIRname);
save('lastDir.mat', 'frogRawDIRname');
frogRawFullFilename = fullfile(frogRawDIRname, frogRawFilename);
frogRawFileID = fopen(frogRawFullFilename, 'r');
if frogRawFileID == -1
    fprintf('*****File not found*****\n');
    break;
end;
frogRaw = fread(frogRawFileID, [1376, 1035], 'uint8');
fclose(frogRawFileID);

%read seperately recorded spectrum
if(0); %Hamamatsu
    spectrumIndependent = dlmread('2013-02-14--17-50-33-afterXPW+CMs+wedges(FROG)-inbeamwithpaper.csv', ',', [1 1 2048 1]);
    spectrumIndependentLambda = n * dlmread('2013-02-14--17-48-33-afterXPW+CMs+wedges(FROG)-more.csv',',', [1 0 2048 0]);
    spectrumIndependent = spectrumIndependent -  dlmread('2013-02-26_1018_darkref_30ms_fiber.csv', ',', [1 1 2048 1]);
    spectrumIndependent(spectrumIndependent < 0 ) = 0;
    spectrumIndependent =  spectrumIndependent .* dlmread('HamamatsuCalibrationwithfactor.txt', '\t', [1 8 2048 8]);
    spectrumIndependentFrequency = c ./ spectrumIndependentLambda;
    spectrumIndependent = spectrumIndependent .* (spectrumIndependentLambda * 100000000).^2 / c;
    frequency2048 = (0:1/2047:1) * c ./ (200*n) ;
    spectrumIndependent2048 = interp1(spectrumIndependentFrequency, spectrumIndependent, frequency2048, 'linear', 0);
else; %Avantes
    spectrumIndependent = dlmread('2013061818juin131930290001_0705014U1.TXT', ';', [8 1 2850 1]);
    spectrumIndependentLambda = n * dlmread('2013061818juin131930290001_0705014U1.TXT',';', [8 0 2850 0]);
    spectrumIndependent = spectrumIndependent; %substract dark reference if possible
    spectrumIndependent(spectrumIndependent < 0 ) = 0;
    avantesCalibrationFactor = interp1(n* dlmread('AvantesCalib.txt', ',', [0 0 1400 0]), dlmread('AvantesCalib.txt', ',', [0 1 1400 1]), spectrumIndependentLambda, 'linear', 0);
    spectrumIndependent =  spectrumIndependent .* avantesCalibrationFactor;
    spectrumIndependentFrequency = c ./ spectrumIndependentLambda;
    spectrumIndependent = spectrumIndependent .* (spectrumIndependentLambda * 100000000).^2 / c;
    frequency2048 = (0:1/2047:1) * c ./ (200*n) ;
    spectrumIndependent2048 = interp1(spectrumIndependentFrequency, spectrumIndependent, frequency2048, 'linear', 0);
end;  
    
    
%done

tTotal = tic;

dimensionL = 1376;
dimensionT = 1035;

pixell = 1:dimensionL;
pixelt = 1:dimensionT;

load('Calibrations/20130906.mat');

% lambdalines = [302,313,365,405,436] * n;
% lambdapixel = [256,361,693,945,1143];
% delayfromposition = ([ -4.15, 6.25, 7.8, 13.38, 15.4, 27.2, 32.3]) * u * 2 / c; 
% delaypixel = [862,692,666,535,551,368,286];
% save('Calibrations/20130906.mat', 'lambdalines', 'lambdapixel', 'delayfromposition', 'delaypixel');


fitLambda = polyfit(lambdapixel,lambdalines,1); %the spectrometer has a linear relation between the pixel and the wavelength
fitLambdaVal = polyval(fitLambda, pixell);

ccd_frequency  = c ./ polyval(fitLambda, pixell);
ccd_frequencyRange = ccd_frequency(length(ccd_frequency)) - ccd_frequency(1);


delayFit = polyfit(delaypixel, delayfromposition, 1);
delayFitVal = polyval(delayFit, pixelt);

ccd_dt = delayFit(1);
ccd_delay = (-(length(pixelt)/2)*ccd_dt:ccd_dt:(length(pixelt)/2 - 1) * ccd_dt);
ccd_delayRange = ccd_delay(length(ccd_delay)) - ccd_delay(1);

if(showAdvancedFigures);

    myfigure('calibration of spectrometer')
    plot(lambdapixel, lambdalines, pixell, fitLambdaVal);
    title('calibration of spectrometer');

    myfigure('calibration of delay');
    plot(delaypixel, delayfromposition, pixelt, delayFitVal);
    title('calibration of delay');

end;

tauRange = tau(N) - tau(1);
frequencyRange = frequency(N) - frequency(1);

%% background substraction


histogram = histc(frogRaw(:), 1:255);
[dontneedyou,maxIndex] = max(histogram);
if(maxIndex > 1)
background = histogram(maxIndex) * maxIndex + histogram(maxIndex + 1) * (maxIndex + 1) + histogram(maxIndex - 1) * (maxIndex - 1);
background = background / (histogram(maxIndex) + histogram(maxIndex + 1) + histogram(maxIndex - 1));
frogRaw = frogRaw - background;
end

%% rotate it a bit, this is not nessesarily a good idea, but do it in any case after the background substraction!!!
frogRaw = imrotate(frogRaw, 0.5, 'bilinear','crop');


%% anti aliasing and noise reduction if noiseReduction > 1

% create filter matrix
noiseReduction = 20;
fftFrog_Delay = 1 / ccd_delayRange * (-dimensionT/2:dimensionT/2-1);
fftFrog_Frequency = 1 / ccd_frequencyRange * (-dimensionL/2:dimensionL/2-1);%this is only an approximation as the frog trace is still in the wavelength domain
NyquistDelay = N / delayRange / 2;
NyquistFrequency = N / frequencyRange / 2; 
[fftFrog_DelayMesh,fftFrog_FrequencyMesh] = meshgrid(fftFrog_Delay,fftFrog_Frequency); 

%simple low pass filter with sharp cuttof
%filterMatrix = ( (fftFrog_DelayMesh/NyquistDelay).^2 + (fftFrog_FrequencyMesh/NyquistFrequency).^2 <= 1/noiseReduction^2);

%use a nth-order butterworth filter, with the Nyquist as cutoff
butterworthOrder = 1; %too low is not good, as it would 
filterMatrixNormalizedRadius =  noiseReduction * sqrt(( (fftFrog_DelayMesh/NyquistDelay).^2 + (fftFrog_FrequencyMesh/NyquistFrequency).^2)) ;
filterMatrix = sqrt(1./ (1 + (filterMatrixNormalizedRadius).^(2 * butterworthOrder)));

% do actual filitering
fftFrog = fftshift(fft2(frogRaw));
frogFiltered = real(ifft2(ifftshift(fftFrog .* filterMatrix)));
frogFiltered(frogFiltered < 0) = 0;

if(showAdvancedFigures);
    
    myfigure('frogFiltered');
    imagesc(frogFiltered);
    colormap(lines(64));

    myfigure('filterMatrix');
    imagesc(abs(filterMatrix));

    myfigure('fftFrog');
    imagesc(abs(fftFrog));

    myfigure('filter difference');
    diff = frogRaw - abs(frogFiltered);
    H = fspecial('average', [10 10]);
    filt_image = imfilter(diff,H);
    imagesc(filt_image, [-1 1 ]);
end;

%% place frog trace in the middle with respect to delay
toMoveTime = sum((-(1035/2):(1035/2)-1) .* sum(frogFiltered).^2)/sum(sum(frogFiltered).^2); %weighted average to find center of peak
toMoveTime(isnan(toMoveTime)) = 0;
frogFiltered = circshift(frogFiltered,[0 -round(toMoveTime)]);

if(showAdvancedFigures);
    
    myfigure('frogFiltered after moving');
    imagesc(frogFiltered);
    colormap(mycolormap);

end;


%% convert the frog trace to be dependent of frequency instead of wavelength
% the intensities need to be corrected with a factor of lambda^2/c

frogConversionFactor = repmat((fitLambdaVal.'.^2 * 10^13), 1, dimensionT);
frogOverTauAndF = frogFiltered .* frogConversionFactor;

%% calculate the frequency marginal

    marginal_frequency = sum(frogOverTauAndF, 2);
    myfigure('frequency marginal')
    plot(ccd_frequency, marginal_frequency);
    

    spectrumIndependentAutoconvoluted = conv(spectrumIndependent2048, spectrumIndependent2048, 'full');
    spectrumIndependentAutoconvoluted = interp1((0:1/4094:1) * c ./ (100*n), spectrumIndependentAutoconvoluted, frequency2048, 'linear', 0);

    myfigure('Autoconvoluted Spectra');
    plot(frequency2048, spectrumIndependentAutoconvoluted/max(spectrumIndependentAutoconvoluted), ccd_frequency, marginal_frequency/max(marginal_frequency));



%% create the final frogtrace
[ccdDelayMesh, ccdFrequencyMesh] = meshgrid(ccd_delay, ccd_frequency);
%center in frequency
%frequencyOffset = ( c / (375 * n));
frequencyOffset = sum(ccd_frequency' .* sum(frogOverTauAndF,2))/sum(sum(frogOverTauAndF,2)); %weighted average to find center of peak
frequencyOffset(isnan(frequencyOffset)) = 0;
finalFrog = interp2(ccdDelayMesh, ccdFrequencyMesh, frogOverTauAndF, tau, frequency.' + frequencyOffset);
finalFrog(isnan(finalFrog)) = 0;


fprintf('Total manipulations time: %f seconds \n', toc(tTotal));


myfigure('Original Frogtrace');
imagesc(frogRaw);
colormap(mycolormap);

myfigure('finalFrog')
imagesc(tau, frequency + frequencyOffset, finalFrog);
colormap(mycolormap);

%% calculate center of mass of each row or column of final frog trace
%(centerofmass of the delay)
myfigure('centerofmass')
subplot(1,2,1)
imagesc(tau, frequency + frequencyOffset, finalFrog);
colormap(mycolormap);
CoMdelay = sum(finalFrog .* (ones(length(frequency),1) * tau), 2)./sum(finalFrog, 2);
hold all;
scatter(CoMdelay, frequency + frequencyOffset, 'black', 'filled' )
hold off;

%THIS IS THE IMPORTANT ONE: centerofmass of the frequency
subplot(1,2,2)
imagesc(tau, frequency + frequencyOffset, finalFrog);
colormap(mycolormap);
CoMfrequency = sum(finalFrog .* (frequency' * ones(1,length(frequency))), 1) ./ sum(finalFrog, 1);
hold all;
scatter(tau, CoMfrequency + frequencyOffset, 'black', 'filled' )
hold off;
%%
%some testing on it
a = -0.0;
T = maketform('affine', [1 0 0; a 1 0; 0 0 1] );
R = makeresampler({'cubic','cubic'},'fill');
shearedFrog = imtransform(finalFrog,T,R);
shearedFrog = shearedFrog((1:256) + (size(shearedFrog,1)/2 - 128), (1:256) + floor(size(shearedFrog,2)/2 - 128));
toMoveTime = sum((-(256/2):(256/2)-1) .* sum(shearedFrog).^2)/sum(sum(shearedFrog).^2); %weighted average to find center of peak
toMoveTime(isnan(toMoveTime)) = 0;
shearedFrog = circshift(shearedFrog,[0 -round(toMoveTime)]);
myfigure('sheared')
imagesc(tau, frequency + frequencyOffset, shearedFrog);
colormap(mycolormap);
CoMdelay = sum(shearedFrog .* (ones(length(frequency),1) * tau), 2)./sum(shearedFrog, 2);
hold all;
scatter(CoMdelay, frequency + frequencyOffset, 'black', 'filled' )
hold off;
saveimagedata = uint16(shearedFrog/max(max(shearedFrog))*65000);
imwrite(saveimagedata, 'generatedsheared.tif', 'tif')


saveimagedata = uint16(finalFrog/max(max(finalFrog))*65000);
imwrite(saveimagedata, 'generated.tif', 'tif')