function h = plotI_Esig(Esig,varargin)
%PLOTI_ESIG plots the FROG signal intensity.
%	PLOTI_ESIG(ESIG) plots the intensity (magnitude squared) of FROG signal field.
%
%	H = PLOTI_ESIG(...) returns the handle for an image graphics object.
%
%	Now has been replaced by plot_Esig, with DisplayStruct.plotvalue set to 'intensity'.
%
%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

Levels = 256;

error(nargchk(1,5,nargin));

wt = (1:size(Esig,1)) - size(Esig,1) / 2 - 1;
tau = (1:size(Esig,2)) - size(Esig,2) / 2 - 1;
cutoff = 1e-2;
wht = false;

[wt, tau, cutoff, wht] = parsevarargin(varargin, wt, tau, cutoff, wht);

Esig = MagSq(Esig);

colormap(FrogColorMap(Levels, 1, wht));

hout = imagesc(tau,wt,Esig,[-1 / (Levels - 1) + cutoff, 1] * max(Esig(:)));

if nargout > 0
	h = hout
end