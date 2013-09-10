function [ X ] = XfrogAlgo( varargin )
%SHGALGO Summary of this function goes here
%  Detailed explanation goes here

%	$Id: XfrogAlgo.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% New members, the gate pulse.
X.Gt = [];
X.Gw = [];
X.wg = [];

switch nargin
	case 0
		% Default constructor.
		Y = FrogBase;
		X = class(X, 'XfrogAlgo', Y);
	case 1
		if isa(varargin{1}, 'XfrogAlgo')
			% Copy constructor
			X = varargin{1};
		else
			% Maybe FrogBase can be constructed from the parameter.
			Y = FrogBase(varargin{1});
			X = class(X, 'XfrogAlgo', Y);
		end
	otherwise
		error('XfrogAlgo:XfrogAlgo:NumberInputs', 'Wrong number of inputs, %d, in constructor!', nargin);
end