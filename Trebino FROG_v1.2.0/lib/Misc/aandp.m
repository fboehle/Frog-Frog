function [Amplitude, Phase] = AandP(E,varargin)
% AANDP Amplitude and phase of a complex field.
%
%   [AMPLITUDE,PHASE] = AANDP(E,UNWRAPPING) returns the normalized AMPLITUDE
%   and PHASE of a complex field E.  The PHASE is the opposite of the
%   argument of E, and will be unwrapped if UNWRAPPING is set to 'ON', or
%   left untouched otherwise.

error(nargchk(1,2,nargin))

[unwrapping] = parsevarargin(varargin,'ON');

Amplitude = quickscale(abs(E));

if unwrapping == 'ON'
    Phase = -unwrap(angle(E));
else
    Phase = -angle(E);
end

% Sets Phase equal to 0 at the peak values
Phase = Phase - Phase(maxindex(Amplitude));