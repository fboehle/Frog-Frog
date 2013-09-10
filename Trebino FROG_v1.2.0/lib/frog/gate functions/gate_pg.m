function p = pggate(Et);
% PGFROG gate function.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: gate_pg.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2001/08/30 15:58:39  zeekec
%	Renamed gate functions
%	
%	Revision 1.2  2001/07/10 01:10:00  zeekec
%	Library cleanup.  Added, deleted, and moved files.
%	
%

p = abs(Et).^2;
