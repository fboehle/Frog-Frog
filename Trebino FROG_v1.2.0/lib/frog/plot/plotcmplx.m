function [axout,h1,h2] = plotcmplx(x,z,varargin)
%PLOTCMPLX Graphs amplitude labels on the left and phase labels on the right.
%   PLOTCMPLX(X,Z) plots ABS(Z) versus X with y-axis labeling
%   on the left and plots UNWRAP(ANGLE(Z)) versus X with y-axis 
%   labeling on the right.
%
%   PLOTCMPLX(X, Z, DISPLAYSTRUCT) uses options specified in DISPLAYSTRUCT
%   to plot the magnitude and phase of Z.  The related options in DISPLAYSTRUCT
%   are:
%               xlim: default [] (full range);
%            zlimMag: magnitude limits, default [] (full range);
%          zlimPhase: phase limits, default [] (full range);
%             xlabel: default '';
%          zlabelMag: default 'Amplitude' or 'Intensity', depending on plotvalue;
%        zlabelPhase: default 'Phase (rad)';
%              title: default '';
%         plotfunMag: plot funtion for magnitude, default @plot;
%       plotfunPhase: plot funtion for phase, default @plot;
%        colorseqMag: color sequence used for magnitude, matlab default;
%      colorseqPhase: color sequence used for phase, matlab default;
%          plotvalue: string, default 'amplitude';
%             unwrap: logical specifying whether to unwrap phase, default true;
%             cutoff: percentage of maximum amplitude/intensity below which phase is
%                     blanked, default 0.
%
%   PLOTCMPLX(X,Z,FUN) uses the plotting function FUN for the amplitude plot
%   instead of PLOT to produce each plot.  FUN should be a 
%   function handle to a plotting function, e.g. @plot, @semilogx,
%   @semilogy, @loglog ,@stem, etc. that accepts the syntax H = FUN(X,Y).
%
%   PLOTCMPLX(X,Z,FUN1,FUN2) uses FUN1(X,ABS(Z)) to plot the data for
%   the left axes and FUN2(X,UNWRAP(ANGLE(Z))) to plot the data for
%   the right axes.
%
%   [AX,H1,H2] = PLOTCMPLX(...) returns the handles of the two axes created in
%   AX and the handles of the graphics objects from each plot in H1
%   and H2. AX(1) is the left axes and AX(2) is the right axes.  
%
%   EXAMPLE  To plot the electric field with a phase blanking cutoff of 0.1
%   instead of the default value of 0:
%
%       DStruct = DisplayStructSet; % set all values to default values
%       DStruct.cutoff = 0.1; % change only the cutoff
%       plotcmplx(lambda, E, DStruct); % plot the complex field
%
%   See also PLOTCMPLXI, PLOT, PLOTYY, @, DISPLAYSTRUCTSET.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

error(nargchk(2,5,nargin))

[fun1, fun2, blank] = parsevarargin(varargin, @plot, @plot, -1);

if isa(fun1, 'function_handle')
    DStruct = DisplayStructSet('plotfunMag', fun1, 'plotfunPhase', fun2, 'cutoff', blank);
elseif isstruct(fun1)
    DStruct = fun1;
else
    error('Unrecognized arguments in plotcmplx.');
end

if isempty(DStruct.cutoff)
    DStruct.cutoff = 0;
end    

if (size(x,1) ~= size(z,1) & size(x,1) == size(z,2)) | ...
		(size(x,2) ~= size(z,2) & size(x,2) == size(z,1))
	z = z.';
end

if isrow(x)
	x = x.';
	z = z.';
end

switch lower(DStruct.plotvalue)
    case 'amplitude'
        Amp = abs(z);
        if isempty(DStruct.zlabelMag)
            DStruct = DisplayStructSet(DStruct, 'zlabelMag', 'Amplitude');
        end
    case 'intensity'
        Amp = magsq(z);
        if isempty(DStruct.zlabelMag)
            DStruct = DisplayStructSet(DStruct, 'zlabelMag', 'Intensity');
        end
    otherwise
        error('Illegal DStruct.plotvalue designation.');
end

if isempty(DStruct.zlabelPhase)
    DStruct = DisplayStructSet(DStruct, 'zlabelPhase', 'Phase (rad)');
end

if DStruct.unwrap
    phi = -unwrap(angle(z), [], 1);
else
    phi = -angle(z);
end

for k = 1 : size(phi,2)
%     Amp(:, k) = quickscale(Amp(:, k));
	[Amaxi, Amax] = maxindex(Amp(:,k));
    phi(:,k) = phi(:,k) - phi(Amaxi, k);
	
	if DStruct.cutoff > 0
		phi(find(Amp(:,k) < DStruct.cutoff * Amax),k) = NaN;
	end
end

Amp_scaled = quickscalecolumn(Amp);
[ax,h1,h2] = plotyy2(x, Amp_scaled, x, phi, DStruct.plotfunMag, DStruct.plotfunPhase);

set(get(ax(1),'YLabel'), 'String', DStruct.zlabelMag, 'FontSize', get(ax(1),'FontSize'), ...
    'Rotation', 90, 'VerticalAlignment', 'middle');
set(get(ax(2),'YLabel'), 'String', DStruct.zlabelPhase, 'FontSize', get(ax(2),'FontSize'), ...
    'Rotation', 270, 'VerticalAlignment', 'middle');

if ~isempty(DStruct.axis)
    axiscell = cellstr(DStruct.axis);
    axis(ax, axiscell{:});
end

title(DStruct.title);

if isempty(DStruct.zlimMag)
    set(ax(1), 'YLim', [0, Inf]);
else
    set(ax(1), 'YLim', sort(DStruct.zlimMag));
end

if isempty(DStruct.zlimPhase)
    set(ax(2), 'YLim', [-Inf, Inf]);
else
    set(ax(2), 'YLim', sort(DStruct.zlimPhase));
end

if ~isempty(DStruct.xlabel)
%     set(get(ax(1),'XLabel'), 'String', DStruct.xlabel)
    xlabel(DStruct.xlabel);
end

% h = get(ax(2),'Children');
% h = findobj(h, 'LineStyle', '-');
% set(h, 'LineStyle', ':');

% hold_state = ishold;
% set(gcf,'nextplot','add')
% ax(3) = axes('position',get(ax(2),'position'));
% set(ax(3),'color','none', 'xgrid', 'off', 'ygrid','off','box','on')
% set(ax(3),'XTickMode','manual','YTickMode','manual')

if isempty(DStruct.xlim)
    set(ax, 'XLim', [min(x), max(x)]);
else
    set(ax, 'XLim', sort(DStruct.xlim));
end

if ~isempty(DStruct.colorseqMag)
    for k = 1 : length(DStruct.colorseqMag)
        set(h1(k), 'Color', DStruct.colorseqMag{k});
    end
end

if ~isempty(DStruct.colorseqPhase)
    for k = 1 : length(DStruct.colorseqPhase)
        set(h2(k), 'Color', DStruct.colorseqPhase{k});
    end
end

% DeleteProxy=findobj('tag','PlotyyDeleteProxy')
% 
% DeleteProxy = text('parent',ax(3),'visible','off',...
%                        'tag','PlotyyDeleteProxy',...
%                        'handlevisibility','off',...
%         'deletefcn','try;delete(get(gcbo,''userdata''));end');
% set(DeleteProxy(3),'userdata',DeleteProxy(2));

% if ~hold_state, hold off, end

% set(gcf,'currentaxes',ax(1));

if nargout > 0, axout = ax; end

if DStruct.drawnow
    drawnow;
end