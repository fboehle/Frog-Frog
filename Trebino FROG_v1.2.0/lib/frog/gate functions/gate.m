function G=gate(NL)
%GATE the FROG gate function.
%	GATE(NL) returns the FROG gate function handle for
%	the non-linearity, NL.  The NL defaults to SHG.
%
%	See also FEVAL

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: gate.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.2  2001/08/30 16:03:17  zeekec
%	Added support for updated gate names.
%	
%	Revision 1.1  2001/07/24 23:47:44  zeekec
%	Added gate function
%	


error(nargchk(0,1,nargin))

switch nargin
case 0
	NL = 'SHG';
end

NL = upper(NL);

switch NL
case 'SHG'
	G = @gate_shg;
case 'SFG'
	G = @gate_sfg;
case 'SD'
	G = @gate_sd;
case 'PG'
	G = @gate_pg;
case 'DFG'
	G = @gate_dfg;
otherwise
	error(['Unknown non-linearity ', NL, '.']);
end
