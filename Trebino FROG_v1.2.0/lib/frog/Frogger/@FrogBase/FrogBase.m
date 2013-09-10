function X = FrogBase(varargin)
%FROGALGO Class constructor

%	$Id: FrogBase.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% The experimental FROG trace amplitude.
X.Asig			= [];
% The current working space for the algorithm.
X.Esig			= [];
% The delay axis.
X.tau			= [];
% The angular frequency axis.
X.w2			= [];

% The current best guess.
X.Et			= [];
% If the trace was theoretical, the original pulse.
X.EtOrig		= [];
% The time axis.
X.t				= [];

% The G error.
X.G				= [];
% The Z error.
X.Z				= [];

% The pulse with the lowest G error.
X.BestG.Et		= [];
% Its G error.
X.BestG.G		= [];
% Its Z error.
X.BestG.Z		= [];
% The iteration it occured on.
X.BestG.Iter	= [];

% The pulse with the lowest Z error.
X.BestZ.Et		= [];
% Its G error.
X.BestZ.G		= [];
% Its Z error.
X.BestZ.Z		= [];
% The iteration it occured on.
X.BestZ.Iter	= [];

% Type Name
X.TypeName = [];
X.NonLinName = [];
X.DomainName = [];
X.AlgoName = [];


% Switch on the number of aguments.
switch nargin
	case 0
		% Create a new, blank FrogObj.
		X = class(X, 'FrogBase');
	case 1
		% Copy constructor.
		if isa(varargin{1}, 'FrogBase')
			X = varargin{1};
		else
			error('FrogBase:FrogBase:ClassType', ...
				'Class %s is not a FrogBase!', class(varargin{1}));
		end
	otherwise
		error('FrogBase:FrogBase:NumberInputs', ...
			'Wrong number of inputs, %d, in constructor!', nargin);
end
