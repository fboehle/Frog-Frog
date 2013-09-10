function updatenonlin(handles)

%	$Id: UpdateNonLin.m,v 1.1 2007-10-10 18:51:02 pam Exp $

T = getclass(handles);

if isempty(T)
	set(handles.NonLin_Popup, 'Enable', 'off');
	return
end

Items = getappdata(handles.Frogger_Main, 'Algorithms');

I = strcmp(Items,T);
NonLins = unique(Items(I(:,1),2));

if isempty(Items)
	set(handles.NonLin_Popup, 'Enable', 'off');
else
	set(handles.NonLin_Popup, 'Enable', 'on');
	set(handles.NonLin_Popup, 'String', NonLins);
end

if get(handles.NonLin_Popup, 'Value') > length(NonLins)
	set(handles.NonLin_Popup, 'Value', 1);
end
