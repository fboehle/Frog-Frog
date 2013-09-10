function [T,N,S] = setclass(handles,T)

%	$Id: SetClass.m,v 1.1 2007-10-10 18:51:02 pam Exp $

S = get(handles.Class_Popup, 'String');
N = get(handles.Class_Popup, 'Value');

N1 = find(strcmpi(upper(T), upper(S)));

if ~isempty(N1)
	N = N1;
end

set(handles.Class_Popup, 'Value', N);

T = S{N};

updatenonlin(handles);
