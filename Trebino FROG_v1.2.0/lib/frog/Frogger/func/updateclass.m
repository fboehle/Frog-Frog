function updateclass(handles)

%	$Id: UpdateClass.m,v 1.1 2007-10-10 18:51:02 pam Exp $

Items = getappdata(handles.Frogger_Main, 'Algorithms');

Types = unique({Items{:,1}});

if isempty(Types)
	set(handles.Class_Popup, 'Enable', 'off');
else
	set(handles.Class_Popup, 'Enable', 'on');
	set(handles.Class_Popup, 'String', Types);
end

if get(handles.Class_Popup, 'Value') > length(Types)
	set(handles.Class_Popup, 'Value', 1);
end

