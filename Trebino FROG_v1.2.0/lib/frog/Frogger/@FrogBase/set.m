function FrogObj = set(FrogObj, varargin )
%SET sets the various objects in a FrogBase Object.
%	FROGOBJ=SET(FROGOBJ, PROP, VAL, ...) sets the PROP to VAL for each pair
%	in the list.

%	$Id: set.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

if nargout ~= 1
	error('FrogBase:set:OutputArgs', ...
		'There must be one and only one output parameter, not %d.', nargout);
end

% While we have at least one parameter-value pair...
while length(varargin) >= 2
	% Get the current property.
	prop = varargin{1};
	% Get the current value.
	val = varargin{2};
	
	if length(varargin) > 2
		% If there are more than on pair remove the first...
		varargin = varargin(3:end);
	else
		% else remove the last pair.
		varargin = {};
	end
	
	% Set the various properties.  See FrogBase.m for a description of the
	% properties.
	% TODO:  Validate that the VALs are the correct data type.
	switch prop
		case 'Asig'
			FrogObj.Asig		= val;
		case 'Esig'
			FrogObj.Esig		= val;
		case 'tau'
			FrogObj.tau			= val;
		case 'w2'
			FrogObj.w2			= val;
		case 'Et'
			FrogObj.Et			= val;
		case 'EtOrig'
			FrogObj.EtOrig		= val;
		case 't'
			FrogObj.t			= val;
		case 'G'
			FrogObj.G			= val;
		case 'Z'
			FrogObj.Z			= val;
		case 'BestG'
			FrogObj.BestG		= val;
		case 'BestG.Et'
			FrogObj.BestG.Et	= val;
		case 'BestG.G'
			FrogObj.BestG.G		= val;
		case 'BestG.Z'
			FrogObj.BestG.Z		= val;
		case 'Best.Iter'
			FrogObj.BestG.Iter	= val;
		case 'BestZ'
			FrogObj.BestZ		= val;
		case 'BestZ.Et'
			FrogObj.BestZ.Et	= val;
		case 'BestZ.G'
			FrogObj.BestZ.G		= val;
		case 'BestZ.Z'
			FrogObj.BestZ.Z		= val;
		case 'BestZ.Iter'
			FrogObj.BestZ.Iter	= val;
		otherwise
			error('FrogBase:set:InvalidProperty','Invalid property, %s.', prop);
	end
end

