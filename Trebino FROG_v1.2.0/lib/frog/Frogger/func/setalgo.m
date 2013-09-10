function [T,N,S] = setclass(handles,T)

%	$Id: SetAlgo.m,v 1.1 2007-10-10 18:51:02 pam Exp $

S = get(handles.Algo_Popup, 'String');
N = get(handles.Algo_Popup, 'Value');

N1 = find(strcmpi(upper(T), upper(S)));

if ~isempty(N1)
	N = N1;
end

set(handles.Algo_Popup, 'Value', N);

T = S{N};

