function [ Et ] = ApplyGfact( X, a )
%APPYGFACT applies the G error fit factor to the pulse.

%	$Id: ApplyGfact.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

Et = get(X, 'Et') .* sqrt(a);
