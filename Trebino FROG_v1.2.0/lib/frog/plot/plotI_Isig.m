function h = plotI_Isig(Isig,varargin)
%PLOTI_ISIG plots the FROG trace intensity.
%	PLOTI_ISIG(ISIG) plots the intensity of FROG signal field.
%
%	H = PLOTI_ISIG(...) returns the handle for an image graphics object.
%
%	Now has been replaced by plot_Esig, with DisplayStruct.plotvalue set to 'intensity'.
%
%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $
%

Levels = 256;

error(nargchk(1,5,nargin));

wt = (1:size(Isig,1)) - size(Isig,1) / 2 - 1;
tau = (1:size(Isig,2)) - size(Isig,2) / 2 - 1;
cutoff = 1e-2;
wht = false;

[wt, tau, cutoff, wht] = parsevarargin(varargin, wt, tau, cutoff, wht);

Isig = quickscale(Isig);

h1 = imagesc(tau,wt,Isig,[-1 / (Levels - 1) + cutoff, 1]);
colormap(FrogColorMap(Levels, [], wht));
axis xy;

if nargout > 0
	h = h1;
end
