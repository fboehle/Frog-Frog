function X = first_moment(y,x)
%FIRST_MOMENT Calculates the first moment.

if nargin < 2 | isempty(x)
	x = 1:length(y);
end

X = sumall(abs(y).^2 .* x) ./ sumall(abs(y).^2);
