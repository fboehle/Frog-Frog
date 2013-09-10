function [Et, Z] = CalcNewEt( X )
%CALCNEWET calculates the new E(t).

%	$Id: CalcNewEt.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

[Et, Z] = MinZerr_X(get(X, 'Esig'), get(X, 'Et'), get(X, 'Gt'));
