% the camera has a timespan from -100fs until 100fs: bandwidth 200fs
%            and a frequency range from about 
%

clear all

%play with this: fftw('planner', 'exhaustive')

constants; %load physical, mathematical and numerical constants
setup; %initilized values

NBig = 2^14;
NBigRange = (-(NBig)/2:(NBig)/2-1);
frequencyBigRange = c ./ (50*n);
dfrequencyBig = frequencyBigRange/NBig;
frequencyBig = NBigRange * dfrequencyBig ;
tBigRange = NBig/frequencyBigRange;
dtBig = tBigRange/NBig;
tBig = NBigRange * dtBig;

%create a gaussian spectrum
spectralAmplitude = exp(-(frequencyBig - c/(800*n)).^2 ./ (3.75e14*0.1).^2);
spectralAmplitude = spectralAmplitude .* (1 + 0.1 * cos(frequencyBig/1000 - 1000));
spectralAmplitude(1:NBig/2) = 0;
myfigure('Spectral Amplitude')
plot(frequencyBig, spectralAmplitude);

title('Spectral Amplitude');

electricField = ifftshift(ifft(fftshift(spectralAmplitude)));
electricField = electricField ./ max(electricField);

myfigure('Electric Field')
clf
[tempPlot, tempPlot1, tempPlot2] = plotyy(tBig, real(electricField), tBig, round(abs(electricField)*10).*angle(electricField.*exp(-1i*2*pi*tBig*(c./(800*n)))));
xlabel('Time') 
hold(tempPlot(1), 'on')
tempPlot3 = plot(tBig, log10(abs(electricField).^2)./5 + 1, 'r', 'Parent', tempPlot(1));
set(tempPlot1,'Color','blue','LineWidth',2)
set(tempPlot2,'Color',[0 0.498 0],'LineWidth',1)
set(tempPlot3,'Color','red','LineWidth',2)
hold off;
annotation('textbox', [.2 .4, .1, .1], 'String', ['FWHM = ', num2str(fwhm(tBig*1e15, abs(electricField).^2)), ' fs'] );
title('Electric Field');

%break;

%read in a recorded spectrum from Avantes
[spectrumRawFilename, spectrumRawDIRname] = uigetfile('*.txt', 'Select the raw FROG trace');
spectrumRawFullFilename = fullfile(spectrumRawDIRname, spectrumRawFilename);

spectrumRaw = dlmread(spectrumRawFullFilename, ';', [8 1 2850 1]);
spectrumRawLambda = n * dlmread(spectrumRawFullFilename,';', [8 0 2850 0]);
avantesCalibrationFactor = interp1(n* dlmread('AvantesCalib.txt', ',', [0 0 1400 0]), dlmread('AvantesCalib.txt', ',', [0 1 1400 1]), spectrumRawLambda, 'linear', 0);
spectrumCalibrated =  spectrumRaw .* avantesCalibrationFactor;
spectrumRawFrequency = c ./ spectrumRawLambda;
spectrumOverF = spectrumCalibrated .* (spectrumRawLambda * 100000000).^2 / c;
spectralIntensity = abs(interp1(spectrumRawFrequency, spectrumOverF, frequencyBig, 'linear', 0));

spectralAmplitude = sqrt(spectralIntensity);
myfigure('Spectral Amplitude')
plot(frequencyBig, spectralAmplitude);
title('Spectral Amplitude');

electricField = ifftshift(ifft(fftshift(spectralAmplitude)));
electricField = electricField ./ max(electricField);

myfigure('Electric Field')
clf
[tempPlot, tempPlot1, tempPlot2] = plotyy(tBig, real(electricField), tBig, round(abs(electricField)*10).*angle(electricField.*exp(-1i*2*pi*tBig*(c./(800*n)))));
xlabel('Time') 
hold(tempPlot(1), 'on')
tempPlot3 = plot(tBig, log10(abs(electricField).^2)./5 + 1, 'r', 'Parent', tempPlot(1));
set(tempPlot1,'Color','blue','LineWidth',2)
set(tempPlot2,'Color',[0 0.498 0],'LineWidth',1)
set(tempPlot3,'Color','red','LineWidth',2)
hold off;
annotation('textbox', [.2 .4, .1, .1], 'String', ['FWHM = ', num2str(fwhm(tBig*1e15, abs(electricField).^2)), ' fs'] );
title('Electric Field');