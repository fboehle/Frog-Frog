function [Et, t, Ew, w ] = pulsegenerator(varargin)
%PULSEGENERATOR Generates a pulse.
%
%		[Et, t, Ew, w ] = PULSEGENERATOR([])
%
%	PULSEGENERATOR(N) returns an N point random function.
%	PULSEGENERATOR([N, m]) returns an N point random function, with the
%	random generator initialized in state m.
%
%	PULSEGENERATOR(N, @shapefunction, FWHM, deltat, lambda) returns an N
%	point function  of type shapefunction or the rand() function.
%
%			Shapefunction Definition
%				Eenv = shapefunction(t,FWHM)
%
%		FWHM is the length of the function in fs; deltat is the time
%		increment in fs; lambda is the center wavelength in nm. 
%
%	PULSEGENERATOR(...,temporalphase,SPM) returns a pulse of type
%		shapefunction with a polynomial temporal phase.  Temporal phase is
%		of form [A,B,C,...] which corresponds to the polynomial:
%
%			A*x^0 + B*x^1 + C*x^2 + ...
%
%		SPM is Self-Phase Modulation. temporal phase = SPM.*abs(Eenv).^2
%
%	PULSEGENERATOR(...,spectralphase) returns a pulse of type shapefunction
%		with a polynomil spectral phase. Spectral phase is of form
%		[A,B,C,...] which corresponds to the polynomail:
%
%			A*x^0 + B*x^1 + C*x^2 + ...
%
%   Defaults:
%		N = 1024; shapefunction = rand(); FWHM = 40; deltat = 1; lamba = 800
%
%	PULSEGENERATOR(..., PREVIEW) plots a preview of the pulse.  Defaults to false.
%
%   PULSEGENERATOR(..., DSTRUCTCELL) uses display options specified in
%   DSTRUCTCELL.  DSTRUCTCELL can be either a two-element DisplayStruct
%   cell array, whose elements specifies the temporal and spectral plot
%   options, respectively; or it can be a DisplayStruct structure, which
%   will be applied to both plots.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $


error(nargchk(0,10,nargin)); 

N0 = 1024;  
shapefunction = @rand;
FWHM = 40;
deltat = 1;
lambda = 800;
temporalphase = 0;
SPM = 0;
spectralphase = 0;
preview = false;

[N0, shapefunction, FWHM, deltat, lambda, temporalphase, SPM, spectralphase, preview, DStructCell] = ...
	parsevarargin(varargin, ...
	N0, shapefunction, FWHM, deltat, lambda, temporalphase, SPM, spectralphase, preview, ...
    DisplayStructSet);

if isstruct(DStructCell)
    DStructCell = {DStructCell, DStructCell};
elseif ~(iscell(DStructCell) && length(DStructCell) == 2)
    error('DStructCell parameter must be either a DisplayStruct or a two-element cell array of DisplayStruct.');
end

if (length(N0) == 1)
    N = N0;
elseif (length(N0) == 2)
    N = N0(1);
    rand('state', N0(2));
else
    error('First parameter too long.');
end

% calculate the envelope of the pulse
t = (-N/2 : N/2 - 1) * deltat;

if strcmp(func2str(shapefunction),'rand')
	Et = rand(size(t)) .* exp(i*2*pi*rand(size(t)));
else
	Et = feval(shapefunction,t,FWHM);
end

% calculate the temporal phase
if any(temporalphase)
	tphase = polyval(fliplr(temporalphase),t);
	
	% apply the phase to the pulse
	Et= Et.*exp(i.*tphase);
end

if SPM ~= 0;
	tphase = SPM .* abs(Et) .^ 2;
	Et= Et.*exp(i.*tphase);
end

% center omega = 2 pi c/lambda
omega0 = ltow(lambda);

% calculate Ew from Et
Ew = fftc(Et);

% calculate w
deltaomega = 2 * pi / N / deltat;

w = (-N/2:N/2-1)*deltaomega + omega0;

% add spectral phase
if any(spectralphase)
	sphase = polyval(fliplr(spectralphase),w-omega0);
	Ew = Ew .* exp(-i * sphase);
	Et = ifftc(Ew);
end

if preview
	H = FindHiddenFig('Name', 'Pulse Preview');
	
	if isempty(H) | ~ishandle(H)
		H = figure('IntegerHandle', 'off', 'NumberTitle', 'off', 'Name', 'Pulse Preview');
		rect = get(H, 'Position');
		rect(2) = rect(2) - rect(4);
		rect(4) = 2.0 * rect(4);
		set(H, 'Position', rect);
	end
	
	set(H, 'HandleVisibility', 'on');
	figure(H);
	
	clf;
	
	subplot 211
	DStruct = DisplayStructSet(DStructCell{1}, 'xlabel', 'Time', 'title', 'Temporal Pulse', 'axis', 'tight');
    plotcmplx(t, Et, DStruct);
	
	subplot 212
	DStruct = DisplayStructSet(DStructCell{2}, 'xlabel', 'Frequency', 'title', 'Spectral Pulse', 'axis', 'tight');
	plotcmplx(w, Ew, DStruct);

	set(H, 'HandleVisibility', 'off');
end
