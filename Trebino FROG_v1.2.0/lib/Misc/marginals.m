function [ac,freq] = marginals(X)
%MARGINALS FROG marginals
%	AC = MARGINALS(X) returns the delay marginal of the FROG
%	trace X.  The frst dimention of X is the time/frequency,
%	and the second dimention is delay.
%
%	[AC,FREQ] = MARGINALS(X) As above plus returns the frequency
%	marginal.

%	v1.0, 6/22/01, Erik Zeek, <zeekec@mad.scientist.com>

error(nargchk(1,1,nargin))
ac = sum(X,1);
if nargout > 1
	freq = sum(X,2);
end