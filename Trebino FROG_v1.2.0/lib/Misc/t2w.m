function [w, Ew] = t2w(Et, varargin)
%T2W converts time base to frequency base.
%
%   [w, Ew] = t2w([t, Et], l0, unit) converts pulse in time [t, Et] to pulse in (angular) frequency domain
%   [w, Ew], with center wavelength l0.
%
%   l0 defaults to 800 nm, unit defaults to 'nm/fs'.
%
%   w = t2w(t, l0) converts bases only.
%
%   Both column format [t, Et] or row format [t; Et] are accepted, and the output will be the same format
%   as input.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:35 $

error(nargchk(1, 3, nargin))

[l0, u] = parsevarargin(varargin, 800, 'nm/fs');

if size(Et, 1) >= size(Et, 2)      % column format
    t = Et(:, 1);
    N = length(t);
	dt = mean(diff(t));
    dw = 2 * pi / N / dt;
    w = (-N/2 : N/2-1)' * dw + ltow(l0, u);
    if size(Et, 2) == 2
        Ett = Et(:, 2);
        Ew = fftc(Ett);
    end
else                                % row format
    t = Et(1, :);
    N = length(t);
	dt = mean(diff(t));
    dw = 2 * pi / N / dt;
    w = (-N/2 : N/2-1) * dw + ltow(l0, u);
    if size(Et, 1) == 2
        Ett = Et(2, :);
        Ew = fftc(Ett);
    end
end