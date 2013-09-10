function E = FLIPTIME(E)
%   FLIPTIME(E) Flips the direction of time for a complex  field E,
%   also flipping the phase correctly, returning the flipped E.
% 
if iscolumn(E)
    E = E';
    E = conj(fliplr(E));
    E = E';
else
    E = conj(fliplr(E));
end