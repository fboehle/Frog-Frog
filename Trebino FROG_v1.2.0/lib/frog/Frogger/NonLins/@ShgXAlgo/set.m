function FrogObj = set(FrogObj, varargin )
%SET sets the properties.

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
		% New properties go here.
		
		otherwise
			% Dispatch to the base class for handling.
			FrogObj.shgalgo = set(FrogObj.shgalgo, prop, val);
	end
end

