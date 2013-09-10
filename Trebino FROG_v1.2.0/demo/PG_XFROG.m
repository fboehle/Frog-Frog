function PG_XFROG(frog1, guess_flag)
% PG_XFROG.m
%
% This is an script for the automated retrieval process. This example is a
% PG XFROG problem, with a measured gate from a GRENOUILLE 8-50. If PG FROG
% is being used, simply change the gate pulse to itself. Of course, another
% geometry will also have to change the form of the gate, and the FROG
% algorithm that the program call. 
%
% See also: PG_XFROG, binner_cmd_demo, calibrate, qFROG_TX, frog_wtol_x,
% frog_wtol

% By Jeff Wong (GaTech) - 2011-08-09, 2022

% === START === 
warning off
fprintf(1,'Start PG XFROG\n');


% Find the name of measurement made by GRENOUILLE
gren_name = regexp(frog1, '_', 'split');
gren_dir = gren_name{2};

temp_cmd = sprintf('dir(''%s/*Temporal*'')',gren_dir);
temp_list = evalin('base',temp_cmd);
gren_path = sprintf('%s/%s', gren_dir, temp_list.name);


clear gren_name gren_dir temp_cmd temp_list
if nargin == 1
    guess_flag = 0;
end

if strcmpi(frog1,'')
    % Load trace1 from GUI
    [Asig1,tau1,freq1,dtau1,f01,df1,NumD1,NumL1,filename1] = frogload();
else
    [Asig1,tau1,freq1,dtau1,f01,df1,NumD1,NumL1,filename1] = frogload(frog1,'delay');
end

% Start timer
tic;

% Initialize constant
w1=2*pi*freq1;
N = length(tau1);
G1 = Inf;
Et1B = [];

% BG Substraction, aggressive BG substraction may result in non-physical
% trace that the algorithm can not retrieve. 
Asig1 = Asig1 - 0.008;
Asig1 = nonegatives(Asig1);

% Take the square root of Asig for Magnitude Repel
Asig1 = sqrt(Asig1);


%% Define the initial guess method
dt1 = mean(diff(tau1));
lam01 = ltow(w1);

% UI input if input method is not provided from the parent. 
method = {'Gaussian', 'Random'};
if ~(guess_flag)
    fprintf(1,'Please select initial guess from menu...\n')
    guess_flag = menu('Select Initial Guess','Gaussian', 'Random');
end
fprintf(1,'Using method: %s\n', method{guess_flag});

% Choose between Gaussian and Random. Modification can be made if you have
% other perferences.
switch guess_flag
    case 1
        % Start with Gaussian
        [Et1,t1, Ewdum,wdum]=PULSEGENERATOR(N, @fgaussian, 75, dt1, lam01, [0], 0, [0,0,0]);
    case 2
        % Start with Random
        [Et1,t1, Ewdum,wdum]=PULSEGENERATOR(N, @rand, 75, dt1, lam01, [0], 0, [0,0,0]);
end


%% Read the GATE Pulse from GRENOUILLE
% Only required because this is a XFROG example. Ignore this part if you
% are working with normal FROG. You do NOT have a known gate pulse if working
% with normal FROG. 
[t_x, Et_i,Et_p] = readqfrog(gren_path);
Et2 = sqrt(Et_i) .* exp (1i * Et_p);

% Find range of GREN time-axis
N = floor(max(t_x) / dtau1);
t_x_new = (-N:N)*dtau1;

% Resample the GREN
Et2_new = interp1(t_x, Et2, t_x_new, 'cubic');

% Pad zeros, so that they have the same length
Et2_new = padarray(Et2_new, [0, round((length(tau1)-length(t_x_new))/2)]);
if (length(Et2_new) > length(tau1))
    Et2_new(end) = [];
else
    Et2_new(end+1) = 0;
end

% Rename and clean up variables
Et2 = Et2_new;
clear Et2_new t_x_new;

% Plotting, optional. To check the gate pulse is not under-sample
figure;
plot(tau1, abs(Et2).^2);

clear Ewdum wdum
Et2 = center(Et2,'max');

%% Retrieval 
% Define the gate (it is known in this example), PG geometry is used here, 
% and therefore using |E|^2

% Change the gate according to your system. 
Gate = quickscale(MagSq(Et2));

% The retrieval algorithm goes here. Change accordingly. 
[Et1B, Et1, Esig1, G1, Z1, EW1] = qFROG_TX(Asig1, Et1, tau1, w1, w1, Gate, G1, Et1B);
% Finish the retrieval problem. 
% Et1B is the output will be used later on. 


%% Plotting
% Generate the retrieved FROG trace
Ew1B = fftc(Et1B);
Asig1 = Asig1.^2;
Asig1r = abs(fft_FROG(CalcEsig(Et1B,quickscale(abs(Et2).^2),1))).^2;

% Convert all the FROG trace from angular frequency to wavelength
frog_wtol_x;

% Plot 
figure;plot(t1, quickscale(abs(Et1B)));title('Temporal 1');
figure;plot(lam, quickscale(abs((ELam1B))).^2);title('Spectral 1');


%% Save output
out_name = 'output.mat';
TBP1 = calcTBPrms(Et1B,t1,Ew1B,w1);

save(out_name)
fprintf(1, 'Save output as %s\n', out_name);
fprintf(1, 'G1: %e\n', G1);
fprintf(1, 'TBP1: %f\n', TBP1);

% Stop timmer
toc

%Delete the source file after recording
% delete(filename1);


end