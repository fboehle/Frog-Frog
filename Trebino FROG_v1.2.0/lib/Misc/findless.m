function [index,value] = findless(A,target)
% FINDLESS(A,TARGET) will find in A the next smallest VALUE
% to the TARGET value and return the INDEX.

error(nargchk(2,2,nargin));

found = find(A <= target);
findex = maxindex(A(found));
index = found(findex);
value = A(index);