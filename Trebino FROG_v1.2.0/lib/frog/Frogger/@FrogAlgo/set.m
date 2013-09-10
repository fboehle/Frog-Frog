function FrogObj = set(FrogObj, varargin )
%SET sets the various objects in a FrogAlgo Object.
%	FROGALGO=SET(FROGALGO, PROP, VAL, ...) sets the PROP to VAL for each pair
%	in the list.

%	$Id: set.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% Loop over the PROP, VAL pairs.
while length(varargin) >= 2
	% Current property.
	prop = varargin{1};
	% Current value.
	val = varargin{2};
	
	% Remove the currrent from the list.
	if length(varargin) > 2
		varargin = varargin(3:end);
	else
		varargin = {};
	end
	
	switch prop
		% Set the FrogAlgo properties.
		% TODO:  There are currently no properties to set.  Add any as they
		% TODO:  are needed.
		
		otherwise
			% PROP is not a FrogAlgo Property, dispatch it up the food
			% chain.
			FrogObj.FrogBase = set(FrogObj.FrogBase, prop, val);
	end
end

