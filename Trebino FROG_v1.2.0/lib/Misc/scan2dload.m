function [A, N_delay, d_delay, N_lambda, lambda_0, d_lambda, N_row, row_0, filename] = Scan2dLoad(filename)
%SCAN2DLOAD loads a delay-scanned 2-d image file
%   [A, N_DELAY, D_DELAY, N_LAMBDA, LAMBDA_0, D_LAMBDA, N_ROW, ROW_0, FILENAME] = SCAN2DLOAD
%   loads a delay-scanned 2-d image file into 3-d matrix A.  N_DELAY is the number of delays
%   scanned, D_DELAY the delay step in mm, N_LAMBDA the number of wavelength, LAMBDA_0 the center
%   wavelength, D_LAMBDA the wavelength increment, N_ROW the number of rows, ROW_0 the number of
%   the first row, and FILENAME.
%
%	... = SCAN2DLOAD(FILENAME) same as above, but loads the file, FILENAME,
%	instead of opening a dialog box.

%	$Revision: 1.1 $ $Date: 2007-01-05 19:05:31 $
%
%	$Log: scan2dload.m,v $
%	Revision 1.1  2007-01-05 19:05:31  pablo
%	lowercase
%	
%	Revision 1.1  2006-11-11 00:15:34  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2002/06/02 02:10:35  xg
%	created.
%	


error(nargchk(0,1,nargin));

if nargin < 1 | isempty(filename)
	[fname,pname] = uigetfile(...
		{'*.dat', 'Delay-scanned 2-d Images (*.dat)';...
			'*.*', 'All Files (*.*)'}, 'Load delay-scannned 2-d image file');
	if fname == 0
		error('Invalid filename');
	end
	filename = [pname,fname];
end

fid = fopen(filename);
N_delay = fscanf(fid, '%d', 1);
d_delay = fscanf(fid, '%f', 1);
N_lambda = fscanf(fid, '%d', 1);
lambda_0 = fscanf(fid, '%f', 1);
d_lambda = fscanf(fid, '%f', 1);
N_row = fscanf(fid, '%d', 1);
row_0 = fscanf(fid, '%d', 1);
A = fscanf(fid, '%d', [N_lambda, N_delay * N_row]);
A = reshape(A, [N_lambda, N_row, N_delay]);
fclose(fid);