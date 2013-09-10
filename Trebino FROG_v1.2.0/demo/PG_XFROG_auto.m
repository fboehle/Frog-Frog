% PG_XFROG_auto.m
%
% This is a routine that load, calibrate, bin and retrieve the traces.
% Please change the binning parameter according to your needs.
%
% See also: PG_XFROG, binner_cmd_demo, calibrate, qFROG_TX, frog_wtol_x,
% frog_wtol

% By Jeff Wong (GaTech) - 2012-02-19, 2352

% === START === 
for width = 100
    
    % Grid size, 2^N will work. For nice Gaussian from oscillator output,
    % 128, 256 should be enough. For higher TBP pulse, 512 or higher may be
    % rerquired
    sz = 2^9; 
    
    % Sample data provided here. 
    input_name = 'X120522_1';
    
    close all
    
    % Take raw data recorded from camera and add in the calibration number
    % to make the .frg file. 
    [name_800] = calibrate(input_name);
    
    % Bin the trace so that the trace satisfy the Fourier transformation
    % relationship. 
    % sz is the grid size
    % width is the width occupied by your data
    % m is the method, 1: fit delay, 2: fit wavelength
    name_800_bin = binner_cmd(name_800, 'sz',sz,'width',width,'m',1);
    
    % Retreival goes here. Second input argument define the initial guess,
    % 0: UI input, 1: Gaussian, 2: Random
    PG_XFROG(name_800_bin,2);
end