function val = get(FrogObj, name)
%GET gets the class properties.

%	$Id: get.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

switch name
	% FROG needs no extra information.
	case 'NeedsExtraInfo'
		val = false;
	
	% What type of FROG is it?
	case 'TypeName'
		val = 'FROG';
	
	% Return the type object.
	case 'TypeObj'
		val = FrogObj;
		
	% See if the base object can handle the get.
	otherwise
		val = get(FrogObj.FrogBase, name);
end
