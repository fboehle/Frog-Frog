function X = FrogAlgo(varargin)
%FROGALGO Class constructor

%	$Id: FrogAlgo.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% There are no new data members.
X = struct;

switch nargin
	case 0
		% Default constructor.
		Y = FrogBase;
		X = class(X, 'FrogAlgo', Y);
	case 1
		if isa(varargin{1}, 'FrogAlgo')
			% Copy constructor.
			X = varargin{1};
		else
			% Maybe FrogBase can be constructed from the input.
			Y = FrogBase(varargin{1});
			X = class(X, 'FrogAlgo', Y);
		end
	otherwise
		error('FrogAlgo:FrogAlgo', 'Wrong number of inputs, %d, in constructor!', nargin);
end