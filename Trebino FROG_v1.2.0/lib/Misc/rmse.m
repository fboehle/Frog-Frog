function err = rmse(X,Y)
%RMSE Calculates the root mean squared error.
%	RMSE(X,Y) returns the root mean squared error difference between X and Y.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

error(nargchk(2,2,nargin))

if ndims(X) ~= ndims(Y)
	error('Arrays must have the same dimentions.')
end

if size(X) ~= size(Y)
	error('Arrays must be the same size.')
end

err = sqrt(mse(X,Y));