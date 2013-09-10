function DStruct = DisplayStructSet(varargin)
%DISPLAYSTRUCTSET Create/alter DisplayStruct.
%   DStruct = DisplayStructSet('PARAM1',VALUE1,'PARAM2',VALUE2,...) creates an
%   Display structure DStruct in which the named parameters have
%   the specified values.  Any unspecified parameters are set to defaults.
%   It is sufficient to type only the leading characters that uniquely identify
%   the parameter.  Case is ignored for parameter names.  
%   NOTE: For values that are strings, correct case and the complete string  
%   are required; if an invalid string is provided, the default is used.
%   
%   DStruct = DisplayStructSet(OldDStruct,'PARAM1',VALUE1,...) creates a copy of OldDStruct 
%   with the named parameters altered with the specified values.
%   
%   DStruct = DisplayStructSet(OldDStruct, NewDStruct) combines an existing options structure
%   OldDStruct with a new options structure NewDStruct.  Any parameters in NewDStruct
%   with non-empty values overwrite the corresponding old parameters in 
%   OldDStruct. 
%   
%   DisplayStructSet with no input arguments and no output arguments displays all 
%   parameter names and their possible values, with defaults shown in {}.).
%
%   DStruct = DisplayStructSet (with no input arguments) creates a display structure
%   DStruct where all the fields are set to [].
%
%   
%   $Revision: 1.1 $  $Date: 2006-11-11 00:15:35 $ 

if (nargin == 0) & (nargout == 0)
    fprintf('                plotfun: function handle {@imagesc}\n');
    fprintf('             plotfunMag: function handle {@plot}\n');
    fprintf('           plotfunPhase: function handle {@plot}\n');    
    fprintf('              plotvalue: string {''amplitude''}\n');
    fprintf('                   xlim: [x1 x2] {[] (full range)}\n');
    fprintf('                   ylim: [y1 y2] {[] (full range)}\n');
    fprintf('                zlimMag: [z1 z2] {[] (full range)}\n');
    fprintf('              zlimPhase: [z1 z2] {[] (full range)}\n');
    fprintf('                 xlabel: string {''''}\n');
    fprintf('                 ylabel: string {''''}\n');
    fprintf('              zlabelMag: string {''''}\n');
    fprintf('            zlabelPhase: string {''''}\n');
    fprintf('                  title: string {''''}\n');
    fprintf('                 unwrap: logical {true}\n');
    fprintf('                 cutoff: real number {[]}\n');    
    fprintf('                   axis: character matrix, cf. strvcat {''''}\n');
    fprintf('               colormap: 3-column matrix valued between 0 and 1 {[]}\n');
    fprintf('            colorseqMag: 3-column matrix valued between 0 and 1 {[]}\n');
    fprintf('          colorseqPhase: cell array of 3-element vectors valued between 0 and 1 {[]}\n');
    fprintf('                drawnow: logical {true}\n');
    fprintf('               colorbar: logical {true}\n');
    return;
end

DStruct = struct('xlim', [], ...
    'ylim', [], ...
    'zlimMag', [], ...
    'zlimPhase', [], ...
    'xlabel', '', ...
    'ylabel', '', ...
    'zlabelMag', '', ...
    'zlabelPhase', '', ...
    'title', '', ...
    'plotfun', @imagesc, ...
    'plotfunMag', @plot, ...
    'plotfunPhase', @plot, ...
    'unwrap', true, ...
    'drawnow', true, ...
    'colorbar', true, ...
    'cutoff', [], ...
    'plotvalue', 'amplitude', ...
    'axis', '', ...
    'colormap', [], ...
    'colorseqMag', {{}}, ...
    'colorseqPhase', {{}});

numberargs = nargin; % we might change this value, so assign it

Names = fieldnames(DStruct);
[m,n] = size(Names);
names = lower(Names);

i = 1;
while i <= numberargs
    arg = varargin{i};
    if isstr(arg)                         % arg is an option name
        break;
    end
    if ~isempty(arg)                      % [] is a valid options argument
        if ~isa(arg,'struct')
            error(sprintf(['Expected argument %d to be a string parameter name ' ...
                    'or a display structure\ncreated with DisplayStructSet.'], i));
        end
        for j = 1:m
            if any(strcmp(fieldnames(arg),Names{j,:}))
                val = arg.(Names{j,:});
            else
                val = [];
            end
            if ~isempty(val)
                if ischar(val)
                    val = deblank(val);
                end
                [valid, errmsg] = checkfield(Names{j,:},val);
                if valid
                    DStruct.(Names{j,:}) = val;
                else
                    error(errmsg);
                end
            end
        end
    end
    i = i + 1;
