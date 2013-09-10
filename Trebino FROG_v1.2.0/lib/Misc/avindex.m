function [ ia ] = avindex(iv, ArraySize)
%AVINDEX is the anti-vectorizing index look-up function.  It calculates the array
%   indices from a corresponding vectorized index- of the array.
%
%   Usually B = A(:) vectorizes array A.
%   Ia = avindex(Ib, ArraySize) calculates the array indices for B such that
%   A(Ia) and B(Ib) reference the same element.  ArraySize is the size of
%   A.

N = prod(ArraySize);
ia = zeros(1, length(ArraySize));
iv = iv - 1;

for idim = length(ArraySize) : -1 : 2
    N = N / ArraySize(idim);
    m = mod(iv, N);
    ia(idim) = (iv - m) / N + 1;
    iv = m;
end

ia(1) = iv + 1;