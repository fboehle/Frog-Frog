function X = nonegatives(X,repl,thresh)
%NONAEGATIVES Replaces negative values.
%   NONAEGATIVES(X) Replaces neagtive values in X with 0.
%
%   NONAEGATIVES(X,REPL) Replaces negative values with REPL.
%
%   NONAEGATIVES(X,REPL,THRESH) Replaces values less than THRESH with REPL.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $
%
%	$Log: nonegatives.m,v $
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.3  2001/10/08 20:40:58  zeekec
%	Added a threshold to the function.
%	
%	v1.0, 6/28/01, Erik Zeek, <zeekec@mad.scientist.com>
%

error(nargchk(1,3,nargin))

if nargin < 2
	repl = 0;
end

if nargin < 3
	thresh = 0;
end

X(find(X < thresh)) = repl;