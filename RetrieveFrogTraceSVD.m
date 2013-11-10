%*********************************************************
%	Retrieve the original pulse from a Frogtrace with the SVD algorithm. 
%	
%	Developement started: end 2012
%	Author: Frederik Böhle code@fboehle.de
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

iterations = 500;
mov = 0;

numberOfRuns = 1;
usePreviousEfield = 0;


eachFrogError = zeros(numberOfRuns, 1);
eachEfield = zeros(numberOfRuns, N);
for numberOfRun = 1:numberOfRuns

%% read the Frog trace
IFrog = double(imread('generatedsheared.tif')) ;
%IFrog = IFrog + 0*random('Poisson',5,N,N) ;
IFrog = IFrog / max(max(IFrog));
sqrtIFrog = sqrt(IFrog);

%testspace***
%tToMove = -round(sum((1:N) .* abs(sum(IFrog,2)).^4)/sum(abs(sum(IFrog,2)).^4)-N/2); %weighted average to find center of peak
%IFrog = circshift(IFrog,[0 0]);
%IFrog = flipud(IFrog);
%testspace***



%% make a guess for the E Field; in this case, put random noise
Efield = random('Poisson',500,1,N) + 1i*random('Poisson',500,1,N);
Efield = Efield/max(Efield);
Egate = Efield ;

%% or use the efield from the previous run
if(usePreviousEfield)
load('previousBestEfield.mat');

Efield = previousBestEfield;
Egate = Efield ;
end

%%

tStart = tic


%% Loop!
for l = 1:iterations

    
    
%% In SHG Frog the gate is the Pulse itself


%% calculate the signal field
Esig = Efield.' * Egate + Egate.' * Efield;

%Esig=Esig-tril(Esig,-ceil(N/2))-triu(Esig,ceil(N/2));

Esig = Esig(indexforcircshift);


Esig = fliplr(fftshift(Esig,2));


%% calculate the theoretical Frog Trace
ICalcwphase = fftshift(fft((Esig),N,1),1);
ICalc = abs(ICalcwphase).^2;

if(~mod(l, mov))
myfigure('retrieved frogtrace')
imagesc(tau, frequency, abs(ICalc))
title('retrieved frogtrace')
colormap(jet(256));
end

%% calculate the Frog Error

mu = sum(sum(IFrog.*ICalc))/sum(sum(ICalc.^2));
G = 1/N * sqrt( sum(sum(  (IFrog - mu * ICalc).^2 )));
fprintf('Frog Error: %.3f%% \tIteration: %d \n', G * 100, l);
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


