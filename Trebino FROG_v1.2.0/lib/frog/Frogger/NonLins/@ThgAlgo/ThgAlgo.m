function [ X ] = ThgAlgo( varargin )
%THGALGO class constructor.

%	$Id: ThgAlgo.m,v 1.1 2006-11-11 00:13:33 pablo Exp $

% No new elements.
X = struct;

switch nargin
	case 0
		Y = FrogAlgo;
		X = class(X, 'ThgAlgo', Y);
	case 1
		if isa(varargin{1}, 'ThgAlgo')
			X = varargin{1};
		else
			Y = FrogAlgo(varargin{1});
			X = class(X, 'ThgAlgo', Y);
		end
	otherwise
		error('ThgAlgo:ThgAlgo:Nargin', ...
			'Wrong number of inputs, %d, in constructor!', nargin);
end
