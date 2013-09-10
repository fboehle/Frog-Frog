function [pix,I] = load_instaspec_asc(filename,replace_method)
% LOAD_INSTASPEC_ASC Loads InstaSpec spectra exported as ASCII files.
%
%   [PIX,I] = LOAD_INSTASPEC_ASC(FILENAME,REPLACE_METHOD) loads the spectrum
%   exported as an ASCII file from the InstaSpec software. PIX is the array of
%   pixel numbers, and I is the array of the intensity counts.
%
%   The input file can also be a .DAT file saved by lambda-commander.vi.
%
%   REPLACE_METHOD is one of the following: 'none', 'NaN', 'interp'. 'none'
%   has no effect on I, 'NaN' replaces known bad photodetectors with NaN,
%   and 'interp' replaces them with interpolated values.
%%% begin skeleton 
	version = '$Id: load_instaspec_asc.m,v 1.1 2006-11-11 00:15:35 pablo Exp $'; 
	disp(version);
	% Units
	cm = 1e-2;
	mm = 1e-3;
	um = 1e-6;
	nm = 1e-9;
	fs = 1e-15;
	THz = 1e12; 
	% Constants
	c = 3e8; % speed of light
%%% end skeleton
% Update this list with known bad photodetectors:
bad_photodetectors = [1 7 8 9 10 11 12 93 94 196 198 199];
%%% Code starts here
file_data = load(filename);
if (size(file_data,2) == 1)
    disp('This looks like a .DAT file from lamba-commander.vi.');
    I = file_data(:,1);
    disp('Creating the pixel array.');
    pix = [1:length(I)]; % re-construct the pixel array    
else % trust the user this is an .ASC file from InstaSpec
    pix = file_data(:,1);
    I = file_data(:,2);
end
switch (lower(replace_method))
    case 'none'
        ; % do nothing
        
    case 'nan'
        disp('Replacing known bad photodetectors values by NaN.');
        bad_photodetectors % no semicolon, so that the array is displayed
        I(bad_photodetectors) = NaN;
    
    case 'interp'
        disp('Replacing known bad photodetectors values by linearly interpolated values.');
        bad_photodetectors % no semicolon, so that the array is displayed
        % Remove corresponding values so that the interpolation function
        % doesn't rely on them!
        deleted_I = I;
        deleted_I(bad_photodetectors) = [];
        deleted_pix = pix;
        deleted_pix(bad_photodetectors) = [];
        
        I(bad_photodetectors) = interp1(deleted_pix,deleted_I,bad_photodetectors);
        
        % The first and last element might have been replaced by NaN
        % because interpolation was not possible -- delete them if that's
        % the case.
        
        NaN_indices = find(isnan(I));
        
        if(NaN_indices) % there are some NaN in I
            disp('Some pixel values were replaced by NaN during the interpolation.');
            NaN_indices % no semicolon for display
            I(NaN_indices) = [];
            pix(NaN_indices) = [];
            disp('They have been removed.');
        end
            
        
    otherwise
        printf('Sorry, %s is not a valid method.  Here is the help section:\n', replace_method);
        help load_instaspec_asc;
end % switch
disp('Done.');
