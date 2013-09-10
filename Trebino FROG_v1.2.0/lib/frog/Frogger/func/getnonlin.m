function [T,N,S] = getnonlin(handles)

%	$Id: GetNonLin.m,v 1.1 2007-10-10 18:51:02 pam Exp $

S = get(handles.NonLin_Popup, 'String');
N = get(handles.NonLin_Popup, 'Value');
T = S{N};

