function [Time,ET] = doublesize(Time,ET)
%   DOUBLESIZE(Time,ET) takes a complex field ET as a function of Time, and
%   doubles the size of the trace, padding both sides with zeros, keeping
%   the time spacing constant, and Time=0 at the center.
%
%   If ET is actually a 2D Esig, like a cropped FROG trace, doublesize
%   will still work.

MatSize = length(Time);
DT = mean(diff(Time));
patmat = zeros(1,floor(MatSize/2));
if ndims(ET) == 2
    padmat = zeros(size(ET,1),floor(size(ET,2)/2));
    ET = [padmat,ET,padmat];
    n=size(ET,2);
    Time = (-n/2:n/2-1).*DT;
elseif iscolumn(ET)
        ET = [padmat,ET',padmat];
        ET = ET';
        n=length(ET);
        Time = (-n/2:n/2-1).*DT;
        Time = Time';
    else
        ET = [padmat,ET,padmat];
        n=length(ET);
        Time = (-n/2:n/2-1).*DT;
    end