function Test_QuickFROG(varargin)
% Testing QuickFROG
% This file is written to test the Matlab environment to make sure all the
% necessary files to run the FROG algorithm are present. Please follow the
% readme file in the home directory if errors show up in test run.

close all
N = 128;
dt = 4;
domain = 1;
plse = 1;
err = 0.0;

[N, dt, domain, plse, err] = parsevarargin(varargin, N, dt, domain, plse, err);

% Pulse Generation 
switch plse
    case 1
        [Et0, t, Ew0, w] = pulsegenerator(N, @fgaussian, 20, dt, 800,[],0,[]);
    case 2
        [Et0, t, Ew0, w] = pulsegenerator(N, @fgaussian, 20, dt, 800,[],0,-[0, 0, 0, 600, 400]);
    case 3
        [Et0, t, Ew0, w] = pulsegenerator(N, @fgaussian, 20, dt, 800,[],0,-[0, 0, 0, 300]);
    case 4
        [Et0, t, Ew0, w] = pulsegenerator(N, @fgaussian, 20, dt, 800,[],0,-[0, 0, 0, 600, 400]);
        Et0 = Et0 + circshift(Et0, [0,20]);
    case 5
        [Et0, t, Ew0, w] = pulsegenerator(N, @fgaussian, 20, dt, 800,[],0,-[0, 0, 0, 300]);
        Et0 = Et0 + circshift(Et0, [0,15]);
end

Et0 = center(Et0,'max');
Et0 = Et0/Et0(end/2);
Ew0 = fftc(Et0);

if plse == 3
    Ew0 = circshift(Ew0.',floor(N/10)).';
end

% Calculate FROG Trace
Et0 = ifftc(Ew0);
Esig = CalcEsig(Et0,Et0);
Asig = abs(fft_FROG(Esig));
Asig = quickscale(Asig);

% Add noise
Asig = Asig + err * (2*rand(size(Asig))-1) * max(Asig(:));
Asig = nonegatives(Asig);

Et = pulsegenerator(N); Et = complex(abs(Et));
Ew = fftc(Et);

% Run the Retrieval Algorithm
switch domain
    case 1
        Et = QuickFROG_tT(Asig, Et, t, w);
    case 2
        Ew = QuickFROG_wW(Asig, Ew, t, w);
end
