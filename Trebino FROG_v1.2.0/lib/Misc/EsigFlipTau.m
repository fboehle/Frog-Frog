function Esigp = EsigFlipTau(Esigm)
%ESIGFLIPTAU flips the sign of tau in the definition of Esig(t, tau).
%   ESIGFLIPTAU converts Esigm = P(t) * G(t - tau)
%               to       Esigp = P(t) * G(t + tau)

%   $Revision: 1.1 $   $Date: 2006-11-11 00:15:34 $

Ntau = size(Esigm, 2);

for n = 1 : Ntau
    Esigp(:, n) = circshift(Esigm(:, n), Ntau / 2 + 1 - n);
end