function Y = AddPolyPhase(x,Y,phase)
%ADDPOLYPHASE adds a polynomial phase.
%	ADDPOLYPHASE(X,Y,PHASE) Adds the phase, PHASE, to Y given X.
%	This function takes the polynomial for the phase in a natural order,
%	lowest order to highest.
%
%	Calculates the function:
%	Y = Y .* exp(i *polyval(fliplr(phase),x));

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

Y = Y .* exp(i * polyval(fliplr(phase),x));
