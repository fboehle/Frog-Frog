function [ Y ] = get( X, name )
%GET gets object properties.

%	$Id: get.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

switch name
	case 'w1'
		% The retrieved pulse's angular frequencies.
		w2 = get(X, 'w2');
		wg = get(X, 'wg');
		Y = w2 - wg(floor(end/2)+1);
		
	case 'NonLinName'
		Y = 'SFG';
	case 'DomainName'
		Y = 'Time';
	case 'AlgoName'
		Y = 'XFROG Z Min.';
	case {'NonLinObj', 'DomainObj', 'AlgoObj'}
		Y = X;
		
	otherwise
		% Dispatch to the base class.
		Y = get(X.XfrogAlgo, name);
end
