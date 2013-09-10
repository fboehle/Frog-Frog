function [ Gt ] = Gate( FrogObj, Et )
%GATE returns the gate pulse.
%	GT = GATE( FROGOBJ ) returns the gate pulse corresponding to
%	FrogObj.Et.
%
%	GT = GATE(FROGOBJ, ET) returns the gate pulse corresponding to Et.
%	This form is used in saving the FROG trace and must be defined.

%	$Id: Gate.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

if nargin < 2
	% Set Et to the current E(t).
	Et = get(FrogObj, 'Et');
end

% Calculate the gate pulse.
Gt = gate_shg(Et);
