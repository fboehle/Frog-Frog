function phi = phasegenerator(P, w, varargin)
%PHASEGENERATOR generates a polynomial phase curve using the supplied
%coefficients.
%
%   phi = phasegenerator(P, w, w0)
%   where P = [phi0, phi1, phi2, ...] are the coefficients;
%         w is the angular frequency vector;
%         w0 is the center angular frequency.
%
%   phi = phi0 + phi1 * (w - w0) + phi2 * (w - w0) .^ 2 + ...
%   
%   If w0 is omitted, it defaults to w(floor(length(w)/2)+1).

error(nargchk(2, 3, nargin));

w0 = parsevarargin(varargin, w(floor(length(w)/2)+1));

if any(P)
	phi = polyval(fliplr(P), w - w0);
else
    phi = zeros(size(w));
end