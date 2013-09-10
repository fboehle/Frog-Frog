function [A,pathfile] = traceload(varargin)
% TRACELOAD(PATHFILE) loads a trace, converting it to a double array.
%	If PATHFILE is empty, then a standard dialog box opens up.  The 
% 	array A is returned, along with the PATHFILE (path and filename)
% 	returned, if desired.
%
%	Currently supported trace types: frg, bmp, tif

%	$Revision: 1.1 $	$Date: 2006-11-11 00:15:30 $

error(nargchk(0,2,nargin))

[pathfile, forder] = parsevarargin(varargin, '', 'delay');

[pname, fname, extn] = fileparts(pathfile);

if isempty(fname)
	[fname, pname] = uigetfile('*.bmp;*.tif;*.frg', 'Load FROG trace', pathfile);
	if fname == 0
		error('traceload:InvalidFilename','Invalid filename');
	end
	pathfile = [pname,fname];
	
	forder = 'ask';
end

if strcmpi(forder, 'ask')
	question = sprintf('Please select the file order.\nDelays or wavelengths first.');
	forder = questdlg(question, 'File Order', 'Delay', 'Wave', 'Delay');
end

[pathstr,name,extn] = fileparts(pathfile);

switch lower(extn)
	case '.bmp'
		% For VideoFrog loading
		rawdata = imread(pathfile,'bmp');
		A = double(rawdata);
        A = swpforder(A, forder);
	case '.tif'
		% For VideoFrog loading
		rawdata = imread(pathfile,'tiff');
		A = double(rawdata);		
        A = swpforder(A, forder);
	case '.frg'
		% For Spiricon loading
		try
			A = load(pathfile,'-ascii');
			A = A';
        A = swpforder(A, forder);
		catch
			A = frogload(pathfile, forder);
		end
end

function B = swpforder(A, forder)
switch lower(forder)
    case 'delay'
        B = A;
    case 'wave'
        B = A.';
    otherwise
        error('File order parameter not recognized.');
end