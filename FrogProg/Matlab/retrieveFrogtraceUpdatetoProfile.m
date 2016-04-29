% the camera has a timespan from -100fs until 100fs: bandwidth 200fs
%            and a frequency range from about 
%
clear all;

retrieveFrogtraceCreate;
tic
for numberOfRuns = 1:10

%% read frogtrace
frogRaw = imread('sample.tif')';
frogRaw = double(frogRaw);


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


%% place frog trace in the middle with respect to delay
toMoveTime = sum((-(1035/2):(1035/2)-1) .* sum(frogFiltered).^2)/sum(sum(frogFiltered).^2); %weighted average to find center of peak
toMoveTime(isnan(toMoveTime)) = 0;
frogFiltered = circshift(frogFiltered,[0 -round(toMoveTime)]);

%% convert the frog trace to be dependent of frequency instead of wavelength
% the intensities need to be corrected with a factor of lambda^2/c

frogConversionFactor = repmat((fitLambdaVal.'.^2 * 10^13), 1, dimensionT);
frogOverTauAndF = frogFiltered .* frogConversionFactor;


%% create the final frogtrace
[ccdDelayMesh, ccdFrequencyMesh] = meshgrid(ccd_delay, ccd_frequency);
finalFrog = interp2(ccdDelayMesh, ccdFrequencyMesh, frogOverTauAndF, tau, frequency.' + ( c / (367 * n)));
finalFrog(isnan(finalFrog)) = 0;



%% read in the frogtrace
IFrog = finalFrog / max(max(finalFrog));
sqrtIFrog = sqrt(IFrog);

% make a first guess for the E Field; in this case, put random noise
Efield = random('Poisson',50,1,N) + 1i*random('Poisson',50,1,N);
Efield = Efield/max(Efield);
Egate = Efield ;

%% Loop!
iterations = 100;
for l = 1:iterations



%% calculate the signal field
Esig = Efield.' * Egate + Egate.' * Efield;

%Esig=Esig-tril(Esig,-ceil(N/2))-triu(Esig,ceil(N/2));

Esig = Esig(indexforcircshift);


Esig = fliplr(fftshift(Esig,2));


%% calculate the theoretical Frog Trace
ICalcwphase = fftshift(fft((Esig),N,1),1);
ICalc = abs(ICalcwphase).^2;


%% calculate the Frog Error
if(l == iterations) %do this only in the last run
mu = sum(sum(IFrog.*ICalc))/sum(sum(ICalc.^2));
G = 1/N * sqrt( sum(sum(  (IFrog - mu * ICalc).^2 )));
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


%% SVD algorithm
% get back to the outer-product

outerProduct = ifftshift(fliplr(Esig), 2);

%for m = 1:N
%    outerProduct(m,:) = circshift(outerProduct(m,:), [0 m]);
%end
outerProduct = outerProduct(indexforcircshiftback);


Efield = (outerProduct * outerProduct') * Efield.';
Egate = (outerProduct' * outerProduct) * Egate.';

Efield = Efield.' / max(abs(Efield));
Egate = conj(Egate.') / max(abs(Egate));

tToMove = -round(sum((-(N)/2:(N)/2-1) .* abs(Efield).^2)/sum(abs(Efield).^2)); %weighted average to find center of peak
Efield = circshift(Efield,[0 tToMove]);
Egate = circshift(Egate,[0 tToMove]);


%% fit
% for fitting one need the Curve Fitting Toolbox
%Efieldfit = fit(t, abs(Efield), 'gauss1');


end

ICalc = ICalc/max(max(ICalc)); %this is actually only the result of the second to last run

set(temporalPlot1, 'YData',abs(Efield).^2);
unwrapedAngle = unwrap(angle(Efield));
set(temporalPlot2, 'YData',unwrapedAngle - unwrapedAngle(N/2) );

%polyvalresult = polyfit(t(3/8*N:5/8*N), unwrap(angle(Efield(3/8*N:5/8*N))), 3);
%fprintf('Second Order Chirp: %.3g fs^2\n', polyvalresult(2)*f^2);
%polyvalresult(4) = 0;
%set(temporalPlot3, 'YData',polyval(polyvalresult, t));

V = fftshift(fft(ifftshift(Efield)));
V = V/max(abs(V));

set(spectralPlot1, 'YData',abs(V).^2);
unwrapedAngle = unwrap(angle(V));
set(spectralPlot2, 'YData', unwrapedAngle - unwrapedAngle(N/2) );

%polyvalresult = polyfit(frequency(3/8*N:5/8*N), unwrap(angle(V(3/8*N:5/8*N))), 3);
%polyvalresult(4) = 0;
%fprintf('Second Order Chirp: %.3g fs^2\n', polyvalresult(2)*f^2);
%set(temporalPlot3, 'YData',polyval(polyvalresult, frequency));


set(originalTracePlot, 'CData', IFrog);
set(retrievedTracePlot, 'CData',ICalc);
drawnow;
fwhmresult = fwhm(t, abs(Efield).^2);
fprintf('FWHM: %.1f fs \tFrog Error: %.3f%% \n', fwhmresult / f, G * 100);

end
toc