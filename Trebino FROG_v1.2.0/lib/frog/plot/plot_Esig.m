function h = plot_Esig(Esig, varargin)
%PLOT_ESIG plots the FROG signal.
%   PLOT_ISIG(Esig, wt, tau, DisplayStruct, cutoff) plots FROG signal
%   field.
%
%   Optional paramters are:
%       wt, frequency/wavelength vector
%       tau, delay vector
%       DisplayStruct, structure specifying display options
%
%   In this function, the default values for DisplayStruct are:
%       cutoff: 0.02
%     colormap: frogcolormap
%
%   For use of DisplayStruct, see functions DisplayStructSet and
%   DisplayStructGet.
%   
%	H = PLOT_ESIG(...) returns the handle for an image graphics object.

%	$Revision: 1.2 $ $Date: 2007-05-26 21:24:47 $
%
%	$Log: plot_Esig.m,v $
%	Revision 1.2  2007-05-26 21:24:47  pablo
%	lowercase
%	
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.2  2004/04/19 20:21:29  xg
%	drawnow and colorbar implemented
%	
%	Revision 1.1  2004/04/19 18:13:08  xg
%	Moved and updated with DisplayStruct.
%	


error(nargchk(1,5,nargin));

wt = (1:size(Esig, 1)) - size(Esig,1) / 2 - 1;
tau = (1:size(Esig, 2)) - size(Esig,2) / 2 - 1;
DisplayStruct = DisplayStructSet;

[wt, tau, DisplayStruct] = parsevarargin(varargin, wt, tau, DisplayStruct);

switch lower(DisplayStruct.plotvalue)
    case 'intensity'
        Isig = magsq(Esig);
    case 'amplitude'
        if ~isreal(Esig)
            Esig = abs(Esig);
        end
        Isig = Esig;
    otherwise
        error('DisplayStruct.plotvalue is unsupported.  Use ''intensity'' or ''amplitude'' only.')
end

if isempty(DisplayStruct.colormap)
    DisplayStruct.colormap = frogcolormap;
end

Levels = size(DisplayStruct.colormap, 1);

if isempty(DisplayStruct.cutoff)
    DisplayStruct.cutoff = .02;
end

maxPlotValue = maxall(Isig);
minPlotValue = max((-1 / (Levels - 1) + DisplayStruct.cutoff) * maxPlotValue, minall(Isig));

switch lower(func2str(DisplayStruct.plotfun))
    case 'imagesc'
        h1 = imagesc(tau, wt, Isig, [minPlotValue, maxPlotValue]);
    case 'pcolor'
        h1 = pcolor(tau, wt, nonegatives(Isig - minPlotValue) + minPlotValue);
        shading interp;
    otherwise
        error('DisplayStruct.plotfunc is unsupported.  Use @imagesc or @pcolor only.');
end

if ~isempty(DisplayStruct.xlim)
    xlim(sort(DisplayStruct.xlim));
end

if ~isempty(DisplayStruct.ylim)
    ylim(sort(DisplayStruct.ylim));
end

xlabel(DisplayStruct.xlabel);
ylabel(DisplayStruct.ylabel);
title(DisplayStruct.title);

colormap(DisplayStruct.colormap);

if ~isempty(DisplayStruct.axis)
    axiscell = cellstr(DisplayStruct.axis);
    axis(axiscell{:});
end

axis xy;

if DisplayStruct.colorbar
    colorbar;
end

if DisplayStruct.drawnow
    drawnow;
end

if nargout > 0
	h = h1;
end