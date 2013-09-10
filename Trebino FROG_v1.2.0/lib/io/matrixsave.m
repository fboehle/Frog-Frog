function filename = matrixsave(A, varargin)
%MATRIXSAVE_ALL saves a matrix to a file
%	FILENAME = FROGSAVE_ALL(A) saves a matrix. The function opens a standard file
%   dialog to select the file.  The filename is returned in FILENAME.
%
%	... = MATRIXSAVE(..., STRF, DELIMITER) same as above, but uses the format string, STRF.
%   Default values are '%.6g' and '\t';
%
%	... = MATRIXSAVE(..., FILENAME) same as above, but saves the file as FILENAME,
%	instead of opening a dialog box.
%	... = MATRIXSAVE(..., [STRF], [], OPEN_DEFAULT_FILE) same as above, but opens a standard
%   file dialog using OPEN_DEFAULT_FILE as the default file name.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: matrixsave.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2006/05/07 11:57:03  xg
%	*** empty log message ***
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

error(nargchk(1, 5, nargin));

[strf, delimiter, filename, open_default_file] = parsevarargin(varargin, '%.6g', '\t',...
    '', '');

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname, pname, filterindex] = uiputfile(...
		{'*.*', 'All files (*.*)'}, 'Save matrix file as', open_default_file);
	if ~filterindex
		error('matrixsave:NoSelection','No file selected.');
	end
	filename = [pname, fname];
end

[file,err] = fopen(filename,'wt');

if file < 0
	error(err);
end

A = A';

f = [];
for k = 1 : (size(A, 1) - 1)
	f = [f strf delimiter];
end

f = [f strf '\n'];

fprintf(file, f, A);

error(ferror(file));

fclose(file);