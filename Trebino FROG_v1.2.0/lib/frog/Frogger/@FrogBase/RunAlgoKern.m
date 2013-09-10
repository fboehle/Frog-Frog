function [ FrogObj ] = RunAlgoKern( FrogObj, handles )
%RUNALGOKERN executes a single step of the algorithm.
%	FrogObj		the FrogBase object to work on.
%	handles		the handles of the frogger Program

%	$Id: RunAlgoKern.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% If the FrogObj.Esig hasn't been initialized, do so.
if isempty(FrogObj.Esig)
	FrogObj.Esig = CalcEsig(FrogObj.Et, Gate(FrogObj));
	FrogObj.Esig = fft_FROG(FrogObj.Esig);
end

% User specified perturbations.
FrogObj = DisturbPulse(FrogObj, handles);

% The magnitude replacement step.
FrogObj.Esig = MagRepl(FrogObj.Esig, FrogObj.Asig);

% Take FrogObj.Esig to the time and delay domain.
FrogObj.Esig = ifft_FROG(FrogObj.Esig);

% Get the new guess and Z error for E(t).
[FrogObj.Et, Z] = CalcNewEt(FrogObj);

% Store the Z error.
FrogObj.Z(end+1) = Z;

% Generate a new Esig.
FrogObj.Esig = CalcEsig(FrogObj.Et, Gate(FrogObj));

% Take FrogObj.Esig back to the frequency and delay domain.
FrogObj.Esig = fft_FROG(FrogObj.Esig);

% Calculate the G error and correction factor.
[G,a] = MinGerr(FrogObj.Esig, FrogObj.Asig);

% Apply the correction factor to E(t).
FrogObj.Et = ApplyGfact(FrogObj,a);

% Store the G error.
FrogObj.G(end+1) = G;

% Is this the best G error?
if isempty(FrogObj.BestG.Et) || G < FrogObj.BestG.G
	FrogObj.BestG.Et	= FrogObj.Et;
	FrogObj.BestG.G		= G;
	FrogObj.BestG.Z		= Z;
	FrogObj.BestG.Iter	= length(FrogObj.G)-1;
end

% Is this the best Z error?
if isempty(FrogObj.BestZ.Et) || Z < FrogObj.BestZ.Z
	FrogObj.BestZ.Et	= FrogObj.Et;
	FrogObj.BestZ.G		= G;
	FrogObj.BestZ.Z		= Z;
	FrogObj.BestZ.Iter	= length(FrogObj.G)-1;
end
