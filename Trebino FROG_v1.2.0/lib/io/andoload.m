function [lambda, inten, filename, headertext, conditiontext, datamode] = AndoLoad(varargin)
%ANDOLOAD loads an Ando spectrum analyzer output file
%	[LAMBDA, INTENSITY, FILENAME, HEADERTEXT, CONDITIONTEXT, DATAMODE]
%   = ANDOLOAD loads an Ando spectrum analyzer output file.  The function opens
%   a standard file dialog to select the file.
%
%	... = ANDOLOAD(FILENAME) same as above, but loads the file, FILENAME,
%	instead of opening a dialog box.

%	$Revision: 1.1 $ $Date: 2007-05-26 21:40:41 $

error(nargchk(0,1,nargin));

[filename] = parsevarargin(varargin, []);

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname,pname,filterindex] = uigetfile(...
		{'*.txt', 'Ando spectrum analyzer output file';
         '*.*', 'All files'}, 'Load Ando spectrum analyzer file');
	if ~filterindex
		error('andoload:NoSelection','No file selected.');
	end
	filename = [pname,fname];
end

[file,err] = fopen(filename, 'rt');

if file < 0
	error(err);
end

s = fscanf(file, '%c');
fclose(file);

s_begin = '^\s*[\d.]+,\s*([\d.-+Ee]+)$';
s_end = '^"\w+".+$';

i1_s_begin = regexp(s, s_begin, 'start', 'lineanchors');
i1_s_end = regexp(s, s_end, 'start', 'lineanchors');
headertext = s(1 : i1_s_begin - 1);
datatext = s(i1_s_begin : i1_s_end - 1);
conditiontext = s(i1_s_end : end);

A = sscanf(datatext, '%f, %f', [2 Inf]);

lambda = A(1, :);
inten = A(2, :);

data_firstline = regexp(datatext, s_begin, 'tokens', 'once', 'lineanchors');
data_firstline = data_firstline{:};

if isempty(strfind(upper(data_firstline), 'E'))
    datamode = 'dB';
    inten = db2lin(inten);
else
    datamode = 'linear';
end