function [EtB, Et, Esig, Gbest, Zbest,Ew ] = qFROG_TX(Asig, Et, t, w1, w2, Gate, Gbest, EtB, options)
% qFROG_TX.m
%
% FROG code for XFROG. The number of iterations can be changed here. Please
% choose another FROG code if not using XFROG. 
%
% See also: PG_XFROG, binner_cmd_demo, calibrate, qFROG_TX, frog_wtol_x,
% frog_wtol

% By Jeff Wong (GaTech) - 2011-08-10, 1400

% === START === 
%	Default options.
defaultopt = struct('Display',		'print', ...
    'DisplayStep',	25, ...
    'DisplayLimit',	100, ...
    'Domain',		'time', ...
    'CorrectG',		'off', ...
    'KeepBest',		'g', ...
    'MaxIter',		200, ...
    'MinimumG',		0.0, ...
    'MinimumZ',		0.0 );

% If just 'defaults' passed in, return the default options in X
if nargin==1 && nargout <= 1 && isequal(Asig,'defaults')
    EtB = defaultopt;
    return
end

if nargin < 9; options = []; end
n = FROG_optimget(options, 'MaxIter', defaultopt, 'fast') - 1;
Gcutoff = FROG_optimget(options, 'MinimumG', defaultopt, 'fast');
Zcutoff = FROG_optimget(options, 'MinimumZ', defaultopt, 'fast');
stepsz = FROG_optimget(options, 'DisplayStep', defaultopt, 'fast');
Klimit = FROG_optimget(options, 'DisplayLimit', defaultopt, 'fast');
CorrectG = strcmp(FROG_optimget(options, 'CorrectG', defaultopt, 'fast'), 'on');

switch FROG_optimget(options, 'Display', defaultopt, 'fast')
    case 'all'
        dsp = 1;
        prnt = 1;
    case 'print'
        prnt = 1;
        dsp = 0;
    case 'graph'
        dsp = 1;
        prnt = 0;
    otherwise
        dsp = 0;
        prnt = 0;
end

switch FROG_optimget(options, 'KeepBest', defaultopt, 'fast')
    case 'g'
        KeepBest = 1;
    otherwise
        KeepBest = 0;
end

sz = size(Asig,2) / size(Asig,1);

k = 0;
G(1,1) = Inf;
Z(1)   = Inf;
Zbest = Inf;

% Compute the FROG trace from the input and the gate. 
Esig = CalcEsig(Et,Gate,sz);
Esig = fft_FROG(Esig);

% Magnitude replace 
Esig = MagRepl(Esig,Asig);
Esig = ifft_FROG(Esig);


% Main algorithm goes here
while G(end,1) > Gcutoff && Z(end) > Zcutoff && k <= n
    k = k+1;
    [Et, Z(k)] = MinZerr_X(Esig, Et, Gate);

    Esig = CalcEsig(Et,Gate);
    Esig = fft_FROG(Esig);
    [G(k,1),a(k)] = MinGerr(Esig,Asig);

    if CorrectG
        Et = Et * (sqrt(a(end)));
    end

    if KeepBest && G(k,1) <= Gbest
        Gbest = G(k,1);
        if prnt
                fprintf(1,'G Best: %e\n', Gbest);
        end
        Zbest = Z(k);
        EtB = Et;
    end
 
	Ew = fftc(Et);
    if dsp && ~mod(k-1,stepsz)
        Ew = fftc(Et);
        DisplayXFROG(Asig, Esig, Et, Ew, t, w1, w2, k, Klimit, G, Z, Gbest, Zbest, Gcutoff, Zcutoff)
    end

    if prnt && ~mod(k-1,stepsz)
        PrintFROG(k, G, Z, Gcutoff, Zcutoff, toc)
    end

    Esig = MagRepl(Esig,Asig);
    Esig = ifft_FROG(Esig);
end

k = k+1;

[Et, Z(k)] = MinZerr_X(Esig, Et, Gate);
Esig = CalcEsig(Et,Gate,sz);
Esig = fft_FROG(Esig);
[G(k,1),a(k)] = MinGerr(Esig,Asig);

if CorrectG
    Et = Et * (sqrt(a(end)));
end

if KeepBest && G(k,1) <= Gbest
    Gbest = G(k,1);
    
    if prnt
        fprintf(1,'G Best: %e\n', Gbest);
    end
    Zbest = Z(k);
    EtB = Et;
end