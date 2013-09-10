function z = polyval2(P, x, y)
%POLYVAL Evaluate two-variable polynomial.
%   Z = POLYVAL(P, X, Y), where P is a matrix whose elements are the
%   coefficients of a two-variable polynomial, is the value of the
%   polynomial evaluated at (X, Y).
%
%       Z = SUMij(P(i, j) * x^(i-1) * y^(j-1))
%
%   Note that here matrix P is ordered in the more convenient way, in
%   ascending power of x and y, opposite to the order MatLab uses in its
%   one-dimensional polynomial functions.

%   $Revision: 1.1 $  $Date: 2006-11-11 00:15:35 $
%   $Log: polyval2.m,v $
%   Revision 1.1  2006-11-11 00:15:35  pablo
%   CVS server re-installation
%
%   Revision 1.1  2002/09/15 20:33:59  xg
%   *** empty log message ***
%

[Nx, Ny] = size(P);

X(1, 1) = 1;
for c = 2 : Nx
    X(1, c) = X(1, c-1) * x;
end

Y(1, 1) = 1;
for c = 2 : Ny
    Y(c, 1) = Y(c-1, 1) * y;
end

z = X * P *Y;