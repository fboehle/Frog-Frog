function [Et, Z] = CalcNewEt( X )
%CALCNEWET calculates the next best E(t).
%	CALCNEWET must be defined.  This is the heart of the algorithm level of
%	object.

%	$Id: CalcNewEt.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% Calculate the gradient
dZ = -dZdE_shg(get(X, 'Esig'), get(X, 'Et'));

% Calculate the new E(t) and Z error.
[Et, Z] = MinZerr_shg(get(X, 'Esig'), get(X, 'Et'), dZ);

% Center the trace for the user.
Et = center(Et,'max');
