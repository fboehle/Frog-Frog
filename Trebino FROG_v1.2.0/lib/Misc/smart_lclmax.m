function [pks,h] = smart_lclmax(B);

% This program changes the threshold for the lclmax function until three 
% peaks are found.
% If the minimum threshold is reached, then an empty pks vector, or one
% with less than three pks will be returned.  
% Use the program like this: [pks,h] = smart_lclmax(B);  
% B is a vector, pks is a vector containing the location of the three peaks
% and h is the height of each of the pks.

%options
tmin = .02;  %minimal threshold value used
t = .1;  %initial threshold value

if max(B)~= 1
    B = Norm(B);
end

[pks, h] = lclmax(B,1,t);
l = length (pks);

while l > 3; 
    t = t+.005;
    [pks, h] = lclmax(B,1,t);
    l = length(pks);
end

while l < 3 &t>tmin;
    t = t-.005;
    [pks, h] = lclmax(B,1,t);
    l = length(pks);
end

if length(pks)<3;
    display('less than three peaks were found')
end
