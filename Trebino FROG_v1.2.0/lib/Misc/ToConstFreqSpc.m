function [W,E,L2] = ToConstFreqSpc(L,E,u)
%TOCONSTFREQSPC Converts E fome constant wavelength to constant angular frequency spacing.
%	[W,E,L2]=TOCONSTWAVESPC(L,E,U) Converts E(L) to E(W) where E
%	is the electric field, W is the angular frequency array, L is the
%	wavelength array, L2 is the wavelengths corresponding to W,
%	and U is the units on the speed of light (defaults to 'nm/fs').

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:34 $
%	

error(nargchk(2,3,nargin));

if (nargin < 3) | isempty(u)
	u = 'nm/fs';
end

wl = ltow(max(L),u);
wh = ltow(min(L),u);
w0 = mean([wl wh]);
w0 = const_c(u);

W = linspace(wl,wh,length(L));

if iscolumn(L)
	W = W';
end

L2 = ltow(W);
W2 = ltow(L);
C = W.^2 / w0^2;

w = find(W2 > 0);

if iscolumn(L)
	E = spline(L(w)', E(w,:)', L2')' .* repmat(C,1,size(E,2));
else
	E = spline(L(w) , E(:,w) , L2 )  .* repmat(C,size(E,1),1);
end
