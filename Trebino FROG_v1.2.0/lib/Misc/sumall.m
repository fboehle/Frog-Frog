function X = sumall(Y)
%SUMALL Sums all elements.
%	SUMALL(Y) Returns the sum af all the elements of Y.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $
%
%	v1.0, 6/22/01, Erik Zeek, <zeekec@mad.scientist.com>
%	v1.1, 7/3/01, Erik Zeek, <zeekec@mad.scientist.com>
%		Removed reshape.
%
%	$Log: sumall.m,v $
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.2  2001/07/10 01:10:00  zeekec
%	Library cleanup.  Added, deleted, and moved files.
%	
%

X = sum(Y(:));
