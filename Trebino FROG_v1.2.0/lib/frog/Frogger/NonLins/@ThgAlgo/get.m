function [ Y ] = get( X, name )
%GET gets the class properties.

%	$Id: get.m,v 1.1 2006-11-11 00:13:33 pablo Exp $

switch name
	case 'w1'
		% The retrieved pulse's angular frequencies.
		w2 = get(X, 'w2');
		Y = w2 - w2(floor(end/2)+1) * 2 / 3;
	case 'NonLinName'
		Y = 'THG';
	case 'DomainName'
		Y = 'Time';
	case 'AlgoName'
		Y = 'Z Minimize';
	case {'NonLinObj', 'DomainObj', 'AlgoObj'}
		Y = X;
		
	otherwise
		% Dispatch others to the base class.
		Y = get(X.FrogAlgo, name);
end
