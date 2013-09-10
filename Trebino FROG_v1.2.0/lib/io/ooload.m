function [lambda, inten, filename, headertext] = ooload(varargin)
%OOLOAD loads an Ocean Optics spectrum file
%	[LAMBDA, INTENSITY, FILENAME, HEADERTEXT] = OOLOAD loads an Ocean 
%   Optics spectrum file.  The function opens a standard file dialog 
%   to select the file.
%
%	... = OOLOAD(FILENAME) same as above, but loads the file, FILENAME,
%	instead of opening a dialog box.

%	$Revision: 1.1 $ $Date: 2007-05-26 21:40:41 $

error(nargchk(0,1,nargin));

[filename] = parsevarargin(varargin, []);

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname,pname,filterindex] = uigetfile(...
		{'*.Irradiance;*.Reference;*.Sample', 'Ocean Optics spectrum file';
         '*.*', 'All files'}, 'Load Ocean Optics spectrum file');
	if ~filterindex
		error('ooload:NoSelection','No file selected.');
	end
	filename = [pname,fname];
end

[file,err] = fopen(filename, 'rt');

if file < 0
	error(err);
end

s = fscanf(file, '%c');
fclose(file);

s_begin = '^>+Begin\sSpectral\sData<+$';
s_end = '^>+End\sSpectral\sData<+$';

[i1_s_begin, i2_s_begin] = regexp(s, s_begin, 'start', 'end', 'lineanchors');
i1_s_end = regexp(s, s_end, 'start', 'lineanchors');
headertext = s(1 : i1_s_begin - 1);
datatext = s(i2_s_begin + 2 : i1_s_end - 1);

A = sscanf(datatext, '%f %f', [2 Inf]);

lambda = A(1, :);
inten = A(2, :);