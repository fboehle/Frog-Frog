function [varargout] = parsevarargin(argin,varargin)
%PARSEVARGIN Parses vargin.
%	[ARG1,ARG2,...]=PARSEVARGIN(ARGIN,ARG1,ARG2,...) parses ARGIN for
%	empty values and replaces them with the default values, ARG1, ARG2, ....
%	Missing values at the end of ARGIN are also replaced by their corresponding
%	default values.
%
%	Example:
% 		function z=sum2(varargin)
% 		
% 		error(nargchk(1,2,nargin))
% 		
% 		[x,y]=ParseVarargin(varargin,0,0);
% 		
% 		z = x + y;
%
%	sum2([],5) = 5
%	sum2(5) = 5
%
%	See also PARSEPARAMS

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

error(nargchk(2,inf, nargin))


if ~iscell(argin)
	error('The fist parameter in ParseVarargin must be a cell array');
end

if iscell(varargin{1})
	varargin = varargin{1};
	warning('ParseVarargin call depreciated.  Call with ParseVarargin(varargin,arg1,arg2,...).');
end

if length(argin) > nargout
	error('The number of arguments in must be less than the number of arguments out.')
end

if length(varargin) ~= nargout
	error('The number of defaults must match the number of arguments out.')
end

varargout = varargin;

for k = 1:length(argin)
	if ~isempty(argin{k})
		varargout{k} = argin{k};
	end
end
