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

lambdalines = [302.2,312.6,334.0, 365.0,404.7,435.8] * 1e-9; %with additional 334nm line
lambdapixel = [258,361,497,693,946,1144];
delayfromposition = ([45.9,37.1,59.2,57.1,51.6,48.1,43.0,40.1,37.5,47.6] * 1e-6 ) * 2 / Phys.c; 
delaypixel = [519,713,224,269,394,470,581,646,702,483];


wavelengthFit = polyfit(lambdapixel,lambdalines,1); %the spectrometer has a linear relation between the pixel and the wavelength
ccd_wavelength = polyval(wavelengthFit, pixell);

ccd_frequency  = Phys.c ./ polyval(wavelengthFit, pixell);
ccd_frequencyRange = ccd_frequency(length(ccd_frequency)) - ccd_frequency(1);


delayFit = polyfit(delaypixel, delayfromposition, 1);
delayFitVal = polyval(delayFit, pixelt);

ccd_dt = delayFit(1);
ccd_delay = (-(length(pixelt)/2)*ccd_dt:ccd_dt:(length(pixelt)/2 - 1) * ccd_dt);
ccd_delayRange = ccd_delay(length(ccd_delay)) - ccd_delay(1);

if(0)
    calibrationFileName = 'Calibrations/20130529-2.mat';
    if(exist(fullfile(cd, calibrationFileName), 'file') == 2)
        error('!!!File already exists!!!')
    else
        save(fullfile(cd, calibrationFileName), 'lambdalines', 'lambdapixel', 'delayfromposition', 'delaypixel', 'ccd_wavelength', 'ccd_frequency', 'ccd_frequencyRange', 'ccd_delay', 'ccd_delayRange');
    end
end
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
break;
myfigure('Calibrated Frogtrace');
surf( ccd_delay * 1e15 ,ccd_wavelength * 1e9, frogRaw, frogRaw);
colormap(mycolormap);

title('Calibrated Frogtrace')
ylabel('Wavelength (nm)');
xlabel('delay (fs)');
