function map = hsv2(m,n)
%HSV2    Hue-saturation-value color map, with black.
%   HSV2(M) returns an M-by-3 matrix containing an HSV colormap, with
%	the first value set to black.  HSV2, by itself, is the same length
%	as the current colormap.
%
%	HSV2(M,N) same as above, except there are N values set to black.
%
%   See also HSV, GRAY, HOT, COOL, BONE, COPPER, PINK, FLAG, PRISM, JET,
%   COLORMAP, RGBPLOT, HSV2RGB, RGB2HSV.

%   See Alvy Ray Smith, Color Gamut Transform Pairs, SIGGRAPH '78.
%   C. B. Moler, 8-17-86, 5-10-91, 8-19-92, 2-19-93.
%   Copyright 1984-2000 The MathWorks, Inc. 
%   Revision: 5.7   Date: 2000/06/01 02:53:43 

%   $Revision: 1.1 $  $Date: 2006-11-11 00:15:35 $
%
%	$Log: hsv2.m,v $
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2002/02/06 18:40:00  zeekec
%	Moved from misc.
%	
%	Revision 1.2  2001/07/10 16:51:51  zeekec
%	Added parameter to change the number of zero levels.
%	
%	Revision 1.1  2001/07/10 01:10:00  zeekec
%	Library cleanup.  Added, deleted, and moved files.
%	

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
	map = [zeros(n,3) ; map];
end
