function [t, Et] = w2t(Ew)
%W2T converts frequency base to time base.
%
%   [t, Et] = w2t([w, Ew]) converts pulse in (angular) frequency domain [w, Ew]
%   to pulse in time domain [t, Et].
%
%   t = w2t(w) converts bases only.
%
%   Both column format [t, Et] or row format [t; Et] are accepted, and the output will be the same format
%   as input.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:35 $
%
%   $Log: w2t.m,v $
%   Revision 1.1  2006-11-11 00:15:35  pablo
%   CVS server re-installation
%
%   Revision 1.4  2002/10/09 16:33:01  zeekec
%   Fixed frequency calculations.
%
%   Revision 1.3  2002/09/23 20:21:18  xg
%   *** empty log message ***
%
%   Revision 1.2  2002/07/17 17:44:36  xg
%   Help updated.
%
%   Revision 1.1  2002/07/17 17:41:13  xg
%   Created.
%

error(nargchk(1, 1, nargin))

if size(Ew, 1) >= size(Ew, 2)      % column format
    w = Ew(:, 1);
    N = length(w);
	dw = mean(diff(w));
    dt = 2 * pi / N / dw;
    t = (-N/2 : N/2-1)' * dt;
    if size(Ew, 2) == 2
        Eww = Ew(:, 2);
        Et = ifftc(Eww);
    end
else                                % row format
    w = Ew(1, :);
    N = length(w);
	dw = mean(diff(w));
    dt = 2 * pi / N / dw;
    t = (-N/2 : N/2-1) * dt;
    if size(Ew, 1) == 2
        Eww = Ew(2, :);
        Et = ifftc(Eww);
    end
end