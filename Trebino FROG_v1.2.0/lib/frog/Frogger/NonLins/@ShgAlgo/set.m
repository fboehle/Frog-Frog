function FrogObj = set(FrogObj, varargin )
%SET sets ShgAlgo properties.

%	$Id: set.m,v 1.1 2006-11-11 00:13:33 pablo Exp $

while length(varargin) >= 2
	prop = varargin{1};
	val = varargin{2};
	
	if length(varargin) > 2
		varargin = varargin(3:end);
	else
		varargin = {};
	end
	
	switch prop
		% ShgAlgo defines no new properties.
		% TODO: Add new properties.
		
		otherwise
			% Try the base properties.
			FrogObj.FrogAlgo = set(FrogObj.FrogAlgo, prop, val);
	end
end

