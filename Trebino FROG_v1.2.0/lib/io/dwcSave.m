function filename = dwcSave(A, dtau, lambda, strf, filename, open_default_file)
%DWCSAVE saves a FROG file in the DWC format
%	FILENAME = DWCSAVE(A, DTAU, LAMBDA) saves a FROG file with header
%	information in the DWC format. The function opens a standard file
%   dialog to select the file.  The FROG trace is passed in A, the delay 
%   spacing in DTAU, and the wavelength vector in LAMBDA.  The filename is
%   returned in FILENAME.
%
%	... = DWCSAVE(..., STRF) same as above, but uses the format string, STRF.
%
%	... = DWCSAVE(..., FILENAME) same as above, but saves the file as FILENAME,
%	instead of opening a dialog box.
%	... = DWCSAVE(..., [STRF], [], OPEN_DEFAULT_FILE) same as above, but opens a standard
%   file dialog using OPEN_DEFAULT_FILE as the default file name.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: dwcSave.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2006/05/02 16:27:56  xg
%	frogger/binner v. 3 updates
%	
%	Revision 1.7  2005/08/06 19:27:23  xg
%	*** empty log message ***
%	
%	Revision 1.6  2002/11/14 18:50:53  xg
%	Now handles path name only inputs (strings ending in '\').
%	
%	Revision 1.5  2002/08/28 19:17:29  xg
%	*** empty log message ***
%	
%	Revision 1.4  2001/10/22 21:18:03  zeekec
%	Changed default format.
%	
%	Revision 1.3  2001/10/21 07:41:24  xg
%	Help updated
%	
%	Revision 1.2  2001/10/19 15:54:46  xg
%	help corrected
%	
%	Revision 1.1  2001/08/09 00:09:13  zeekec
%	Added frogload and frogsave.
%	

error(nargchk(3, 6, nargin));

if nargin < 4 | isempty(strf)
	strf = '%.6g';
end

if ~exist('filename')
    filename = '';
end

if ~exist('open_default_file')
    open_default_file = '';
end

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname, pname, filterindex] = uiputfile(...
		{'*.DWC', 'FROG DWC Files (*.dwc)';...
			'*.*', 'All Files (*.*)'}, 'Save FROG file as', open_default_file);
	if ~filterindex
		error('dwcsave:NoSelection','No file selected.');
	end
	filename = [pname, fname];
end

[file,err] = fopen(filename,'wt');

if file < 0
	error(err);
end

A = A';

fprintf(file, ['Number of delay points = %d\nNumber of wavelength points = %d\n',...
    'Delay increment = %.7g\n'], size(A), dtau);

f_d = [];
f_l = [];
for k = 1 : (size(A, 1) - 1)
	f_d = [f_d strf '\t'];
end
for k = 1 : (size(A, 2) - 1)
	f_l = [f_l strf '\t'];
end

f_d = [f_d strf '\n'];
f_l = [f_l strf '\n'];

fprintf(file, '\n[Wavelength vector]\n');
fprintf(file, f_l, lambda);

fprintf(file, '\n[Data array]\n');
fprintf(file, f_d, A);

error(ferror(file));

fclose(file);