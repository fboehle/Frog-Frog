function [Int,Phs] = phaseblank(E,varargin);

% [INT,PHS] = PHASEBLANK(E,THRESH,WRAPPING) returns the INTensity and
% PHaSe of an E-field, leaving the phase as "NaN" when
% the associated intensity is less that the THRESHold.
% By default, phase WRAPPING is 'ON'.
%
% See also:  IANDP, AANDP, IPSAVE

error(nargchk(1,3,nargin))

thresh = .005;
wrapping = 'ON';

[thresh,wrapping] = parsevarargin(varargin,thresh,wrapping);

[Int,Phs] = IandP(E,wrapping);
Phs(find(Int<thresh)) = NaN;