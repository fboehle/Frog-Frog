function Eenv = fsech2(t,FWHM)
%   Function for a sech^2 envelope.
%
%	t - The time array.
%   FWHM - FWHM of the pulse to be generated.

%   
%

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

T = FWHM/2/(asech(sqrt(1/2)));
Eenv = sech(t/T);
