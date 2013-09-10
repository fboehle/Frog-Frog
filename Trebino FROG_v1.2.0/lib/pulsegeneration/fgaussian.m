function Eenv = fguassian(t,FWHM)
%   Function for a guassian envelope.
%
%	t - The time array.
%   FWHM - FWHM of the pulse to be generated.

%   
%

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

T = FWHM/2/sqrt(log(2)/2);
Eenv = exp(-( t/T ).^2);    