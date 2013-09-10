function [ FrogObj ] = DisturbPulse( FrogObj, handles )
%DISTURBPULSE perturbs the pulse.

%	$Id: DisturbPulse.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% Flips the time direction.
if getappdata(handles.Frogger_Main, 'FlipTime')
	FrogObj.Et = fliptime(FrogObj.Et);
    FrogObj.BestG.Et = fliptime(FrogObj.BestG.Et);
    FrogObj.BestZ.Et = fliptime(FrogObj.BestZ.Et);
	setappdata(handles.Frogger_Main, 'FlipTime', false)
	FrogObj.Esig = CalcEsig(FrogObj.Et, Gate(FrogObj));
	FrogObj.Esig = fft_FROG(FrogObj.Esig);
end

% Flattens the temporal phase.
if getappdata(handles.Frogger_Main, 'FlatPhase')
	FrogObj.Et = abs(FrogObj.Et);
	setappdata(handles.Frogger_Main, 'FlatPhase', false)
	FrogObj.Esig = CalcEsig(FrogObj.Et, Gate(FrogObj));
	FrogObj.Esig = fft_FROG(FrogObj.Esig);
end
