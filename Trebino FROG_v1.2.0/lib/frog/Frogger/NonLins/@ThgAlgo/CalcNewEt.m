function [Et, Z] = CalcNewEt( X )
%CALCNEWET clacs a new E(t)

%	$Id: CalcNewEt.m,v 1.1 2006-11-11 00:13:33 pablo Exp $

dZ = -dZdE_thg(get(X, 'Esig'), get(X, 'Et'));

[Et, Z] = MinZerr_thg(get(X, 'Esig'), get(X, 'Et'), dZ);

Et = center(Et,'max');