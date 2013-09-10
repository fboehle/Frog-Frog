function [T,N,S] = getclass(handles)

%	$Id: GetClass.m,v 1.1 2007-10-10 18:51:02 pam Exp $

S = get(handles.Class_Popup, 'String');
N = get(handles.Class_Popup, 'Value');
T = S{N};

