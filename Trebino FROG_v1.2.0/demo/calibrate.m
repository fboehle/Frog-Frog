function [output_name] = calibrate(source_name)
% calibrate.m
%
% This routine is design to create the .frg file from raw data. It loads
% the .mat file and create the .frg with the calibration factor as header.
% 
% See also: PG_XFROG, binner_cmd_demo, calibrate, qFROG_TX, frog_wtol_x,
% frog_wtol

% By Jeff Wong (GaTech) - 2011-08-12, 1530

% === START === 
fprintf(1,'Start Calibrating\n');

% Center Wavelength (nm)
lam = 800;
T1 = source_name;
temp_name = regexprep(source_name,'X', '');
evalin('base', sprintf('load %s', temp_name));
BG = 'BG';
A = evalin('base',sprintf('nonegatives(%s - %s_%s1- %s_%s2)', T1,T1,BG, T1,BG));
A = flipud(A);
A = A';
m = size(A);

% calibration factor: make sure you measure this correctly
% dt: fs/px
% dl: nm/px
dt = 3.5228129662;
dl = 0.0670592995;

% Create the .frg file
% The file contain header and the frog trace
% Header: 
% [width, height; time_calibration; wavelength_calibration; wavelength]
header1 = [m(2);m(1);dt;dl;lam];
output_name = sprintf('%s.frg',T1);
save(output_name ,'header1','-ASCII')
save(output_name,'A','-APPEND','-ASCII')
fprintf(1,'Saving the frog trace as: %s\n',output_name);

end