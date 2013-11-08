%*********************************************************
%	Calibrate the Frog from recorded traces
%	
%	Developement started: 11/2013
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

setup; %initilized values


load('lastDir.mat');
if(frogRawDIRname == 0) 
    frogRawDIRname = pwd;
end
[frogRawFilename, frogRawDIRname] = uigetfile('*.frogtrace', 'Select the raw FROG trace', frogRawDIRname);
fprintf('Filename: %s \n', frogRawFilename);
save('lastDir.mat', 'frogRawDIRname');
frogRawFullFilename = fullfile(frogRawDIRname, frogRawFilename);
frogRawFileID = fopen(frogRawFullFilename, 'r');
if frogRawFileID == -1
    fprintf('*****File not found*****\n');
    break;
end;
frogRaw = fread(frogRawFileID, [1376, 1035], 'uint8');
fclose(frogRawFileID);
    
dimensionL = 1376;
dimensionT = 1035;

pixell = 1:dimensionL;
pixelt = 1:dimensionT;

myfigure('Raw Frogtrace');
imagesc( pixelt,pixell, frogRaw);
title('Raw Frogtrace')
ylabel('Wavelength (pixel)');
xlabel('delay (pixel)');
colormap(mycolormap);


lambdalines = [302,313,365,405,436] * 1e-9;
lambdapixel = [241,344,676,930,1128];
delayfromposition = (-[ 153.6, 145.8, 134.7, 119.6, 104.7, 94.3, 84.3] * 1e-6 ) * 2 / Phys.c + 800e-15; 
delaypixel = [986,888,736,527,331,191,59];


wavelengthFit = polyfit(lambdapixel,lambdalines,1); %the spectrometer has a linear relation between the pixel and the wavelength
ccd_wavelength = polyval(wavelengthFit, pixell);

ccd_frequency  = Phys.c ./ polyval(wavelengthFit, pixell);
ccd_frequencyRange = ccd_frequency(length(ccd_frequency)) - ccd_frequency(1);


delayFit = polyfit(delaypixel, delayfromposition, 1);
delayFitVal = polyval(delayFit, pixelt);

ccd_dt = delayFit(1);
ccd_delay = (-(length(pixelt)/2)*ccd_dt:ccd_dt:(length(pixelt)/2 - 1) * ccd_dt);
ccd_delayRange = ccd_delay(length(ccd_delay)) - ccd_delay(1);

save('Calibrations/20130214.mat', 'lambdalines', 'lambdapixel', 'delayfromposition', 'delaypixel', 'ccd_wavelength', 'ccd_frequency', 'ccd_frequencyRange', 'ccd_delay', 'ccd_delayRange');

%%
myfigure('calibration of spectrometer')
scatter(lambdapixel, lambdalines * 1e9, 'd', 'markerFaceColor', 'b');
hold all;
plot(pixell, ccd_wavelength * 1e9);
hold off;
title('Calibration of Spectrometer');
xlabel('CCD pixel');
ylabel('Wavelength (nm)');
legend('Calibration Wavelength', 'linear fit', 'Location', 'northwest');

%saveFigure(gcf, 'spectrometerCalibration');


%%

myfigure('calibration of delay');

title('Calibration of Delay');
scatter(delaypixel, delayfromposition * 1e15, 'd', 'markerFaceColor', 'b');
hold all;
plot(pixelt, delayFitVal * 1e15);
hold off;
xlabel('CCD pixel');
ylabel('Delay (fs)');
legend('Delay Induced by Translation', 'linear fit', 'Location', 'northeast');

%saveFigure(gcf, 'delayCalibration');


%%

myfigure('Calibrated Frogtrace');
contour( ccd_delay * 1e15 ,ccd_wavelength * 1e9, frogRaw);
title('Calibrated Frogtrace')
ylabel('Wavelength (nm)');
xlabel('delay (fs)');
