function y = Binner_Center(X, Y, meth, y)

switch meth
case 1
% 	y = mean(X(:));
	y = X(floor(end/2+1));
case 2
	y = first_moment(Y(:), X(:));
case 3
	y = X(maxindex(Y(:)));
case 4
otherwise
	error('Unknown centering method.');
end
