function X = isrow(Y)
%ISROW is the vector a row.
%	ISROW(Y) returns true if Y is a row vector.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

error(nargchk(1,1,nargin));

X = logical((ndims(Y) == 2) & (size(Y,1) == 1) & (size(Y,2) ~= 1));
