function [ X ] = PgAlgo( varargin )
%PGALGO class constructor.

%	$Id: PgAlgo.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% No new elements.
X = struct;

switch nargin
	case 0
		Y = FrogAlgo;
		X = class(X, 'PgAlgo', Y);
	case 1
		if isa(varargin{1}, 'PgAlgo')
			X = varargin{1};
		else
			Y = FrogAlgo(varargin{1});
			X = class(X, 'PgAlgo', Y);
		end
	otherwise
		error('PgAlgo:PgAlgo:Nargin', ...
			'Wrong number of inputs, %d, in constructor!', nargin);
end
