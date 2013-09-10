function [pol, ang] = polstate(polcell)
%POLSTATE returns polarization and angle.
%	[POL, ANG] = POLSTATE(POLCELL) returns polarization and angle.
%
%   Allowed POLCELL designations include:
%       'o' or 'e', specifying o/e optical axis;
%       ang, specifying crystal angle ang;
%       or cell form {pol, ang}.

if ischar(polcell)
    pol = polcell;
    switch upper(pol)
        case 'O'
            ang = 0;
        case 'E'
            ang = pi / 2;
        otherwise
            error('Improper polarization state designation.');
    end        
elseif isnumeric(polcell)
    pol = 'e';
    ang = polcell;
elseif iscell(polcell)
    pol = polcell{1};
    ang = polcell{2};
else
    error('Improper polarization state designation.');
end