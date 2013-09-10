% This m-file loads two different images that are assumed to vary by only a gamma
% factor.
%
%Load the files
load gamma1.txt %Gamma=1
load gamma045.txt %Gamma=0.45
% Normalize to largest value
gamma1 = gamma1/max(max(gamma1));
gamma045 = gamma045/max(max(gamma045));
% Now test for gammas
minmeansquareerror = 9E99;
for x=1.0:0.025:2.3
    meansquareerror=sqrt(sum(sum((gamma045.^x-gamma1).^2)));
    if (minmeansquareerror > meansquareerror)
        minmeansquareerror = meansquareerror;
        bestgamma = 1/x;
    end
    x,meansquareerror
end
    '  '
    'Best Gamma is ',bestgamma
    