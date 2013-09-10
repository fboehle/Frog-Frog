function filename = frogsave_all(A, dtau, lambda, strf, filename, open_default_file)
%FROGSAVE_ALL saves a FROG file in the FRG or DWC formats
%	FILENAME = FROGSAVE_ALL(A, DTAU, LAMBDA) saves a FROG file with header
%	information in the FRG or DWC formatS. The function opens a standard file
%   dialog to select the file.  The FROG trace is passed in A, the delay 
%   spacing in DTAU, and the wavelength vector in LAMBDA.  The filename is
%   returned in FILENAME.
%
%	... = FROGSAVE_ALL(..., STRF) same as above, but uses the format string, STRF.
%
%	... = FROGSAVE_ALL(..., FILENAME) same as above, but saves the file as FILENAME,
%	instead of opening a dialog box.
%	... = FROGSAVE_ALL(..., [STRF], [], OPEN_DEFAULT_FILE) same as above, but opens a standard
%   file dialog using OPEN_DEFAULT_FILE as the default file name.

%	$Revision: 1.3 $ $Date: 2008-08-13 14:15:40 $
%
%	$Log: frogsave_all.m,v $
%	Revision 1.3  2008-08-13 14:15:40  pam
%	*** empty log message ***
%	
%	Revision 1.2  2008-01-22 00:29:37  pam
%	*** empty log message ***
%	
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

filename = '';
[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname, pname, filterindex] = uiputfile(...
		{'*.FRG', 'FROG files (*.frg)'; '*.DWC', 'FROG files (*.dwc)'; ...
			'*.*', 'All files (*.*)'}, 'Save FROG file as', open_default_file);
	if ~filterindex
		error('frogsave_all:NoSelection','No file selected.');
	end
	filename = [pname, fname];
end

if filterindex == 3
    Types = {'FROG files (*.frg)'; 'FROG files (*.dwc)'};
    question = 'Please select the FROG file type.';
    filterindex = listdlg('Name', question, 'PromptString', 'FROG file type',...
        'SelectionMode', 'single', 'ListString', Types);
end

switch filterindex
    case 1
        l0 = lambda(floor(end/2+1));
        dl = incre(lambda);
        frogsave(A, dtau, l0, dl, strf, filename); 
    case 2
        dwcsave(A, dtau, lambda, strf, filename);
end
