function [Et1, Z, X, p, p1] = MinZerr_thg(Esig, Et, dZ)

p1 = MinZerrKern_thg(Esig,Et,dZ);

p = polyder(p1);

r = roots(p);

X = r(find(imag(r) == 0))';

% for k = 1:length(X)
% 	Et1 = Et + X(k) * dZ;
% 
% 	Z(k) = Zerr(Esig, CalcEsig(Et1,Et1,size(Esig,2)/size(Esig,1)));
% end

Z1 = polyval(p1,X);

[Z, minZIndx] = min(Z1);

% Assign eps value to calculated Z values that are lower
Zmin = eps * p1(end);
if Z < Zmin
    Z = Zmin;
end

Z = sqrt(Z);
X = X(minZIndx);

Et1 = Et + X * dZ;