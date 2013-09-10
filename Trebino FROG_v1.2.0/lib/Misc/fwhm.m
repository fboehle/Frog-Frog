function x = fwhm(y,t)
%FWHM  Find the full-width at half-maximum of an array.
%	FWHM(Y) Returns the full-width at half-maximum of the the
%	array in array indicies.  The function uses a linear
%	interpolation to estimate the actual crossing points.
%
%	FWHM(Y,T) Returns the FWHM of Y using T as the scale.

%	$Revision: 1.2 $ $Date: 2010-01-21 21:29:55 $

error(nargchk(1,2,nargin))

thresh = 0.5 * max(y);

temp = find (y > thresh);

if (temp(1)-1) < 1 | temp(end) >= length(y)
	x = NaN;
	return
end

x01 = linthresh(temp(1)-1, y, thresh);
x02 = linthresh(temp(end), y, thresh);

if nargin < 2
	x = x02 - x01;
	return
end

x = abs(lininterp(floor(x02),t,x02) - lininterp(floor(x01),t,x01));

function x0 = linthresh(x1, y, y0)
%LINTHRESH  Linear threshold function

x2 = x1+1;
y1 = y(x1);
y2 = y(x2);

x0 = (y0-y1) / (y2-y1) * (x2-x1) + x1;

function y0 = lininterp(x1, y, x0)
%LININTERP  Linear interpolation function

x2 = x1+1;
y1 = y(x1);
y2 = y(x2);

y0 = (x0-x1) / (x2-x1) * (y2-y1) + y1;