end

% A finite state machine to parse name-value pairs.
if rem(numberargs-i+1,2) ~= 0
    error('Arguments must occur in name-value pairs.');
end
expectval = 0;                          % start expecting a name, not a value
while i <= numberargs
    arg = varargin{i};
    
    if ~expectval
        if ~isstr(arg)
            error(sprintf('Expected argument %d to be a string parameter name.', i));
        end
        
        lowArg = lower(arg);
        j = strmatch(lowArg,names);
        if isempty(j)                       % if no matches
            error(sprintf('Unrecognized parameter name ''%s''.', arg));
        elseif length(j) > 1                % if more than one match
            % Check for any exact matches (in case any names are subsets of others)
            k = strmatch(lowArg,names,'exact');
            if length(k) == 1
                j = k;
            else
                msg = sprintf('Ambiguous parameter name ''%s'' ', arg);
                msg = [msg '(' Names{j(1),:}];
                for k = j(2:length(j))'
                    msg = [msg ', ' Names{k,:}];
                end
                msg = sprintf('%s).', msg);
                error(msg);
            end
        end
        expectval = 1;                      % we expect a value next
        
    else           
        if ischar(arg)
            arg = deblank(arg);
        end
        [valid, errmsg] = checkfield(Names{j,:},arg);
        if valid
            DStruct.(Names{j,:}) = arg;
        else
            error(errmsg);
        end
        expectval = 0;
    end
    i = i + 1;
end

if expectval
    error(sprintf('Expected value for parameter ''%s''.', arg));
end


%-------------------------------------------------
function [valid, errmsg] = checkfield(field,value)
%CHECKFIELD Check validity of structure field contents.
%   [VALID, MSG] = CHECKFIELD('field',V) checks the contents of the specified
%   value V to be valid for the field 'field'. 
%


valid = 1;
errmsg = '';
% empty matrix is always valid
if isempty(value)
    return
end

switch field
case {'xlim', 'ylim', 'zlimMag', 'zlimPhase'} % real two-element vector or empty
    if ~(isempty(value) || (all(size(value) == [1 2]) && isreal(value)))
        valid = 0;
        errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be a real two-element vector, or for default, an empty array.',field);
    end
case {'xlabel', 'ylabel', 'zlabelMag', 'zlabelPhase', 'title'} % string
    if ~ischar(value)
        valid = 0;
        errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be a string.',field);
    end
case {'plotvalue'} % 'intensity' or 'phase'
    if ~(strcmpi(value, 'intensity') || strcmpi(value, 'amplitude'))
        valid = 0;
        errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be either ''intensity'' or ''amplitude''.',field);
    end    
case {'plotfun', 'plotfunMag', 'plotfunPhase'} % string
    if ~isa(value, 'function_handle')
        valid = 0;
        errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be a function handle.',field);
    end
case {'colormap'} % matrix of 3 columns, valued between 0 and 1
    if ~isempty(value)
        if (size(value, 2) ~= 3)
            valid = 0;
            errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be a 3-column matrix [R G B].',field);
        elseif (minall(value) < 0 | maxall(value) > 1)
            valid = 0;
            errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be valued between 0 and 1.',field);
        end
    end
case {'colorseqMag', 'colorseqPhase'} % cell array of 3-column vectors, valued between 0 and 1
    if ~iscell(value)
        valid = 0;
        errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be a cell arry of 3-column vectors [R G B].', field);
    elseif ~isempty(value)
        for vi = 1 : length(value)
            if (size(value{vi}) ~= [1 3])
                valid = 0;
                errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be a cell arry of 3-column vectors [R G B].',field);
            elseif (minall(value{vi}) < 0 | maxall(value{vi}) > 1)
                valid = 0;
                errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be a cell arry of 3-column vectors [R G B].',field);
            end
        end
    end
case {'cutoff'}
    if ~(isreal(value) && length(value) == 1) && ~isempty(value)
        valid = 0;
        errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be a real number.',field);
    end    
case {'unwrap', 'drawnow', 'colorbar'}
    if ~islogical(value)
        valid = 0;
        errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be a logical.',field);
    end
case {'axis'}
    if ~ischar(value)
        valid = 0;
        errmsg = sprintf('Invalid value for DisplayStruct parameter %s: must be a character matrix.',field);
    end
otherwise
    valid = 0;
    error('Unknown field name for DisplayStruct structure.')
end