function x = makex(dx, N, varargin)
%MAKEX generates a evenly spaced vector, using the provided increment dx, number
%   of points N, and center wavelength x0.
%
%   x = makex(dx, N, x0)
%   optional paramter x0 defaults to 0.

error(nargchk(0,3,nargin));

x0 = parsevarargin(varargin, 0);

x = (-N/2 : N/2 - 1) * dx + x0;