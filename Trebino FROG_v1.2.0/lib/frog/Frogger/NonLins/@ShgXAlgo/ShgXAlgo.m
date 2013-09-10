function [ X ] = ShgXAlgo( varargin )
%SHGXALGO class constructor

%	$Id: ShgXAlgo.m,v 1.1 2006-11-11 00:13:33 pablo Exp $

% No added elements.
X = struct;

switch nargin
	case 0
		Y = ShgAlgo;
		X = class(X, 'ShgXAlgo', Y);
	case 1
		if isa(varargin{1}, 'ShgXAlgo')
			X = varargin{1};
		else
			Y = ShgAlgo(varargin{1});
			X = class(X, 'ShgXAlgo', Y);
		end
	otherwise
		error('ShgXAlgo:ShgXAlgo:Nargin', 'Wrong number of inputs, %d, in constructor!', nargin);
end