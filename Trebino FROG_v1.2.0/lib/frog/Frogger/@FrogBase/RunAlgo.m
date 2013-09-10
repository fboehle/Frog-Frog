function [ FrogObj ] = RunAlgo( FrogObj, handles, DStruct, DStructPulse )
%RUNALGO is the main algorithm loop.
%	FrogObj		the FrogBase object to work on.
%	handles		the frogger handles.

%	$Id: RunAlgo.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% Get some preferences...
MaxIter = getpref('frogger', 'MaxIter');
PlotEvery = getpref('frogger', 'PlotEvery');

% Loop until we should stop.
while ~getappdata(handles.Frogger_Main, 'Stopping') && length(FrogObj.G < MaxIter)
	
	% Update the FrogObj.
	FrogObj = RunAlgoKern(FrogObj, handles);
	
	% Check to see if we should plot...
	if ~mod(length(FrogObj.G)-1, PlotEvery)
		% Update the plots.
		UpdateRecon(FrogObj, handles.Recon_Axes, handles.Diff_Axes, DStruct);
		UpdatePlots(FrogObj, handles.Time_Axes, handles.Spec_Axes, ...
			handles.Error_Axes, handles.Status_Text, DStructPulse);
	end
	
	drawnow
end

% If we didn't plot on the last iteration, do it now.
if mod(length(FrogObj.G), PlotEvery)
	UpdateRecon(FrogObj, handles.Recon_Axes, handles.Diff_Axes, DStruct);
	UpdatePlots(FrogObj, handles.Time_Axes, handles.Spec_Axes, ...
		handles.Error_Axes, handles.Status_Text, DStructPulse);
	drawnow
end
