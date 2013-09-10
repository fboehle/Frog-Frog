function Et_c = BestPulseForm(Et, varargin)
%BestPulseForm normalizes and centers a pulse E(t).
%
%   Et_c = BestPulseForm(Et, CenterMethod, AmpMethod, PhaseMethod) uses the
%   specified CenterMethod, AmpMethod and PhaseMethod to normalize and
%   center a pulse E(t).
%   
%   Options of CenterMethod are:
%       'max':      The maximum intensity point.
%       'moment':   The center-of-mass point of the intensity profile.
%   Options of AmpMethod are:
%       'max':      The maximum intensity point is normalized to 1.
%       'moment':   The intensity of the center-of-mass intensity point is 
%                   normalized to 1.
%       'energy':   The total pulse energy (integrated intensity)
%                   is normalized to 1.
%   Options of PhaseMethod are:
%       'max':      The phase of the maximum intensity point is set to 0.
%       'moment':   The phase of the center-of-mass intensity point is set 
%                   to 0.
%
%   The default CenterMethod is 'moment', the default AmpMethod is 'max',
%   the default PhaseMethod is 'moment'.

[CenterMethod, AmpMethod, PhaseMethod] = parsevarargin(varargin, 'moment', 'max', 'moment');

N = length(Et);
[Amax, Cmax] = max(abs(Et));
Cmoment = moment(magsq(Et));

T0 = 1 : N;

switch lower(AmpMethod)
    case 'max'
        Et_c = Et / Amax;
    case 'energy'
        En = sum(magsq(Et));
        Et_c = Et / En;
    case 'moment'
        Et_c = Et / abs(Et(floor(Cmoment)));
end;

switch lower(PhaseMethod)
    case 'max'
        Et_c = Et_c * exp(-i * angle(Et(Cmax)));
    case 'moment'
        Et_c = Et_c * exp(-i * angle(Et(floor(Cmoment))));
end


switch lower(CenterMethod)
    case 'max'
        Et_c = shift(Et_c, floor(N / 2) + 1 - Cmax);
    case 'moment'
        Et_c = interp1(T0, Et_c, T0 - floor(N / 2) - 1 + Cmoment, [], 0);
end

Et_c = reshape(Et_c, size(Et));