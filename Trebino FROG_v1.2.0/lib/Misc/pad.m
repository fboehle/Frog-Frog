function [X,Y] = pad(X,Y,N)
%PAD pads a complex array.

error(nargchk(3,3,nargin));

if N < length(X)
	warning('Final length is less that input length');
	return
end

n1 = floor((N - length(X)) / 2);
n2 = N - n1 - length(X);

dX = mean(diff(X));

x1 = (-n1:-1) * dX + min(X);
x2 = (1:n2)   * dX + max(X);

if isrow(X)
	X = [x1, X, x2];
	Y = [zeros(size(x1)), Y, zeros(size(x2))];
else
	X = [x1'; X; x2'];
	Y = [zeros(size(x1')); Y; zeros(size(x2'))];
end