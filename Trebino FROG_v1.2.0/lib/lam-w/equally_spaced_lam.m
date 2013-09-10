function lam = equally_spaced_lam(w)

c = 300;
n = length(w);
if n == 0
    lam = [];
else if n == 1
        lam = wtol(w);
    else
        lmin=2*pi*c/max(w);
        lmax=2*pi*c/min(w);
        dl = (lmax-lmin)/n;
        lam = (lmax:-dl:lmin+dl);
    end
end