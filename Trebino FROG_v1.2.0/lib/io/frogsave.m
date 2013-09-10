function filename = frogsave(A, dtau, l0, dl, strf, filename, open_default_file)
%FROGSAVE saves a FROG file
%	FILENAME = FROGSAVE(A, DTAU, L0, DL) saves a FROG file with header information.  The
%	function opens a standard file dialog to select the file.  The FROG trace
%	is passed in A, the delay spacing in DTAU, the center wavelength in L0,
%	and the wavelength spacing in DL.  The filename is returned in FILENAME.
%
%	... = FROGSAVE(..., STRF) same as above, but uses the format string, STRF.
%
%	... = FROGSAVE(..., FILENAME) same as above, but saves the file as FILENAME,
%	instead of opening a dialog box.
%	... = FROGSAVE(..., [STRF], [], OPEN_DEFAULT_FILE) same as above, but opens a standard
%   file dialog using OPEN_DEFAULT_FILE as the default file name.

%	$Revision: 1.3 $ $Date: 2008-08-13 14:25:44 $
%
%	$Log: frogsave.m,v $
%	Revision 1.3  2008-08-13 14:25:44  pam
%	*** empty log message ***
%	
%	Revision 1.2  2008-01-22 00:29:37  pam
%	*** empty log message ***
%	
%	Revision 1.1  2007-05-26 21:40:41  pablo
%	lowercase
%	
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

error(nargchk(4, 7, nargin));

if nargin < 5 | isempty(strf)
	strf = '%.6g';
end

if ~exist('filename')
    filename = '';
end

if ~exist('open_default_file')
    open_default_file = '';
end

if ~ischar(filename);
    filename = '';
end

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname, pname, filterindex] = uiputfile(...
		{'*.frg', 'FROG Files (*.frg)';...
			'*.*', 'All Files (*.*)'}, 'Save FROG file as', open_default_file);
	if ~filterindex
		error('frogsave:NoSelection','No file selected.');
	end
	filename = [pname, fname];
end

[file,err] = fopen(filename,'wt');

if file < 0
	error(err);
end

A = A';

fprintf(file, ['%d\t%d\t%.7g\t%.7g\t%.7g\n'], size(A), dtau, dl, l0);

f = [];
for k = 1 : (size(A, 1) - 1)
	f = [f strf '\t'];
end

f = [f strf '\n'];

fprintf(file, f, A);

error(ferror(file));

fclose(file);