% the camera has a timespan from -100fs until 100fs: bandwidth 200fs
%            and a frequency range from about 
%

clear all

%play with this: fftw('planner', 'exhaustive')

constants; %load physical, mathematical and numerical constants
setup; %initilized values

showAdvancedFigures = 0;


%read frogtrace
%frogRaw = imread('2013-05-29--16-37-49 wedges optimized, 2bar He.frogtrace.tif')';
%frogRaw = double(frogRaw);
[frogRawFilename, frogRawDIRname] = uigetfile('*.frogtrace', 'Select the raw FROG trace');
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

lambdalines = [302,313,365,405,436] * n;
lambdapixel = [256,361,693,945,1143];
%lambdapixel = [245,352,680,934,1130];
fitLambda = polyfit(lambdapixel,lambdalines,1); %the spectrometer has alinear relation between the pixel and the wavelength
fitLambdaVal = polyval(fitLambda, pixell);

ccd_frequency  = c ./ polyval(fitLambda, pixell);
ccd_frequencyRange = ccd_frequency(length(ccd_frequency)) - ccd_frequency(1);

delayfromposition = (-[37.1,59.2,57.1,51.6,48.1,43.0,40.1,37.5,47.6]) * u * 2 / c; 
delaypixel = [713,224,269,394,470,581,646,703,483];
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

%% rotate it a bit, this is not nessesarily a good idea, but do it after the background substraction!!!
frogRaw = imrotate(frogRaw, 1, 'bilinear','crop');


%% anti aliasing and noise reduction if noiseReduction > 1

% create filter matrix
noiseReduction = 1;
fftFrog_Delay = 1 / ccd_delayRange * (-dimensionT/2:dimensionT/2-1);
fftFrog_Frequency = 1 / ccd_frequencyRange * (-dimensionL/2:dimensionL/2-1);%this is only an approximation as the frog trace is still in the wavelength domain
NyquistDelay = N / delayRange / 2;
NyquistFrequency = N / frequencyRange / 2; 
[fftFrog_DelayMesh,fftFrog_FrequencyMesh] = meshgrid(fftFrog_Delay,fftFrog_Frequency); 
filterMatrix = ( (fftFrog_DelayMesh/NyquistDelay).^2 + (fftFrog_FrequencyMesh/NyquistFrequency).^2 <= 1/noiseReduction^2);

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
    H = fspecial('average', [1 1]);
    filt_image = imfilter(diff,H);
    imagesc(filt_image, [-1 1 ]);
end;

if(showAdvancedFigures);
    
    myfigure('frogFiltered before moving');
    imagesc(frogFiltered);
    colormap(mycolormap);

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
finalFrog = interp2(ccdDelayMesh, ccdFrequencyMesh, frogOverTauAndF, tau, frequency.' + ( c / (350 * n)));
finalFrog(isnan(finalFrog)) = 0;


fprintf('Total manipulations time: %f seconds \n', toc(tTotal));


myfigure('Original Frogtrace');
imagesc(frogRaw);
colormap(mycolormap);

myfigure('finalFrog')
imagesc(finalFrog);
colormap(mycolormap);

saveimagedata = uint16(finalFrog/max(max(finalFrog))*65000);
imwrite(saveimagedata, 'generated.tif', 'tif')