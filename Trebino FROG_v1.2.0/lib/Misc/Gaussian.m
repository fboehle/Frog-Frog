function [y,x] = gaussian(FWHM, x, x0)
%GAUSSIAN Create a gaussian pulse.
%	Y=GAUSSIAN  Returns a gaussian amplitude with a 20 Intensity FWHM
%	centered at 0 on an x scale of -100 : 0.1 : 100.
%
%	Y=GAUSSIAN(FWHM)  As above with the FWHM as indicated.
%
%	Y=GAUSSIAN(FWHM, X)  As above with the indicated X scale.
%
%	Y=GAUSSIAN(FWHM, X, X0)  As above but centered at X0.
%
%	[Y,X]=GAUSSIAN(...) As above with the X scale used returned in X.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:34 $

error(nargchk(0,3,nargin))
if nargin < 1
	FWHM = 20;
end
if nargin < 2
	x = -100 : .1 : 100;
end
if nargin < 3
	x0 = 0;
end

X = FWHM/sqrt(log(2) * 2);

y = exp(-((x-x0)/X).^2);
