function y=sinc2(x)
%SINC2 Sin(x)/(x) function, not scaled by PI.
%	SINC(X) returns a matrix whose elements are the sinc of the elements 
%	of X, i.e.
%		y	= sin(x)/(x)	if x ~= 0
%			= 1				if x == 0
%	where x is an element of the input matrix and y is the resultant
%	output element.
%
%	See also SINC, SQUARE, SIN, COS, CHIRP, DIRIC, GAUSPULS, PULSTRAN,
%	RECTPULS, and TRIPULS.

%	Author(s): T. Krauss, 1-14-93
%	Copyright 1988-2002 The MathWorks, Inc.
%		$Revision: 1.1 $  $Date: 2006-11-11 00:15:35 $

%	$Id: sinc2.m,v 1.1 2006-11-11 00:15:35 pablo Exp $

y=ones(size(x));
i=find(x);
y(i)=sin(x(i))./(x(i));
