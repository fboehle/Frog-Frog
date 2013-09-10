function [ val ] = get( FrogAlgo, name )
%GET get the valies of properties.

%	$Id: get.m,v 1.1 2006-11-11 00:13:33 pablo Exp $

switch name
	% New properties go here.
		
	case 'AlgoName'
		val = 'XFROG Z Min.';
	case 'AlgoObj'
		val = FrogAlgo;
		
	otherwise
		% Dispatch to base class for handling.
		val = get(FrogAlgo.ShgAlgo, name);
end
