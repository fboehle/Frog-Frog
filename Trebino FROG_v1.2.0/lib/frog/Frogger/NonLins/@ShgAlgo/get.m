function [ val ] = get( FrogObj, name )
%GET retrieves the ShgAlgo properties.

%	$Id: get.m,v 1.1 2006-11-11 00:13:33 pablo Exp $

switch name
	case 'w1'
		% returns the frequencies of the retrieved trace.
		w2 = get(FrogObj, 'w2');
		val = w2 - w2(floor(end/2)+1) / 2;
		
	case 'NonLinName'
		% The name of the nonlinearity.
		val = 'SHG';
	case 'DomainName'
		% The domain the algorithm works in.
		val = 'Time';
	case 'AlgoName'
		% The name of the particular algorithm.
		val = 'Z Minimize';

	case {'NonLinObj', 'DomainObj', 'AlgoObj'}
		% This is the end object for the nonlinearity, domain, and
		% algorithm, so we return this for them.
		val = FrogObj;
		
	otherwise
		val = get(FrogObj.FrogAlgo, name);
end
