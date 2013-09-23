%*********************************************************
%	TEST Script Retrieve the original pulse from a Frogtrace in the radial 
%   frequency domain 
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

f = 10^(-15);
n = 10^(-9);
c = 300000000;

N = 256;
delayRange = 350;
dt = delayRange/N*f;
t = (-(N)/2:(N)/2-1)*dt;
dOmega = 2 * pi * 1/(dt*N);
omega = (-N/2:N/2-1) * dOmega;




%% create index for the circshift
p = 1:N;
q = 1:N;
[P, Q] = ndgrid(p, q);
Q = Q -1;
k = 0:(N-1);
K = repmat(k(:), [1 N]);
Q = 1+mod(Q+K, N);
indexforcircshift = sub2ind([N N], P, Q);

p = 1:N;
q = 1:N;
[P, Q] = ndgrid(p, q);
Q = Q -1;
k = 0:(N-1);
K = -repmat(k(:), [1 N]);
Q = (1+mod(Q+K, N));
indexforcircshiftback = sub2ind([N N], P, Q);

%% read the Frog trace
IFrog = double(imread('generated.tif')) ;
IFrog = IFrog + 0*random('Poisson',5,N,N) ;
IFrog = IFrog / max(max(IFrog));
sqrtIFrog = sqrt(IFrog);

%testspace***
%tToMove = -round(sum((1:N) .* abs(sum(IFrog,2)).^4)/sum(abs(sum(IFrog,2)).^4)-N/2); %weighted average to find center of peak
IFrog = circshift(IFrog,[0 0]);
%IFrog = flipud(IFrog);
%testspace***

figure(4);
imagesc(t, omega, IFrog)
colormap(jet(256));
title('Original Frog')

%% make a guess for the E Field; in this case, put random noise
Efield = random('Poisson',50,1,N) + 1i*random('Poisson',50,1,N);
Efield = Efield/max(Efield);
Egate = Efield ;

figure(1);
plotyy(t, abs(Efield), t, angle(Efield) .* min(round(abs(Efield)*100),1))
title('retrieved Efield')

tStart = tic

mov = 0;

%% Loop!
for l = 1:100

    
    
%% In SHG Frog the gate is the Pulse itself


%% calculate the signal field
Esig = Efield.' * Egate + Egate.' * Efield;

%Esig=Esig-tril(Esig,-ceil(N/2))-triu(Esig,ceil(N/2));

Esig = Esig(indexforcircshift);


Esig = fliplr(fftshift(Esig,2));


%% calculate the theoretical Frog Trace
ICalcwphase = fftshift(fft((Esig),N,1),1);
ICalc = abs(ICalcwphase).^2;

if(mov)
figure(2);
imagesc(t, omega, abs(ICalc))
title('retrieved Frog Trace')
colormap(jet(256));
end

%% calculate the Frog Error

mu = sum(sum(IFrog.*ICalc))/sum(sum(ICalc.^2));
G = 1/N * sqrt( sum(sum(  (IFrog - mu * ICalc).^2 )))
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

if(mov)
figure(3);
imagesc(abs(Esig))
title('Esig')
end


%% SVD algorithm
% get back to the outer-product

outerProduct = ifftshift(fliplr(Esig), 2);

%for m = 1:N
%    outerProduct(m,:) = circshift(outerProduct(m,:), [0 m-1]);
%end
outerProduct = outerProduct(indexforcircshiftback);


Efield = (outerProduct * outerProduct') * Efield.';
Egate = (outerProduct' * outerProduct) * Egate.';

Efield = Efield.' / max(abs(Efield));
Egate = conj(Egate.') / max(abs(Egate));

tToMove = -round(sum((1:N) .* abs(Efield).^4)/sum(abs(Efield).^4)-N/2); %weighted average to find center of peak
Efield = circshift(Efield,[0 tToMove]);
Egate = circshift(Egate,[0 tToMove]);

if(mov)
figure(1);
plotyy( t, abs(Efield), t, unwrap(angle(Efield) .* min(round(abs(Efield)*30),1)))
title('retrieved Efield')
end

%% fit
% for fitting one need the Curve Fitting Toolbox
%Efieldfit = fit(t, abs(Efield), 'gauss1');


end

toc(tStart)
figure(1);
plotyy(t, abs(Efield), t, unwrap(angle(Efield) .* min(round(abs(Efield)*1000),1)))
title('retrieved Efield')


V = fftshift(fft(ifftshift(Efield)));

figure(11);
plotyy(omega, abs(V), omega, angle(V) )
title('retrieved spectrum')


figure(2);
imagesc(t, omega, abs(ICalc))
colormap(jet(256));
title('retrieved Frog Trace')

figure(3);
imagesc(abs(Esig))
title('Esig')

