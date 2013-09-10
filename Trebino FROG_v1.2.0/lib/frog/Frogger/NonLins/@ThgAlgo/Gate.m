function [ Gt ] = Gate( X, Et )
%GATE returns the gate pulse.

%	$Id: Gate.m,v 1.1 2006-11-11 00:13:33 pablo Exp $

if nargin == 1
	Et = get(X, 'Et');
end

Gt = gate_thg(Et);
