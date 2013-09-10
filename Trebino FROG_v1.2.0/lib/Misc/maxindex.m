function [I,Y] = maxindex(X,dim)
%MAXINDEX    Largest component index.
%   For vectors, MAXINDEX(X) is the index of the largest element in X. For matrices,
%   MAXINDEX(X) is a row vector containing the index of the maximum element from each
%   column. For N-D arrays, MAXINDEX(X) operates along the first
%   non-singleton dimension.
%   If the values along the first non-singleton dimension contain more
%   than one maximal element, the index of the first one is returned.
%
%   [I,Y] = MAXINDEX(X) returns the maximum values in vector Y.
%
%   [I,Y] = MAXINDEX(X,DIM) operates along the dimension DIM. 
%
%   When complex, the magnitude MAX(ABS(X)) is used.  NaN's are
%   ignored when computing the maximum.
%
%   See also MAX, MIN, MEDIAN, MEAN, SORT.

%   $Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

error(nargchk(1,2,nargin))

if nargin < 2 | isempty(dim)
    [Y,I] = max(X);
else
    [Y,I] = max(X,[],dim);
end
