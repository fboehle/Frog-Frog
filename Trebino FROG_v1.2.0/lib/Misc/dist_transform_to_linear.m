function S = dist_transform_to_linear(x)
%DIST_TRANSFORM_TO_LINEAR(x) calculates the function necessary to transform a
%distribution on a non-uniform-spaced axis x to a uniformed spaced axis,
%evaluated on axis x.
%
%   If f(x) is a distribution on x where x is not uniformly spaced.  The same
%   distribution will be written as f'(x') where x' is uniformly spaced.
%   Then f'(x) = f(x) .* dist_transform_to_linear(x).

% Calculating d_n / d_x
warning('off', 'MATLAB:polyfit:RepeatedPointsOrRescale');
N = cumsum(ones(size(x)));
p = polyfit(N, x, 6);

p1 = polyder(p);

S = abs(1 ./ polyval(p1, N));
