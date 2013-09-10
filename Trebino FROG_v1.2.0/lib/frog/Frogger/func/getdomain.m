function [T,N,S] = getdomain(handles)

%	$Id: GetDomain.m,v 1.1 2007-10-10 18:51:02 pam Exp $

S = get(handles.Domain_Popup, 'String');
N = get(handles.Domain_Popup, 'Value');
T = S{N};


