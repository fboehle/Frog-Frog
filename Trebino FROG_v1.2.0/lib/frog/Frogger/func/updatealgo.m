function updatealgo(handles)


%	$Id: UpdateAlgo.m,v 1.1 2007-10-10 18:51:02 pam Exp $

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

Items = getappdata(handles.Frogger_Main, 'Algorithms');

I = strcmp(Items,T1);
Items = Items(I(:,1),:);

I = strcmp(Items,T2);
Items = Items(I(:,2),:);

I = strcmp(Items,T3);
Items = unique(Items(I(:,3),4));

if isempty(Items)
	set(handles.Algo_Popup, 'Enable', 'off');
else
	set(handles.Algo_Popup, 'Enable', 'on');
	set(handles.Algo_Popup, 'String', Items);
end

if get(handles.Algo_Popup, 'Value') > length(Items)
	set(handles.Algo_Popup, 'Value', 1);
end
