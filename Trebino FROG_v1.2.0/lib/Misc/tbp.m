function p = TBP(varargin)
%p=TBP(PulseShape, WidthDef) gives the time-bandwidth product of the given
%pulse shape and width definition.
%
%   PulseShape defaults to 'fgaussian', and WidthDef defaults to 'FWHM'.

error(nargchk(0, 2, nargin));

[PulseShape, WidthDef] = parsevarargin(varargin, 'fgaussian', 'FWHM');

switch upper(PulseShape)
    case {'FGAUSSIAN', 'GAUSSIAN'}
        switch upper(WidthDef)
            case 'FWHM'
                p = 0.441;
        end
end