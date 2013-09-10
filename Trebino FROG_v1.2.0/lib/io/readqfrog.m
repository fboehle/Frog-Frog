function [x, I, p, E] = readqfrog(filename)
% Read the spectrum from data taken from QuickFROG in frequency domain
%


%% ==Start==
% Initialize variable
x = [];
I = [];
p = [];
E = [];

if nargin == 0
    [fname,pname,findex] = uigetfile('*.dat','QuickFROG data');
    filename = [pname,fname];
else
    fprintf(1, 'User input: %s\n', filename);
end

fprintf(1,'Reading FROG spectrum from %s......\n', filename);

% Read the spectrum file and create the file handler
fid = fopen(filename , 'r');

flag = 0;
% Check if the file is read correctly
if (fid ~= -1)
    flag = 1;
else
    fprintf(1,'Error in reading file, please check the filename or premission.\n');
    return;
end

% If reading file is good, continue by dumping all the headers
if (flag)
    
    % EOF checking and line counts checking, if number of line does not
    % match with recorded in the header, warn the user
    while ~(feof(fid))
        % Reading out the data
        temp = fgetl(fid);
        if ~isempty(temp)
            temp = regexp(temp, '[\s]', 'split');
%             temp{1)
            % freq = str2double(temp{1});
            wavelength = str2double(temp{1});
            intensity = str2double(temp{2});
            phase = str2double(temp{3});
            Efield = str2double(temp{4}) + 1i * str2double(temp{5});
            x = [x wavelength];
            I = [I intensity];
            p = [p phase];
            E = [E Efield];
        end
    end
end

% figure;
% [ax, h1,h2] = plotyy(frog.wavelength, frog.intensity,  frog.wavelength, frog.phase);

% Close the file handler
fprintf(1,' done. \n');
fclose(fid);
end
%% ==EOF==