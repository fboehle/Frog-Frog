function [trace, lambda, delay, limits, sizes, filename] = frogtraceload(filename)
%FROGTRACELOAD Loads a FROG trace file, usually named 'a.dat' or 'arecon.dat'.
%	[TRACE, LAMBDA, DELAY, LIMITS, SIZES, FILENAME] = FROGTRACELOAD loads a FROG
%   trace file with header information.  The function opens a standard file dialog
%   to select the file.  The FROG trace is returned in TRACE, along with the
%   wavelength vector LAMBDA, the delay vector DELAY, minimum and maximum pixel
%   values in LIMITS, and the size of both dimensions in SIZES.
%
%	... = FROGTRACELOAD(FILENAME) same as above, but loads the file, FILENAME,
%	instead of opening a dialog box.
%
%   FROGTRACESAVE now accepts pathname input, but the pathname has to end
%   with '\'.

%	$Revision: 1.1 $ $Date: 2007-05-26 21:40:41 $
%
%	$Log: frogtraceload.m,v $
%	Revision 1.1  2007-05-26 21:40:41  pablo
%	lowercase
%	
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2006/05/02 16:27:56  xg
%	frogger/binner v. 3 updates
%	
%	Revision 1.7  2005/08/06 19:28:40  xg
%	*** empty log message ***
%	
%	Revision 1.6  2002/09/27 19:14:18  xg
%	*** empty log message ***
%	
%	Revision 1.5  2002/09/27 18:41:00  xg
%	Pathname input added.
%	
%	Revision 1.4  2001/10/21 07:42:13  xg
%	Help updated
%	
%	Revision 1.3  2001/10/19 19:45:27  xg
%	Switched trace matrix dimensions to match the convention of other functions.
%	
%	Revision 1.2  2001/10/18 19:18:07  zeekec
%	Changed limits type to %f.
%	
%	Revision 1.1  2001/10/17 20:39:18  xg
%	Created
%	

error(nargchk(0,1,nargin));

if nargin < 1
    filename = '';
end

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname, pname, filterindex] = uigetfile(...
		{'*.dat', 'FROG Trace Files (*.dat)';...
			'*.*', 'All Files (*.*)'}, 'Load FROG trace file', filename);
	if ~filterindex
		error('frogtraceload:NoSelection', 'No file selected.');
    end
	filename = [pname, fname];
end

[file,err] = fopen(filename,'rt');

if file < 0
	error(err);
end

sizes = fscanf(file, '%d', 2);
limits = fscanf(file, '%f', 2);
lambda = fscanf(file, '%f', sizes(1));
delay = fscanf(file, '%f', sizes(2));

trace = fscanf(file, '%f', flipud(sizes)')';

error(ferror(file));

fclose(file);