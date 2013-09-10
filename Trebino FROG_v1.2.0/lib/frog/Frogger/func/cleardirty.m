function cleardirty( handles )
%CLEARDIRTY Summary of this function goes here
%  Detailed explanation goes here

%	$Id: ClearDirty.m,v 1.1 2007-10-10 18:51:02 pam Exp $

setappdata(handles.Frogger_Main, 'Dirty', false);

name = get(handles.Frogger_Main, 'Name');

if name(end) == '*'
	set(handles.Frogger_Main, 'Name', name(1:end-2));
end
