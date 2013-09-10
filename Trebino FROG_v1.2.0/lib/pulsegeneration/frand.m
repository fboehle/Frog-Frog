function Eenv = frand(t,FWHM)
%Function for a random pulse.
%
%	t - The time array.
%   FWHM - FWHM of the pulse to be generated.
%   
%

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

Eenv = rand(size(t));

Eenv(find( (t + FWHM/2) < 0)) = 0;
Eenv(find( (t - FWHM/2) > 0)) = 0;
