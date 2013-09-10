function [ X ] = ShgAlgo( varargin )
%SHGALGO class constructor.

%	$Id: ShgAlgo.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% No new members.
X = struct;

switch nargin
	case 0
		% Default constructor.
		Y = FrogAlgo;
		X = class(X, 'ShgAlgo', Y);
	case 1
		if isa(varargin{1}, 'ShgAlgo')
			% Copy constructor.
			X = varargin{1};
		else
			% Try base constructor.
			Y = FrogAlgo(varargin{1});
			X = class(X, 'ShgAlgo', Y);
		end
	otherwise
		error('ShgAlgo:ShgAlgo:Nargin', ...
			'Wrong number of inputs, %d, in constructor!', nargin);
end