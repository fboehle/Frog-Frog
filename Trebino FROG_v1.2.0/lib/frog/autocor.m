function AC = autocor(Et)

Esig = CalcEsig(Et, Et);
AC = sum(magsq(Esig), 1);