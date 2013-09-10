function [ Y ] = get( X, name )
%GET gets XfrogAlgo properties.

%	$Id: get.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

switch name
	% XfrogAlgo properties.
	case 'Gt'
		Y = X.Gt;
	case 'Gw'
		Y = X.Gw;
    case 'wg'
        Y = X.wg;
		
	case 'NeedsExtraInfo'
		% XfrogAlgo needs extra info.
		Y = true;
		
	case 'TypeName'
		% Its FROG type.
		Y = 'XFROG';
	case 'TypeObj'
		% The type object.
		Y = X;
		
	otherwise
		% Try FrogBase properties.
		Y = get(X.FrogBase, name);
end
