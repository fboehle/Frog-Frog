function [lambda, inten, filename] = specload_all(varargin)
%SPECLOAD_ALL loads a spectrum file.
%
%	[LAMBDA, INTEN, FILENAME] = SPECLOAD_ALL loads a spectrum file.
%
%	... = FROGLOAD(FILENAME) same as above, but loads the file, FILENAME,
%	instead of opening a dialog box.
%
%	... = FROGLOAD(..., TYPE) specifies the file type.  Options are 'Ocean
%	Optics', 'SPREADSHEET', and 'ASK'.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

error(nargchk(0, 3, nargin));

[filename, type, window_title] = parsevarargin(varargin, '', [], 'Load spectrum file');

[pname, fname, ext] = fileparts(filename);

Types = {'Ocean Optics', 'Ando', 'BWSpec', 'Spreadsheet'};

if isempty(fname)
    [fname,pname,filterindex] = uigetfile(...
        {'*.Irradiance;*.Reference;*.Sample', 'Ocean Optics spectrum file';
        '*.txt', 'Ando spectrum analyzer file';
        '*.txt', 'BWSpec spectrum file';
        '*.*', 'Text spreadsheet file';
        '*.*', 'All files'}, window_title);
    if ~filterindex
        error('specload_all:NoSelection','No file selected.');
    end
    if filterindex ~= 5
        type = Types{filterindex};
    end
    filename = fullfile(pname, fname);
    [pname, fname, ext] = fileparts(filename);
end

if isempty(type)
    question = 'Please select the spectrum file type.';
    selection = listdlg('Name', question, 'PromptString', 'Spectrum file type',...
        'SelectionMode', 'single', 'ListString', Types);
    type = Types{selection};
end

switch upper(type)
    case 'OCEAN OPTICS'
        [lambda, inten] = ooload(filename);
    case 'ANDO'
        [lambda, inten] = andoload(filename);
    case 'BWSPEC'
        [lambda, inten] = bwspecload(filename);
    case 'SPREADSHEET'
        A = load(filename);
        lambda = A(:, 1);
        inten = A(:, 2);
    otherwise
        error('specload_all:NoTypeSelection', 'No file type selected.');
end
