function AC = frac(Et, t, w0)

Ones = ones(size(Et));
Esig = Et(:) * exp(-i * w0 * t(:)') + CalcEsig(Ones, Et);
AC = sum(magsq(Esig).^2, 1);