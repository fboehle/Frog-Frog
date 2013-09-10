function [axout,h1,h2] = plotcmplx(x,z,varargin)
%PLOTCMPLX Graphs amplitude labels on the left and phase labels on the right.
%   PLOTCMPLX(X,Z) plots ABS(Z) versus X with y-axis labeling
%   on the left and plots UNWRAP(ANGLE(Z)) versus X with y-axis 
%   labeling on the right.
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
%   See also PLOTCMPLXI, PLOT, PLOTYY, @.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

error(nargchk(2,5,nargin))

[fun1, fun2, blank] = parsevarargin(varargin,@plot,@plot, -1);

% disp([size(x), size(z)])

if (size(x,1) ~= size(z,1) & size(x,1) == size(z,2)) | ...
		(size(x,2) ~= size(z,2) & size(x,2) == size(z,1))
	z = z.';
end

% disp([size(x), size(z)])

if isrow(x)
	x = x.';
	z = z.';
end

% disp([size(x), size(z)])

Amp = abs(z);

phi = -unwrap(angle(z), [], 1);

for k = 1:size(z,2)
	phi(:,k) = -unwrap(angle(z(:,k)));
	
	phi(:,k) = phi(:,k) - phi(maxindex(Amp(:,k)),k);
	
	if blank > 0
		phi(find(Amp(:,k)<blank),k) = NaN;
	end
end

[ax,h1,h2] = plotyy2(x, Amp, x, phi, fun1, fun2);

set(get(ax(1),'YLabel'),'String','Amplitude (a.u.)','Rotation',90, ...
	'VerticalAlignment','bottom', ...
	'FontName',	get(ax(1),'FontName'), ...
	'FontUnits',	get(ax(1),'FontUnits'), ...
	'FontSize',	get(ax(1),'FontSize'), ...
	'FontWeight',	get(ax(1),'FontWeight'), ...
	'FontAngle',	get(ax(1),'FontAngle') ...
	);
set(get(ax(2),'YLabel'),'String','Phase (rad)','Rotation',270, ...
	'VerticalAlignment','bottom', ...
	'FontName',	get(ax(1),'FontName'), ...
	'FontUnits',	get(ax(1),'FontUnits'), ...
	'FontSize',	get(ax(1),'FontSize'), ...
	'FontWeight',	get(ax(1),'FontWeight'), ...
	'FontAngle',	get(ax(1),'FontAngle') ...
);
axis(ax,'tight');

if nargout > 0, axout = ax; end
