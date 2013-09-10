function [ X ] = ExtraInfo( X )
%EXTRAINFO gets the extra information from the user, for the XFROG program.

%	$Id: ExtraInfo.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% Use uipulsegen to get the gate pulse.
[Gt, T, Gw, W] = uipulsegen;

% Default gate pulse shape
if isempty(Gt) && isempty(X.Gt)
    [Gt, T, Gw, W] = pulsegenerator(128, @fgaussian, 3, 30, 800);
end

if ~isempty(Gt)
    % Make sure that it has the proper scaling.
    Gt = interp1(T, Gt, get(X, 'tau'), 'spline', 0);

    % Store the gate information.
    X.Gt = Gt;
    X.Gw = fftc(Gt);
    X.wg = ttow(get(X, 'tau'), W(floor(end/2)+1));
end