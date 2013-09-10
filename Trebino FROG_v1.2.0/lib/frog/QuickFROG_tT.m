function [EtB, Et] = QuickFROG_tT(Asig, Et, t, w, options)


%	Default options.
defaultopt = struct('Display',		'all', ...
	'DisplayStep',	25, ...
	'DisplayLimit',	100, ...
	'Domain',		'time', ...
	'CorrectG',		'on', ...
	'KeepBest',		'g', ...
	'MaxIter',		500, ...
	'MinimumG',		0.0, ...
	'MinimumZ',		0.0 );

% If just 'defaults' passed in, return the default options in X
if nargin==1 && nargout <= 1 && isequal(Asig,'defaults')
	EtB = defaultopt;
	return
end

if nargin < 5; options = []; end

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
case 'graph'
	dsp = 1;
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
% G(1,2) = Inf;
Z(1)   = Inf;
Gbest = Inf;
Zbest = Inf;

tic;

Esig = CalcEsig(Et,Et);

Esig = fft_FROG(Esig);

Esig = MagRepl(Esig,Asig);

Esig = ifft_FROG(Esig);

while G(end,1) > Gcutoff & Z(end) > Zcutoff & k < n
	k = k+1;
	
	dZ = -dZdE_shg(Esig,Et);
	
	[Et, Z(k)] = MinZerr_shg(Esig, Et, dZ);
	
	if ~mod(k-1,stepsz)
		Et = center(Et,'max');
% 		Et = circshift(Et,[0, -22]);
	end
	
	Esig = CalcEsig(Et,Et,sz);
	
	Esig = fft_FROG(Esig);
	
% 	[G(k,1),a(k),G(k,2)] = MinGerr(Esig,Asig);
	[G(k,1),a(k)] = MinGerr(Esig,Asig);
	
	if CorrectG
		Et = Et * sqrt(sqrt(a(end)));
	end
	
	if KeepBest & G(k,1) <= Gbest
		Gbest = G(k,1);
		Zbest = Z(k);
		EtB = Et;
	elseif Z(k) <= Zbest
		Gbest = G(k,1);
		Zbest = Z(k);
		EtB = Et;
	end
	
	if dsp & ~mod(k-1,stepsz)
		Ew = fftc(Et);
		DisplayFROG(Asig, Esig, Et, Ew, t, w, k, Klimit, G, Z, Gbest, Zbest, Gcutoff, Zcutoff)
	end
	
	if prnt & ~mod(k-1,stepsz)	
		PrintFROG(k, G, Z, Gcutoff, Zcutoff, toc)
	end
	
	Esig = MagRepl(Esig,Asig);
	
	Esig = ifft_FROG(Esig);
end

k = k+1;

dZ = -dZdE_shg(Esig,Et);

[Et, Z(k)] = MinZerr_shg(Esig, Et, dZ);

Esig = CalcEsig(Et,Et,sz);

Esig = fft_FROG(Esig);

[G(k,1),a(k)] = MinGerr(Esig,Asig);

Et = Et * sqrt(sqrt(a(end)));

if dsp
	Ew = fftc(Et);
	DisplayFROG(Asig, Esig, Et, Ew, t, w, k, Klimit, G, Z, Gbest, Zbest, Gcutoff, Zcutoff)
end

if prnt
	PrintFROG(k, G, Z, Gcutoff, Zcutoff, toc)
end

beep

