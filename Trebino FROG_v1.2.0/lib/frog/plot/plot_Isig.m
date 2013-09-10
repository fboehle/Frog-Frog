function h = plot_Isig(Isig,varargin)
%PLOT_ISIG plots the FROG intensity signal Isig.
%   PLOT_ISIG(Isig, wt, tau, DisplayStruct, cutoff) plots FROG intensity
%   signal Isig.
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
%	H = PLOT_ISIG(...) returns the handle for an image graphics object.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $
%
%	$Log: plot_Isig.m,v $
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.2  2004/04/19 20:21:30  xg
%	drawnow and colorbar implemented
%	
%	Revision 1.1  2004/04/19 18:13:08  xg
%	Moved and updated with DisplayStruct.
%	
%	Revision 1.3  2001/11/21 00:04:56  zeekec
%	*** empty log message ***
%	
%	Revision 1.2  2001/10/19 16:17:28  zeekec
%	Streamlined function
%	
%	Revision 1.1  2001/10/08 20:39:43  zeekec
%	Added new functions
%	

error(nargchk(1,5,nargin));

wt = (1:size(Isig,1)) - size(Isig,1) / 2 - 1;
tau = (1:size(Isig,2)) - size(Isig,2) / 2 - 1;
DisplayStruct = DisplayStructSet;

[wt, tau, DisplayStruct] = ParseVarargin(varargin, wt, tau, DisplayStruct);

switch lower(DisplayStruct.plotvalue)
    case 'intensity'
        Isig = nonegatives(Isig);
    case 'amplitude'
        Isig = sqrt(nonegatives(Isig));
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