function [Et1, Z, X, p, p1] = MinZerr_shg(Esig, Et, dZ)

p1 = MinZerrKern_pg(Esig,Et,dZ);

p = polyder(p1);

r = roots(p)';

X = r(find(imag(r) == 0));

% for k = 1:length(X)
% 	Et1 = Et + X(k) * dZ;
% 
% 	Z(k) = Zerr(Esig, CalcEsig(Et1,Et1,size(Esig,2)/size(Esig,1)));
% end

Z = polyval(p1,X);

[Z,Indx] = sort(Z);
X = X(Indx);

Z = Z(1);
X = X(1);

Et1 = Et + X * dZ;
