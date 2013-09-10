function Esig = FROGMagReplace(Esig,Asig)
% FROGMAGREPLACE Replace the magnitude of a FROG trace.
%	FROGMAGREPLACE(ESIG,ASIG) Returns a matrix with the magnitude of ASIG and the
%	phase of ESIG.  Where ASIG < 0 this function returns ESIG.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: FROGMagReplace.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.2  2002/04/02 21:20:38  zeekec
%	Added help and removed divide by zero warning.
%	

% Esig1(find(Asig >= 0)) = Asig(find(Asig >= 0)) .* Esig(find(Asig >= 0)) ./ abs(Esig(find(Asig >= 0)));

Esig(find(Asig >= 0)) = Asig(find(Asig >= 0)) .* exp(i * angle(Esig(find(Asig >= 0))));
