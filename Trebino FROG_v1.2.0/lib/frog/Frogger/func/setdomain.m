function [T,N,S] = setdomain(handles,T)

%	$Id: SetDomain.m,v 1.1 2007-10-10 18:51:02 pam Exp $

S = get(handles.Domain_Popup, 'String');
N = get(handles.Domain_Popup, 'Value');

N1 = find(strcmpi(upper(T), upper(S)));

if ~isempty(N1)
	N = N1;
end

set(handles.Domain_Popup, 'Value', N(1));

T = S{N(1)};

updatealgo(handles);
