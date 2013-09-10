function sd = sdgate(Et);
%
% Gate takes an input vector (one dimensional row vector), Et, and creates a matrix 
% of time delayed versions of Et^2. The output is an N by N matrix (where N is size of Et) 
% where each row is Et^2 delayed by a certain time increment.  The first row is Et^2 delayed 
% by 1/2 the entire time range of Et, row two is Et^2 delayed by 1/2 the entire time range 
% minus one unit of time, and so on.  Each unit is determined by the time units represented 
% by the index in Et.  For more info, contact Devang Naik, gte171r@prism.gatech.edu.
%

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: gate_sd.m,v $
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

sd = Et.^2;