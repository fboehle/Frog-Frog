function dl = dt2dl(dt, l0, tbp0)

if nargin < 3
    tbp0 = tbp('fgaussian', 'fwhm');
end

dw = 2 * pi * tbp0 / dt;

dl = dw2dl(dw, l0);