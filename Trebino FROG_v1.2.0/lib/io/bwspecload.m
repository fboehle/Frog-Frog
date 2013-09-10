function [lambda, inten, filename, headertext] = BWSpecLoad(varargin)
%BWSPECLOAD loads a BWSpec spectrum file
%	[LAMBDA, INTENSITY, FILENAME, HEADERTEXT] = OOLOAD loads a BWSpec
%   spectrum file.  The function opens a standard file dialog 
%   to select the file.
%
%	... = BWSPECLOAD(FILENAME) same as above, but loads the file, FILENAME,
%	instead of opening a dialog box.

%	$Revision: 1.1 $ $Date: 2007-05-26 21:40:41 $

error(nargchk(0,2,nargin));

[filename, datatype] = parsevarargin(varargin, [], 'Dark Subtracted #1');

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname,pname,filterindex] = uigetfile(...
		{'*.txt', 'BWSpec spectrum file';
         '*.*', 'All files'}, 'Load BWSpec spectrum file');
	if ~filterindex
		error('BWSpecload:NoSelection','No file selected.');
	end
	filename = [pname,fname];
end

[file,err] = fopen(filename, 'rt');

if file < 0
	error(err);
end

s = fscanf(file, '%c');
fclose(file);

s_begin = '^[\w# ]+;[\w# ]+;[\w# ]+;[\w# ]+;';

i1_s_begin = regexp(s, s_begin, 'start', 'lineanchors');
headertext = s(1 : i1_s_begin - 1);
i2_s_begin = regexp(s(i1_s_begin : end), '.$', 'once', 'lineanchors');
columnheader = s(i1_s_begin : i1_s_begin + i2_s_begin);
datatext = s(i1_s_begin + i2_s_begin + 1 : end);
datatext = regexprep(datatext, '(.)$', '$1;', 'lineanchors');

tok = regexp(columnheader, '([\w# ]+)[;\n]', 'tokens');
N_tok = prod(size(tok));
for i_tok = 1 : N_tok
    tok{i_tok} = tok{i_tok}{1};
end

idx_wavelength = strmatch('Wavelength', tok);
idx_data = strmatch(datatype, tok);

if isempty(idx_data)
    datatype = inputdlg({'BWSpec data type.'}, 'Please enter the BWSpec data type');
    idx_data = strmatch(datatype{:}, tok);
    if isempty(idx_data)
        error('bwspecload:WrongDataType','Wrong data type.');
    end
end

A = sscanf(datatext, '%f;', [N_tok Inf]);

lambda = A(idx_wavelength, :);
inten = A(idx_data, :);