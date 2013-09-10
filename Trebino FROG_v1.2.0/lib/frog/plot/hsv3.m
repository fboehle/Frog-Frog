function map = hsv3(m,n)
%HSV3    Hue-saturation-value color map, with white.
%   HSV3(M) returns an M-by-3 matrix containing an HSV colormap, with
%	the first value set to white.  HSV3, by itself, is the same length
%	as the current colormap.
%
%	HSV3(M,N) same as above, except there are N values set to white.
%
%   See also HSV, GRAY, HOT, COOL, BONE, COPPER, PINK, FLAG, PRISM, JET,
%   COLORMAP, RGBPLOT, HSV2RGB, RGB2HSV.

%   $Revision: 1.1 $  $Date: 2006-11-11 00:15:35 $

error(nargchk(0,2,nargin));

if nargin < 1
	m = size(get(gcf,'colormap'),1); 
end

if nargin < 2
	n = 1;
end

if m < 1
	map = [];
else
	map = hsv(m-n);
	map = [ones(n,3) ; map];
end
