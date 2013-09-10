function [Isig, Tau, Lam, Binned, Filename] = Binner_GetCurrData(handles)

Isig	= [];
Tau		= [];
Lam		= [];
Binned  = [];
Filename= [];

if isempty(handles.FrogData)
	return
end

Isig	= handles.FrogData(end).Isig;
Tau		= handles.FrogData(end).Tau;
Lam		= handles.FrogData(end).Lam;
Binned	= handles.FrogData(end).Binned;
Filename= handles.FrogData(end).Filename;