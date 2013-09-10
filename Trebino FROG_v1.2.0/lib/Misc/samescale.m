function [X,Y] = samescale(P,Q)
%   SAMESCALE Scales P and Q to the same scale as P
%	SAMESCALE(P, Q) Scales P and Q to the maximum of the absolute value of P
%	to 1.  Works for both vectors and matricies.
%	
%	X = P / max(abs(P(:)));
%	Y = Q / max(abs(P(:)));

X = P / max(abs(P(:)));
Y = Q / max(abs(P(:)));