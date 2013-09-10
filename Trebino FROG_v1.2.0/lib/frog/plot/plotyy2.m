function [axout,h1,h2]=plotyy2(x1,y1,x2,y2,fun1,fun2)
%PLOTYY2 Graphs with y tick labels on the left and right.
%   PLOTYY2(X1,Y1,X2,Y2) plots Y1 versus X1 with y-axis labeling
%   on the left and plots Y2 versus X2 with y-axis labeling on
%   the right.
%
%   PLOTYY2(X1,Y1,X2,Y2,FUN) uses the plotting function FUN 
%   instead of PLOT to produce each plot.  FUN should be a 
%   function handle to a plotting function, e.g. @plot, @semilogx,
%   @semilogy, @loglog ,@stem, etc. that accepts the syntax H = FUN(X,Y).
%
%   PLOTYY2(X1,Y1,X2,Y2,FUN1,FUN2) uses FUN1(X1,Y1) to plot the data for
%   the left axes and FUN2(X1,Y1) to plot the data for the right axes.
%
%   [AX,H1,H2] = PLOTYY2(...) returns the handles of the two axes created in
%   AX and the handles of the graphics objects from each plot in H1
%   and H2. AX(1) is the left axes and AX(2) is the right axes.  
%
%   See also PLOTYY, PLOT, @.


%   $Revision: 1.1 $  $Date: 2006-11-11 00:15:35 $

if nargin<4, error('Not enough input arguments.'); end
if nargin<5, fun1 = @plot; end
if nargin<6, fun2 = fun1; end

cax = newplot;
fig = get(cax,'Parent');
hold_state = ishold(cax);
co = get(fig,'DefaultAxesColorOrder');

% Plot first plot
ax(1) = cax;
set(fig, 'Nextplot', 'add');
h1 = feval(fun1,x1,y1);
set(ax(1), 'Box', 'off');

% Plot second plot
ax(2) = axes('units',		get(ax(1),'units'), ...
			 'position',	get(ax(1),'position'), ...
			 'FontName',	get(ax(1),'FontName'), ...
			 'FontUnits',	get(ax(1),'FontUnits'), ...
			 'FontSize',	get(ax(1),'FontSize'), ...
			 'FontWeight',	get(ax(1),'FontWeight'), ...
			 'FontAngle',	get(ax(1),'FontAngle') ...
			 );
h2 = feval(fun2,x2,y2);
% set(fig,'Nextplot','add')
set(ax(2),'YAxisLocation','right', 'XAxisLocation', 'top', ...
    'XTickLabel', '', 'Color','none', 'XGrid','off','YGrid','off','Box','off');
set(get(ax(2), 'Children'), 'LineStyle', ':');
% h = findobj(ax(2), 'LineStyle', '-');
% set(h, 'LineStyle', ':');

% ax(3) = axes('position', get(ax(1),'position'));
% set(ax(3),'color','none', 'xgrid','off','ygrid','off','box','on')
% % set(ax(3),'XTickMode','manual','YTickMode','manual')

% create DeleteProxy objects (an invisible text object in
% the first axes) so that the other axes will be deleted
% properly.
DeleteProxy(1) = text('parent',ax(1),'visible','off',...
                      'tag','PlotyyDeleteProxy',...
                      'handlevisibility','off',...
        'deletefcn','delete(get(gcbo,''userdata''))');
DeleteProxy(2) = text('parent',ax(2),'visible','off',...
                       'tag','PlotyyDeleteProxy',...
                       'handlevisibility','off',...
        'deletefcn','delete(get(gcbo,''userdata''))');
set(DeleteProxy(1),'userdata',ax(2));
set(DeleteProxy(2),'userdata',DeleteProxy(1));

if ~hold_state, hold off, end

% Reset colororder
set(gcf,'defaultaxescolororder',co,'currentaxes',ax(1))

if nargout>0, axout = ax; end

