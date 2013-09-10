function [Et, Z] = CalcNewEt( X )
%CALCNEWET returns a new E(t)

%	$Id: CalcNewEt.m,v 1.1 2006-11-11 00:13:33 pablo Exp $

% Calc new E(t) and Z error.
[Et, Z] = MinZerr_X(get(X,'Esig'), get(X,'Et'), get(X,'Et'));

% Center the trace.
Et = center(Et,'max');