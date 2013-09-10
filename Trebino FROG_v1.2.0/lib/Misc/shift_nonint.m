function b = shift_nonint(a,p,padvalue)
%SHIFT_NONINT Shift array linearly by a non-integer value.
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
%   $Log: shift_nonint.m,v $
%   Revision 1.1  2006-11-11 00:15:35  pablo
%   CVS server re-installation
%
%   Revision 1.1  2005/08/06 18:38:56  xg
%   *** empty log message ***
%
%   Revision 1.2  2001/10/30 03:16:30  xg
%   CVS keywords corrected
%

error(nargchk(2, 3, nargin));

if nargin < 3
	padvalue = 0;
end

[p, sizeA, numDimsA, X, msg] = ParseInputs(a,p);
if (~isempty(msg))
    error(msg);
end

b = interpn(a, X{:}, 'cubic', 0);

%%%
%%% Parse inputs
%%%
function [p, sizeA, numDimsA, X, msg] = ParseInputs(a,p)

% default values
sizeA    = size(a);
numDimsA = ndims(a);
msg      = '';

sh        = p(:);
isFinite  = all(isfinite(sh));
isReal = all(isa(sh,'double') & (imag(sh)==0));
isVector  = ((ndims(p) == 2) & ((size(p,1) == 1) | (size(p,2) == 1)));

if ~(isFinite & isReal & isVector)
    msg = 'Invalid shift type: must be a finite, real vector.';
    return;
end

% Make sure the shift vector has the same length as numDimsA. 
% The missing shift values are assumed to be 0. The extra 
% shift values are ignored when the shift vector is longer 
% than numDimsA.
if (prod(size(p)) < numDimsA)
   p(numDimsA) = 0;
end

Vone = ones(1, numDimsA);

for k = 1 : numDimsA
    V = Vone;
    V(k) = sizeA(k);
    X{k} = reshape(1 : sizeA(k), V) - p(k);
end