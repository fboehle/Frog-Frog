function [ac,freq] = marginals(X)
%MARGINALS FROG marginals
%	AC = MARGINALS(X) returns the delay marginal of the FROG
%	trace X.  The frst dimention of X is the time/frequency,
%	and the second dimention is delay.
%
%	[AC,FREQ] = MARGINALS(X) As above plus returns the frequency
%	marginal.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

error(nargchk(1,1,nargin))
ac = sum(X,1);
if nargout > 1
	freq = sum(X,2);
end