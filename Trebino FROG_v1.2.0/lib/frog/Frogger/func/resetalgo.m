function [ handles ] = resetalgo( handles )
%SETALGO Summary of this function goes here
%  Detailed explanation goes here

%	$Id: ReSetAlgo.m,v 1.1 2007-10-10 18:51:02 pam Exp $

T1 = getclass(handles);

if isempty(T1)
	set(handles.Algo_Popup, 'Enable', 'off');
	return
end

T2 = getnonlin(handles);

if isempty(T2)
	set(handles.Algo_Popup, 'Enable', 'off');
	return
end

T3 = getdomain(handles);

if isempty(T3)
	set(handles.Algo_Popup, 'Enable', 'off');
	return
end

T4 = getalgo(handles);

if isempty(T4)
	set(handles.Algo_Popup, 'Enable', 'off');
	return
end

Items = getappdata(handles.Frogger_Main, 'Algorithms');

I = strcmp(Items,T1);
Items = Items(I(:,1),:);

I = strcmp(Items,T2);
Items = Items(I(:,2),:);

I = strcmp(Items,T3);
Items = Items(I(:,3),:);

I = strcmp(Items,T4);
Items = Items(I(:,4),:);

FrogObj = getappdata(handles.Frogger_Main,'FrogObj');

if strcmp(Items(1,1), get(FrogObj, 'TypeName'))
	if strcmp(Items(1,2), get(FrogObj, 'NonLinName'))
		if strcmp(Items(1,3), get(FrogObj, 'DomainName'))
			if strcmp(Items(1,4), get(FrogObj, 'AlgoName'))
				FrogObj = get(FrogObj, 'AlgoObj');
			else
				FrogObj = get(FrogObj, 'DomainObj');
			end
		else
			FrogObj = get(FrogObj, 'NonLinObj');
		end
	else
		FrogObj = get(FrogObj, 'TypeObj');
	end
else
	FrogObj = get(FrogObj, 'BaseObj');
end

FrogObj = feval(Items{1,5}, FrogObj);

setappdata(handles.Frogger_Main, 'FrogObj', FrogObj);

updateextra(handles);
