function [ Et ] = ApplyGfact( X, a )
%APPYGFACT applies the factor returned by the G error minimization.
%	The function will depend on the nonlinearity used.

%	$Id: ApplyGfact.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% SHG is the forth root of a.
Et = get(X, 'Et') .* sqrt(sqrt(a));
