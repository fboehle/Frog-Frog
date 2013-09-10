function [axout,h1,h2] = plotcmplxI(x,z,varargin)
%PLOTCMPLXI Graphs intensity labels on the left and phase labels on the right.
%   PLOTCMPLXI is now a shorthand of PLOTCMPLX with DisplayStruct.plotvalue
%   set to 'intensity'.
%
%   PLOTCMPLXI(X,Z) plots ABS(Z).^2 versus X with y-axis labeling
%   on the left and plots ANGLE(Z) versus X with y-axis 
%   labeling on the right.
%
%   PLOTCMPLXI(X, Z, DISPLAYSTRUCT) uses options specified in DISPLAYSTRUCT
%   to plot the magnitude and phase of Z.  The related options in DISPLAYSTRUCT
%   are:
%               xlim: default [] (full range);
%            zlimMag: intensity limits, default [] (full range);
%          zlimPhase: phase limits, default [] (full range);
%             xlabel: default '';
%          zlabelMag: default 'Intensity';
%        zlabelPhase: default 'Phase (rad)';
%              title: default '';
%         plotfunMag: plot funtion for intensity, default @plot;
%       plotfunPhase: plot funtion for phase, default @plot;
%             unwrap: logical specifying whether to unwrap phase, default true;
%             cutoff: percentage of maximum intensity below which phase is
%                     blanked, default 0.
%
%   PLOTCMPLXI(X,Z,FUN) uses the plotting function FUN for the amplitude plot
%   instead of PLOT to produce each plot.  FUN should be a 
%   function handle to a plotting function, e.g. @plot, @semilogx,
%   @semilogy, @loglog ,@stem, etc. that accepts the syntax H = FUN(X,Y).
%
%   PLOTCMPLXI(X,Z,FUN1,FUN2) uses FUN1(X,ABS(Z)) to plot the data for
%   the left axes and FUN2(X,UNWRAP(ANGLE(Z))) to plot the data for
%   the right axes.
%
%   [AX,H1,H2] = PLOTCMPLXI(...) returns the handles of the two axes created in
%   AX and the handles of the graphics objects from each plot in H1
%   and H2. AX(1) is the left axes and AX(2) is the right axes.
%
%   See also PLOTCMPLX, PLOT, PLOTYY, @.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

error(nargchk(2,5,nargin))

[fun1, fun2, blank] = parsevarargin(varargin, @plot, @plot, -1);

if isa(fun1, 'function_handle')
    DStruct = DisplayStructSet('plotfunMag', fun1, 'plotfunPhase', fun2, 'cutoff', blank, 'plotvalue', 'intensity');
elseif isstruct(fun1)
    DStruct = DisplayStructSet(fun1, 'plotvalue', 'intensity');
else
    error('Unrecognized arguments in plotcmplx.');
end

[ax, h1, h2] = plotcmplx(x, z, DStruct);

if nargout > 0, axout = ax; end