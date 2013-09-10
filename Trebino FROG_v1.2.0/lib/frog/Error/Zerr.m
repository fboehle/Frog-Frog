function err = Zerr(Esig,Esigp)
%ZERR the FROG Z error
%	ZERR(ESIG,ESIGP) returns the FROG Z error between two traces, ESIG and ESIGP.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

err = sqrt(sum( MagSq(Esig(:) - Esigp(:))) / prod(size(Esig)));
