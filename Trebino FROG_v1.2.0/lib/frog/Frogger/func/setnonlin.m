function [T,N,S] = setnonlin(handles,T)

%	$Id: SetNonLin.m,v 1.1 2007-10-10 18:51:02 pam Exp $

S = get(handles.NonLin_Popup, 'String');
N = get(handles.NonLin_Popup, 'Value');

N1 = find(strcmpi(upper(T), upper(S)));

if ~isempty(N1)
	N = N1;
end

set(handles.NonLin_Popup, 'Value', N(1));

T = S{N(1)};

updatedomain(handles);
