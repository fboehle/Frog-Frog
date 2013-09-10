function [L,Int,W2] = ToConstWaveSpc(W,Int,u)
%TOCONSTWAVESPC Converts Intensity from constant frequency to constant wavelength spacing.
%	[L,Int,W2]=TOCONSTWAVESPC(W,Int,U) Converts I(W) to I(L) where I
%	is the intensity, W is the angular frequency array, L is the
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
C = L ./ l0 ;

C_diag = diag(C, 0);
    


if iscolumn(W)
	Int = spline(W',Int',W2')' * C_diag ;
else
	Int = C_diag * spline(W, Int, W2) ;
end
