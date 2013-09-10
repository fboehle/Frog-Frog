function Mnorm = NormArray(M)
%NORMARRAY normalizes matrix rows
%   MNORM = NORMARRAY(M) normalizes the rows of matrix M by dividing each row
%   by the maximum pixel in that row.

%   $Revision: 1.1 $    $Date: 2007-05-01 15:34:37 $
%
%   $Log: normarray.m,v $
%   Revision 1.1  2007-05-01 15:34:37  pablo
%   replaced with lowercase
%
%   Revision 1.1  2006-11-11 00:15:34  pablo
%   CVS server re-installation
%
%   Revision 1.3  2001/10/22 16:28:04  zeekec
%   Corrected help
%
%   Revision 1.2  2001/10/21 07:48:27  xg
%   misc
%
%   Revision 1.1  2001/10/21 07:46:41  xg
%   Created
%

Mnorm = diag(1 ./ max(M')) * M;