function updatedomain(handles)

%	$Id: UpdateDomain.m,v 1.1 2007-10-10 18:51:02 pam Exp $

T1 = getclass(handles);

if isempty(T1)
	set(handles.Domain_Popup, 'Enable', 'off');
	return
end

T2 = getnonlin(handles);

if isempty(T2)
	set(handles.Domain_Popup, 'Enable', 'off');
	return
end

Items = getappdata(handles.Frogger_Main, 'Algorithms');

I = strcmp(Items,T1);
Items = Items(I(:,1),:);

I = strcmp(Items,T2);
Domains = unique(Items(I(:,2),3));

if isempty(Items)
	set(handles.Domain_Popup, 'Enable', 'off');
else
	set(handles.Domain_Popup, 'Enable', 'on');
	set(handles.Domain_Popup, 'String', Domains);
end

if get(handles.Domain_Popup, 'Value') > length(Domains)
	set(handles.Domain_Popup, 'Value', 1);
end

