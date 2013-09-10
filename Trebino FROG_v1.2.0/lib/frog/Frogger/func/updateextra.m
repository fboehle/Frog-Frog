function updateextra(handles)

%	$Id: UpdateExtra.m,v 1.1 2007-10-10 18:51:02 pam Exp $

if get(getappdata(handles.Frogger_Main,'FrogObj'), 'NeedsExtraInfo')
	set(handles.Extra_Button, 'Enable', 'on');
    set(handles.Extra_MenuItem, 'Enable', 'on');
else
	set(handles.Extra_Button, 'Enable', 'off');
    set(handles.Extra_MenuItem, 'Enable', 'off');
end