Efield = (outerProduct * outerProduct') * Efield.';
Egate = (outerProduct' * outerProduct) * Egate.';

Efield = Efield.' / max(abs(Efield));
Egate = conj(Egate.') / max(abs(Egate));

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

ICalc = ICalc/max(max(ICalc)); %this is actually only the result of the second to last run


%myfigure('retrieved Efield')
%plotyy(t, abs(Efield), t, unwrap((angle(Efield)-angle(Efield(N/2))) .* min(round(abs(Efield)*100),1)))
%title('retrieved Efield')




fwhmresult = fwhm(t, abs(Efield).^2);

V = fftshift(fft(ifftshift(Efield)));
V = V/max(abs(V));

myfigure('Esig')
imagesc(abs(Esig))
title('Esig')

myfigure('Retrieval Error')
    imagesc(ICalc - IFrog, [-0.1 0.1]);
    colorbar;
    
angleV = unwrap(angle(V));
angleV = angleV - angleV(N0);
angleEfield = unwrap(angle(Efield));
angleEfield = angleEfield - angleEfield(N0);







%% fit the phase



fitOrder = 4;
[borderLower, borderHigher] = findBorderIndex(abs(Efield).^2, 20);
temporalPhaseFit = polyfit(t(borderLower:borderHigher), angleEfield(borderLower:borderHigher), fitOrder);


[borderLower, borderHigher] = findBorderIndex(abs(V).^2, 20);
spectralPhaseFit = polyfit(frequency(borderLower:borderHigher), angleV(borderLower:borderHigher), fitOrder);

%% print DATA
fprintf('***********************************\n');
fprintf('Time for %d Iterations: %f s, that is %f s per iteration on average.\n',iterations, toc(tStart), toc(tStart)/iterations);
fprintf('Frog Error: %.3f%% \tIteration: %d \n', G * 100, l);
fprintf('FWHM: %.1f fs\n', fwhmresult / f);
fprintf('Second Order Temporal Chirp: %.3g fs^(-2)\n', temporalPhaseFit(fitOrder-1)*f^2);
fprintf('Second Order Dispersion: %.3g fs^2\n', spectralPhaseFit(fitOrder-1)/f^2*2/((2*pi)^2));
fprintf('Thirt Order Dispersion: %.3g fs^3\n', spectralPhaseFit(fitOrder-2)/f^3*6/((2*pi)^3));
fprintf('Fourth Order Dispersion: %.3g fs^4\n', spectralPhaseFit(fitOrder-3)/f^4*24/((2*pi)^4));

%% display always a positive second order chirp
if(spectralPhaseFit(fitOrder-1) < 0)
    angleV = - angleV;
    spectralPhaseFit = -spectralPhaseFit;
end


%% plot the data
   
myfigure('Frog Retrieval');
	colormap([0 0 0.515625;0 0 0.53125;0 0 0.546875;0 0 0.5625;0 0 0.578125;0 0 0.59375;0 0 0.609375;0 0 0.625;0 0 0.640625;0 0 0.65625;0 0 0.671875;0 0 0.6875;0 0 0.703125;0 0 0.71875;0 0 0.734375;0 0 0.75;0 0 0.765625;0 0 0.78125;0 0 0.796875;0 0 0.8125;0 0 0.828125;0 0 0.84375;0 0 0.859375;0 0 0.875;0 0 0.890625;0 0 0.90625;0 0 0.921875;0 0 0.9375;0 0 0.953125;0 0 0.96875;0 0 0.984375;0 0 1;0 0.015625 1;0 0.03125 1;0 0.046875 1;0 0.0625 1;0 0.078125 1;0 0.09375 1;0 0.109375 1;0 0.125 1;0 0.140625 1;0 0.15625 1;0 0.171875 1;0 0.1875 1;0 0.203125 1;0 0.21875 1;0 0.234375 1;0 0.25 1;0 0.265625 1;0 0.28125 1;0 0.296875 1;0 0.3125 1;0 0.328125 1;0 0.34375 1;0 0.359375 1;0 0.375 1;0 0.390625 1;0 0.40625 1;0 0.421875 1;0 0.4375 1;0 0.453125 1;0 0.46875 1;0 0.484375 1;0 0.5 1;0 0.515625 1;0 0.53125 1;0 0.546875 1;0 0.5625 1;0 0.578125 1;0 0.59375 1;0 0.609375 1;0 0.625 1;0 0.640625 1;0 0.65625 1;0 0.671875 1;0 0.6875 1;0 0.703125 1;0 0.71875 1;0 0.734375 1;0 0.75 1;0 0.765625 1;0 0.78125 1;0 0.796875 1;0 0.8125 1;0 0.828125 1;0 0.84375 1;0 0.859375 1;0 0.875 1;0 0.890625 1;0 0.90625 1;0 0.921875 1;0 0.9375 1;0 0.953125 1;0 0.96875 1;0 0.984375 1;0 1 1;0.015625 1 0.984375;0.03125 1 0.96875;0.046875 1 0.953125;0.0625 1 0.9375;0.078125 1 0.921875;0.09375 1 0.90625;0.109375 1 0.890625;0.125 1 0.875;0.140625 1 0.859375;0.15625 1 0.84375;0.171875 1 0.828125;0.1875 1 0.8125;0.203125 1 0.796875;0.21875 1 0.78125;0.234375 1 0.765625;0.25 1 0.75;0.265625 1 0.734375;0.28125 1 0.71875;0.296875 1 0.703125;0.3125 1 0.6875;0.328125 1 0.671875;0.34375 1 0.65625;0.359375 1 0.640625;0.375 1 0.625;0.390625 1 0.609375;0.40625 1 0.59375;0.421875 1 0.578125;0.4375 1 0.5625;0.453125 1 0.546875;0.46875 1 0.53125;0.484375 1 0.515625;0.5 1 0.5;0.515625 1 0.484375;0.53125 1 0.46875;0.546875 1 0.453125;0.5625 1 0.4375;0.578125 1 0.421875;0.59375 1 0.40625;0.609375 1 0.390625;0.625 1 0.375;0.640625 1 0.359375;0.65625 1 0.34375;0.671875 1 0.328125;0.6875 1 0.3125;0.703125 1 0.296875;0.71875 1 0.28125;0.734375 1 0.265625;0.75 1 0.25;0.765625 1 0.234375;0.78125 1 0.21875;0.796875 1 0.203125;0.8125 1 0.1875;0.828125 1 0.171875;0.84375 1 0.15625;0.859375 1 0.140625;0.875 1 0.125;0.890625 1 0.109375;0.90625 1 0.09375;0.921875 1 0.078125;0.9375 1 0.0625;0.953125 1 0.046875;0.96875 1 0.03125;0.984375 1 0.015625;1 1 0;1 0.984375 0;1 0.96875 0;1 0.953125 0;1 0.9375 0;1 0.921875 0;1 0.90625 0;1 0.890625 0;1 0.875 0;1 0.859375 0;1 0.84375 0;1 0.828125 0;1 0.8125 0;1 0.796875 0;1 0.78125 0;1 0.765625 0;1 0.75 0;1 0.734375 0;1 0.71875 0;1 0.703125 0;1 0.6875 0;1 0.671875 0;1 0.65625 0;1 0.640625 0;1 0.625 0;1 0.609375 0;1 0.59375 0;1 0.578125 0;1 0.5625 0;1 0.546875 0;1 0.53125 0;1 0.515625 0;1 0.5 0;1 0.484375 0;1 0.46875 0;1 0.453125 0;1 0.4375 0;1 0.421875 0;1 0.40625 0;1 0.390625 0;1 0.375 0;1 0.359375 0;1 0.34375 0;1 0.328125 0;1 0.3125 0;1 0.296875 0;1 0.28125 0;1 0.265625 0;1 0.25 0;1 0.234375 0;1 0.21875 0;1 0.203125 0;1 0.1875 0;1 0.171875 0;1 0.15625 0;1 0.140625 0;1 0.125 0;1 0.109375 0;1 0.09375 0;1 0.078125 0;1 0.0625 0;1 0.046875 0;1 0.03125 0;1 0.015625 0;1 0 0;0.984375 0 0;0.96875 0 0;0.953125 0 0;0.9375 0 0;0.921875 0 0;0.90625 0 0;0.890625 0 0;0.875 0 0;0.859375 0 0;0.84375 0 0;0.828125 0 0;0.8125 0 0;0.796875 0 0;0.78125 0 0;0.765625 0 0;0.75 0 0;0.734375 0 0;0.71875 0 0;0.703125 0 0;0.6875 0 0;0.671875 0 0;0.65625 0 0;0.640625 0 0;0.625 0 0;0.609375 0 0;0.59375 0 0;0.578125 0 0;0.5625 0 0;0.546875 0 0;0.53125 0 0;0.515625 0 0;0.972549021244049 0.972549021244049 0.972549021244049]);
	ax(1) = subplot(2,2,1);
		originalTracePlot = imagesc(tau * 1e15, frequency,IFrog, [0 1]);
        xlabel('delay (fs)');
        ylabel('frequency - \omega_0 (rad/s)');
        title('original FROG trace');
    ax(2) = subplot(2,2,2);
		retrievedTracePlot = imagesc(tau * 1e15, frequency,abs(ICalc), [0 1]);
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

    eachFrogError(numberOfRun) = G;
    eachEfield(numberOfRun, :) = Efield;
end

%%
spectrum = SpectrumAvantes('D:\Dropbox\Diploma Thesis\HCF FROG EXPERIMENTS\20130527-29 after HCF\2013-05-30--18-12-00 004_0705014U1.TXT');
myfigure('CompareSpectrum');
plotyy(frequency, abs(V).^2, spectrum.frequencydomain.frequency - 4e+14,spectrum.frequencydomain.intensity);



%%

[minimumfrogerror, indexofminimumfrogerror] = min(eachFrogError);
fprintf('************************************\n');
fprintf('Minimum Frog Error: %.3f%% \t Index: %d \n ', minimumfrogerror * 100, indexofminimumfrogerror);
previousBestEfield = eachEfield(indexofminimumfrogerror, :);
save('previousBestEfield.mat', 'previousBestEfield');



%%

if(0)
myfigure('original Frogtrace')
imagesc(tau, frequency,IFrog, [0 1]);
title('original Frogtrace')
xlabel('delay') 
ylabel('frequency')
colormap(jet(256));

myfigure('retrieved Frogtrace')
imagesc(tau, frequency,abs(ICalc), [0 1]);
title('retrieved Frogtrace');
xlabel('delay') 
ylabel('frequency')
colormap(jet(256));
end

fprintf('Total execution Time was %f s.\n', toc(tTotal));
%%
datafororigin = zeros(N, 6);
datafororigin(:,1) = t;
datafororigin(:,2) = abs(Efield).^2.';
datafororigin(:,3) = angleEfield.';
datafororigin(:,4) = frequency;
datafororigin(:,5) = abs(V).^2.';
datafororigin(:,6) = angleV.';