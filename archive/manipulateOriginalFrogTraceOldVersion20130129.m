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
%       the camera has a timespan from -100fs until 100fs: bandwidth 200fs
%       and a frequency range from about 
%
%   Changelog:
%
%*********************************************************

clear all

f = 10^(-15);
n = 10^(-9);
c = 300000000;
T = 10^(12);

N = 256;
dt = 300/N*f;
t = (-(N)/2:(N)/2-1)*dt;
dtau = dt;
tau = t;
dw = 1/(dt*N);
w = (-N/2:N/2-1) * dw;

frog = double(imread('afterXPW_2.bmp')');


lambdalines = [280,312,323,375,414,446,473] * n;
calibrationpixels = [1,393,566,946,1134,1246,1376]
frequencylines = c ./ lambdalines;
pixell = [1:1376]
fit = polyfit(calibrationpixels,frequencylines,3)
frequencyfit = polyval(fit, pixell);

pixelt = [1:1035]
ccddt = 0.2 * f;
timefit = (-(length(pixelt)/2)*ccddt:ccddt:(length(pixelt)/2 - 1)*ccddt);

timerange = t(N) - t(1);
frequencyrange = w(N) - w(1)



figure(1)
%contourf(pixelt,frequencyfit, frog)

figure(2)
plot(calibrationpixels, frequencylines, pixell, frequencyfit);


frogint = interp1(frequencyfit, frog, w + 890*T);
frogint(isnan(frogint)) = 0;

frogint = frogint.';
frogint = interp1(timefit, frogint, t - t(N/2 + 5));
frogint = frogint.';
frogint(isnan(frogint)) = 0;

figure(5)
imagesc(t, w,frogint)
colorbar
colormap(jet(256))

saveimagedata = uint16(frogint/max(max(frogint))*65000);
imwrite(saveimagedata, 'generated.tif', 'tif')