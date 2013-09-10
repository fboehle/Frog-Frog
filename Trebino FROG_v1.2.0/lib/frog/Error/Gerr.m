function err = Gerr(Esig,Asig)
%GERR FROG G error
%	GERR(ESIG,ASIG) returns the FROG G error given the signal field, ESIG,
%	and the amplitude of the experimental trace, ASIG.
%
%	This function ignores values of ASIG that are less than 0.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: Gerr.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.2  2001/10/23 19:55:10  zeekec
%	Added help and limited error calculation to positive values of ASIG.
%	

err = sqrt( sumall((Asig(find(Asig >= 0)).^2 - abs(Esig(find(Asig >= 0))).^2) .^ 2) / prod(size(Esig)));