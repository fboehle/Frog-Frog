function [Et1, Z] = MinZerr_X(Esig, Et, G)

n = length(Et);

G0 = sum(magsq(G(:)));

G = G(:);

A = [G(n / 2 + 1 : +1 : end); zeros(n / 2 - 0, 1)];
B = [G(n / 2 + 1 : -1 :   1); zeros(n / 2 - 1, 1)];

Et1 = sum(Esig .* toeplitz(A, B), 2)/G0;

Et1 = Et1 * max(abs(Et))/max(abs(Et1));

Z = Zerr(Esig, CalcEsig(Et1, G));