function Y = lorentzian( X, x0, dx)

Y = 1 ./ (1 + i*(X - x0)/dx);
