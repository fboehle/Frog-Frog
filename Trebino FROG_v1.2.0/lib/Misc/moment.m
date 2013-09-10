function X = moment(y,x,n)
%MOMENT Calculates the moments.
%	MOMENT(Y) calculates the first moment of Y.
%
%	MOMENT(Y,X) calculates the first moment of Y(X).
%
%	MOMENT(Y,X,N) calculates the Nth moment of Y(X).
%
%   If Y is a matrix, enter X in the form of {X1, X2}, where X1 and X2 are
%   two vectors specifying scales in both dimensions.


N = size(y);
if (length(N) > 2)
    error('Cannot handle arrays of dimensions greater than 2.');
end

v = find(N == 1);
is1d = ~isempty(v);

if is1d
    nv = 3 - v;   % (3-nv) gives the non-singleton dimension: 1->2 and 2->1
end

if nargin < 2 | isempty(x)
	x = {1 : size(y, 1), 1 : size(y, 2)};
elseif ~iscell(x)
    xp{nv} = x;
    x = xp;
end

if nargin < 3 | isempty(n)
	n = 1;
end

if is1d
    X = moment1d(y, x{nv}, n);
else
    X = [moment1d(sum(y, 2), x{1}, n), moment1d(sum(y, 1), x{2}, n)];
end


% moment1d calculates moments for 1-d vectors
function X = moment1d(y, x, n)
X = (abs(x(:))' .^ n * y(:)) / sumall(y);