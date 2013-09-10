function [T,N,S] = getalgo(handles)

%	$Id: GetAlgo.m,v 1.1 2007-10-10 18:51:02 pam Exp $

S = get(handles.Algo_Popup, 'String');
N = get(handles.Algo_Popup, 'Value');
T = S{N};

