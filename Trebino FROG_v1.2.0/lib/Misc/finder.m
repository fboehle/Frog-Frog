function [index,value] = finder(A,target)
% FINDMORE(A,TARGET) will find the next closest VALUE to the
% TARGET in A, and return the INDEX.

[MI,MV] = findmore(A,target);
[LI,LV] = findless(A,target);
if (MV - target < target - LV)
    index = MI;
    value = MV;
else
    index = LI;
    value = LV;
end