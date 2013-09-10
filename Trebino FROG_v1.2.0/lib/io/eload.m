function [x, E, filename] = eload(filename)
%ELOAD Loads FROG E-field output file 'Ek.dat' or 'Speck.dat'
%	[X, E, FILENAME] = ELOAD loads FROG E-field output file 'Ek.dat' or 'Speck.dat'.  The
%   function opens a standard file dialog to select the file.  FILENAME is returned.
%
%   In case of 'Ek.dat', time is returned in X, and complex E field in E.
%   In case of 'Speck.dat', wavelength is returned in X, and complex E field in E.
%
%	... = ELOAD(FILENAME) same as above, but loads the file, FILENAME,
%	instead of opening a dialog box.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: eload.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2006/05/11 22:36:29  pablo
%	converted to lower case
%	
%	Revision 1.1  2006/05/02 16:27:55  xg
%	frogger/binner v. 3 updates
%	
%	Revision 1.5  2005/08/06 19:28:39  xg
%	*** empty log message ***
%	
%	Revision 1.4  2002/11/14 18:50:53  xg
%	Now handles path name only inputs (strings ending in '\').
%	
%	Revision 1.3  2002/06/04 13:46:13  xg
%	Misc
%	
%	Revision 1.2  2001/10/22 23:09:39  xg
%	File name return added
%	
%	Revision 1.1  2001/10/22 17:38:20  xg
%	Created
%	
error(nargchk(0,1,nargin));
% narginchk(0,1);

if ~exist('filename')
    filename = '';
end

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname,pname] = uigetfile(...
		{'*.dat', 'FROG Output Files (*.dat)';...
			'*.*', 'All Files (*.*)'}, 'Load FROG E-field file', filename);
	if fname == 0
		error('Invalid filename');
	end
	filename = [pname,fname];
end

data = load(filename);

if (size(data, 2) ~= 5)
    error('File error');
end

x = data(:, 1);
E = complex(data(:, 4), data(:, 5));