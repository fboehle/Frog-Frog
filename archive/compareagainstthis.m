
%% read the Frog trace
IFrog = double(imread('generated.tif')) ;
IFrog = IFrog / max(max(IFrog));
sqrtIFrog = sqrt(IFrog);


%% Loop!
for l = 1:iterations
mov = 0;
    
    
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
