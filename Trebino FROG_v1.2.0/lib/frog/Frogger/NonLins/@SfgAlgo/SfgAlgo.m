function [ X ] = SfgAlgo( varargin )
%SFGALGO class constructor.

%	$Id: SfgAlgo.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% No additional elements.
X = struct;

switch nargin
	case 0
		Y = XfrogAlgo;
		X = class(X, 'SfgAlgo', Y);
	case 1
		if isa(varargin{1}, 'SfgAlgo')
			X = varargin{1};
		else
			Y = XfrogAlgo(varargin{1});
			X = class(X, 'SfgAlgo', Y);
		end
	otherwise
		error('SfgAlgo:SfgAlgo:Nargin', 'Wrong number of inputs, %d, in constructor!', nargin);
end