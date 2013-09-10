function b = shift(a,p,padvalue)
%SHIFT Shift array linearly.
%   B = SHIFT(A, SHIFTSIZE, PADVALUE) linearly shifts the values in the
%   array A by SHIFTSIZE elements, padding vacated elements with PADVALUE.
%   SHIFTSIZE is a vector of integer scalars where the N-th element
%   specifies the shift amount for the N-th dimension of array A.  If an
%   element in SHIFTSIZE is positive, the values of A are shifted down
%   (or to the right). If it is negative, the values of A are shifted up
%   (or to the left).   PADVALUE defaults to 0.
%
%   Please note that this function applies to matrices.  Therefore, a row
%   vector will be treated as a 1xN matrix, which will then need a matrix-
%   form SHIFTSIZE [0 k] to shift the vector by k elements.
%
%   Class Support
%   -------------
%   A can be of any class.  B is of the same class as A.
%
%   Example
%   -------
%   A = [ 1 2 3;4 5 6; 7 8 9];
%   B = shift(A,1);% shifts first dimension values down by 1, padding with 0.
%   B =     0     0     0
%           1     2     3
%           4     5     6
%
%   B = shift(A,[1 -1], 1); % shifts first dimension values down by 1 and
%                           % second dimension left by 1, padding with 1.
%   B =     1     1     1
%           2     3     1
%           5     6     1
%
%   See also CIRCSHIFT.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:35 $
%
%   $Log: shift.m,v $
%   Revision 1.1  2006-11-11 00:15:35  pablo
%   CVS server re-installation
%
%   Revision 1.2  2001/10/30 03:16:30  xg
%   CVS keywords corrected
%

error(nargchk(2, 3, nargin));

if nargin < 3
	padvalue = 0;
end

[p, sizeA, numDimsA, msg] = ParseInputs(a,p);
if (~isempty(msg))
    error(msg);
end

b = ones(sizeA) * padvalue;

for k = 1 : numDimsA
    m = sizeA(k);
    temp = (1 : m) - p(k);
    inrange{k} = find(temp > 0 & temp <= m);
    newidx{k} = temp(inrange{k});
end

b(inrange{:}) = a(newidx{:});


%%%
%%% Parse inputs
%%%
function [p, sizeA, numDimsA, msg] = ParseInputs(a,p)

% default values
sizeA    = size(a);
numDimsA = ndims(a);
msg      = '';

sh        = p(:);
isFinite  = all(isfinite(sh));
isInteger = all(isa(sh,'double') & (imag(sh)==0) & (sh==round(sh)));
isVector  = ((ndims(p) == 2) & ((size(p,1) == 1) | (size(p,2) == 1)));

if ~(isFinite & isInteger & isVector)
    msg = 'Invalid shift type: must be a finite, real integer vector.';
    return;
end

% Make sure the shift vector has the same length as numDimsA. 
% The missing shift values are assumed to be 0. The extra 
% shift values are ignored when the shift vector is longer 
% than numDimsA.
if (prod(size(p)) < numDimsA)
   p(numDimsA) = 0;
end


