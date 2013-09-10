function y = flattop(x, FWHM)

y = zeros(size(x));
index_ones = find((x > -round(FWHM/2)) & (x < round(FWHM/2)));
y(index_ones) = 1;