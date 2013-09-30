%*********************************************************
%	Convert the frog camera image to a calibrated frogtrace
%	
%	Developement started: end 2012
%	Author: Frederik Böhle code@fboehle.de
%
%*********************************************************
%   
%   Description: 
%
%   Notes:
%       Mistake inside this code!
%
%       the camera has a timespan from -100fs until 100fs: bandwidth 200fs
%       and a frequency range from about 
%
%   Changelog:
%
%*********************************************************

clear all

f = 10^(-15);
n = 10^(-9);
u = 10^(-6);
c = 300000000;
T = 10^(12);

N = 512;
dt = 750/N*f;
t = (-(N)/2:(N)/2-1)*dt;
dw = 1/(dt*N);
w = (-N/2:N/2-1) * dw;

frog = double(imread('2013-02-14--15-48-32_visually_best_compression.tif')' -10);
frog = imrotate(frog, 1, 'bilinear','crop');

tToMove = -round(sum((1:1035) .* abs(sum(frog)).^2)/sum(abs(sum(frog)).^2)-1035/2); %weighted average to find center of peak
frog = circshift(frog,[0 tToMove]);
tToMove = -round(sum((1:1376).' .* abs(sum(frog,2)).^2)/sum(abs(sum(frog,2)).^2)-1376/2); %weighted average to find center of peak
frog = circshift(frog,[tToMove 0]);

lambdalines = [302,313,365,405,436] * n;
lambdapixel = [245,352,680,934,1130];
frequencylines = c ./ lambdalines;
pixell = 1:1376;
fitL = polyfit(lambdapixel,frequencylines,1);
frequencyfit = polyval(fitL, pixell);

pixelt = 1:1035;
delayfromposition = (-[-153.6,-145.8,-134.7,-119.6,-104.7,-94.3,-84.3] - 100) * u * 2 / c; 
delaypixel = [983,883,731,526,329,190,56];
fitT = polyfit(delaypixel, delayfromposition, 1);
delayfit = polyval(fitT, pixelt);

figure(2)
plot(delaypixel, delayfromposition, pixelt, delayfit);

ccddt = fitT(1);
timefit = (-(length(pixelt)/2)*ccddt:ccddt:(length(pixelt)/2 - 1)*ccddt);

timerange = t(N) - t(1);
frequencyrange = w(N) - w(1);



%figure(1)
%contourf(pixelt,frequencyfit, frog)

figure(2)
plot(lambdapixel, frequencylines, pixell, frequencyfit);

N10 = 10*N;
t10 = (-(N10)/2:(N10)/2-1)*dt/10;
w10 = (-N10/2:N10/2-1) * dw/10;

frogint = interp1(frequencyfit, frog, w10 + frequencyfit(length(pixell)/2));
frogint(isnan(frogint)) = 0;

frogint = frogint.';
frogint = interp1(timefit, frogint, t10);
frogint = frogint.';
frogint(isnan(frogint)) = 0;
tic;
frogint2 = zeros(N,N10);
for k = 1:N10
frogint2(:,k) = decimate(frogint(:,k), 10);
end
frogint3 = zeros(N,N);
for k = 1:N
frogint3(k,:) = decimate(frogint2(k,:), 10);
end
toc
figure(3)
imagesc(t, w,frogint)
colormap(jet(256));
colorbar

figure(4)
imagesc(frogint3)
colormap(jet(256));
colorbar

saveimagedata = uint16(frogint3/max(max(frogint3))*65000);
imwrite(saveimagedata, 'generated.tif', 'tif')