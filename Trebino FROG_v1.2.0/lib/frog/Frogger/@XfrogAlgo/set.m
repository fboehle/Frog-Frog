function FrogObj = set(FrogObj, varargin )
%SET sets XfrogAlgo properties.

%	$Id: set.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

while length(varargin) >= 2
	prop = varargin{1};
	val = varargin{2};
	
	if length(varargin) > 2
		varargin = varargin(3:end);
	else
		varargin = {};
	end
	
	switch prop
		% Set the XfrogAlgo properties.
		case 'Gt'
			FrogObj.Gt = val;
		case 'Gw'
			FrogObj.Gw = val;
        case 'wg'
            FrogObj.wg = val;
			
		% Maybe its a FrogBase property.
		otherwise
			FrogObj.FrogBase = set(FrogObj.FrogBase, prop, val);
	end
end

