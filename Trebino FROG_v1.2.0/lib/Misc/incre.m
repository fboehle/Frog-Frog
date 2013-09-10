function dx = incre(x)
%INCRE(X) returns the increment value (step size) of vector X.

dx = (x(end) - x(1)) / (length(x) - 1);