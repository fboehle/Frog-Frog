function A1 = quickscaleColumn(A)

for ci = 1 : size(A, 2)
    A1(:, ci) = quickscale(A(:, ci));
end