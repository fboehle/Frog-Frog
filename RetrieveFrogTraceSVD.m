%*********************************************************
%	Retrieve the original pulse from a Frogtrace with the SVD algorithm. 
%	
%	Developement started: end 2012
%	Author: Frederik Böhle (code@fboehle.de)
%
%*********************************************************
%   
%   Description: 
%
%   Notes: this is the best implementation so far
%
%   Changelog:
%
%*********************************************************

clear all
tTotal = tic;
constants; %load physical, mathematical and numerical constants
setup; %initilized values
indexForCircshift;

iterations = 20;
mov = 0;

numberOfRuns = 1;
usePreviousEfield = 1;
seperateSpectrumAvailable = 1;

eachFrogError = zeros(numberOfRuns, 1);
eachEfield = zeros(numberOfRuns, N);
for numberOfRun = 1:numberOfRuns

%% read the Frog trace
%IFrog = double(imread('generated.tif')) ;
load('generated.mat');
IFrog = normMax(dataTransfer.finalFrog.intensity);
sqrtIFrog = sqrt(IFrog);

%% testspace***
%tToMove = -round(sum((1:N) .* abs(sum(IFrog,2)).^4)/sum(abs(sum(IFrog,2)).^4)-N/2); %weighted average to find center of peak
%IFrog = circshift(IFrog,[0 0]);
%IFrog = flipud(IFrog);
%testspace***



%% make a guess for the E Field; in this case, put random noise
Efield = random('Poisson',500,1,N) + 1i*random('Poisson',500,1,N);
Efield = normMax(Efield);
Egate = Efield ;

%% or use the efield from the previous run
if(usePreviousEfield)
    load('previousBestEfield.mat');
    Efield = previousBestEfield;
    Egate = Efield ;
end

%%

tStart = tic;


%% Loop!
fprintf('Retrieval started!\n ************************************');


for l = 1:iterations

    
%% calculate the signal field
Esig = Efield.' * Egate + Egate.' * Efield;
%Esig=Esig-tril(Esig,-ceil(N/2))-triu(Esig,ceil(N/2));
Esig = Esig(indexforcircshift);
Esig = fliplr(fftshift(Esig,2));


%% calculate the theoretical Frog Trace
ICalc.amplitude = fftshift(fft((Esig),N,1),1);
ICalc.intensity = abs(ICalc.amplitude).^2;

if(~mod(l, mov))
    myfigure('retrieved frogtrace')
    imagesc(tau, frequency, ICalc.intensity)
    title('retrieved frogtrace')
    colormap(jet(256));
end

%% calculate the Frog Error

mu = sum(sum(IFrog.*ICalc.intensity))/sum(sum(ICalc.intensity.^2));
G = 1/N * sqrt( sum(sum(  (IFrog - mu * ICalc.intensity).^2 )));
fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\bFrog Error: %.3f%% \tIteration: %.4d ', G * 100, l);
if(G<0.001) 
%    break;
end


%% replace the magnitude of ICalc.amplitude with the one from the original
%  trace without altering the phase

%ICalc.amplitude = exp(i * angle(ICalc.amplitude)) .* sqrtIFrog ;
%ICalc = abs(ICalc.amplitude).^2;
ICalc.amplitude(ICalc.amplitude == 0) = NaN;
ICalc.amplitude = ICalc.amplitude ./abs(ICalc.amplitude) .* sqrtIFrog ;
ICalc.amplitude(isnan(ICalc.amplitude)) = 0;

%% do the inverse FT back to the time domain
Esig = ifft(ifftshift(ICalc.amplitude,1), N, 1);

if(~mod(l, mov))
    myfigure('Esig')
    imagesc(abs(Esig))
    title('Esig')
end


%% SVD algorithm
% get back to the outer-product

outerProduct = ifftshift(fliplr(Esig), 2);

%for m = 1:N
%    outerProduct(m,:) = circshift(outerProduct(m,:), [0 m]);
%end
outerProduct = outerProduct(indexforcircshiftback);


