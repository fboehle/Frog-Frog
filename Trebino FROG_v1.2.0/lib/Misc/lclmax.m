function [x1, x2] = lclmax(x,p2,thresh)
%LCLMAX 1-D peak search           [ A.K.Booer  3-Dec-1992 ]
%	PK = LCLMAX(X,P,THRESH) Finds peaks inside a sliding
%	window of width 2*P+1, and with a height greather than thresh.
%	PK is a logical array of the peaks' locations.
%
%	[L,H] = LCLMAX(X,P,THRESH) Same as above except, L is the peaks' indeces,
%	and H is the peaks' heights.

%	$Revision: 1.1 $  $Date: 2006-11-11 00:15:35 $

x = x(:);
p = 2*p2 + 1;                  % full window width
[n,m] = size(x);               % useful dimensions
z = zeros(p2,m);               % pre-allocate result

y = buffer(x,p,p-1,'nodelay'); % index into original data matrix
ma = max(y);                   % find maximum in window

pk = [z ; reshape(ma,n-p+1,m) ; z]; % add missing edge elements
pk = logical((pk == x) & (x >= thresh));
	% find matching elements and threshold

if nargout < 2
	x1 = pk;
else
	x1 = (1:length(x))';
	x1 = x1(pk);
	x2 = x(pk);
end
