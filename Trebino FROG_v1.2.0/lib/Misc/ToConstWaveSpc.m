function [L,E,W2] = ToConstWaveSpc(W,E,u)
%TOCONSTWAVESPC Converts E from constant frequency to constant wavelength spacing.
%	[L,E,W2]=TOCONSTWAVESPC(W,E,U) Converts E(W) to E(L) where E
%	is the electric field, W is the angular frequency array, L is the
%	wavelength array, W2 is the ang. frequencies corresponding the L,
%	and U is the units on the speed of light (defaults to 'nm/fs').

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:34 $

error(nargchk(2,3,nargin));

if (nargin < 3) | isempty(u)
	u = 'nm/fs';
end

ll = ltow(max(W));
lh = ltow(min(W));
l0 = mean([ll lh]);
%l0=1;

L = linspace(ll,lh,length(W));

L = reshape(L, size(W));

W2 = ltow(L);
C = L.^2 / l0.^2 ;

C_diag = diag(C, 0);
    


if iscolumn(W)
	E = spline(W',E',W2')' * C_diag ;
else
	E = C_diag * spline(W, E, W2) ;
end