Efield = (outerProduct * outerProduct') * Efield.'; %this is an approximation. Should be done an infinite number of times
Egate = (outerProduct' * outerProduct) * Egate.';

Efield = normMax(Efield.');
Egate = normMax(conj(Egate.'));

tToMove = -round(sum((-(N)/2:(N)/2-1) .* abs(Efield).^2)/sum(abs(Efield).^2)); %weighted average to find center of peak
Efield = circshift(Efield,[0 tToMove]);
Egate = circshift(Egate,[0 tToMove]);

if(~mod(l, mov))
    myfigure('retrieved Efield')
    plotyy( t, abs(Efield), t, unwrap(angle(Efield) .* min(round(abs(Efield)*30),1)))
    title('retrieved Efield')
    drawnow;
end

%% fit
% for fitting one need the Curve Fitting Toolbox
%Efieldfit = fit(t, abs(Efield), 'gauss1');


end

ICalc.intensity = normMax(ICalc.intensity); %this is actually only the result of the second to last run


%myfigure('retrieved Efield')
%plotyy(t, abs(Efield), t, unwrap((angle(Efield)-angle(Efield(N/2))) .* min(round(abs(Efield)*100),1)))
%title('retrieved Efield')




fwhmresult = fwhm(t, abs(Efield).^2);

V = fftshift(fft(ifftshift(Efield)));
V = normMax(V);

myFigure('Esig')
imagesc(abs(Esig))
title('Esig')

myFigure('Retrieval Error')
    imagesc(ICalc.intensity - IFrog, [-0.1 0.1]);
    colorbar;
    
myFigure('Retrieval Error Marginal')
    plot(tau, normMax(sum(IFrog)) - normMax(sum(ICalc.intensity)));
    
angleV = unwrap(angle(V));
angleV = angleV - angleV(N0);
angleEfield = unwrap(angle(Efield));
angleEfield = angleEfield - angleEfield(N0);







%% fit the phase



fitOrder = 4;
[borderLower, borderHigher] = findBorderIndex(abs(Efield).^2, 10);
temporalPhaseFit = polyfit(t(borderLower:borderHigher), angleEfield(borderLower:borderHigher), fitOrder);


[borderLower, borderHigher] = findBorderIndex(abs(V).^2, 10);
spectralPhaseFit = polyfit(frequency(borderLower:borderHigher), angleV(borderLower:borderHigher), fitOrder);

%% print DATA
fprintf('\n***********************************\n');
fprintf('Time for %d Iterations: %f s, that is %f s per iteration on average.\n',iterations, toc(tStart), toc(tStart)/iterations);
fprintf('Frog Error: %.3f%% \tIteration: %d \n', G * 100, l);
%fprintf('Second Order Temporal Chirp: %.3g fs^(-2)\n', temporalPhaseFit(fitOrder-1)*f^2);
fprintf('Second Order Dispersion: %.3g fs^2\n', spectralPhaseFit(fitOrder-1)/f^2*2/((2*pi)^2));
fprintf('Thirt Order Dispersion: %.3g fs^3\n', spectralPhaseFit(fitOrder-2)/f^3*6/((2*pi)^3));
fprintf('Fourth Order Dispersion: %.3g fs^4\n', spectralPhaseFit(fitOrder-3)/f^4*24/((2*pi)^4));
fprintf('FWHM: %.2f fs\n', fwhmresult / f);
fprintf('***********************************\n');

%% display always a positive second order chirp
if(spectralPhaseFit(fitOrder-1) < 0)
    angleV = - angleV;
    spectralPhaseFit = -spectralPhaseFit;
end


%% plot the data
   
myFigure('Frog Retrieval');
	colormap([0 0 0.515625;0 0 0.53125;0 0 0.546875;0 0 0.5625;0 0 0.578125;0 0 0.59375;0 0 0.609375;0 0 0.625;0 0 0.640625;0 0 0.65625;0 0 0.671875;0 0 0.6875;0 0 0.703125;0 0 0.71875;0 0 0.734375;0 0 0.75;0 0 0.765625;0 0 0.78125;0 0 0.796875;0 0 0.8125;0 0 0.828125;0 0 0.84375;0 0 0.859375;0 0 0.875;0 0 0.890625;0 0 0.90625;0 0 0.921875;0 0 0.9375;0 0 0.953125;0 0 0.96875;0 0 0.984375;0 0 1;0 0.015625 1;0 0.03125 1;0 0.046875 1;0 0.0625 1;0 0.078125 1;0 0.09375 1;0 0.109375 1;0 0.125 1;0 0.140625 1;0 0.15625 1;0 0.171875 1;0 0.1875 1;0 0.203125 1;0 0.21875 1;0 0.234375 1;0 0.25 1;0 0.265625 1;0 0.28125 1;0 0.296875 1;0 0.3125 1;0 0.328125 1;0 0.34375 1;0 0.359375 1;0 0.375 1;0 0.390625 1;0 0.40625 1;0 0.421875 1;0 0.4375 1;0 0.453125 1;0 0.46875 1;0 0.484375 1;0 0.5 1;0 0.515625 1;0 0.53125 1;0 0.546875 1;0 0.5625 1;0 0.578125 1;0 0.59375 1;0 0.609375 1;0 0.625 1;0 0.640625 1;0 0.65625 1;0 0.671875 1;0 0.6875 1;0 0.703125 1;0 0.71875 1;0 0.734375 1;0 0.75 1;0 0.765625 1;0 0.78125 1;0 0.796875 1;0 0.8125 1;0 0.828125 1;0 0.84375 1;0 0.859375 1;0 0.875 1;0 0.890625 1;0 0.90625 1;0 0.921875 1;0 0.9375 1;0 0.953125 1;0 0.96875 1;0 0.984375 1;0 1 1;0.015625 1 0.984375;0.03125 1 0.96875;0.046875 1 0.953125;0.0625 1 0.9375;0.078125 1 0.921875;0.09375 1 0.90625;0.109375 1 0.890625;0.125 1 0.875;0.140625 1 0.859375;0.15625 1 0.84375;0.171875 1 0.828125;0.1875 1 0.8125;0.203125 1 0.796875;0.21875 1 0.78125;0.234375 1 0.765625;0.25 1 0.75;0.265625 1 0.734375;0.28125 1 0.71875;0.296875 1 0.703125;0.3125 1 0.6875;0.328125 1 0.671875;0.34375 1 0.65625;0.359375 1 0.640625;0.375 1 0.625;0.390625 1 0.609375;0.40625 1 0.59375;0.421875 1 0.578125;0.4375 1 0.5625;0.453125 1 0.546875;0.46875 1 0.53125;0.484375 1 0.515625;0.5 1 0.5;0.515625 1 0.484375;0.53125 1 0.46875;0.546875 1 0.453125;0.5625 1 0.4375;0.578125 1 0.421875;0.59375 1 0.40625;0.609375 1 0.390625;0.625 1 0.375;0.640625 1 0.359375;0.65625 1 0.34375;0.671875 1 0.328125;0.6875 1 0.3125;0.703125 1 0.296875;0.71875 1 0.28125;0.734375 1 0.265625;0.75 1 0.25;0.765625 1 0.234375;0.78125 1 0.21875;0.796875 1 0.203125;0.8125 1 0.1875;0.828125 1 0.171875;0.84375 1 0.15625;0.859375 1 0.140625;0.875 1 0.125;0.890625 1 0.109375;0.90625 1 0.09375;0.921875 1 0.078125;0.9375 1 0.0625;0.953125 1 0.046875;0.96875 1 0.03125;0.984375 1 0.015625;1 1 0;1 0.984375 0;1 0.96875 0;1 0.953125 0;1 0.9375 0;1 0.921875 0;1 0.90625 0;1 0.890625 0;1 0.875 0;1 0.859375 0;1 0.84375 0;1 0.828125 0;1 0.8125 0;1 0.796875 0;1 0.78125 0;1 0.765625 0;1 0.75 0;1 0.734375 0;1 0.71875 0;1 0.703125 0;1 0.6875 0;1 0.671875 0;1 0.65625 0;1 0.640625 0;1 0.625 0;1 0.609375 0;1 0.59375 0;1 0.578125 0;1 0.5625 0;1 0.546875 0;1 0.53125 0;1 0.515625 0;1 0.5 0;1 0.484375 0;1 0.46875 0;1 0.453125 0;1 0.4375 0;1 0.421875 0;1 0.40625 0;1 0.390625 0;1 0.375 0;1 0.359375 0;1 0.34375 0;1 0.328125 0;1 0.3125 0;1 0.296875 0;1 0.28125 0;1 0.265625 0;1 0.25 0;1 0.234375 0;1 0.21875 0;1 0.203125 0;1 0.1875 0;1 0.171875 0;1 0.15625 0;1 0.140625 0;1 0.125 0;1 0.109375 0;1 0.09375 0;1 0.078125 0;1 0.0625 0;1 0.046875 0;1 0.03125 0;1 0.015625 0;1 0 0;0.984375 0 0;0.96875 0 0;0.953125 0 0;0.9375 0 0;0.921875 0 0;0.90625 0 0;0.890625 0 0;0.875 0 0;0.859375 0 0;0.84375 0 0;0.828125 0 0;0.8125 0 0;0.796875 0 0;0.78125 0 0;0.765625 0 0;0.75 0 0;0.734375 0 0;0.71875 0 0;0.703125 0 0;0.6875 0 0;0.671875 0 0;0.65625 0 0;0.640625 0 0;0.625 0 0;0.609375 0 0;0.59375 0 0;0.578125 0 0;0.5625 0 0;0.546875 0 0;0.53125 0 0;0.515625 0 0;0.972549021244049 0.972549021244049 0.972549021244049]);
	ax(1) = subplot(2,2,1);
		originalTracePlot = imagesc(tau * 1e15, frequency,IFrog, [0 1]);
        xlabel('delay (fs)');
        ylabel('frequency - \omega_0 (rad/s)');
        title('original FROG trace');
    ax(2) = subplot(2,2,2);
		retrievedTracePlot = imagesc(tau * 1e15, frequency,ICalc.intensity, [0 1]);
        xlabel('delay (fs)');
        ylabel('frequency - \omega_0 (rad/s)');
        title('retrieved FROG trace');
    linkaxes(ax);
    subplot(2,2,3);
		[temporalPlot, temporalPlot1, temporalPlot2] = plotyy(t, abs(Efield).^2, t, angleEfield);
		xlabel('time (s)')
        ylabel('normalized intensity (arb. units)')
        ylabel(temporalPlot(2), 'phase (rad)');
        %xlim([t(1) t(N)]);
        ylim(temporalPlot(1),[-0.1 1.1]);
        ylim(temporalPlot(2),[-5 5]);
        set(temporalPlot(2), 'YTick',-4:2:4)
		%hold(temporalPlot(1), 'on')
		hold(temporalPlot(2), 'on')
		temporalPlot3 = plot(t, polyval(temporalPhaseFit, t), 'r', 'Parent', temporalPlot(2));
        set(temporalPlot1,'Color','blue','LineWidth',2)
		set(temporalPlot2,'Color',[0 0.498 0],'LineWidth',2)
		set(temporalPlot3,'Color','red','LineWidth',1)
        title('retrieved temporal shape');
        hold off;
    subplot(2,2,4);
		[spectralPlot, spectralPlot1, spectralPlot2] = plotyy(frequency, abs(V).^2, frequency,angleV);
        xlabel('frequency - \omega_0 (rad/s)') 
        ylabel('normalized intensity (arb. units)')
        ylabel(spectralPlot(2), 'phase (rad)');
        %xlim([frequency(1) frequency(N)]);
        ylim(spectralPlot(1),[-0.1 1.1]);
        ylim(spectralPlot(2),[-5 5]);
        set(spectralPlot(2), 'YTick',-4:2:4)
		%hold(spectralPlot(1), 'on') %slows drawnow significantly down  
		hold(spectralPlot(2), 'on')
		spectralPlot3 = plot(frequency, polyval(spectralPhaseFit, frequency), 'r', 'Parent', spectralPlot(2));
        set(spectralPlot1,'Color','blue','LineWidth',2)
		set(spectralPlot2,'Color',[0 0.498 0],'LineWidth',2)
		set(spectralPlot3,'Color','red','LineWidth',1)
        title('retrieved spectral shape');
      
        hold off;
    
set(gcf, 'PaperSize', [40 30] , 'PaperPosition', [0 0 40 30]); 

%%


    eachFrogError(numberOfRun) = G;
    eachEfield(numberOfRun, :) = Efield;
end

%%
%spectrum = SpectrumAvantes('D:\Dropbox\Diploma Thesis\HCF FROG EXPERIMENTS\20130527-29 after HCF\2013-05-30--18-12-00 004_0705014U1.TXT');
%myfigure('CompareSpectrum');
%plotyy(frequency, abs(V).^2, spectrum.frequencydomain.frequency - 4e+14,spectrum.frequencydomain.intensity);



%%

[minimumfrogerror, indexofminimumfrogerror] = min(eachFrogError);
fprintf('************************************\n');
fprintf('Minimum Frog Error: %.3f%% \t Index: %d \n ', minimumfrogerror * 100, indexofminimumfrogerror);
previousBestEfield = eachEfield(indexofminimumfrogerror, :);
save('previousBestEfield.mat', 'previousBestEfield');



%%

%read seperately recorded spectrum
if(seperateSpectrumAvailable)
    load('lastSpectrumFilename.mat');
    if(spectrumFullFilename == 0) 
     spectrumFullFilename = pwd;
    end
    [spectrumFilename, spectrumDirectory] = uigetfile({'*.csv','Hamamatsu (*.csv)';'*.*',  'All files (*.*)'}, 'Select indepentend spectrum', spectrumFullFilename);
    spectrumFullFilename = fullfile(spectrumDirectory, spectrumFilename);
    
    save('lastSpectrumFilename.mat', 'spectrumFullFilename');
    
    spectrumIndependent = SpectrumHamamatsu(spectrumFullFilename);

    myFigure('compare retrieved and measured spectral intensity');
    plot(frequency + dataTransfer.finalFrog.frequencyOffset/2, abs(V).^2*1e14/trapz(frequency + dataTransfer.finalFrog.frequencyOffset/2,abs(V).^2), spectrumIndependent.frequencydomain.frequency,spectrumIndependent.frequencydomain.intensity*1e14/trapz(-spectrumIndependent.frequencydomain.frequency,spectrumIndependent.frequencydomain.intensity))
    legend('retrieved spectrum', 'measured spectrum');
    xlabel('Frequency (Hz)');
    ylabel('Spectral Intensity (arb. units)')
end

if(0)
    myFigure('original Frogtrace')
    imagesc(tau, frequency,IFrog, [0 1]);
    title('original Frogtrace')
    xlabel('delay') 
    ylabel('frequency')
    colormap(jet(256));

    myFigure('retrieved Frogtrace')
    imagesc(tau, frequency,abs(ICalc), [0 1]);
    title('retrieved Frogtrace');
    xlabel('delay') 
    ylabel('frequency')
    colormap(jet(256));
end


myFigure('Retrieved Spectrum')
		[spectralPlot, spectralPlot1, spectralPlot2] = plotyy(frequency, abs(V).^2, frequency,angleV);
        xlabel('frequency - \omega_0 (rad/s)') 
        ylabel('normalized intensity (arb. units)')
        ylabel(spectralPlot(2), 'phase (rad)');
        %xlim([frequency(1) frequency(N)]);
        ylim(spectralPlot(1),[-0.1 1.1]);
        ylim(spectralPlot(2),[-5 5]);
        xlim(spectralPlot(1), [-2e14 2e14])
        xlim(spectralPlot(2), [-2e14 2e14])
        set(spectralPlot(2), 'YTick',-4:2:4)
		%hold(spectralPlot(1), 'on') %slows drawnow significantly down  
		hold(spectralPlot(2), 'on')
		spectralPlot3 = plot(frequency, polyval(spectralPhaseFit, frequency), 'r', 'Parent', spectralPlot(2));
        set(spectralPlot1,'Color','blue','LineWidth',2)
		set(spectralPlot2,'Color',[0 0.498 0],'LineWidth',2)
		set(spectralPlot3,'Color','red','LineWidth',1)
        title('retrieved spectral shape');
        hold off;

fprintf('Total execution Time was %f s.\n', toc(tTotal));
%%

%% Optics Letter Figure
if(seperateSpectrumAvailable)
f = myFigure('Thesis Figure');
clf;
    colormap(ColorMaps.whiteJet(1024))
	%colormap([0 0 0.0;0 0 0.53125;0 0 0.546875;0 0 0.5625;0 0 0.578125;0 0 0.59375;0 0 0.609375;0 0 0.625;0 0 0.640625;0 0 0.65625;0 0 0.671875;0 0 0.6875;0 0 0.703125;0 0 0.71875;0 0 0.734375;0 0 0.75;0 0 0.765625;0 0 0.78125;0 0 0.796875;0 0 0.8125;0 0 0.828125;0 0 0.84375;0 0 0.859375;0 0 0.875;0 0 0.890625;0 0 0.90625;0 0 0.921875;0 0 0.9375;0 0 0.953125;0 0 0.96875;0 0 0.984375;0 0 1;0 0.015625 1;0 0.03125 1;0 0.046875 1;0 0.0625 1;0 0.078125 1;0 0.09375 1;0 0.109375 1;0 0.125 1;0 0.140625 1;0 0.15625 1;0 0.171875 1;0 0.1875 1;0 0.203125 1;0 0.21875 1;0 0.234375 1;0 0.25 1;0 0.265625 1;0 0.28125 1;0 0.296875 1;0 0.3125 1;0 0.328125 1;0 0.34375 1;0 0.359375 1;0 0.375 1;0 0.390625 1;0 0.40625 1;0 0.421875 1;0 0.4375 1;0 0.453125 1;0 0.46875 1;0 0.484375 1;0 0.5 1;0 0.515625 1;0 0.53125 1;0 0.546875 1;0 0.5625 1;0 0.578125 1;0 0.59375 1;0 0.609375 1;0 0.625 1;0 0.640625 1;0 0.65625 1;0 0.671875 1;0 0.6875 1;0 0.703125 1;0 0.71875 1;0 0.734375 1;0 0.75 1;0 0.765625 1;0 0.78125 1;0 0.796875 1;0 0.8125 1;0 0.828125 1;0 0.84375 1;0 0.859375 1;0 0.875 1;0 0.890625 1;0 0.90625 1;0 0.921875 1;0 0.9375 1;0 0.953125 1;0 0.96875 1;0 0.984375 1;0 1 1;0.015625 1 0.984375;0.03125 1 0.96875;0.046875 1 0.953125;0.0625 1 0.9375;0.078125 1 0.921875;0.09375 1 0.90625;0.109375 1 0.890625;0.125 1 0.875;0.140625 1 0.859375;0.15625 1 0.84375;0.171875 1 0.828125;0.1875 1 0.8125;0.203125 1 0.796875;0.21875 1 0.78125;0.234375 1 0.765625;0.25 1 0.75;0.265625 1 0.734375;0.28125 1 0.71875;0.296875 1 0.703125;0.3125 1 0.6875;0.328125 1 0.671875;0.34375 1 0.65625;0.359375 1 0.640625;0.375 1 0.625;0.390625 1 0.609375;0.40625 1 0.59375;0.421875 1 0.578125;0.4375 1 0.5625;0.453125 1 0.546875;0.46875 1 0.53125;0.484375 1 0.515625;0.5 1 0.5;0.515625 1 0.484375;0.53125 1 0.46875;0.546875 1 0.453125;0.5625 1 0.4375;0.578125 1 0.421875;0.59375 1 0.40625;0.609375 1 0.390625;0.625 1 0.375;0.640625 1 0.359375;0.65625 1 0.34375;0.671875 1 0.328125;0.6875 1 0.3125;0.703125 1 0.296875;0.71875 1 0.28125;0.734375 1 0.265625;0.75 1 0.25;0.765625 1 0.234375;0.78125 1 0.21875;0.796875 1 0.203125;0.8125 1 0.1875;0.828125 1 0.171875;0.84375 1 0.15625;0.859375 1 0.140625;0.875 1 0.125;0.890625 1 0.109375;0.90625 1 0.09375;0.921875 1 0.078125;0.9375 1 0.0625;0.953125 1 0.046875;0.96875 1 0.03125;0.984375 1 0.015625;1 1 0;1 0.984375 0;1 0.96875 0;1 0.953125 0;1 0.9375 0;1 0.921875 0;1 0.90625 0;1 0.890625 0;1 0.875 0;1 0.859375 0;1 0.84375 0;1 0.828125 0;1 0.8125 0;1 0.796875 0;1 0.78125 0;1 0.765625 0;1 0.75 0;1 0.734375 0;1 0.71875 0;1 0.703125 0;1 0.6875 0;1 0.671875 0;1 0.65625 0;1 0.640625 0;1 0.625 0;1 0.609375 0;1 0.59375 0;1 0.578125 0;1 0.5625 0;1 0.546875 0;1 0.53125 0;1 0.515625 0;1 0.5 0;1 0.484375 0;1 0.46875 0;1 0.453125 0;1 0.4375 0;1 0.421875 0;1 0.40625 0;1 0.390625 0;1 0.375 0;1 0.359375 0;1 0.34375 0;1 0.328125 0;1 0.3125 0;1 0.296875 0;1 0.28125 0;1 0.265625 0;1 0.25 0;1 0.234375 0;1 0.21875 0;1 0.203125 0;1 0.1875 0;1 0.171875 0;1 0.15625 0;1 0.140625 0;1 0.125 0;1 0.109375 0;1 0.09375 0;1 0.078125 0;1 0.0625 0;1 0.046875 0;1 0.03125 0;1 0.015625 0;1 0 0;0.984375 0 0;0.96875 0 0;0.953125 0 0;0.9375 0 0;0.921875 0 0;0.90625 0 0;0.890625 0 0;0.875 0 0;0.859375 0 0;0.84375 0 0;0.828125 0 0;0.8125 0 0;0.796875 0 0;0.78125 0 0;0.765625 0 0;0.75 0 0;0.734375 0 0;0.71875 0 0;0.703125 0 0;0.6875 0 0;0.671875 0 0;0.65625 0 0;0.640625 0 0;0.625 0 0;0.609375 0 0;0.59375 0 0;0.578125 0 0;0.5625 0 0;0.546875 0 0;0.53125 0 0;0.515625 0 0;0.5 0 0]);
        ax(1) = axes('Position',[0.075 0.6 0.35 0.35]);
        frog.recorded.wavelengthdomain.wavelength = c./(frequency + dataTransfer.finalFrog.frequencyOffset);
        frog.recorded.wavelengthdomain.delay = tau;
        frog.recorded.wavelengthdomain.intensity = IFrog .* repmat(c./frog.recorded.wavelengthdomain.wavelength'.^2, 1, length(frog.recorded.wavelengthdomain.delay ));
        goodIndizes = (frog.recorded.wavelengthdomain.wavelength < 800e-9 & frog.recorded.wavelengthdomain.wavelength > 150e-9);
        frog.recorded.wavelengthdomain.wavelength = frog.recorded.wavelengthdomain.wavelength(goodIndizes);
        frog.recorded.wavelengthdomain.delay = frog.recorded.wavelengthdomain.delay;
        frog.recorded.wavelengthdomain.intensity = normMax(frog.recorded.wavelengthdomain.intensity(goodIndizes,:));

        frog.recorded.evenlyspacedWavelengthdomain.wavelength = linspace(200, 800, 1024) * 1e-9;
        frog.recorded.evenlyspacedWavelengthdomain.delay = frog.recorded.wavelengthdomain.delay; 
        [Xq, Yq] = meshgrid(frog.recorded.evenlyspacedWavelengthdomain.delay, frog.recorded.evenlyspacedWavelengthdomain.wavelength);
        frog.recorded.evenlyspacedWavelengthdomain.intensity = interp2(frog.recorded.wavelengthdomain.delay, frog.recorded.wavelengthdomain.wavelength, frog.recorded.wavelengthdomain.intensity, Xq, Yq);
		originalTracePlot = imagesc(frog.recorded.evenlyspacedWavelengthdomain.delay * 1e15, frog.recorded.evenlyspacedWavelengthdomain.wavelength * 1e9,  frog.recorded.evenlyspacedWavelengthdomain.intensity  );
        set(gca,'ydir','normal');       
        
        
        
        %originalTracePlot = pcolor(frog.recorded.wavelengthdomain.delay * 1e15, frog.recorded.wavelengthdomain.wavelength * 1e9,  frog.recorded.wavelengthdomain.intensity  );
        shading flat;
		%originalTracePlot = imagesc(tau * 1e15, (frequency + dataTransfer.finalFrog.frequencyOffset)* 2*pi*1e-15,IFrog, [0 1]);
        xlabel('Delay (fs)');
           
        ylabel('Wavelength (nm)');
        title('Measured FROG Trace');
        set(gca, 'TickDir', 'in');
        set(ax(1) ,'box','on','color','none')
        cb = colorbar;
        cb.Position = ([0.925 0.6 0.02 0.35]);

        ax(2) = axes('Position',[0.575 0.6 0.35 0.35]);
        
        frog.retrieved.wavelengthdomain.wavelength = c./(frequency + dataTransfer.finalFrog.frequencyOffset);
        frog.retrieved.wavelengthdomain.delay = tau;
        frog.retrieved.wavelengthdomain.intensity = ICalc.intensity .* repmat(c./frog.retrieved.wavelengthdomain.wavelength'.^2, 1, length(frog.retrieved.wavelengthdomain.delay ));
        goodIndizes = (frog.retrieved.wavelengthdomain.wavelength < 800e-9 & frog.retrieved.wavelengthdomain.wavelength > 150e-9);
        frog.retrieved.wavelengthdomain.wavelength = frog.retrieved.wavelengthdomain.wavelength(goodIndizes);
        frog.retrieved.wavelengthdomain.delay = frog.retrieved.wavelengthdomain.delay;
        frog.retrieved.wavelengthdomain.intensity = normMax(frog.retrieved.wavelengthdomain.intensity(goodIndizes,:));
        frog.retrieved.wavelengthdomain.wavelength = flipdim(frog.retrieved.wavelengthdomain.wavelength,2);
        frog.retrieved.wavelengthdomain.intensity = flipdim(frog.retrieved.wavelengthdomain.intensity,1);
        
        frog.retrieved.evenlyspacedWavelengthdomain.wavelength = linspace(200, 800, 1024) * 1e-9;
        frog.retrieved.evenlyspacedWavelengthdomain.delay = frog.retrieved.wavelengthdomain.delay; 
        [Xq, Yq] = meshgrid(frog.retrieved.evenlyspacedWavelengthdomain.delay, frog.retrieved.evenlyspacedWavelengthdomain.wavelength);
        frog.retrieved.evenlyspacedWavelengthdomain.intensity = interp2(frog.retrieved.wavelengthdomain.delay, frog.retrieved.wavelengthdomain.wavelength, frog.retrieved.wavelengthdomain.intensity, Xq, Yq);
		retrievedTracePlot = imagesc(frog.retrieved.evenlyspacedWavelengthdomain.delay * 1e15, frog.retrieved.evenlyspacedWavelengthdomain.wavelength * 1e9,  frog.retrieved.evenlyspacedWavelengthdomain.intensity  );
        set(gca,'ydir','normal');
        xlabel('Delay (fs)');
        ylabel('Wavelength (nm)');
        title('Retrieved FROG Trace');
%        colorbar([0.9 0.6 0.02 0.35]);
%         s1Pos = get(ax(1),'position');
%         s2Pos = get(ax(2),'position');
%         s2Pos(3:4) = [s1Pos(3:4)];
%         set(ax(2),'position',s2Pos);     
        set(gca, 'TickDir', 'in');
        linkaxes([ax(1) ax(2)]);
        xlim([-65 65]);
        ylim([275 485 ]);
        set(ax(1),  'YTick',-300:50:450)
        set(ax(2),  'YTick',-300:50:450)
        set(ax(2) ,'box','on','color','none')

    
        ax(3) = axes('Position',[0.075 0.13 0.35 0.35]);
        axes('Position',get(gca,'Position'),'box','on','xtick',[],'ytick',[]);
        axes(ax(3))


		[temporalPlot, temporalPlot1, temporalPlot2] = plotyy(t * 1e15, abs(Efield).^2, t * 1e15, angleEfield);

		xlabel('Time (fs)')
        
        ylabel('Intensity (arb. units)')
        ylabel(temporalPlot(2), 'Phase (rad)');
        xlim(temporalPlot(1),[-14 25]);
        xlim(temporalPlot(2),[-14 25]);
        set(temporalPlot(1), 'XTick',-10:10:20)
        set(temporalPlot(2), 'XTick',-10:10:20)
        ylim(temporalPlot(1),[0 1.1]);
        ylim(temporalPlot(2),[-8 9.6]);
        set(temporalPlot(1), 'YTick',-0:0.2:1)
        set(temporalPlot(2), 'YTick',-8:4:8)
		%hold(temporalPlot(1), 'on')
		hold(temporalPlot(2), 'on')
        set(temporalPlot1,'LineStyle','-')
		set(temporalPlot2,'LineStyle','--')
        title('Retrieved Temporal Shape');
        hold off;
        set(temporalPlot(1), 'TickDir', 'out');
        set(temporalPlot(2), 'TickDir', 'out');
        set(ax(3),'box','off','color','none')

        
        ax(4) = axes('Position',[0.575 0.13 0.35 0.35]);
        axes('Position',get(gca,'Position'),'box','on','xtick',[],'ytick',[]);
        axes(ax(4))

        
    frog.wavelengthdomain.l = c./( (frequency + dataTransfer.finalFrog.frequencyOffset/2) );
    frog.wavelengthdomain.I = abs(V).^2 * c ./ (frog.wavelengthdomain.l.^2);
    frog.wavelengthdomain.phase =  angleV;
    goodIndizes = (frog.wavelengthdomain.l < 1500e-9 & frog.wavelengthdomain.l > 300e-9);
        
    frog.wavelengthdomain.I = frog.wavelengthdomain.I(goodIndizes);
    frog.wavelengthdomain.phase = frog.wavelengthdomain.phase(goodIndizes);
    frog.wavelengthdomain.l = frog.wavelengthdomain.l(goodIndizes);  %DO THIS LAST
    
    frog.wavelengthdomain.phase(frog.wavelengthdomain.I < 0.02 * max(frog.wavelengthdomain.I)) = NaN;
    frog.wavelengthdomain.I = frog.wavelengthdomain.I * 1.4024e-7 ./ -( trapz(frog.wavelengthdomain.l,frog.wavelengthdomain.I));
    
    
		[spectralPlot, spectralPlot1, spectralPlot2] = plotyy(frog.wavelengthdomain.l*1e9,frog.wavelengthdomain.I ,frog.wavelengthdomain.l*1e9, frog.wavelengthdomain.phase);
        
        xlabel('Wavelength (nm)') 
        ylabel('Intensity (arb. units)')
        ylabel(spectralPlot(2), 'Phase (rad)');
        xlim(spectralPlot(1),[500 1050]);
        xlim(spectralPlot(2),[500 1050]);
        ylim(spectralPlot(1),[-0.0 1.1]);
        ylim(spectralPlot(2),[-3.0 3.6]);
        set(spectralPlot(1), 'YTick',-0:0.2:1)
        set(spectralPlot(2), 'YTick',-3:1:3)
		
        hold(spectralPlot(1), 'on')
		spectralPlot3 = plot(spectrumIndependent.wavelengthdomain.wavelength * 1e9,spectrumIndependent.wavelengthdomain.intensity * 1.4024e-7 ./ trapz(spectrumIndependent.wavelengthdomain.wavelength,spectrumIndependent.wavelengthdomain.intensity), 'Parent', spectralPlot(1));
        %set(spectralPlot1,'Color','black')
		set(spectralPlot2,'LineStyle','--')
        set(spectralPlot3,'Color',Colors.loaGreen)
        title('Retrieved Spectral Shape');
        [h_legend hO] = legend('Retr. Int.', 'Meas. Int.', 'Retr. Phase', 'Location', 'NorthWest');
        hO(1).Position(1) = hO(1).Position(1) -0.15;
        hO(2).Position(1) = hO(2).Position(1) -0.15;
        hO(3).Position(1) = hO(3).Position(1) -0.15;
        hO(4).XData(2) = hO(4).XData(2)  * 0.6;
        hO(6).XData(2) = hO(6).XData(2)  * 0.6;
        hO(8).XData(2) = hO(8).XData(2)  * 0.6;
        h_legend.Box = 'off';
        %set(h_legend,'FontSize',10);
        
        
        uistack(spectralPlot3,'bottom')
        hold off;
        set(spectralPlot(1), 'TickDir', 'out');
        set(spectralPlot(2), 'TickDir', 'out');
        set(ax(4),'box','off','color','none')

        
        
        set(f, 'PaperSize', [20 15] , 'PaperPosition', [0 0 20 15] ); 
        %saveFigure(f, '2013-12-11--17-46-29 001j Retrieved Thesis');
end
