function lam3 = lamsum(lam1,lam2,varargin);

% LAMSUM(LAM1,LAM2,UN) returns the sum-frequency wavelength of
% LAM1 and LAM2, in the same UNits.


error(nargchk(2, 3, nargin))

[un] = parsevarargin(varargin, 'nm/fs');

lam3 = ltof(ltof(lam1,un)+ltof(lam2,un),un);