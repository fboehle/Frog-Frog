function o = DisplayStructGet(DisplayStruct, name, default, flag)
%DISPLAYSTRUCTGET Get DISPLAYSTRUCT parameters.
%   VAL = DISPLAYSTRUCTGET(DISPLAYSTRUCT,'NAME') extracts the value of the named parameter
%   DisplayStruct structure DISPLAYSTRUCT, returning an empty matrix if
%   the parameter value is not specified in DISPLAYSTRUCT.  It is sufficient to
%   type only the leading characters that uniquely identify the
%   parameter.  Case is ignored for parameter names.  [] is a valid DISPLAYSTRUCT
%   argument.
%   
%   VAL = DISPLAYSTRUCTGET(DISPLAYSTRUCT,'NAME',DEFAULT) extracts the named parameter as
%   above, but returns DEFAULT if the named parameter is not specified (is [])
%   in DISPLAYSTRUCT.  For example
%   
%     val = DisplayStructGet(DStruct, 'xlabel', 'Label X');
%   
%   returns val = 'Label X' if the xlabel property is not specified in DStruct.
%   
%   See also DISPLAYSTRUCTSET.

%   $Revision: 1.1 $  $Date: 2006-11-11 00:15:35 $ 

if nargin < 2
  error('Not enough input arguments.');
end
if nargin < 3
  default = [];
end
if nargin < 4
   flag = [];
end

% undocumented usage for fast access with no error checking
if isequal('fast',flag)
   o = DisplayStructGetFast(DisplayStruct, name, default);
   return
end

if ~isempty(DisplayStruct) & ~isa(DisplayStruct,'struct')
  error('First argument must be a DisplayStruct structure created with DisplayStructSet.');
end

if isempty(DisplayStruct)
  o = default;
  return;
end

d = struct('xlim', [], ...
    'ylim', [], ...
    'xlabel', [], ...
    'ylabel', [], ...
    'title', [], ...
    'colormap', []);

Names = fieldnames(d);
[m,n] = size(Names);
names = lower(Names);

lowName = lower(name);
j = strmatch(lowName,names);
if isempty(j)               % if no matches
  error(sprintf(['Unrecognized property name ''%s''.  ' ...
                 'See DisplayStructSet for possibilities.'], name));
elseif length(j) > 1            % if more than one match
  % Check for any exact matches (in case any names are subsets of others)
  k = strmatch(lowName,names,'exact');
  if length(k) == 1
    j = k;
  else
    msg = sprintf('Ambiguous property name ''%s'' ', name);
    msg = [msg '(' Names{j(1),:}];
    for k = j(2:length(j))'
      msg = [msg ', ' Names{k,:}];
    end
    msg = sprintf('%s).', msg);
    error(msg);
  end
end

if any(strcmp(Names,Names{j,:}))
   o = DisplayStruct.(Names{j,:});
  if isempty(o)
    o = default;
  end
else
  o = default;
end

%------------------------------------------------------------------
function value = DisplayStructGetFast(DisplayStruct,name,defaultopt)
%DISPLAYSTRUCTGETFAST Get DisplayStruct parameter with no error checking so fast.
%   VAL = DISPLAYSTRUCTGETFAST(DISPLAYSTRUCT,FIELDNAME,DEFAULTOPTIONS) will get the
%   value of the FIELDNAME from DISPLAYSTRUCT with no error checking or
%   fieldname completion. If the value is [], it gets the value of the
%   FIELDNAME from DEFAULTOPTIONS, another DISPLAYSTRUCT structure which is 
%   probably a subset of the DisplayStruct in DISPLAYSTRUCT.
%

if ~isempty(DisplayStruct)
        value = DisplayStruct.(name);
else
    value = [];
end

if isempty(value)
    value = defaultopt.(name);
end