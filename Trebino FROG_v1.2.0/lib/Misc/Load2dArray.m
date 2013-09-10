function [SpecArray, xvector, filename] = Load2dArray(filename)
%LOAD2DARRAY loads a 2-d array camera image-mode output file
%   [SPECARRAY, XVECTOR, FILENAME] = LOAD2DARRAY loads the output file of a 2-d array
%   camera in image mode.  The function opens a file selection dialog.  The image array
%   is returned in SPECARRAY, the wavelength vector (or column pixel numbers if
%   uncalibrated) is returned in XVECTOR, and FILENAME is also returned.
%
%   ... = LOAD2DARRAY(FILENAME) same as above, but loads the file, FILENAME,
%   instead of opening a dialog box.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:34 $
%
%   $Log: Load2dArray.m,v $
%   Revision 1.1  2006-11-11 00:15:34  pablo
%   CVS server re-installation
%
%   Revision 1.3  2002/04/25 18:44:45  xg
%   Bug fix concerning explicit file name input.
%
%   Revision 1.2  2001/10/21 08:33:35  xg
%   File name output added
%
%   Revision 1.1  2001/10/21 07:44:44  xg
%   Created
%

error(nargchk(0,1,nargin));

if nargin < 1 | isempty(filename)
	[fname,pname] = uigetfile(...
		{'*.asc', 'Spectrometer Image Files (*.asc)';...
			'*.*', 'All Files (*.*)'}, 'Load spectrometer image file');
	if fname == 0
		error('Invalid filename');
	end
	filename = [pname,fname];
end

data = load(filename)';
if size(data, 2) < 2
    error('File error');
end

xvector = data(1, :);
SpecArray = data(2 : end, :);