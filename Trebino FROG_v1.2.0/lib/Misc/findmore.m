function [index,value] = findmore(A,target)
% FINDMORE(A,TARGET) will find in A the next largest VALUE
% to the TARGET value and return the INDEX.

error(nargchk(2,2,nargin));

found = find(A >= target);
findex = minindex(A(found));
index = found(findex);
value = A(index);